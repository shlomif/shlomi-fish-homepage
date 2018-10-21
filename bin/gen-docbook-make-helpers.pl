#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use utf8;

use File::Basename qw(dirname basename);
use Path::Tiny qw/ cwd path /;
use Parallel::ForkManager ();
use YAML::XS              ();
use lib './lib';
use HTML::Latemp::GenWmlHSects        ();
use HTML::Latemp::DocBook::GenMake    ();
use Shlomif::Homepage::GenQuadPresMak ();

my $global_username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);

my $cwd            = cwd();
my $upper_dir      = dirname($cwd);
my $cwd_basename   = basename($cwd);
my $git_clones_dir = path("$upper_dir/_$cwd_basename--clones");
$git_clones_dir->mkpath;

sub _github_clone
{
    my $args = shift;

    my $type = $args->{'type'} // 'github_git';

    my $gh_username = $args->{'username'};
    my $repo        = $args->{'repo'};
    my $into_dir    = $args->{'into_dir'};

    my $url;

    if ( $type eq 'bitbucket_hg' )
    {
        $url = qq#https://$gh_username\@bitbucket.org/$gh_username/$repo#;
    }
    else
    {
        $url = "https://github.com/$gh_username/$repo.git";
    }

    my $clone_into = $git_clones_dir->child($repo);
    my $link       = "$into_dir/$repo";

    my @prefix =
        (
        ( $type eq 'bitbucket_hg' ) ? ( 'hg', 'clone' ) : ( 'git', 'clone' ) );
    my @cmd = ( @prefix, $url, $clone_into );

    if ( !-e $clone_into )
    {
        print "@cmd\n";
        if ( system(@cmd) )
        {
            die "git clone [@cmd] failed!";
        }
    }
    if ( !-e $link )
    {
        symlink( $clone_into, $link );
    }

    return;
}

sub _bitbucket_hg_shlomif_clone
{
    my ( $into_dir, $repo ) = @_;

    return _github_clone(
        {
            type     => 'bitbucket_hg',
            username => 'shlomif',
            into_dir => $into_dir,
            repo     => $repo,
        }
    );
}

sub _github_shlomif_clone
{
    my ( $into_dir, $repo ) = @_;

    return _github_clone(
        {
            username => 'shlomif',
            into_dir => $into_dir,
            repo     => $repo,
        }
    );
}

my $pm = Parallel::ForkManager->new(20);

sub _task(&)
{
    my $cb = shift;
    if ( not $pm->start )
    {
        $cb->();
        $pm->finish;
    }
    return;
}

if ( not -e 'lib/js/MathJax/README.md' )
{
    _task
    {
        system(
'cd lib/js && git clone git://github.com/mathjax/MathJax.git MathJax && cd MathJax && git checkout 2.7.5'
        );
    };
}

if ( not -e 'lib/js/jquery-expander' )
{
    _task
    {
        system(
'cd lib/js && git clone https://github.com/kswedberg/jquery-expander'
        );
    };
}
if ( not -e 'lib/ebookmaker/README.md' )
{
    _task
    {
      # Broken due to the bug in this pull-request:
      #    - https://github.com/setanta/ebookmaker/pull/7
      #
      # I switched to my fork for now.
      #
      # system('cd lib && git clone https://github.com/setanta/ebookmaker.git');
        system('cd lib && git clone https://github.com/shlomif/ebookmaker');
    };
}

if ( not -e 'lib/c-begin/README.md' )
{
    _task
    {
        system('cd lib && git clone https://github.com/shlomif/c-begin.git');
    };
}

my $BLOGS_DIR     = 'lib/blogs';
my $TECH_BLOG     = 'shlomif-tech-diary';
my $back_to_hp    = 'Shlomi-Fish-Back-to-my-Homepage-Logo';
my $VALIDATE_YOUR = 'validate-your-html';
foreach my $repo ( $VALIDATE_YOUR, 'how-to-share-code-online', $TECH_BLOG,
    $back_to_hp, )
{
    if ( not -e "$BLOGS_DIR/$repo" )
    {
        _task
        {
            _github_shlomif_clone( $BLOGS_DIR, $repo );
        };
    }
}

my $screenplay_vcs_base_dir = 'lib/screenplay-xml/from-vcs';

my @screenplay_git_checkouts;
my @screenplay_docs_basenames;
my @screenplay_epubs;

