package Shlomif::Homepage::TTRender;

use strict;
use warnings;
use utf8;

use Encode qw/ decode_utf8 /;
use Moo;
use Path::Tiny      qw/ path /;
use URI::Escape::XS qw/ encodeURIComponent /;
use YAML::XS        ();

use HTML::Acronyms                         ();
use HTML::Latemp::AddToc                   ();
use Module::Format::AsHTML                 ();
use Set::CSS v0.2.0                        ();
use Shlomif::Homepage::ArticleIndex        ();
use Shlomif::Homepage::FortuneCollections  ();
use Shlomif::Homepage::LicenseBlurbs       ();
use Shlomif::Homepage::LongStories         ();
use Shlomif::Homepage::NavBlocks           ();
use Shlomif::Homepage::NavBlocks::Renderer ();
use Shlomif::Homepage::News                ();
use Shlomif::Homepage::P4N_Lect5_HebNotes  ();
use Shlomif::Homepage::RelUrl                (qw/ _set_url _url_obj /);
use Shlomif::Homepage::SectionMenu::IsHumour (qw/ get_is_humour_re /);
use Shlomif::Homepage::TocDiv      ();
use Shlomif::Homepage::TrueStories ();
use Shlomif::MD                    ();
use Shlomif::XmlFictionSlurp       ();
use Template                       ();
use VimIface                       ();

has printable => ( is => 'ro', required => 1 );
has stdout    => ( is => 'ro', required => 1 );

my $IS_HUMOUR_RE = qr#\A@{[ get_is_humour_re() ]}#;

my $LATEMP_SERVER = "t2";
my $toc           = HTML::Latemp::AddToc->new;

my $DEFAULT_TOC_DIV = Shlomif::Homepage::TocDiv::toc_div();
my $cpan            = Module::Format::AsHTML->new;
my $license         = Shlomif::Homepage::LicenseBlurbs->new(
    {
        contact_url      => "http://www.shlomifish.org/me/contact-me/",
        copyright_holder => "Shlomi Fish",
    }
);
my $true_stories_obj = Shlomif::Homepage::TrueStories->new();

