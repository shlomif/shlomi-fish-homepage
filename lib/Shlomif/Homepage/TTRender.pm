package Shlomif::Homepage::TTRender;

use strict;
use warnings;
use utf8;

use Encode qw/ decode_utf8 /;
use Moo;
use Path::Tiny qw/ path /;
use YAML::XS ();

use HTML::Acronyms                         ();
use HTML::Latemp::AddToc                   ();
use Shlomif::Homepage::ArticleIndex        ();
use Shlomif::Homepage::CPAN_Links          ();
use Shlomif::Homepage::FortuneCollections  ();
use Shlomif::Homepage::LicenseBlurbs       ();
use Shlomif::Homepage::LongStories         ();
use Shlomif::Homepage::NavBlocks           ();
use Shlomif::Homepage::NavBlocks::Renderer ();
use Shlomif::Homepage::News                ();
use Shlomif::Homepage::P4N_Lect5_HebNotes  ();
use Shlomif::Homepage::TocDiv              ();
use Shlomif::MD                            ();
use Shlomif::XmlFictionSlurp               ();
use Template                               ();
use VimIface                               ();

has printable => ( is => 'ro', required => 1 );
has stdout    => ( is => 'ro', required => 1 );

my $LATEMP_SERVER = "t2";
my $toc           = HTML::Latemp::AddToc->new;

my $DEFAULT_TOC_DIV = Shlomif::Homepage::TocDiv::toc_div();
my $cpan            = Shlomif::Homepage::CPAN_Links->new;
my $license         = Shlomif::Homepage::LicenseBlurbs->new;

my $base_path;

my $nav_blocks         = Shlomif::Homepage::NavBlocks->new;
my $nav_block_renderer = Shlomif::Homepage::NavBlocks::Renderer->new(
    {
        host => 't2',
    }
);

sub _render_nav_block
{
    my ($id) = @_;

    return $nav_block_renderer->render(
        { obj => $nav_blocks->get_nav_block($id), } );
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

sub _shlomif_include_colorized_file
{
    my $args = shift;

    return decode_utf8(
        VimIface::get_syntax_highlighted_html_from_file(
            +{ 'filename' => $args->{fn}, }
        )
    );
}

has vars => (
    is      => 'ro',
    default => sub {
        my $self = shift;
        return +{
            ( $self->printable ? ( PRINTABLE => 1 ) : () ),
            cpan         => $cpan,
            license_obj  => $license,
            long_stories => $long_stories,
            news_obj     => $news,
            mytan =>
qq#\\tan{\\left[\\arcsin{\\left(\\frac{1}{2 \\sin{36°}}\\right)}\\right]}#,
            d2url           => "http://divisiontwo.shlomifish.org/",
            print_nav_block => sub {
                my $args = shift;
                return _render_nav_block( $args->{name} );
            },
            article_index__body => sub {
                return Shlomif::Homepage::ArticleIndex->new->calc_string();
            },
            fortunes__package_base => sub {
                lib->import('./src/humour/fortunes/');
                require ShlomifFortunesMake;
                return ShlomifFortunesMake->package_base;
            },
            fortune_colls_obj => $fortune_colls_obj,
            print_markdown    => \&Shlomif::MD::as_fixed_xhtml5,
            longblank         => $LONGBLANK,
            main_email        => 'shlomif@shlomifish.org',
            my_acronym        => sub {
                my $args = shift;

                return $latemp_acroman->abbr( { key => $args->{key}, } )
                    ->{html};
            },
            shlomif_cpan      => $shlomif_cpan,
            default_toc       => $DEFAULT_TOC_DIV,
            toc_div           => \&Shlomif::Homepage::TocDiv::toc_div,
            retrieved_slurp   => \&retrieved_slurp,
            path_slurp        => \&path_slurp,
            xml_fiction_slurp => $xml_fiction_slurp,
            shlomif_include_colorized_file => \&_shlomif_include_colorized_file,
            p4n_lecture5_heb_notes =>
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
    }
);

my @DEST       = ( '.', "dest", "pre-incs", $LATEMP_SERVER, );
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
    $::latemp_filename = $input_tt2_page_path;
    my @fn = split m#/#, $input_tt2_page_path;
    $base_path = ( '../' x $#fn );

    my $vars = $self->vars;
    $vars->{base_path} = $base_path;
    $license->base_path($base_path);
    $vars->{fn_path} = $input_tt2_page_path;
    $vars->{raw_fn_path} =
        $input_tt2_page_path =~ s#(?:\A|/)\Kindex\.x?html\z##r;
    my $set = sub {
        my ( $name, $inc ) = @_;
        $vars->{$name} = _inc( $input_tt2_page_path, $inc );
        return;
    };
    $set->( 'leading_path_string',           "breadcrumbs-trail" );
    $set->( 'html_head_nav_links',           "html_head_nav_links" );
    $set->( 'shlomif_main_expanded_nav_bar', "shlomif_main_expanded_nav_bar" );
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
        path( @DEST, @fn, )->spew_utf8($html);
    }
}

1;
