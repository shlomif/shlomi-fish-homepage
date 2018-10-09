#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use File::Find::Object;
use URI::Escape qw/uri_escape/;
use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);
use lib './lib';
use HTML::Latemp::Local::Paths;

my $T2_DEST = HTML::Latemp::Local::Paths->new->t2_dest;

open my $m, '>', "$T2_DEST/MANIFEST.html";

$m->print(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>Shlomi Fish’s Homepage’s List of all Files</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<h1>MANIFEST</h1>
<ul>
EOF

{
    my $ffo = File::Find::Object->new( {}, $T2_DEST, );

    while ( my $r = $ffo->next_obj() )
    {
        if ( $r->is_file )
        {
            my $rel_path =
                escape_html( join( '/', @{ $r->full_components() } ) );
            print {$m} qq{<li><a href="$rel_path">$rel_path</a></li>\n};
        }
    }
}

$m->print(<<'EOF');
</ul>
</body>
</html>
EOF

close($m);
