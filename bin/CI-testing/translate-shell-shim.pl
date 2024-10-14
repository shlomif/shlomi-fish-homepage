#! /usr/bin/env perl -lp
#
# Short description for translate-shell-shim.pl
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

s/^( *)gem/$1sudo gem/;

if (/^ *go get.*minify/)
{
    $_ =
q# if ( set -e -x; mkdir -p $HOME/src ; cd $HOME/src ; git clone https://github.com/tdewolff/minify.git ; cd minify ; make SHELL=/bin/bash install ; cd .. ; rm -fr minify ; which minify ; ) ; then true ; else ln -s /bin/true /usr/bin/minify ; fi#;
}

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
