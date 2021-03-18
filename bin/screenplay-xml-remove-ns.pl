#! /usr/bin/env perl
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
# Copyright (C) 2019 Shlomi Fish <shlomif@cpan.org>
#
use strict;
use warnings;
use 5.014;
use autodie;
if (m#^<html #ms)
{
s#\Q xmlns:sp="http://web-cpan.berlios.de/modules/XML-Grammar-Screenplay/screenplay-xml-0.2/"\E##;

    if ( my $d = $ENV{DIR} )
    {
        s/(<html )/$1dir="$d" /;
    }
}
my $MOBILE_FRIENDLY_CSS_STYLE_TAG = <<'EOF';
<style>
img { max-width: 85%; }
pre { overflow: hidden; }
</style>
EOF
s#(</head>)#${MOBILE_FRIENDLY_CSS_STYLE_TAG}${1}#;
