#! /usr/bin/env perl
#
# Short description for website-stats.pl
#
# Version 0.0.1
# Copyright (C) 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp qw/ confess /;
use Getopt::Long qw/ GetOptions /;
use Path::Tiny qw/ cwd path tempdir tempfile /;
use Docker::CLI::Wrapper::Container v0.0.4 ();

sub run
{
    my $output_fn;

    my $obj = Docker::CLI::Wrapper::Container->new(
        { container => "rinutils--deb--test-build", sys => "debian:sid", } );

    GetOptions( "output|o=s" => \$output_fn, )
        or die "errror in cmdline args: $!";

    if ( 0 and !defined($output_fn) )
    {
        die "Output filename not specified! Use the -o|--output flag!";
    }

    # $obj->do_system( { cmd => [ "git", "clone", "-b", $BRANCH, $URL, ] } );

    my $cmd =
        qq#find dest/post-incs/ -regex '.*\\.x?html' | ( LC_ALL=C sort -u )#;
    my $num_pages = `$cmd | wc -l`;
    my $num_words = `$cmd | xargs cat | wc -w`;
    chomp( $num_pages, $num_words );
    system(
qq#echo "<b>Current statistics</b>: $num_pages pages ; $num_words words." | commify#,
    );

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
