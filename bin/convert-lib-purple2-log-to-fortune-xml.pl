#!/usr/bin/env perl

use strict;
use warnings;

if ( my ( $who, $text ) =
m{\A<font color="[^"]*"><font size="2">[^<]*</font> <b>([^<]+)</b></font> (.*)<br/>\z}
    )
{
    $text =~ s#<a href="([^"]+)">\1</a>#$1#g;
    print qq#<saying who="$who">$text</saying>#;
}
