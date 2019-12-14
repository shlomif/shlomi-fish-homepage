#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;
use utf8;

use lib './lib';
use Parallel::ForkManager::Segmented ();

use Path::Tiny qw/ path /;
use Getopt::Long qw/ GetOptions /;

$Shlomif::Homepage::in_nav_block = undef();

use Shlomif::Homepage::TTRender ();
my $printable;
my @filenames;
my $obj = Shlomif::Homepage::TTRender->new;
GetOptions(
    'printable!' => \$printable,
    'stdout!'    => scalar( $obj->get_stdout_ref ),
    'fn=s'       => \@filenames,
);

my $LATEMP_SERVER = "t2";
my @tt;
$obj->calc_vars(
    {
        printable => $printable,
    }
);

if ( !@filenames )
{
    @filenames = path("lib/make/tt2.txt")->lines_raw( { chomp => 1 } );
}
Parallel::ForkManager::Segmented->new->run(
    {
        #         disable_fork => 1,
        items        => \@filenames,
        nproc        => 1,
        batch_size   => 100,
        process_item => \&Shlomif::Homepage::TTRender::proc,
    }
);
