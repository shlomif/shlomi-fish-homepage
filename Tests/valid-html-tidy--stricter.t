#!/usr/bin/perl

use strict;
use warnings;

package MyTidy;

use MooX qw/ late /;

extends('Test::HTML::Tidy::Recursive');

sub calc_tidy
{
    my $self = shift;

    my $tidy = HTML::Tidy->new( { output_xhtml => 1, } );

    # $tidy->ignore( type => TIDY_WARNING, type => TIDY_INFO );

    return $tidy;
}

package main;

my %whitelist = (
    map { $_ => 1 } (
        'dest/t2/humour/Blue-Rabbit-Log/ideas.xhtml',
        'dest/t2/humour/by-others/oded-c/No_name.html',
        'dest/t2/humour/by-others/oded-c/bla_bla.html',
        'dest/t2/humour/by-others/oded-c/hilazon.html',
'dest/t2/humour/human-hacking/arabic-v2/human-hacking-field-guide-v2-arabic/index.html',
        'dest/t2/humour/human-hacking/arabic-v2.html',
        'dest/t2/humour/humanity/songs/index.html',
        'dest/t2/lecture/Perl/Lightning/Mojolicious/mojolicious-slides.html',
        'dest/t2/lecture/WebMetaLecture/slides/examples/APIs/toc/index.html',
        'dest/t2/js/jquery-ui/index.html',
'dest/t2/open-source/resources/how-to-contribute-to-my-projects/HACKING.html',
'dest/t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.html',
        'dest/vipe/js/jquery-ui/index.html',
    ),
);

MyTidy->new(
    {
        filename_filter => sub {
            my $fn = shift;
            return not(
                exists $whitelist{$fn}
                or $fn =~ m#\A dest/t2/
                    (?:MathVentures/ |
                    lecture/
                    (?:
                    Perl/
                    (?:
                    Lightning/
                    (?: Mojolicious | Opt-Multi-Task-in-PDL/ | Test-Run/ |
                    Too-Many-Ways/
                        )
                        |
                    Graham-Function/
                    )
                    | SCM/subversion/for-pythoneers/ | Vim/beginners/ )
                    slides/ |
                    js/MathJax/ |
                    open-source/projects/Spark/mission/
                    )
                #x
            );
        },
        targets => [
            './dest/t2/DeCSS/',
            './dest/t2/SFresume.html',
            './dest/t2/SFresume_detailed.html',
            './dest/t2/art/',
            './dest/t2/index.html',
            './dest/t2/grad-fu/',
            './dest/t2/guide2ee/',
            './dest/t2/haskell/',
            './dest/t2/homesteading/',
            './dest/t2/humour.html',
            './dest/t2/humour-heb.html',
            './dest/t2/humour/Blue-Rabbit-Log/',
            './dest/t2/humour/Buffy/',
            './dest/t2/humour/GNU-Visual-Basic/',
            './dest/t2/humour/Muppets-Show-TNI/',
            './dest/t2/humour/Pope/',
            './dest/t2/humour/RoadToHeaven/',
            './dest/t2/humour/Selina-Mandrake/',
            './dest/t2/humour/So-Who-The-Hell-Is-Qoheleth/',
            './dest/t2/humour/Star-Trek/',
            './dest/t2/humour/Summerschool-at-the-NSA/',
            './dest/t2/humour/TOWTF/',
            './dest/t2/humour/The-Earth-Angel/',
            './dest/t2/humour/TheEnemy/',
            './dest/t2/humour/aphorisms/',
            './dest/t2/humour/bits/',
            './dest/t2/humour/by-others/',
            './dest/t2/humour/human-hacking/',
            './dest/t2/humour/humanity/',
            './dest/t2/i-bex/',
            './dest/t2/images/',
            './dest/t2/jmikmod/',
            './dest/t2/js/',
            './dest/t2/lambda-calculus/',
            './dest/t2/lecture/',
            './dest/t2/linux_banner/',
            './dest/t2/MathVentures/',
            './dest/t2/me/',
            './dest/t2/meta/',
            './dest/t2/no-ie/',
            './dest/t2/old-news.html',
            './dest/t2/open-source/',
            './dest/t2/personal-heb.html',
            './dest/t2/personal.html',
            './dest/t2/philosophy/',
            './dest/t2/prog-evolution/',
            './dest/t2/puzzles/',
            './dest/t2/recommendations/',
            './dest/t2/rindolf/',
            './dest/t2/rwlock/',
            './dest/t2/site-map/',
            './dest/t2/t/',
            './dest/t2/temp/',
            './dest/t2/toggle.html',
            './dest/t2/wonderous.html',
            './dest/t2/work/',
            './dest/t2/wysiwyt.html',
            './dest/vipe/',
        ],
    }
)->run;
