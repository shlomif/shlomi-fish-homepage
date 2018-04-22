#!/usr/bin/perl

use strict;
use warnings;

use Test::HTML::Tidy::Recursive::Strict;

my %whitelist = (
    map { $_ => 1 } (
        'dest/t2/humour/Blue-Rabbit-Log/ideas.xhtml',
'dest/t2/humour/human-hacking/arabic-v2/human-hacking-field-guide-v2-arabic/index.html',
        'dest/t2/humour/human-hacking/arabic-v2.html',
        'dest/t2/humour/humanity/songs/index.html',
        'dest/t2/lecture/WebMetaLecture/slides/examples/APIs/toc/index.html',
'dest/t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.html',
    ),
);

Test::HTML::Tidy::Recursive::Strict->new(
    {
        filename_filter => sub {
            my $fn = shift;
            return not(
                exists $whitelist{$fn}
                or $fn =~ m#\A
    dest/t2/ (?:
        MathVentures/
            |
        lecture/ (?:
            Perl/ (?:
                Lightning/ (?:
                    Opt-Multi-Task-in-PDL/
                        |
                    Test-Run/
                        |
                    Too-Many-Ways/
                )
                    |
                Graham-Function/
            )
                |
            SCM/subversion/for-pythoneers/
        )
            slides/
            |
        js/MathJax/
    )
                #x
            );
        },
        targets => ['./dest'],
    }
)->run;
