package Shlomif::Homepage::TTRender;

use strict;
use warnings;
use utf8;

use Encode qw/ decode_utf8 /;
use Moo;
use Path::Tiny qw/ path /;

use HTML::Latemp::Acronyms                ();
use Shlomif::Homepage::FortuneCollections ();
use Shlomif::Homepage::LongStories        ();

sub cpan_dist
{
    my $args = shift;
    return
        qq#<a href="http://metacpan.org/release/$args->{d}">$args->{body}</a>#;
}

sub cpan_homepage
{
    my $args = shift();
    return qq#http://metacpan.org/author/\U$args->{who}\E#;
}

sub cpan_mod
{
    my %args = @_;
    return qq#<a href="http://metacpan.org/module/$args{m}">$args{body}</a>#;
}

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
my $shlomif_cpan      = cpan_homepage( +{ who => 'shlomif' } );

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

my $vars = +{
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

sub calc_vars
{
    my ( $self, $args ) = @_;

    if ( $args->{printable} )
    {
        $vars->{PRINTABLE} = 1;
    }
    else
    {
        delete $vars->{PRINTABLE};
    }
    return $vars;
}

1;
