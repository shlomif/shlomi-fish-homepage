#!/usr/bin/env perl

use strict;
use warnings;

use 5.020;

local $/;
my $t = <>;

print <<"END_OF_OUTPUT";
    id_base => @{[$t =~ m#<facts__header_tabs id_base=("[^"]+")# ? $1: (die "Bar")]},
    license_wml => <<'EOF',
@{[$t =~ m#\Q<h2 id="license">Copyright and Licence</h2>\E\s+((?:\S[^\n]+\n)+)#ms ? ($1 =~ s#\s+\z##mrs) : (die "Bazooka")]}
EOF
    links_wml => <<'EOF',
@{[$t =~ m#\Q<h2 id="links">Links</h2>\E\n(.*?)(?:^<h2|^<\w+?_nav_block />|\z)#ms ? ($1 =~ s#\s+\z##mrs =~ s#\A\s+##mrs) : (die "Godmilla")]}
EOF
    meta_desc => @{[$t =~ m#<latemp_meta_desc ("[^"]+")# ? $1 : (die "Lamp")]},
    nav_blocks_wml => <<'EOF',
@{[$t =~ m#((?:^<\w+?_nav_block />\s*\n)*)\n*\z#ms ? ($1 =~ s#\s+\z##mrs) : (die "Qax")]}
EOF
    see_also_wml => <<'EOF',
@{[$t =~ m#\Q<h2 id="see_also">See Also</h2>\E\n(.*?)(?:^<h2|^<\w+?_nav_block />|\z)#ms ? ($1 =~ s#\s+\z##mrs =~ s#\A\s+##mrs) : (qq#<p>\n<b>TODO</b>\n</p>#)]}
EOF
    short_id => @{[$t =~ m#^<facts__(\w+)\s* />#ms ? qq#'$1'# : (die "Emitter")]},
    tabs_title => @{[$t =~ m#<facts__header_tabs id_base="[^"]+" h=("[^"]+") />#ms ? $1: (die "Bar")]},
    title => @{[$t =~ m#<latemp_subject ("[^"]+")\s*/># ? $1 : (die "Foo")]},
END_OF_OUTPUT
