#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use lib './lib';

use Path::Tiny                qw/ path /;
use File::Update              qw/ write_on_change write_on_change_no_utf8 /;
use JSON::MaybeXS             ();
use XML::LibXML               ();
use XML::LibXML::XPathContext ();
use XML::Grammar::Fortune 0.0800;
use Template                               ();
use Shlomif::Homepage::FactoidsPages::Data ();
use Shlomif::Homepage::FactoidsPages::Page ();
use Carp::Always;
use List::Util qw/ uniqstr /;

my $data_obj    = Shlomif::Homepage::FactoidsPages::Data->new();
my @pages_proto = @{ $data_obj->calc_data()->{'pages_proto'} };

my $xml_parser = XML::LibXML->new;

my $fortune_proc   = XML::Grammar::Fortune->new();
my $facts_xml_path = './lib/factoids/shlomif-factoids-lists.xml';
my $dom            = $xml_parser->parse_file($facts_xml_path);

my %deps;
my $xpc = XML::LibXML::XPathContext->new();
$xpc->registerNs( 'xhtml', "http://www.w3.org/1999/xhtml" );
foreach my $list_node ( $dom->findnodes("//list/\@xml:id") )
{
    foreach my $lang (qw(en-US he-IL))
    {
        my $list_id = $list_node->value;

        my $basename  = "$list_id--$lang";
        my $indiv_dom = $fortune_proc->perform_xslt_translation(
            {
                output_format => 'html',
                source        => { dom => $dom },
                output        => "dom",
                xslt_params   => {
                    'filter-facts-list.id' => "'$list_id'",
                    'filter.lang'          => "'$lang'",
                }
            }
        );

        $xpc->setContextNode($indiv_dom);

        if ( $lang eq 'he-IL' )
        {
            foreach my $node (
                $xpc->findnodes(
"//xhtml:table/xhtml:tbody/xhtml:tr[\@class='author']/xhtml:td[\@class='field']/xhtml:b[text() = 'Author']"
                )
                )
            {
                $node->replaceChild( XML::LibXML::Text->new("מאת:"),
                    $node->firstChild );
            }
        }

        my $node =
            $xpc->findnodes("//xhtml:div[\@class='main_facts_list']")->[0];

        my $reduced_xhtml =
            "lib/factoids/indiv-lists-xhtmls/$basename.xhtml.reduced";
        write_on_change( scalar( path($reduced_xhtml) ),
            \( $node->toString =~ s/\s+xmlns:xsi="[^"]+"//gr ) );
        push @{ $deps{$list_id} }, $reduced_xhtml;
    }
}

sub _page_to_obj
{
    my ($hash_ref) = @_;

    my $ret;
    eval { $ret = Shlomif::Homepage::FactoidsPages::Page->new($hash_ref); };

    if ( my $err = $@ )
    {
        print "Failed at " . $hash_ref->{id_base} . "!\n";
        die $err;
    }

    return $ret;
}

my @pages = ( map { _page_to_obj($_); } @pages_proto );

my $TT2_GEN__COMMON_INCLUDE = <<'END_OF_TEMPLATE';
[% PROCESS "Inc/emma_watson.tt2" %]

{{ FOREACH p IN pages }}

[% BLOCK facts__img__{{ p.short_id() }} %]
<!-- Taken from {{ p.img_attribution() }} -->
<img src="{{ p.img_src_tt2() }}" alt="{{ p.img_alt() }}" class="{{ p.img_class() }}" />
[% END %]

[% BLOCK facts__{{ p.short_id() }} %]

[% IF NOT nowrap %]
<section class="facts_wrap">

<header>
[% IF 1 %]
<h2>Introduction</h2>
[% ELSE %]
<h2>{{ p.title() }}</h2>
[% END %]
</header>
[% END %]

<div class="desc">
[% INCLUDE facts__img__{{ p.short_id() }} %]
<div class="abstract">
{{ p.abstract() }}
</div>
</div>

[% IF NOT nowrap %]
</section>
[% END %]

[% END %]

{{ END }}

[% BLOCK facts__list %]

<div class="facts_wrap">
{{ FOREACH p IN pages }}

[% WRAPPER h3_section id="facts-{{ p.short_id() }}" sect_class="facts" href="{{ p.url_base() }}/" title="{{ p.title() }}" %]
[% INCLUDE facts__{{ p.short_id() }} nowrap = 1 %]
[% END %]

{{ END }}
</div>

[% END %]
END_OF_TEMPLATE

my $PAGE_TEMPLATE = <<'END_OF_TEMPLATE';
[% SET title = "{{ p.title() }} [Satire]" %]
[% SET desc = "{{ p.meta_desc() }}" %]

[% WRAPPER wrap_html %]

[% PROCESS "Inc/emma_watson.tt2" %]
[% PROCESS "Inc/factoids_jqui_tabs_multi_lang.tt2" %]
[% PROCESS "Inc/nav_blocks.tt2" %]
[% PROCESS "Inc/summer_glau.tt2" %]
[% PROCESS "factoids/common-out/tags.tt2" %]
[% PROCESS "stories/stories-list.tt2" %]

[% INCLUDE facts__{{ p.short_id() }} %]
[% INCLUDE facts__header_tabs id_base="{{ p.id_base() }}" h="{{ p.tabs_title() }}" %]

[% WRAPPER h2_section id="license" title="Copyright and Licence"%]
[% license_obj.{{ p.license_method() }} (year=>"{{ p.license_year() }}") %]
[% END %]

[% WRAPPER links_sect  %]

{{ p.links_tt2() }}

[% WRAPPER h3_section id = "facts__common_links" title = "Common Links" %]

<ul>

<li>
<p>
<a href="[% base_path %]humour/fortunes/shlomif-factoids.html#shlomif-fact-{{ p.dashed_short_id() }}-1">These factoids in XML-Grammar-Fortune format</a> - also individually wrapped.
</p>
</li>

</ul>

[% END %]

[% END %]

[% WRAPPER see_also  %]
{{ p.see_also() }}
[% END %]

[% END %]
END_OF_TEMPLATE

# some useful options (see below for full list)
my $config = {
    POST_CHOMP => 1,    # cleanup whitespace
    EVAL_PERL  => 1,    # evaluate Perl code blocks
};

# create Template object
my $tt2__template =
    Template->new( +{ %$config, START_TAG => "\\{\\{", END_TAG => "\\}\\}", } );

sub _write_processed
{
    my ( $TT2, $vars, $path ) = @_;
    $tt2__template->process(
        $TT2, $vars,
        sub {
            my ($out_str) = @_;

            write_on_change( scalar( path($path) ), \$out_str, );
        }
    ) or die $!;

    return;
}

my @deps;
foreach my $page (@pages)
{
    my $libfn = "lib/factoids/pages/" . $page->id_base() . '.tt2';
    my $destfn =
          "dest/pre-incs/t2/humour/bits/facts/"
        . $page->url_base()
        . '/index.xhtml';

    push @deps, "${destfn}: $libfn\n";
    _write_processed( \$PAGE_TEMPLATE, { p => $page, }, $libfn, );
}
write_on_change(
    path("lib/make/generated/factoids-deps.mak"),
    \( join "", sort @deps ),
);

_write_processed(
    \$TT2_GEN__COMMON_INCLUDE,
    { pages => \@pages, },
    "lib/factoids/common-out/tags.tt2",
);

my $new_json = JSON::MaybeXS->new(
    utf8      => 1,
    canonical => 1
)->encode(
    [
        map {
            my $page = $_;
            +{
                url  => "humour/bits/facts/" . $page->url_base . "/",
                text => $page->title,
            }
        } @pages
    ]
);

my $json_fn = path('lib/Shlomif/factoids-nav.json');

write_on_change_no_utf8( path($json_fn), \$new_json, );

sub _content__process_page
{
    my ($page) = @_;

    my $id   = $page->id_base;
    my $path = $page->url_base;
    my $pre_incs_path =
        "dest/pre-incs/t2/humour/bits/facts/${path}/index.xhtml";
    return [
        +{
            'path' => $pre_incs_path,
            line   => "$pre_incs_path: "
                . join( " ", uniqstr( sort @{ $deps{$id} } ) ) . "\n",
        },
    ];
}

my @content =
    map { @{ _content__process_page($_) }; }
    sort { $a->short_id cmp $b->short_id } @pages;

path("lib/factoids/deps.mak")
    ->spew_utf8( join( " ", "all:", map { $_->{path} } @content ) . "\n",
    ( map { $_->{line} } @content ) );

# No write_on_change() because we want it to have the time of the last run.
path("lib/factoids/TIMESTAMP")->spew_utf8( time() );

__END__

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Shlomi Fish.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
