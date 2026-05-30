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

use lib "./lib";
use CGI::Minimal ();
my $id_re = qr#[A-Za-z][A-Za-z0-9_\-]*#ms;

my $cgi  = CGI::Minimal->new();
my $mode = ( $cgi->param('mode') // '' );
if ( $mode eq "random" )
{
    my $filename      = "__FORTS-show-cgi-ids.dat";
    my @stat          = stat($filename);
    my $len           = $stat[7];
    my $BITS          = 7;
    my $RECORD_LEN    = ( 1 << $BITS );
    my $records_count = ( $len >> $BITS );
    my $i             = int rand($records_count);
    my $p             = ( $i << $BITS );
    open my $fh, '<:raw', $filename
        or die;
    seek( $fh, $p, 0 );
    my $buf = '';
    read( $fh, $buf, $RECORD_LEN );
    close $fh;

    if ( my ($id) = ( $buf =~ m#\A(${id_re})\n#ms ) )
    {
        print "Status: 302\r\nLocation: show.cgi?id=${id}\r\n\r\n";
        exit(0);
    }
    else
    {
        die "bad record";
    }

}
my $id = $cgi->param('id');
if ( $id !~ m#\A${id_re}\z#ms )
{
    print
"Status: 404\r\nContent-Type: application/xhtml+xml; charset=utf-8\r\n\r\n",
        <<'EOF';
<?xml version="1.0" encoding="utf-8"?><!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><head><title>Dangerous / Invalid ID</title><meta charset="utf-8"/></head><body><h1>Dangerous / Invalid ID</h1></body></html>
EOF

    exit(0);

    # die "dangerous ID";
}
my $body = _utf8_slurp(
    (
        ( $mode eq 'raw' )
        ? "__FORTS-show-cgi-rawxhtmls"
        : "__FORTS-show-cgi-xhtmls"
    )
    . "/${id}.xhtml"
);
my $HEADER = "Content-Type: application/xhtml+xml; charset=utf-8\r\n\r\n";
print $HEADER;
binmode STDOUT, ':encoding(utf8)';

print $body;

sub _utf8_slurp
{
    my $filename = shift;
    my $in;
    if ( not( open $in, '<:encoding(utf8)', $filename ) )
    {
        print
"Status: 404\r\nContent-Type: application/xhtml+xml; charset=utf-8\r\n\r\n",
            <<'EOF';
<?xml version="1.0" encoding="utf-8"?><!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><head><title>Unknown ID</title><meta charset="utf-8"/></head><body><h1>Unknown / non existing ID</h1></body></html>
EOF

        exit(0);
    }

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

1;
