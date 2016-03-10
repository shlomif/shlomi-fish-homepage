#!/usr/bin/perl

use strict;
use warnings;

use autodie;

use utf8;

use HTML::Parser 3.00 ();
use List::MoreUtils qw(any);
use IO::All qw/ io /;

binmode STDOUT, ":encoding(utf8)";

my @general_whitelist;
my @records;

my $filename = 'lib/hunspell/whitelist1.txt';

{
    my $rec;
    open my $fh, '<:encoding(utf8)', $filename;
    my $found_global = 0;
    while (my $l = <$fh>)
    {
        chomp($l);
        # Whitespace or comment - skip.
        if ($l !~ /\S/ or ($l =~ /\A\s*#/))
        {
            # Do nothing.
        }
        elsif ($l =~ s/\A====\s+//)
        {
            if ($l =~ /\AGLOBAL:\s*\z/)
            {
                if (defined($rec))
                {
                    die "GLOBAL is not the first directive.";
                }
                $found_global = 1;
            }
            elsif ($l =~ /\AIn:\s*(.*)/)
            {
                if (defined($rec))
                {
                    push @records, $rec;
                }
                $rec = {
                    'files' => [ sort { $a cmp $b } split /\s*,\s*/, $1],
                    'words' => [],
                },
            }
            else
            {
                die "Unknown directive <<==== $l>>!";
            }
        }
        else
        {
            if (defined($rec))
            {
                push @{$rec->{'words'}}, $l;
            }
            else
            {
                if (!$found_global)
                {
                    die "GLOBAL not found before first word.";
                }
                push @general_whitelist, $l;
            }
        }
    }
    push @records, $rec;
    close ($fh);
}

sub rec_sorter
{
    my ($a_aref, $b_aref, $idx) = @_;

    return (
        (@$a_aref == $idx) ? -1
        : (@$b_aref == $idx) ? 1
        : (($a_aref->[$idx] cmp $b_aref->[$idx])
        ||
        rec_sorter($a_aref, $b_aref, $idx+1))
    );
}

sub _sort_words
{
    my $words_aref = shift;

    return [sort { $a cmp $b } @$words_aref];
}

my %_gen = map { $_ => 1 } @general_whitelist;

io($filename)->encoding('utf8')->print(
    map { "$_\n" }
    (
        "==== GLOBAL:",
        @{_sort_words(\@general_whitelist)}, '',
        (map
            { ("==== In: ".join(' , ', @{$_->{files}})), '',
                (@{ _sort_words(
                            [grep { !exists($_gen{$_}) } @{$_->{words}}]
                    )
                  }
                ), ''
            }
            sort { rec_sorter($a->{files}, $b->{files}, 0) }
            @records
        )
    )
);
