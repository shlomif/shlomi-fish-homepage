#! /usr/bin/env perl
#
# Short description for reformat-docbook5.pl
#
# %!perl -lp -0777 -C bin/reformat-docbook5.pl
#
# Version 0.0.1
# Copyright (C) 2026 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp                                   qw/ confess /;
use Getopt::Long                           qw/ GetOptions /;
use Path::Tiny                             qw/ cwd path tempdir tempfile /;
use Docker::CLI::Wrapper::Container v0.0.4 ();

sub run
{

s!^([\ \t]*)(<section xml:id="([^\"\n]+?)">)((<info>)(<title>)([^\<\n]+?)(</title>)(</info>))\n! $1 . $2 . "\n\n" . $1 . $4 . "\n" !egms;

s!^([\ \t]*)((<info>)(<title>)([^\<\n]+?)(</title>)(</info>))\n! $1 . $3 . "\n" . $1 . $4 . $5 . $6 . "\n" . $1 . $7 . "\n" !egms;

    return;
}

run();

1;

__END__

=encoding UTF-8

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
