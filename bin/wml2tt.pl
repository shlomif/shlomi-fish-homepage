#!/usr/bin/env perl

use strict;
use warnings;

s#<(cc_by_british_blurb|book_info|cpan_dist|cpan_self_dist|cpan_b_self_dist|cpan_self_mod|pdoc_f|toc_div|wiki_link|my_acronym)\s([^>]*?)/>#
    my ($tag, $args) = ($1, $2);
    "[% $tag( " . ($args =~ s{([a-z]+)="([^"]+)"}{"$1" => "$2",}gmrs) . ") %]"
    #egms;

s#<(mailto_link_to_self)\s([^>]*?)/>#
    my ($tag, $args) = ($1, $2);
    "[% PROCESS $tag " . ($args =~ s{([a-z]+)="([^"]+)"}{"$1" => "$2",}gmrs) . " %]"
    #egms;

s#<pdoc_f f="(\w+)">#[%- WRAPPER pdoc_f f = "$1" -%]#g;
s#<cpan_dist d="([^"]*)">#[%- WRAPPER cpan_dist d = "$1" -%]#g;
s#<pdoc d="(\w+)">#[%- WRAPPER pdoc d = "$1" -%]#g;
my $re =
qr#(?:perl_for_newbies_entry|note|modern_perl_entry|beginning_perl_entry|cpan_dist|pdoc|pdoc_f)#;

s#<($re)>#[%- WRAPPER $1 -%]#g;
s#</$re>#[%- END -%]#g;
my $rep = "[% base_path %]";
s/\$\(ROOT\)\//$rep/g;
s/\$\(PATH_TO_ROOT\)/$rep/g;

my $meta = '';

if (s{^<latemp_meta_desc\s+"([^"]+)"\s*/>}{}ms)
{
    $meta .= "[%- SET desc = \"$1\" -%]\n";
}
if (s{^<latemp_more_keywords\s+"([^"]+)"\s*/>}{}ms)
{
    $meta .= "[%- SET more_keywords = \"$1\" -%]\n";
}

s{\A#include "template.wml"(?:#include[^\n]*\n|\n)*<latemp_subject ("[^"]*") />\n+}{[%- SET title = $1 -%]
${meta}

[%- PROCESS "blocks.tt2" -%]
[%- WRAPPER wrap_html -%]\n\n};

$_ .= "\n[% END %]\n";
