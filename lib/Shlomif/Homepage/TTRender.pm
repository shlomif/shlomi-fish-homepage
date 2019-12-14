package Shlomif::Homepage::TTRender;

use strict;
use warnings;
use utf8;

use Encode qw/ decode_utf8 /;
use Moo;
use Path::Tiny qw/ path /;

use Template                              ();
use HTML::Latemp::Acronyms                ();
use Shlomif::Homepage::CPAN_Links         ();
use Shlomif::Homepage::FortuneCollections ();
use Shlomif::Homepage::LicenseBlurbs      ();
use Shlomif::Homepage::LongStories        ();
use HTML::Latemp::AddToc                  ();

has printable => ( is => 'ro', required => 1 );
has stdout    => ( is => 'ro', required => 1 );

my $LATEMP_SERVER = "t2";
my $toc           = HTML::Latemp::AddToc->new;

my $cpan    = Shlomif::Homepage::CPAN_Links->new;
my $license = Shlomif::Homepage::LicenseBlurbs->new;

my $base_path;

sub get_base_path_ref
{
    my ($self) = @_;

    return \$base_path;
}

use Shlomif::Homepage::NavBlocks::Renderer ();
use Shlomif::Homepage::NavBlocks           ();

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
my $latemp_acroman    = HTML::Latemp::Acronyms->new;
my $long_stories      = Shlomif::Homepage::LongStories->new;
my $shlomif_cpan      = $cpan->homepage( +{ who => 'shlomif' } );

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

has vars => (
    is      => 'ro',
    default => sub {
        my $self = shift;
        return +{
            ( $self->printable ? ( PRINTABLE => 1 ) : () ),
            cpan        => $cpan,
            license_obj => $license,
            mytan =>
qq#\\tan{\\left[\\arcsin{\\left(\\frac{1}{2 \\sin{36°}}\\right)}\\right]}#,
            d2url            => "http://divisiontwo.shlomifish.org/",
            in_nav_block_set => sub {
                $Shlomif::Homepage::in_nav_block = 1;
                return;
            },
            in_nav_block_unset => sub {
                $Shlomif::Homepage::in_nav_block = undef();
                return;
            },
            print_nav_block => sub {
                my $args = shift;
                return _render_nav_block( $args->{name} );
            },
            p_ArticleIndex__calc_string => sub {
                require Shlomif::Homepage::ArticleIndex;
                return Shlomif::Homepage::ArticleIndex->new->calc_string();
            },
            p_ShlomifFortunesMake__package_base => sub {
                use lib './src/humour/fortunes/';
                use ShlomifFortunesMake;
                return ShlomifFortunesMake->package_base;
            },
            print_fortune_records_toc => sub {
                return $fortune_colls_obj->calc_fortune_records_toc();
            },
            print_front_page => sub {
                require Shlomif::Homepage::News;
                return Shlomif::Homepage::News->new(
                    { dir => "lib/feeds/shlomif_hsite" } )->render_front_page;
            },
            print_old_news => sub {
                require Shlomif::Homepage::News;
                return Shlomif::Homepage::News->new(
                    { dir => "lib/feeds/shlomif_hsite" } )->render_old;
            },
            print_markdown => sub {
                my $args = shift;

                require Shlomif::MD;
                return Shlomif::MD::as_text( $args->{fn} ) =~
                    s#align="(left|right)"#style="float:$1;"#gr =~
s#(<img )([^>]+)(>)#my ($s, $mid, $e)=($1, $2, $3);$mid.=" /" if $mid !~ m%/\s*\z%;$s.$mid.$e#egr;
            },
            longblank => <<'EOF',
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
EOF
            main_email => 'shlomif@shlomifish.org',
            my_acronym => sub {
                my $args = shift;

                return $latemp_acroman->abbr( { key => $args->{key}, } )
                    ->{html};
            },
            shlomif_cpan => $shlomif_cpan,
            toc_div      => sub {
                my %args = %{ shift() // {} };
                $args{head_tag} //= 'h2';
                $args{lang}     //= 'en';
                my $lang_attr =
                    $args{lang} eq 'en'
                    ? "lang=\"en\""
                    : "lang=\"he\"";
                my $title =
                    $args{lang} eq 'en'
                    ? "Table of Contents"
                    : "תוכן העניינים";

                my $head =
                    "<$args{head_tag} id=\"toc\">$title</$args{head_tag}>";
                $head = '';
                my $details = "<summary>$title</summary>";
                my $c =
                    $args{collapse}
                    ? "<details id=\"toc\">$details<toc $lang_attr nohtag=\"1\" /></details>"
                    : "$head<toc $lang_attr />";
                return qq#<nav class="page_toc">$c</nav>#;
            },
            wiki_link => sub {
                my $args = shift() // {};

                return qq#http://perl.net.au/wiki/Beginners#
                    . ( $args->{url} ? '/' . $args->{url} : '' );
            },
            irc_channel => sub {
                my $args = shift;

                my $net     = $args->{net};
                my $chan    = $args->{chan};
                my %servers = (
                    'freenode' => "irc.freenode.net",
                    'efnet'    => "irc.Prison.NET",
                    'oftc'     => "irc.oftc.net",
                    'undernet' => "us.undernet.org",
                    'ircnet'   => "ircnet.demon.co.uk",
                );
                if ( !exists( $servers{$net} ) )
                {
                    die "Unknown network!";
                }
                return
                      "<a href=\"irc://"
                    . $servers{$net}
                    . "/%23$chan\"><code>#$chan</code></a>";
            },
            retrieved_slurp                  => \&retrieved_slurp,
            path_slurp                       => \&path_slurp,
            p__Shlomif_XmlFictionSlurp_slurp => sub {
                require Shlomif::XmlFictionSlurp;
                my $args = shift() // {};
                return Shlomif::XmlFictionSlurp->my_calc($args);
            },
            long_stories__calc_all_stories_entries => sub {
                my $args = shift() // {};
                return $long_stories->calc_all_stories_entries( $args->{tag} );
            },
            long_stories__calc_common_top_elems => sub {
                my $args = shift;

                return $long_stories->calc_common_top_elems( $args->{id} );
            },
            long_stories__calc_abstract => sub {
                my $args = shift;

                return $long_stories->calc_abstract( $args->{id} );
            },
            shlomif_include_colorized_file => sub {
                require VimIface;
                my $args = shift;

                return decode_utf8(
                    VimIface::get_syntax_highlighted_html_from_file(
                        +{ 'filename' => $args->{filename}, }
                    )
                );
            },
            long_stories__calc_logo => sub {
                my $args = shift;

                return $long_stories->calc_logo( $args->{id} );
            },
            p4n_lecture5_heb_notes => sub {
                return decode_utf8( scalar `bash bin/lecture5-txt2html.bash` );
            },
        };
    }
);

my %INDEX = ( map { $_ => 1 } 'index.html', 'index.xhtml' );

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
    my @fn     = split m#/#, $input_tt2_page_path;
    my @fn_nav = @fn;
    my $tail   = \$fn_nav[-1];
    $$tail = '' if ( exists $INDEX{$$tail} );
    $base_path =
        ( '../' x ( scalar(@fn) - 1 ) );
    my $fn2 = join( '/', @fn_nav ) || '/';

    my $vars = $self->vars;
    $vars->{base_path} = $base_path;
    $license->base_path($base_path);
    $vars->{fn_path}     = $input_tt2_page_path;
    $vars->{raw_fn_path} = $input_tt2_page_path =~ s#(\A|/)index\.x?html\z#$1#r;
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
