#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;
use utf8;

use lib './lib';
use Template                         ();
use Parallel::ForkManager::Segmented ();

use Path::Tiny qw/ path /;
use Encode qw/ decode_utf8 /;
use Getopt::Long qw/ GetOptions /;

use HTML::Latemp::AddToc   ();
use HTML::Latemp::Acronyms ();

my $latemp_acroman = HTML::Latemp::Acronyms->new;
$Shlomif::Homepage::in_nav_block = undef();

use Shlomif::Homepage::NavBlocks::Renderer ();
use Shlomif::Homepage::NavBlocks (
    qw(
        get_nav_block
        )
);

my $nav_block_renderer = Shlomif::Homepage::NavBlocks::Renderer->new(
    {
        host => 't2',
    }
);

sub _render_nav_block
{
    my ($id) = @_;

    return $nav_block_renderer->render( { obj => get_nav_block($id), } );
}

sub _print_nav_block
{
    if ( not $Shlomif::Homepage::in_nav_block )
    {
        # Cancelled due to tt2 scoping.
        # die "I suck. \$Shlomif::Homepage::in_nav_block must be set.";
    }
    return _render_nav_block(@_);
}

# use MyNavData            ();

# use MyNavLinks ();

my $printable;
my $stdout;
my @filenames;
GetOptions(
    'printable!' => \$printable,
    'stdout!'    => \$stdout,
    'fn=s'       => \@filenames,
);

