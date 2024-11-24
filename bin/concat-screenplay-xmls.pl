#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use 5.014;

use Carp                                  ();
use Path::Tiny                            qw/ cwd path tempdir tempfile /;
use XML::Grammar::Screenplay::API::Concat ();

sub _main
{
    my $FLAG = shift(@ARGV);
    if ( $FLAG ne "--output" )
    {
        Carp::confess("no flag");
    }
    my $OUTPUT_FN = shift(@ARGV) or Carp::confess("not enough args");
    my $ARGV_SEP  = shift(@ARGV);
    if ( $ARGV_SEP ne "--" )
    {
        Carp::confess("no separator");
    }
    my @inputs;
    foreach my $chapter (@ARGV)
    {
        my $fn = path($chapter);
        push @inputs,
            {
            type     => "file",
            filename => scalar($fn),
            };

    }
    my $output_rec = XML::Grammar::Screenplay::API::Concat->new()
        ->concat( { inputs => [@inputs] } );
    my $output_text = $output_rec->{'string'};
    path($OUTPUT_FN)->spew_utf8($output_text);
    print "Wrote : $OUTPUT_FN\n";
    if (0)
    {
        my $XHTML_FN = "queen-padme.screenplay-output.xhtml";
        system( $^X, "-MXML::Grammar::Screenplay::App::ToHTML=run",
            "-E", "run()", "--", "--output", $XHTML_FN, $OUTPUT_FN );
        print "Wrote : $XHTML_FN\n";
    }
}

_main();
