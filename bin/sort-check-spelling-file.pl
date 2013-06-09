#!/usr/bin/perl

use strict;
use warnings;

use autodie;

use utf8;

use HTML::Parser 3.00 ();
use List::MoreUtils qw(any);
use IO::All;

binmode STDOUT, ":encoding(utf8)";

my @general_whitelist;
my @records;

my $filename = 'lib/hunspell/whitelist1.txt';

{
    my $rec;
    open my $fh, '<:encoding(utf8)', $filename;
    while (my $l = <$fh>)
    {
        chomp($l);
        # Whitespace or comment - skip.
        if ($l !~ /\S/ or ($l =~ /\A\s*#/))
        {
            # Do nothing.
        }
        elsif ($l =~ /\A====\s*(.*)/)
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
            if (defined($rec))
            {
                push @{$rec->{'words'}}, $l;
            }
            else
            {
                push @general_whitelist, $l;
            }
        }
    }
    push @records, $rec;
    close ($fh);
}

io($filename)->encoding('utf8')->print(
    map { "$_\n" }
    (
        @general_whitelist, '',
        (map
            { ("==== ".join(' , ', @{$_->{files}})), '', @{$_->{words}}, '' }
            @records
        )
    )
);
