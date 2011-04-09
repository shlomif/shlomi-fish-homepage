#!/usr/bin/perl

use strict;
use warnings;

use XML::Parser;

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

                    if ($l =~ m{"})
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

    $parser->parsefile($filename);
}