my $LATEMP_SERVER = "t2";
my $template      = Template->new(
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

sub cpan_mod
{
    my %args = @_;
    return qq#<a href="http://metacpan.org/module/$args{m}">$args{body}</a>#;
}

sub cpan_homepage
{
    my $args = shift();
    return qq#http://metacpan.org/author/\U$args->{who}\E#;
}

my $shlomif_cpan = cpan_homepage( +{ who => 'shlomif' } );

sub cpan_dist
{
    my $args = shift;
    return
        qq#<a href="http://metacpan.org/release/$args->{d}">$args->{body}</a>#;
}

sub path_slurp
{
    return slurp( "lib/" . shift );
}

sub retrieved_slurp
{
    return slurp( "lib/retrieved-html-parts/" . shift );
}

sub slurp
{
    return path(shift)->slurp_utf8;
}

sub cc_by_sa_british_blurb
{
    my $args = shift;
    my $year = $args->{year};

    return <<"EOF";
<p>
This document is Copyright by Shlomi Fish, $year, and is available
under the
terms of <a rel="license"
href="http://creativecommons.org/licenses/by-sa/3.0/">the Creative Commons
Attribution-ShareAlike License 3.0 Unported</a> (or at your option any
later version).
</p>

<p>
For securing additional rights, please contact
<a href="http://www.shlomifish.org/me/contact-me/">Shlomi Fish</a>
and see <a href="http://www.shlomifish.org/meta/copyrights/">the
explicit requirements</a> that are being spelt from abiding by that licence.
</p>
EOF
}

sub cc_by_sa_license_british
{
    my $args = shift() // {};

    my $head_tag = $args->{head_tag} // 'h3';

    return qq#
<$head_tag id="license">Copyright and Licence</$head_tag># .

        cc_by_sa_british_blurb($args);

}

use Shlomif::Homepage::LongStories        ();
use Shlomif::Homepage::FortuneCollections ();
my $long_stories      = Shlomif::Homepage::LongStories->new;
my $fortune_colls_obj = Shlomif::Homepage::FortuneCollections->new;
my @DEST              = ( '.', "dest", "pre-incs", $LATEMP_SERVER, );
my $base_path;
my $vars = +{
    ( $printable ? ( PRINTABLE => 1 ) : () ),
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
        return _print_nav_block( $args->{name} );
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

        return $latemp_acroman->abbr( { key => $args->{key}, } )->{html};
    },
    shlomif_cpan             => $shlomif_cpan,
    cpan_homepage            => \&cpan_homepage,
    cc_by_sa_british_blurb   => \&cc_by_sa_british_blurb,
    cc_by_sa_license_british => \&cc_by_sa_license_british,
    cc_by_british_blurb      => sub {
        my $args = shift;

        my $year = $args->{year};

        return <<"EOF";
<p><a rel="license" href="http://creativecommons.org/licenses/by/3.0/"><img alt="Creative Commons License" class="bless" src="${base_path}images/somerights20.png"/></a></p>

<p>
This document is Copyright by Shlomi Fish, $year, and is available
under the
terms of <a rel="license"
href="http://creativecommons.org/licenses/by/3.0/">the Creative Commons
Attribution License 3.0 Unported</a> (or at your option any
later version of that licence).
</p>

<p>
For securing additional rights, please contact
<a href="http://www.shlomifish.org/me/contact-me/">Shlomi Fish</a>
and see <a href="http://www.shlomifish.org/meta/copyrights/">the
explicit requirements</a> that are being spelt from abiding by that licence.
</p>
EOF
    },
    cc_by_hebrew_blurb => sub {
        my $args = shift;

        my $year = $args->{year};

        return <<"EOF";
<p><a rel="license" href="http://creativecommons.org/licenses/by/2.5/deed.he"><img alt="Creative Commons License" class="bless" src="${base_path}images/somerights20.png"/></a></p>

<p>
זכויות היוצרים על מסמך זה שייכות לשלומי פיש, והוא נוצר בשנת ${year},
תחת תנאי
<a rel="license" href="http://creativecommons.org/licenses/by/2.5/deed.he">הרישיון
ייחוס 2.5 לא מותאם של קריאייטיב קומונס Creative Commons)</a>
(או לשיקולכם כל גרסה מאוחרת יותר של אותו הרישיון.)
</p>

<p>
בשביל לרכוש זכויות נוספות, אנא צרו קשר עם
<a href="http://www.shlomifish.org/me/contact-me/">שלומי פיש</a>
ושימו לב
<a href="http://www.shlomifish.org/meta/copyrights/">לדרישות המפורשות</a>
שהוא דורש כדי לעמוד בתנאי הרישיון הזה.
</p>
EOF
    },
    toc_div => sub {
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

        my $head = "<$args{head_tag} id=\"toc\">$title</$args{head_tag}>";
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
    cpan_self_mod => sub {
        my $args = shift;

        return cpan_mod( %$args, body => $args->{'m'} );
    },
    cpan_b_self_dist => sub {
        my $args = shift;

        return cpan_dist( { %$args, body => "<b>$args->{d}</b>", } );
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
    cpan_self_dist => sub {
        my $args = shift;

        return cpan_dist( { %$args, body => $args->{d} } );
    },
    retrieved_slurp => \&retrieved_slurp,
    path_slurp      => \&path_slurp,
    p4n_slurp       => sub {
        my $idx = shift;
        return path(
            "lib/tutorials/perl-for-newbies/lect$idx-all-in-one/index.html")
            ->slurp_utf8() =~ s{.*<body[^>]*>}{}mrs =~ s{< / body >.*}{}mrsx;
    },
    book_info => sub {
        require PerlBegin::Books;
        return PerlBegin::Books->book_info(shift);
    },
    files_and_dirs => sub {
        require PerlBegin::TopicsExamples::FilesAndDirs;

        return PerlBegin::TopicsExamples::FilesAndDirs->_run();
    },
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

my @tt;
if (@filenames)
{
    @tt = @filenames;
}
else
{
    @tt = path("lib/make/tt2.txt")->lines_raw;
    chomp @tt;
}
my $toc        = HTML::Latemp::AddToc->new;
my $INC_PREF   = qq#\n(((((include "cache/combined/$LATEMP_SERVER#;
my $INC_SUFFIX = qq#")))))\n#;

sub _inc
{
    my ( $result, $id ) = @_;
    return sprintf( "%s/%s/%s%s", $INC_PREF, $result, $id, $INC_SUFFIX );
}

sub proc
{
    my $result = shift;
    $::latemp_filename = $result;
    my @fn     = split m#/#, $result;
    my @fn_nav = @fn;
    if ( $fn_nav[-1] =~ m#\Aindex\.x?html\z# )
    {
        $fn_nav[-1] = '';
    }
    $base_path =
        ( '../' x ( scalar(@fn) - 1 ) );
    my $fn2 = join( '/', @fn_nav ) || '/';

=begin removed
    my $nav_bar = HTML::Widgets::NavMenu->new(
        'path_info'    => $fn2,
        'current_host' => $LATEMP_SERVER,
        MyNavData::get_params(),
        'ul_classes'     => [],
        'no_leading_dot' => 1,
    );

    my $rendered_results = $nav_bar->render();
    my $nav_links_obj = $rendered_results->{nav_links_obj};
            my $nav_links = $rendered_results->{nav_links};
            my $nav_links_renderer = MyNavLinks->new(
                'nav_links'     => $nav_links,
                'nav_links_obj' => $nav_links_obj,
                'root'          => $base_path,
            );
            my $with_accesskey = '';
            my @params;
            if ( $with_accesskey ne "" )
            {
                push @params, ( 'with_accesskey' => $with_accesskey );
            }
            my $text = $nav_links_renderer->get_total_html(@params);
=cut

    $vars->{base_path}   = $base_path;
    $vars->{fn_path}     = $result;
    $vars->{raw_fn_path} = $result =~ s#(\A|/)index\.x?html\z#$1#r;
    my $set = sub {
        my ( $name, $inc ) = @_;
        $vars->{$name} = _inc( $result, $inc );
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
    $template->process( "src/$result.tt2", $vars, \$html, binmode => ':utf8', )
        or die $template->error();

    $toc->add_toc( \$html );
    if ($stdout)
    {
        binmode STDOUT, ':encoding(utf-8)';
        print $html;
    }
    else
    {
        path( @DEST, @fn, )->spew_utf8($html);
    }
}

Parallel::ForkManager::Segmented->new->run(
    {
        items        => \@tt,
        nproc        => 4,
        batch_size   => 100,
        process_item => \&proc,
    }
);
