#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use XML::Parser;
use Text::Hunspell;
use List::MoreUtils qw(any);

my $speller = Text::Hunspell->new(
    '/usr/share/hunspell/en_GH.aff',
    '/usr/share/hunspell/en_GH.dic',
);

die unless $speller;

binmode STDOUT, ":encoding(utf8)";

foreach my $filename (@ARGV)
{
    my $parser = XML::Parser->new(
        Handlers => {
            Char => sub {
                my ($expat, $string) = @_;

                my @lines = split /\n/, $string, -1;

                foreach my $idx (0 .. $#lines)
                {
                    my $l = $lines[$idx];

                    my $mispelling_found = 0;

                    my $mark_word = sub {
                        my ($word) = @_;
                        
                        my $verdict = !($speller->check($word));
                        
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
                                $idx+$expat->current_line(), 
                                $l
                        );
                    }
                }

                return;
            },
        },
    );

    eval {
        $parser->parsefile($filename);
    };

    if (my $err = $@)
    {
        die "Error '$err' at filename '$filename'";
    }
}
