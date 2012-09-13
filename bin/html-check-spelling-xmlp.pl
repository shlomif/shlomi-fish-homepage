#!/usr/bin/perl

use strict;
use warnings;

use autodie;

use utf8;

use HTML::Parser 3.00 ();
use Text::Hunspell;
use List::MoreUtils qw(any);

my $speller = Text::Hunspell->new(
    '/usr/share/hunspell/en_GH.aff',
    '/usr/share/hunspell/en_GH.dic',
);

die unless $speller;

binmode STDOUT, ":encoding(utf8)";

sub _slurp_utf8_array
{
    my $filename = shift;

    open my $in, '<:encoding(utf8)', $filename
        or die "Cannot open '$filename' for slurping - $!";

    my @ret = <$in>;

    close($in);

    chomp(@ret);

    return \@ret;
}

my %general_whitelist;
my %per_filename_whitelists;

{
    my @current_whitelists_list = \%general_whitelist;
    open my $fh, '<', 'lib/hunspell/whitelist1.txt';
    while (my $l = <$fh>)
    {
        chomp($l);
        if ($l =~ /\A====(.*)/)
        {
            @current_whitelists_list =
            (
                map { $per_filename_whitelists{$_} ||= +{} }
                split /,/, $1
            );
        }
        else
        {
            foreach my $w (@current_whitelists_list)
            {
                $w->{$l} = 1;
            }
        }
    }
    close ($fh);
}

my %inside;

sub tag
{
   my($tag, $num) = @_;
   $inside{$tag} += $num;
   print " ";  # not for all tags
}


foreach my $filename (@ARGV)
{
    my $process_text = sub
    {
        return if $inside{script} || $inside{style};

        my $text = shift;

        my @lines = split /\n/, $text, -1;

        foreach my $l (@lines)
        {

            my $mispelling_found = 0;

            my $mark_word = sub {
                my ($word) = @_;

                $word =~ s{’(ve|s|m|d|t|ll)\z}{'$1};

                my $verdict =
                (
                    (!exists($general_whitelist{$word}))
                        &&
                    (!exists($per_filename_whitelists{$filename}{$word}))
                        &&
                    ($word !~ m#\A\p{Hebrew}+\z#)
                        &&
                    (!($speller->check($word)))
                );

                $mispelling_found ||= $verdict;

                return $verdict ? "«$word»" : $word;
            };

            $l =~ s/
            # Not sure this regex to match a word is fully
            # idiot-proof, but we can amend it later.
            ([\w'’-]+)
            /$mark_word->($1)/egx;

            if ($mispelling_found)
            {
                printf {*STDOUT}
                (
                    "%s:%d:%s\n",
                    $filename,
                    1,
                    $l
                );
            }
        }
    };

    open(my $fh, "<:utf8", $filename);

    HTML::Parser->new(api_version => 3,
        handlers    => [start => [\&tag, "tagname, '+1'"],
            end   => [\&tag, "tagname, '-1'"],
            text  => [$process_text, "dtext"],
        ],
        marked_sections => 1,
    )->parse_file($fh);

    close ($fh);
}

print "\n";
