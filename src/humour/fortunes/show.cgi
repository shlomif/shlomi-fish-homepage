#! /usr/bin/env perl
#
# Short description for show.pl
#
# Version 0.0.1
# Copyright (C) 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.008;

# use autodie;

use Carp qw/ confess /;
use CGI  ();

my $cgi = CGI->new();
my $id  = $cgi->param('id');
if ( $id !~ m#\A[A-Za-z][A-Za-z0-9_\-]*\z#ms )
{
    die "dangerous ID";
}
my $HEADER = "Content-Type: application/xhtml+xml; charset=utf-8\r\n\r\n";
print $HEADER;
my $body = _utf8_slurp("__FORTS-show-cgi-xhtmls/${id}.xhtml");
print $body;

sub _utf8_slurp
{
    my $filename = shift;

    open my $in, '<:encoding(utf8)', $filename
        or die "Cannot open '$filename' for slurping - $!";

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

1;
