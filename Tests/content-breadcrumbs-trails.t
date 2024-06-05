#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More tests => 9;
use DBI        ();
use Path::Tiny qw/ path /;
use DBD::SQLite::Constants ':dbd_sqlite_string_mode';

my $full_db_path = "node_modules/sects.sqlite3";

my $dbh = DBI->connect(
    "dbi:SQLite:dbname=$full_db_path",
    "", "",
    {
        RaiseError         => 1,
        sqlite_string_mode => DBD_SQLITE_STRING_MODE_UNICODE_STRICT,
    },
);

$dbh->begin_work();

my $sth = $dbh->prepare("SELECT data FROM t WHERE str_id = ?");

sub _test
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my ($args) = @_;
    my ( $path, $expected, $blurb ) = @$args{qw(path expected blurb)};
    $sth->execute("C/$path");
    my $content = $sth->fetchrow_arrayref()->[0];

    return is( $content . "\n",
        $expected, "$path breadcrumbs trail content is right - $blurb" );
}

sub _starts_with
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my ($args) = @_;
    my ( $path, $expected, $blurb ) = @$args{qw(path expected blurb)};

    $sth->execute("C/$path");
    my $content = $sth->fetchrow_arrayref()->[0];

    return is( substr( $content, 0, length($expected) ),
        $expected, "$path section nav-menu content starts right - $blurb" );
}

# TEST
TODO:
{
    # local $TODO = 1;
    _test(
        {
            path     => "lecture/W2L/Network/index.xhtml/breadcrumbs-trail",
            blurb    => 'w2l-networking-lecture',
            expected => <<'EOF',
<a href="../../../">Shlomi Fish’s Homepage</a> → <a href="../../" title="Presentations I Wrote (Mostly Technical)">Lectures</a> → <a href="../" title="Presentations in the Series for Linux Beginners">Welcome to Linux</a> → <a href="./" title="Networking in Linux Explanation and Howto">Networking</a>
EOF
        }
    );
}

# TEST
_test(
    {
        path     => "humour/bits/facts/Buffy/index.xhtml/breadcrumbs-trail",
        blurb    => 'buffy factoids',
        expected => <<'EOF',
<a href="../../../../">Shlomi Fish’s Homepage</a> → <a href="../../../" title="My Humorous Creations">Humour</a> → <a href="../../../aphorisms/">Aphorisms and Quotes</a> → <a href="../" title="“Facts” about Chuck Norris and other things">Factoids</a> → <a href="./">Buffy Facts</a>
EOF
    }
);

# TEST
TODO:
{
    # local $TODO = 1;
    _test(
        {
            path =>
                "humour/TheEnemy/The-Enemy-English-v7.html/breadcrumbs-trail",
            blurb    => 'The-Enemy-English',
            expected => <<'EOF',
<a href="../../">Shlomi Fish’s Homepage</a> → <a href="../" title="My Humorous Creations">Humour</a> → <a href="../stories/">Stories</a> → <a href="../stories/usable/">Usable</a> → <a href="./" title="The Enemy and How I Helped to Fight it">The Enemy</a> → <a href="The-Enemy-English-v7.html" title="Text of “The Enemy” In English">Text in English</a>
EOF
        }
    );

    # TEST
    _test(
        {
            path =>
"humour/Star-Trek/We-the-Living-Dead/index.xhtml/breadcrumbs-trail",
            blurb    => 'Star-Trek/We-the-Living-Dead',
            expected => <<'EOF',
<a href="../../../">Shlomi Fish’s Homepage</a> → <a href="../../" title="My Humorous Creations">Humour</a> → <a href="../../stories/" title="Large-Scale Stories I Wrote">Stories</a> → <a href="../../stories/usable/">Usable</a> → <a href="./">Star Trek: “We, the Living Dead”</a>
EOF
        }
    );

    # TEST
    _test(
        {
            path  => "humour/Queen-Padme-Tales/cast.html/breadcrumbs-trail",
            blurb =>
'The Queen-Padme-Tales cast page should be part of the site-flow',
            expected => <<'EOF',
<a href="../../">Shlomi Fish’s Homepage</a> → <a href="../" title="My Humorous Creations">Humour</a> → <a href="../stories/">Stories</a> → <a href="../stories/usable/">Usable</a> → <a href="./" title="Star Wars + Star Trek + Real Life Fanfic">Queen Padmé Tales</a> → <a href="cast.html" title="Who I want to play each character">Cast</a>
EOF
        }
    );
}

# TEST
_test(
    {
        path =>
"open-source/resources/editors-and-IDEs/index.xhtml/breadcrumbs-trail",
        blurb    => 'curated lists: IDEs',
        expected => <<'EOF',
<a href="../../../">Shlomi Fish’s Homepage</a> → <a href="../../" title="Pages related to Software (mostly Open-Source)">Software</a> → <a href="../" title="Various Software Resources Pages">Resources Pages</a> → <a href="../sw-lists/">Curated Lists and Directories</a> → <a href="./" title="Index of Text Editors and Integrated Development Environments">Editors and IDEs</a>
EOF
    }
);

# TEST
_test(
    {
        path =>
"humour/bits/true-stories/socialising-with-a-young-hermione-cosplayer/index.xhtml/breadcrumbs-trail",
        blurb    => 'true-stories are not "Humour"',
        expected => <<'EOF',
<a href="../../../../">Shlomi Fish’s Homepage</a> → <a href="../../../">Stories</a> → <a href="../../" title="Small Scale Funny Works of Mine">Small Scale</a> → <a href="../">True Stories / Memoirs</a> → <a href="./" title="Socialising with a young Hermione (“Harry Potter”) cosplayer and her family at GeekCon Nine Worlds">Socialising with a Young Hermione Cosplayer and Her Family</a>
EOF
    }
);

# TEST
_starts_with(
    {
        path =>
"humour/bits/true-stories/socialising-with-a-young-hermione-cosplayer/index.xhtml/sect-navmenu",
        blurb    => 'true-stories are not "Humour"',
        expected => <<'EOF',
<p class="invisible"><a href="#aft_sub_menu">Skip the sub-menu.</a></p>
<div class="sub_menu">
<h2>Stories Section Menu</h2>
EOF
    }
);

# TEST
_test(
    {
        path =>
"philosophy/philosophy/SummerNSA-2014-09-call-for-action/index.xhtml/breadcrumbs-trail",
        blurb    => 'SummerNSA call4action is below #SummerNSA',
        expected => <<'EOF',
<a href="../../../">Shlomi Fish’s Homepage</a> → <a href="../../" title="Various Essays and Articles about Technology and Philosophy in General">Essays</a> → <a href="../../politics/" title="Essays about Politics and Philosophical Politics">Political Essays</a> → <a href="../../SummerNSA/" title="The #SummerNSA / “Summerschool at the NSA” effort">#SummerNSA</a> → <a href="./">Sep 2014 Call for Action</a>
EOF
    }
);