sub _calc_screenplay_doc_makefile_lines
{
    my $d = $_;

    my $b           = $d->{base};
    my $github_repo = $d->{github_repo};
    my $subdir      = $d->{subdir};
    my $docs        = $d->{docs};

    my $vcs_dir_var = "${b}__VCS_DIR";

    push @screenplay_git_checkouts, { github_repo => $github_repo, };

    my @ret;

    push @ret, "$vcs_dir_var = $screenplay_vcs_base_dir/$github_repo/$subdir\n";

    foreach my $doc (@$docs)
    {
        my $doc_base = $doc->{base};
        my $suf      = $doc->{suffix};

        push @screenplay_docs_basenames, $doc_base;

        my $src_varname       = "${b}_${suf}_SCREENPLAY_XML_SOURCE";
        my $dest_varname      = "${b}_${suf}_TXT_FROM_VCS";
        my $epub_dest_varname = "${b}_${suf}_EPUB_FROM_VCS";
        my $src_vcs_dir_var   = "${b}_${suf}_SCREENPLAY_XML__SRC_DIR";

        push @screenplay_epubs, $epub_dest_varname;

        push @ret, "$src_vcs_dir_var = \$($vcs_dir_var)/screenplay\n\n";
        push @ret,
"$src_varname = \$($src_vcs_dir_var)/${doc_base}.screenplay-text.txt\n\n";

        push @ret,
            "$dest_varname = \$(SCREENPLAY_XML_TXT_DIR)/${doc_base}.txt\n\n";

        push @ret,
"$epub_dest_varname = \$(SCREENPLAY_XML_EPUB_DIR)/${doc_base}.epub\n\n";

        push @ret,
            (     "\$($dest_varname): \$($src_varname)\n" . "\t"
                . q/$(call COPY)/
                . "\n\n" );

        push @ret, <<"EOF";
\$($epub_dest_varname): \$($src_varname) \$($src_vcs_dir_var)/scripts/prepare-epub.pl
\texport EBOOKMAKER="\$\$PWD/lib/ebookmaker/ebookmaker"; cd \$($src_vcs_dir_var) && SCREENPLAY_COMMON_INC_DIR="\$(SCREENPLAY_COMMON_INC_DIR)" gmake epub
\tcp -f \$($src_vcs_dir_var)/${doc_base}.epub \$($epub_dest_varname) || true
EOF
    }

    return \@ret;
}

