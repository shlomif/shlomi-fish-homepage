package Shlomif::Homepage::FactoidsPages::Page;

use strict;
use warnings;

use MooX qw/late/;

has [
    'abstract',  'id_base',    'img_alt',        'img_attribution',
    'img_class', 'img_src',    'license_tag',    'license_year',
    'links_wml', 'meta_desc',  'nav_blocks_wml', 'see_also_wml',
    'short_id',  'tabs_title', 'title',          'url_base',
] => ( is => 'ro', isa => 'Str', required => 1 );
my $re = qr#(?:nav_blocks)#;

sub _tt2
{
    return
        shift() =~ s#\$\(ROOT\)/#[% base_path %]#gr =~
s#<: Shlomif::Homepage::LongStories->render_(abstract)\('([a-z_]+)'\); :>#[% long_stories__calc_$1(id => '$2') %]#gr
        =~ s#<($re)(?:\s([^>]*?))?>#    my ($tag, $args) = ($1, ($2 // ''));
        "[% WRAPPER $tag " . ($args =~ s{([a-z_]+)="([^"]+)"}{$1 = "$2" }gmrs) . " %]"
            #egmrs =~ s#</$re>#[%- END -%]#gr =~
s#<(li_SummerNSA_hashtag|summer_glau_common_links|rindolf_floaty_img|w2l_devel_talk__license|project_euler_progress|story_ongoing_episode_li|screenplay_github_repo|cc_by_licence_section|cc_by_nc_sa_british_blurb|common_art__graphics_design|docbook_formats_w_base|emma_watson_common_links|emma_watson_intro_text|emma_watson_intro|factoids_frame|home_pages_on_forges|humanity_licensing|lightning_talks_list|mailto_link_to_self|qp-lect|rellink|shlomif_docbook_doc_text|link_to_fiction_text|link_to_screenplay|link_to_epub_only|link_to_epub|link_to_fiction_text|links_to_judaism_and_israel|tagline|humour_link|humour_story|humour_stories_list_text|story_episode_li|x11_licence|(?:[a-z_]+_nav_block))\s([^>]*?)/>#
    my ($tag, $args) = ($1, ($2 // ''));
    $tag =~ tr/-/_/;
    "[% PROCESS $tag " . ($args =~ s{([a-z_A-Z]+)="([^"]+)"}{$1 = "$2",}gmrs) . " %]"
    #egmrs;
}

sub img_src_tt2
{
    my ($self) = @_;

    my $ret = $self->img_src;

    return _tt2($ret);
}

sub see_also_tt2
{
    my ($self) = @_;

    my $ret = $self->see_also_wml;

    return _tt2($ret);
}

sub links_tt2
{
    my ($self) = @_;

    my $ret = $self->links_wml;

    return _tt2($ret);
}

sub nav_blocks_tt2
{
    my ($self) = @_;

    my $ret = $self->nav_blocks_wml;

    return _tt2($ret);
}

=begin foo

has ['entry_id', 'entry_text', 'href',
] => (is => 'ro', isa => 'Str',);

has ['entry_extra_html',
] => (is => 'ro', isa => 'Str', default => q{},);

=end foo

=cut

1;