my $base_path;
my $with_absolute_urls = ( $ENV{LATEMP_ABS} // "" );

my $nav_blocks         = Shlomif::Homepage::NavBlocks->new;
my $nav_block_renderer = Shlomif::Homepage::NavBlocks::Renderer->new(
    {
        host => 't2',
    }
);
my $latemp_fn;

sub check_nav_blocks
{
    my ($args) = @_;
    my $names  = $args->{names};
    my $page   = $latemp_fn;
    $page =~ s#(?:\A|/)\Kindex\.x?html\z##;

    my $want = $nav_blocks->lookup_page_blocks($page);

    if (0)
    {
        if ( ( $page ne "meta/nav-blocks/blocks/index.xhtml" )
            and $nav_block_renderer->flush_found() )
        {
            my $err = qq#NavBlock had no page "$page"!\n#;
            print {*STDERR} "err=\n\n$err\n\n";
            die $err;
        }
    }
    if ( !defined($want) )
    {
        warn qq{no nav_block_renderer for page='$page'};
        return;
    }
    my $canonicalize_lists = sub {
        $names = [ sort @$names ];
        return;
    };
    $canonicalize_lists->();
    if ( "@$want" ne "@$names" )
    {
        warn qq|mismatch want=[@$want] names=[@$names]|;
        return "&nbsssssspp;";
    }
    return '';
}

sub _render_nav_blocks
{
    my ($args) = @_;
    my $names = $args->{names};
    $names = [ sort @$names ];

    my $ret  = '';
    my $page = $latemp_fn;

    foreach my $name (@$names)
    {
        $ret .= $nav_block_renderer->render(
            { obj => $nav_blocks->get_nav_block($name), } );

        if ( ( $page ne "meta/nav-blocks/blocks/index.xhtml" )
            and $nav_block_renderer->flush_found() )
        {
            my $err = qq#NavBlock "$name" had no page "$page"!\n#;
            print {*STDERR} "err=\n\n$err\n\n";
            die $err;
        }

    }
    return $ret;
}

my $NAV_BLOCKS__START = <<'EOF';
<nav class="nav_blocks">
<header>
<h2 id="nav_blocks">Navigation Blocks</h2>
</header>
EOF

sub render_compact_nav_blocks
{

=begin removed
    my ($args) = @_;
    $args = $args->{STASH};

    my $names = $args->{names}
        or die join( ",", keys %$args ) . "@_;";

    $names = [ sort @$names ];
    check_nav_blocks( { 'names' => $names } );

=cut

    my $page = $latemp_fn;
    $page =~ s#(?:\A|/)\Kindex\.x?html\z##;

    my $names = $nav_blocks->lookup_page_blocks($page);
    if ( not defined $names )
    {
        return '';
    }
    my $ret = '';

    $ret .= $NAV_BLOCKS__START;

    $ret .= _render_nav_blocks( { 'names' => $names } );

    $ret .= qq#</nav>#;
    return $ret;
}

my $fortune_colls_obj = Shlomif::Homepage::FortuneCollections->new;
my $ACRONYMS_FN       = "lib/acronyms/list1.yaml";
my $latemp_acroman =
    HTML::Acronyms->new( dict => scalar( YAML::XS::LoadFile($ACRONYMS_FN) ) );
my $long_stories = Shlomif::Homepage::LongStories->new;
my $shlomif_cpan = $cpan->homepage( +{ who => 'shlomif' } );
my $news = Shlomif::Homepage::News->new( { dir => "lib/feeds/shlomif_hsite" } );
my $LONGBLANK         = ( "<br/>" x 72 );
my $xml_fiction_slurp = Shlomif::XmlFictionSlurp->new;

sub slurp
{
    return path(shift)->slurp_utf8;
}

sub retrieved_slurp
{
    return slurp( "lib/retrieved-html-parts/" . shift );
}

sub path_slurp
{
    return slurp( "lib/" . shift );
}

sub h_inc_path_slurp
{
    return path_slurp(shift) =~ s#<(/?)h([0-9]+)#"<". $1 ."h". ( $2 + 1 )#egr;
}

sub _shlomif_include_colorized_file
{
    my $args = shift;

    return decode_utf8(
        VimIface::get_syntax_highlighted_html_from_file(
            +{ 'filename' => $args->{fn}, }
        )
    );
}
my $ORIG_URL_PREFIX = "https://www.shlomifish.org/";
my $FULL_URL_PREFIX = $ORIG_URL_PREFIX;
my $NAME            = "Shlomi Fish";
my $H               = "Homesite";

sub _process_title
{
    my $args  = shift;
    my $title = $args->{title};
    return (
        ( $title =~ m#\Q${NAME}\E\S*\s+Home# )
        ? $title
        : ("$title - $NAME’s $H")
    );
}

my $FALSE = '';
my $TRUE  = 1;

has vars => (
    is      => 'ro',
    default => sub {
        my $self = shift;
        return +{
            ( $self->printable ? ( PRINTABLE => 1 ) : () ),
            is_dev           => $FALSE,
            cpan             => $cpan,
            is_forked_site   => $FALSE,
            license_obj      => $license,
            long_stories     => $long_stories,
            news_obj         => $news,
            true_stories_obj => $true_stories_obj,
            mytan            =>
qq#\\tan{\\left[\\arcsin{\\left(\\frac{1}{2 \\sin{36°}}\\right)}\\right]}#,
            d2url               => "http://divisiontwo.shlomifish.org/",
            check_nav_blocks    => \&check_nav_blocks,
            nav_blocks_obj      => $nav_blocks,
            print_nav_blocks    => \&_render_nav_blocks,
            article_index__body => sub {
                return Shlomif::Homepage::ArticleIndex->new->calc_string();
            },
            fortunes__package_base => sub {
                lib->import('./src/humour/fortunes/');
                require ShlomifFortunesMake;
                return ShlomifFortunesMake->package_base;
            },
            fortune_colls_obj => $fortune_colls_obj,
            print_markdown    => sub {
                return Shlomif::MD->new()->as_fixed_xhtml5(shift);
            },
            longblank     => $LONGBLANK,
            main_email    => 'shlomif@shlomifish.org',
            process_title => \&_process_title,
            my_acronym    => sub {
                my $args = shift;

                return $latemp_acroman->abbr(
                    { key => $args->{key}, no_link => $args->{no_link}, } )
                    ->{html};
            },
            shlomif_cpan      => $shlomif_cpan,
            default_toc       => $DEFAULT_TOC_DIV,
            toc_div           => \&Shlomif::Homepage::TocDiv::toc_div,
            retrieved_slurp   => \&retrieved_slurp,
            h_inc_path_slurp  => \&h_inc_path_slurp,
            path_slurp        => \&path_slurp,
            xml_fiction_slurp => $xml_fiction_slurp,
            shlomif_include_colorized_file => \&_shlomif_include_colorized_file,
            p4n_lecture5_heb_notes         =>
                \&Shlomif::Homepage::P4N_Lect5_HebNotes::calc,
        };
    }
);

my $template = Template->new(
    {
        COMPILE_DIR  => ( $ENV{TMPDIR} // "/tmp" ) . "/shlomif-hp-tt2-cache",
        COMPILE_EXT  => ".ttc",
        INCLUDE_PATH => [ ".", "./lib", ],
        PRE_PROCESS  => ["lib/blocks.tt2"],
        POST_CHOMP   => 1,
        RELATIVE     => 1,
        ENCODING     => 'utf8',
        BLOCKS       => +{
            render_compact_nav_blocks => \&render_compact_nav_blocks,
        },
    }
);

my $DEST       = path( '.', "dest", "pre-incs", $LATEMP_SERVER, ) . '';
my $INC_PREF   = qq#\n(((((include "cache/combined/$LATEMP_SERVER#;
my $INC_SUFFIX = qq#")))))\n#;

sub _inc
{
    my ( $input_tt2_page_path, $id ) = @_;
    return sprintf( "%s/%s/%s%s",
        $INC_PREF, $input_tt2_page_path, $id, $INC_SUFFIX );
}

sub proc
{
    my ( $self, $input_tt2_page_path ) = @_;
    _set_url( $latemp_fn = $input_tt2_page_path );
    $long_stories->fn( _url_obj() );
    $nav_block_renderer->fn( _url_obj() );
    my @fn = split m#/#, $input_tt2_page_path;
    $base_path = ( $with_absolute_urls ? $ORIG_URL_PREFIX : ( '../' x $#fn ) );

    my $vars = $self->vars;
    $vars->{base_path} = $base_path;
    $license->base_path($base_path);
    $vars->{fn_path} = $input_tt2_page_path;
    my $raw_fn_path = ( $vars->{raw_fn_path} =
            $input_tt2_page_path =~ s#(?:\A|/)\Kindex\.x?html\z##r );
    my $full_url = $FULL_URL_PREFIX . $raw_fn_path;
    $vars->{canonical_url}        = $full_url;
    $vars->{text_ORIG_URL_PREFIX} = $ORIG_URL_PREFIX;
    $vars->{orig_url}             = $ORIG_URL_PREFIX . $raw_fn_path;
    $vars->{escaped_url}          = encodeURIComponent($full_url);
    my $NOT_FRONT_PAGE = scalar( length($raw_fn_path) > 1 );
    $vars->{main_class} =
        Set::CSS->new( "main", ( $NOT_FRONT_PAGE ? ( "fancy_sects", ) : () ), );
    my $set = sub {
        my ( $name, $inc ) = @_;
        $vars->{$name} = _inc( $input_tt2_page_path, $inc );
        return;
    };
    $set->( 'leading_path_string',           "breadcrumbs-trail" );
    $set->( 'html_head_nav_links',           "html_head_nav_links" );
    $set->( 'shlomif_main_expanded_nav_bar', "shlomif_main_expanded_nav_bar" );
    $set->(
        'shlomif_hebrew_expanded_nav_bar',
        "shlomif_hebrew_expanded_nav_bar"
    );
    $set->(
        'nav_links_without_accesskey',
        "shlomif_nav_links_renderer-with_accesskey=0"
    );
    $set->(
        'nav_links_with_accesskey',
        "shlomif_nav_links_renderer-with_accesskey=1"
    );
    $set->( 'nav_menu_html',      "main_nav_menu_html" );
    $set->( 'sect_nav_menu_html', "sect-navmenu" );
    my $html = '';
    $template->process( "src/$input_tt2_page_path.tt2",
        $vars, \$html, binmode => ':utf8', )
        or die $template->error();

    $toc->add_toc( \$html );
    if ( $self->stdout )
    {
        binmode STDOUT, ':encoding(utf-8)';
        print $html;
    }
    else
    {
        path( $DEST, @fn, )->spew_utf8($html);
    }
}

1;