{
    my @o = ( map { @{ _calc_screenplay_doc_makefile_lines($_) } }
            @{ YAML::XS::LoadFile("./lib/screenplay-xml/list.yaml") } );
    my $epub_dests_varname = 'SCREENPLAY_XML__EPUBS_DESTS';
    my $epub_dests         = <<'EOF';
$(T2_POST_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-part-1.epub \
$(T2_POST_DEST)/humour/Buffy/A-Few-Good-Slayers/Buffy--a-Few-Good-Slayers.epub \
$(T2_POST_DEST)/humour/humanity/Humanity-Movie.epub \
$(T2_POST_DEST)/humour/humanity/Humanity-Movie-hebrew.epub \
$(T2_POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Harry-Potter.epub \
$(T2_POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Jennifer-Lawrence.epub \
$(T2_POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Summer-Glau-and-Chuck-Norris.epub   \
$(T2_POST_DEST)/humour/Selina-Mandrake/selina-mandrake-the-slayer.epub \
$(T2_POST_DEST)/humour/Star-Trek/We-the-Living-Dead/Star-Trek--We-the-Living-Dead.epub \
$(T2_POST_DEST)/humour/So-Who-The-Hell-Is-Qoheleth/So-Who-the-Hell-is-Qoheleth.epub \
$(T2_POST_DEST)/humour/Summerschool-at-the-NSA/Summerschool-at-the-NSA.epub \
$(T2_POST_DEST)/humour/TOWTF/TOW_Fountainhead_1.epub \
$(T2_POST_DEST)/humour/TOWTF/TOW_Fountainhead_2.epub \
EOF

    my @_files = ( $epub_dests =~ /(\$\(T2_POST_DEST\)\S+)/g );
    my @_htmls_files =
        map { my $x = $_; $x =~ s/\.epub\z/\.raw.html/; $x } @_files;

    my $_htmls_dests = join "", map { "$_ \\\n" } @_htmls_files;
    path("lib/make/docbook/sf-screenplays.mak")->spew_utf8(
        @o,
        "\n\nSCREENPLAY_DOCS_FROM_GEN = \\\n",
        ( map { "\t$_ \\\n" } @screenplay_docs_basenames ),
        "\n\nSCREENPLAY_DOCS__DEST_EPUBS = \\\n",
        ( map { "\t\$($_) \\\n" } @screenplay_epubs ),
        "\n\n",
        "$epub_dests_varname = \\\n$epub_dests$_htmls_dests\n\n",
        (
            map {
                      "$_: \$(SCREENPLAY_XML_EPUB_DIR)/"
                    . [ split m#/#, $_ ]->[-1]
                    . "\n\t\$(call COPY)\n\n"
            } @_files
        ),
        (
            map {
                "$_: \$(SCREENPLAY_XML_HTML_DIR)/"
                    . do
                {
                    my $x = [ split m#/#, $_ ]->[-1];
                    $x =~ s/\.raw(\.html)\z/$1/;
                    $x;
                    }
                    . qq{\n\tperl -lpE 's#\\Q xmlns:sp="http://web-cpan.berlios.de/modules/XML-Grammar-Screenplay/screenplay-xml-0.2/"\\E## if m#^<html #ms' < \$< > \$\@\n\n}
            } @_htmls_files
        ),
    );

    my $clone_cb = sub {
        my ($r) = @_;

        my $full = "$screenplay_vcs_base_dir/$r";

        if ( not -e $full )
        {
            _task
            {
                _github_shlomif_clone( $screenplay_vcs_base_dir, $r );
            };
        }

        return;
    };

    foreach my $github_repo (@screenplay_git_checkouts)
    {
        $clone_cb->( $github_repo->{github_repo} );
    }
    $clone_cb->('screenplays-common');
}

my $fiction_vcs_base_dir = 'lib/fiction-xml/from-vcs';

my @fiction_docs_basenames;

sub _calc_fiction_story_makefile_lines
{
    my ($d) = @_;

    my $b           = $d->{base};
    my $github_repo = $d->{github_repo};
    my $subdir      = $d->{subdir};
    my $docs        = $d->{docs};

    my $vcs_dir_var = "${b}__VCS_DIR";

    my @ret;

    push @ret, "$vcs_dir_var = \$(FICTION_VCS_BASE_DIR)/$github_repo\n\n";

    foreach my $doc (@$docs)
    {
        my $doc_base = $doc->{base};
        my $suf      = $doc->{suf};
        my $type     = $doc->{type};

        my $bsuf = "${b}_${suf}";

        my (
            $src_varname, $from_vcs_varname, $src_suffix,
            $dest_suffix, $dest_dir_var
        );

        if ( $type eq 'fiction-text' )
        {
            push @fiction_docs_basenames, $doc_base;

            $src_varname      = "${bsuf}_FICTION_XML_SOURCE";
            $src_suffix       = 'fiction-text.txt';
            $from_vcs_varname = "${bsuf}_FICTION_TXT_FROM_VCS";
            $dest_suffix      = 'txt';
            $dest_dir_var     = 'FICTION_XML_TXT_DIR';
        }
        elsif ( $type eq 'docbook5' )
        {
            $src_varname      = "${bsuf}_DOCBOOK5_SOURCE";
            $src_suffix       = 'db5.xml';
            $from_vcs_varname = "${bsuf}_DOCBOOK5_FROM_VCS";
            $dest_suffix      = 'xml';
            $dest_dir_var     = 'DOCBOOK5_XML_DIR';
        }

        push @ret,
"$src_varname = \$($vcs_dir_var)/$subdir/text/$doc_base.$src_suffix\n\n";
        push @ret,
            "$from_vcs_varname = \$($dest_dir_var)/$doc_base.$dest_suffix\n\n";

        push @ret,
            qq{\$($from_vcs_varname): \$($src_varname)\n\t\$(call COPY)\n\n};
    }

    return \@ret;
}

{
    my $fiction_data = [
        {
            base        => "EARTH_ANGEL",
            github_repo => "The-Earth-Angel",
            subdir      => "The-Earth-Angel",
            docs        => [
                {
                    base => "The-Earth-Angel-english",
                    type => "fiction-text",
                    suf  => "ENG",
                },
                {
                    base => "The-Earth-Angel-hebrew",
                    type => "fiction-text",
                    suf  => "HEB",
                },
            ],
        },
        {
            base        => "HHFG",
            github_repo => "Human-Hacking-Field-Guide",
            subdir      => "HHFG",
            docs        => [
                {
                    base => "human-hacking-field-guide-v2--english",
                    type => "docbook5",
                    suf  => "ENG",
                },
                {
                    base => "human-hacking-field-guide-v2--hebrew",
                    type => "fiction-text",
                    suf  => "HEB",
                },
            ],
        },
        {
            base        => "POPE",
            github_repo => "The-Pope-Died-on-Sunday",
            subdir      => "Pope",
            docs        => [
                {
                    base => "The-Pope-Died-on-Sunday-english",
                    type => "fiction-text",
                    suf  => "ENG",
                },
                {
                    base => "The-Pope-Died-on-Sunday-hebrew",
                    type => "fiction-text",
                    suf  => "HEB",
                },
            ],
        },
    ];

FICT:
    foreach my $d (@$fiction_data)
    {
        my $github_repo = $d->{github_repo};
        my $r           = $github_repo;
        my $full        = "$fiction_vcs_base_dir/$r";

        next FICT if -e $full;
        _task
        {
            _github_shlomif_clone( $fiction_vcs_base_dir, $r );
        };
    }

    my @o =
        ( map { @{ _calc_fiction_story_makefile_lines($_) } } @$fiction_data );

    path("lib/make/docbook/sf-fictions.mak")->spew_utf8(
        "FICTION_VCS_BASE_DIR = $fiction_vcs_base_dir\n\n",
        @o,
        (
            "\n\nFICTION_DOCS_FROM_GEN = \\\n",
            ( map { "\t$_ \\\n" } @fiction_docs_basenames ),
            "\n\n"
        ),
    );
}

HTML::Latemp::DocBook::GenMake->new(
    { dest_var => '$(T2_DEST)', post_dest_var => '$(T2_POST_DEST)' } )
    ->generate;
Shlomif::Homepage::GenQuadPresMak->new->generate;
HTML::Latemp::GenWmlHSects->new->run;

$pm->wait_all_children;
