#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use File::Find::Object                 ();
use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $PRE_DEST  = HTML::Latemp::Local::Paths->new->t2_pre_dest;
my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

open my $m, '>', "$POST_DEST/MANIFEST.html";

$m->print(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Shlomi Fish’s Homepage’s List of all Files</title>
<meta charset="utf-8"/>
</head>
<body>
<h1>MANIFEST</h1>
<ul>
EOF

{
    my $ffo = File::Find::Object->new( {}, $PRE_DEST, );

    while ( my $r = $ffo->next_obj() )
    {
        if ( $r->is_file )
        {
            my $p = join( '/', @{ $r->full_components() } );
            if (
                not(   ( $p =~ m#humour/fortunes.*\.tar\.gz\z# )
                    or ( $p =~ m#lecture/.*\.pl\z# ) )
                )
            {
                my $rel_path = escape_html($p);
                print {$m} qq{<li><a href="$rel_path">$rel_path</a></li>};
            }
        }
    }
}

$m->print(q{</ul></body></html>});

close($m);
