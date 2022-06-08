#! /usr/bin/env perl
#
# Short description for clean-fortune-xml-to-xhtml-toc-output.pl
#
# Version 0.0.1
# Copyright (C) 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;

# use 5.014;
use autodie;
s#\A.*?<ul[^>]*?>#<ul>#ms;
s#^[ \t]+##gms;
s#[ \t]+$##gms;

__END__

=encoding UTF-8

=head1 NAME

XML::Grammar::Screenplay::App::FromProto

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2022 by Shlomi Fish.

This is free software, licensed under:

  The MIT (Expat) License

=cut
