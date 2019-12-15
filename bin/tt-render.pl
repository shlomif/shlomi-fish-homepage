#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use lib './lib';

use Getopt::Long qw/ GetOptions /;
use Parallel::ForkManager::Segmented ();
use Path::Tiny qw/ path /;
use Shlomif::Homepage::TTRender ();

my $printable;
my $stdout;
my @filenames;

GetOptions(
    'fn=s'       => \@filenames,
    'printable!' => \$printable,
    'stdout!'    => \$stdout,
) or die $!;

my $obj = Shlomif::Homepage::TTRender->new(
    { printable => $printable, stdout => $stdout, } );

if ( !@filenames )
{
    @filenames = path("lib/make/tt2.txt")->lines_raw( { chomp => 1 } );
}

Parallel::ForkManager::Segmented->new->run(
    {
        #         disable_fork => 1,
        items         => \@filenames,
        nproc         => 4,
        batch_size    => 100,
        process_batch => sub {
            my ($aref) = @_;
            foreach my $fn (@$aref)
            {
                $obj->proc($fn);
            }
            return;
        },
    }
);
