#! /usr/bin/env perl
#
# Short description for timestampede.pl
#
# Version 0.0.1
# Copyright (C) 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp         qw/ confess /;
use Getopt::Long qw/ GetOptions /;
use Digest       ();
use Time::HiRes  qw( stat lstat utime );

use Path::Tiny qw/ cwd path tempdir tempfile /;
use Docker::CLI::Wrapper::Container v0.0.4 ();

sub run
{
    my $output_fn;

    my $obj = Docker::CLI::Wrapper::Container->new(
        { container => "rinutils--deb--test-build", sys => "debian:sid", } );

    GetOptions( "output|o=s" => \$output_fn, )
        or die "errror in cmdline args: $!";

    if ( !defined($output_fn) )
    {
        die "Output filename not specified! Use the -o|--output flag!";
    }

    #    $obj->do_system( { cmd => [ "git", "clone", "-b", $BRANCH, $URL, ] } );

    ## no critic
    open my $dfh, "find dest/post-incs/t2 | (LC_ALL=C sort)|";
    ## use critic
    while ( chomp( my $l = <$dfh> ) )
    {
        my @s = stat($l);
        if ( -f _ )
        {
            my $d = Digest->new("MD5");
            open my $fh, "<", $l;
            $d->addfile($fh);
            close $fh;
            my $h = $d->hexdigest;
            print sprintf( "%s\t%s\t%f\t%f", $l, $h, @s[ 8, 9 ] ), "\n";
        }
    }
    close $dfh;
    exit(0);
}

run();

1;

__END__

=encoding UTF-8

=head1 NAME

XML::Grammar::Screenplay::App::FromProto

=head1 VERSION

version v0.16.0

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
