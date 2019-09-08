#!/usr/bin/env perl

use strict;
use warnings;

s#<(cc_by_british_blurb|cc_by_sa_british_blurb|cc_by_sa_license_british|book_info|cpan_dist|cpan_self_dist|cpan_b_self_dist|cpan_self_mod|pdoc_f|toc_div|wiki_link|my_acronym)\s([^>]*?)/>#
    my ($tag, $args) = ($1, $2);
    "[% $tag( " . ($args =~ s{([a-z_]+)="([^"]+)"}{"$1" => "$2",}gmrs) . ") %]"
    #egms;
my $assigns = '';
s#\s*<set-var\s+(rtl_layout|shlomif_lang)="?([^"]+)"?\s*/>\s*#$assigns .= qq/[% SET $1 = "$2" %]\n/;""#egms;

s#<(longblank)\s*/\s*>#
    my ($tag, $args) = ($1, ($2 // ''));
    $tag =~ tr/-/_/;
    "[% $tag %]"
    #egms;
s#<(rindolf_floaty_img|w2l_devel_talk__license|project_euler_progress|story_ongoing_episode_li|screenplay_github_repo|cc_by_licence_section|cc_by_nc_sa_british_blurb|common_art__graphics_design|docbook_formats_w_base|emma_watson_common_links|emma_watson_intro_text|emma_watson_intro|factoids_frame|home_pages_on_forges|humanity_licensing|lightning_talks_list|mailto_link_to_self|qp-lect|rellink|shlomif_docbook_doc_text|link_to_fiction_text|link_to_screenplay|link_to_epub_only|link_to_epub|link_to_fiction_text|links_to_judaism_and_israel|tagline|humour_link|humour_story|humour_stories_list_text|story_episode_li|x11_licence|(?:[a-z_]+_nav_block))\s([^>]*?)/>#
    my ($tag, $args) = ($1, ($2 // ''));
    $tag =~ tr/-/_/;
    "[% PROCESS $tag " . ($args =~ s{([a-z_A-Z]+)="([^"]+)"}{$1 = "$2",}gmrs) . " %]"
    #egms;

s#<(url_body_link)\s([^>]*?)/>#
    my ($tag, $args) = ($1, ($2 // ''));
    $tag =~ tr/-/_/;
    "[% INCLUDE $tag " . ($args =~ s{([a-z_A-Z]+)="([^"]+)"}{$1 = "$2",}gmrs) . " %]"
    #egms;
s#<pdoc_f f="(\w+)">#[%- WRAPPER pdoc_f f = "$1" -%]#g;
s#<cpan_dist d="([^"]*)">#[%- WRAPPER cpan_dist d = "$1" -%]#g;
s#<pdoc d="(\w+)">#[%- WRAPPER pdoc d = "$1" -%]#g;
my $re =
qr#(?:about_sect|hebrew_div|mydesign|riddle|bitbucket_cpan_dist_links|github_cpan_dist_links|intro|perl_for_newbies_entry|news_sect|note|screenplay_read_online|modern_perl_entry|nav_blocks|beginning_perl_entry|cpan_dist|pdoc|pdoc_f|licence_sect|links_sect|see_also|h[234]_section|art__my_image)#;

s#<($re)(?:\s([^>]*?))?>#    my ($tag, $args) = ($1, ($2 // ''));
    "[% WRAPPER $tag " . ($args =~ s{([a-z_]+)="([^"]+)"}{$1 = "$2" }gmrs) . " %]"
    #egms;
s#</$re>#[%- END -%]#g;
my $rep = "[% base_path %]";
s/\$\(ROOT\)\//$rep/g;
s/\$\(PATH_TO_ROOT\)/$rep/g;

my $meta = '';

if (s{^<latemp_meta_desc\s+"([^"]+)"\s*/>}{}ms)
{
    $meta .= "[%- SET desc = \"$1\" -%]\n";
}
if (s{^<(apply_screenplay_style)\s*/>}{}ms)
{
    $meta .= "[%- SET $1 = 1 -%]\n";
}
if (s{^<latemp_more_keywords\s+"([^"]+)"\s*/>}{}ms)
{
    $meta .= "[%- SET more_keywords = \"$1\" -%]\n";
}
while (s{^<(page_extra_head_elements)>(.*?)</\1>}{}ms)
{
    $meta .= "[% BLOCK $1 %]${2}[% END %]\n";
}

s{\A[\s\n\r]*#include "(?:multi-lang|template).wml"(?:#include[^\n]*\n|\n)*<latemp_subject ("[^"]*") />\n+}{${assigns}[%- SET title = $1 -%]
${meta}

[%- PROCESS "blocks.tt2" -%]
[%- WRAPPER wrap_html -%]\n\n};

$_ .= "\n[% END %]\n";

s#[ \t]+$##gms;
