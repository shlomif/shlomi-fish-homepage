#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use utf8;

use File::Basename qw(dirname basename);
use Cwd qw(getcwd);
use Template ();
use Path::Tiny qw/ path /;
use File::Find::Object::Rule ();
use List::MoreUtils qw(any);
use Parallel::ForkManager ();
use File::Update qw/ write_on_change /;
use lib './lib';
use HTML::Latemp::GenWmlHSects;

my $global_username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);

my $cwd            = getcwd();
my $upper_dir      = dirname($cwd);
my $cwd_basename   = basename($cwd);
my $git_clones_dir = "$upper_dir/_$cwd_basename--clones";
path($git_clones_dir)->mkpath;

sub _github_clone
{
    my $args = shift;

    my $type = $args->{'type'} // 'github_git';

    my $gh_username = $args->{'username'};
    my $repo        = $args->{'repo'};
    my $into_dir    = $args->{'into_dir'};

    my $url;

    if (   ( $gh_username eq 'shlomif' )
        && ( $global_username eq 'shlomif' )
        && ( !$ENV{SHLOMIF_ANON} ) )
    {
        if ( $type eq 'bitbucket_hg' )
        {
            $url = qq#ssh://hg\@bitbucket.org/${gh_username}/${repo}#;
        }
        else
        {
            $url = "git\@github.com:${gh_username}/${repo}.git";
        }
    }
    else
    {
        if ( $type eq 'bitbucket_hg' )
        {
            $url = qq#https://$gh_username\@bitbucket.org/$gh_username/$repo#;
        }
        else
        {
            $url = "https://github.com/$gh_username/$repo.git";
        }
    }

    my $clone_into = "$git_clones_dir/$repo";
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

if ( not -e 'lib/js/MathJax/README.md' )
{
    my $pid;
    if ( !( $pid = $pm->start ) )
    {
        system(
'cd lib/js && git clone git://github.com/mathjax/MathJax.git MathJax && cd MathJax && git checkout 2.7.5'
        );
        $pm->finish;
    }
}

if ( not -e 'lib/js/jquery-expander' )
{
    my $pid;
    if ( !( $pid = $pm->start ) )
    {
        system(
'cd lib/js && git clone https://github.com/kswedberg/jquery-expander'
        );
        $pm->finish;
    }
}
if ( not -e 'lib/ebookmaker/README.md' )
{
    my $pid;
    if ( !( $pid = $pm->start ) )
    {
      # Broken due to the bug in this pull-request:
      #    - https://github.com/setanta/ebookmaker/pull/7
      #
      # I switched to my fork for now.
      #
      # system('cd lib && git clone https://github.com/setanta/ebookmaker.git');
        system('cd lib && git clone https://github.com/shlomif/ebookmaker');
        $pm->finish;
    }
}

if ( not -e 'lib/c-begin/README.md' )
{
    my $pid;
    if ( !( $pid = $pm->start ) )
    {
        system('cd lib && git clone https://github.com/shlomif/c-begin.git');
        $pm->finish;
    }
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
        my $pid;
        if ( !( $pid = $pm->start ) )
        {
            _github_shlomif_clone( $BLOGS_DIR, $repo );
            $pm->finish;
        }
    }
}

my @documents = (
    {
        id     => "case-for-drug-legalisation",
        path   => "philosophy/politics/drug-legalisation",
        base   => "case-for-drug-legalisation",
        db_ver => 5,
    },
    {
        id     => "case-for-drug-legalisation-rev2",
        path   => "philosophy/politics/drug-legalisation",
        base   => "case-for-drug-legalisation-rev2",
        db_ver => 5,
    },
    {
        id     => "case-for-drug-legalisation-v3",
        path   => "philosophy/politics/drug-legalisation",
        base   => "case-for-drug-legalisation-v3",
        db_ver => 5,
    },
    {
        id     => "case-for-drug-legalisation--hebrew-v3",
        path   => "philosophy/politics/drug-legalisation",
        base   => "case-for-drug-legalisation--hebrew-v3",
        db_ver => 5,
    },
    {
        id     => "case-for-file-swapping-rev3",
        path   => "philosophy/case-for-file-swapping/revision-3",
        base   => "case-for-file-swapping-rev3",
        db_ver => 5,
    },
    {
        id               => "dealing-with-hypomanias",
        path             => "philosophy/psychology/hypomanias/",
        base             => "dealing-with-hypomanias",
        work_in_progress => 1,
        db_ver           => 5,
    },
    {
        id     => "end-of-it-slavery",
        path   => "philosophy/computers/software-management/end-of-it-slavery",
        base   => "end-of-it-slavery",
        db_ver => 5,
    },
    {
        id     => "foss-and-other-beasts",
        path   => "philosophy/foss-other-beasts/revision-2",
        base   => "foss-and-other-beasts",
        db_ver => 5,
    },
    {
        id      => "hebrew-html-tutorial",
        path    => "lecture/HTML-Tutorial/v1/xhtml1/hebrew",
        base    => "hebrew-html-tutorial",
        db_ver  => 5,
        no_epub => 1,
    },
    {
        id     => "introductory-language",
        path   => "philosophy/computers/education/introductory-language",
        base   => "introductory-language",
        db_ver => 5,
    },

    {
        id     => "isr-pales-conflict-solution",
        path   => "philosophy/israel-pales",
        base   => "isr-pales-conflict-solution",
        db_ver => 5,
    },

    {
        id        => "objectivism-and-open-source",
        path      => "philosophy/obj-oss",
        base      => "objectivism-and-open-source-r1",
        dest_base => "objectivism-and-open-source",
        db_ver    => 5,
    },

    {
        id     => "objectivism-and-open-source-r2",
        path   => "philosophy/obj-oss/rev2",
        base   => "objectivism-and-open-source",
        db_ver => 5,
    },

    {
        id     => "rindolf-spec",
        path   => "rindolf",
        base   => "rindolf-spec",
        db_ver => 5,
    },

    {
        id     => "the-eternal-jew",
        path   => "philosophy/the-eternal-jew",
        base   => "the-eternal-jew",
        db_ver => 5,
    },

    {
        id     => "what-makes-software-high-quality",
        path   => "philosophy/computers/high-quality-software",
        base   => "what-makes-software-high-quality",
        db_ver => 5,
    },

    {
        id     => "what-makes-software-high-quality-rev2",
        path   => "philosophy/computers/high-quality-software/rev2",
        base   => "what-makes-software-high-quality-rev2",
        db_ver => 5,
    },
    {
        id     => "perfect-it-workplace",
        path   => "philosophy/computers/software-management/perfect-workplace",
        base   => "perfect-it-workplace",
        db_ver => 5,
    },
    {
        id     => "park-lisp-informal-spec",
        path   => "open-source/projects/Park-Lisp",
        base   => "park-lisp-informal-spec",
        db_ver => 5,
    },
    {
        id => "putting-all-cards-on-the-table-2013",
        path =>
"philosophy/philosophy/putting-all-cards-on-the-table-2013/DocBook5",
        base   => "putting-all-cards-on-the-table-2013",
        db_ver => 5,
    },
    {
        id => "putting-more-cards-on-the-table-2014",
        path =>
"philosophy/philosophy/putting-more-cards-on-the-table-2014/DocBook5",
        base   => "putting-more-cards-on-the-table-2014",
        db_ver => 5,
    },
    {
        id     => "Spark-Pre-Birth-of-a-Modern-Lisp",
        path   => "open-source/projects/Spark/mission",
        base   => "Spark-Pre-Birth-of-a-Modern-Lisp",
        db_ver => 5,
    },
    {
        id => "SummerNSA-2014-09-call-for-action",
        path =>
            "philosophy/philosophy/SummerNSA-2014-09-call-for-action/DocBook5",
        base   => "SummerNSA-2014-09-call-for-action",
        db_ver => 5,
    },
    {
        id     => "A-SummerNSA-Reading",
        path   => "philosophy/SummerNSA/A-SummerNSA-Reading/",
        base   => "A-hashtag-SummerNSA-s-Reading",
        db_ver => 5,
    },
    {
        id         => "human-hacking-field-guide",
        path       => "humour/human-hacking",
        base       => "human-hacking-field-guide",
        db_ver     => 5,
        custom_css => 1,
    },
    {
        id     => "human-hacking-field-guide-v2-arabic",
        path   => "humour/human-hacking/arabic-v2",
        base   => "human-hacking-field-guide-v2-arabic",
        db_ver => 5,
    },
    {
        id   => "perfect-it-workplace-v2",
        path => "philosophy/computers/software-management/perfect-workplace/v2",
        base => "perfect-it-workplace-v2",
        db_ver           => 5,
        work_in_progress => 1,
    },

    {
        id     => "foss-licences-wars",
        path   => "philosophy/computers/open-source/foss-licences-wars",
        base   => "foss-licences-wars",
        db_ver => 5,
    },

    {
        id   => "foss-licences-wars-rev2",
        path => "philosophy/computers/open-source/foss-licences-wars/rev2/",
        base => "foss-licences-wars-rev2",
        work_in_progress => 1,
        db_ver           => 5,
    },
    {
        id             => "human-hacking-field-guide-v2",
        path           => "humour/human-hacking",
        base           => "human-hacking-field-guide-v2--english",
        custom_css     => 1,
        del_revhistory => 1,
        db_ver         => 5,
    },
    {
        id     => "foss-and-other-beasts-v3",
        path   => "philosophy/foss-other-beasts/version-3",
        base   => "foss-and-other-beasts-v3",
        db_ver => 5,
    },
    {
        id     => "usability-of-perl-world-for-newcomers",
        path   => "philosophy/perl-newcomers/v1",
        base   => "usability-of-perl-world-for-newcomers",
        db_ver => 5,
    },
    {
        id     => "c-and-cpp-elements-to-avoid",
        path   => "lecture/C-and-CPP/bad-elements/",
        base   => "c-and-cpp-elements-to-avoid",
        db_ver => 5,
    },
    {
        id             => "The-Enemy-English-v7",
        path           => "humour/TheEnemy",
        base           => "The-Enemy-English-v7",
        custom_css     => 1,
        del_revhistory => 1,
        db_ver         => 5,
    },
);

=begin foo
    # Removed due to it already being in FICTION_DOCS in Makefile.
    {
        id => "The-Pope-Died-on-Sunday-hebrew",
        path => "humour/Pope/",
        base => "The-Pope-Died-on-Sunday-hebrew",
        work_in_progress => 1,
        db_ver => 5,
    },
=end foo

=cut

foreach my $d (@documents)
{
    if ( !exists( $d->{db_ver} ) )
    {
        $d->{db_ver} = 4;
    }
    elsif ( !( any { $d->{db_ver} eq $_ } ( 4, 5 ) ) )
    {
        die "Illegal db_ver $d->{db_ver}!";
    }

    if ( !exists( $d->{custom_css} ) )
    {
        $d->{custom_css} = 0;
    }

    if ( !exists( $d->{del_revhistory} ) )
    {
        $d->{del_revhistory} = 0;
    }
}

sub process_simple_end_format
{
    my $fmt = shift;

    my %f = %$fmt;

    if ( !exists( $f{dir} ) )
    {
        $f{dir} = lc( $f{var} );
    }

    return \%f;
}

my @end_formats = (
    (
        map { process_simple_end_format($_) } (
            {
                var => "EPUB",
                ext => ".epub",
            },
            {
                var => "PDF",
                ext => ".pdf",
            },
            {
                var => "XML",
                ext => ".xml",
            },
            {
                var => "RTF",
                ext => ".rtf",
            },
            {
                var          => "FO",
                ext          => ".fo",
                skip_install => 1,
            },
            {
                var           => "INDIVIDUAL_XHTML",
                ext           => "",
                installed_ext => '/index',
                dir           => "indiv-nodes",
            },
        )
    )
);

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
\texport EBOOKMAKER="\$\$PWD/lib/ebookmaker/ebookmaker"; cd \$($src_vcs_dir_var) && SCREENPLAY_COMMON_INC_DIR="\$(SCREENPLAY_COMMON_INC_DIR)" make epub
\tcp -f \$($src_vcs_dir_var)/${doc_base}.epub \$($epub_dest_varname) || true
EOF
    }

    return \@ret;
}

{
    my $screenplays_data = [
        {
            base        => "TOWTF",
            github_repo => "TOW-Fountainhead",
            subdir      => "TOW_Fountainhead",
            docs        => [
                { base => "TOW_Fountainhead_1", suffix => "1", },
                { base => "TOW_Fountainhead_2", suffix => "2", },
            ],
        },
        {
            base        => "STAR_TREK_WTLD",
            github_repo => "Star-Trek--We-the-Living-Dead",
            subdir      => "star-trek--we-the-living-dead",
            docs        => [
                { base => "Star-Trek--We-the-Living-Dead", suffix => "ENG", },

         # { base => "Star-Trek--We-the-Living-Dead-hebrew", suffix => "HEB", },
            ],
        },
        {
            base        => "HUMANITY",
            github_repo => "Humanity-the-Movie",
            subdir      => "humanity",
            docs        => [
                { base => "Humanity-Movie",        suffix => "ENG", },
                { base => "Humanity-Movie-hebrew", suffix => "HEB", },
            ],
        },
        {
            base        => "SELINA_MANDRAKE",
            github_repo => "Selina-Mandrake",
            subdir      => "selina-mandrake",
            docs =>
                [ { base => "selina-mandrake-the-slayer", suffix => "ENG", }, ],
        },
        {
            base        => "SUMMERSCHOOL_AT_THE_NSA",
            github_repo => "Summerschool-at-the-NSA",
            subdir      => "summerschool-at-the-nsa",
            docs =>
                [ { base => "Summerschool-at-the-NSA", suffix => "ENG", }, ],
        },
        {
            base        => "BUFFY_A_FEW_GOOD_SLAYERS",
            github_repo => "Buffy-a-Few-Good-Slayers",
            subdir      => "buffy--a-few-good-slayers",
            docs =>
                [ { base => "Buffy--a-Few-Good-Slayers", suffix => "ENG", }, ],
        },
        {
            base        => "MUPPET_SHOW_TNI",
            github_repo => "The-Muppets-Show--The-New-Incarnation",
            subdir      => "Muppets-Show-TNI",
            docs        => [
                {
                    base   => "Muppets-Show--Harry-Potter",
                    suffix => "Harry-Potter",
                },
                {
                    base   => "Muppets-Show--Jennifer-Lawrence",
                    suffix => "Jennifer-Lawrence",
                },
                {
                    base   => "Muppets-Show--Summer-Glau-and-Chuck-Norris",
                    suffix => "Summer-Glau-and-Chuck-Norris",
                },
            ],
        },
        {
            base        => "SO_WHO_THE_HELL_IS_QOHELETH",
            github_repo => "So-Who-the-Hell-Is-Qoheleth",
            subdir      => "so-who-the-hell-is-qoheleth",
            docs        => [
                { base => "So-Who-the-Hell-is-Qoheleth", suffix => "ENG", },
            ],
        },
        {
            base        => "BLUE_RABBIT_LOG",
            github_repo => "Blue-Rabbit-Log",
            subdir      => "Blue-Rabbit-Log",
            docs =>
                [ { base => "Blue-Rabbit-Log-part-1", suffix => "part-1", }, ],
        },
    ];

    {
        my @o = (
            map { @{ _calc_screenplay_doc_makefile_lines($_) } }
                @$screenplays_data,
        );
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
    }

    my $clone_cb = sub {
        my ($r) = @_;

        my $full = "$screenplay_vcs_base_dir/$r";

        if ( not -e $full )
        {
            my $pid;
            if ( !( $pid = $pm->start ) )
            {
                _github_shlomif_clone( $screenplay_vcs_base_dir, $r );
                $pm->finish;
            }
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

    foreach my $d (@$fiction_data)
    {
        my $github_repo = $d->{github_repo};
        {
            my $r    = $github_repo;
            my $full = "$fiction_vcs_base_dir/$r";

            if ( not -e $full )
            {
                my $pid;
                if ( !( $pid = $pm->start ) )
                {
                    _github_shlomif_clone( $fiction_vcs_base_dir, $r );
                    $pm->finish;
                }
            }
        }
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

my $tt     = Template->new( {} );
my $css_tt = Template->new( {} );

my $gen_make_fn = "lib/make/docbook/sf-homepage-docbooks-generated.mak";
open my $make_fh,     ">", $gen_make_fn;
open my $template_fh, "<", "lib/make/docbook/sf-homepage-db-gen.tt";

my $qp_template_en_text =
    path("lib/presentations/qp/common/template-en.wml")->slurp_utf8;
my $qp_template_he_text =
    path("lib/presentations/qp/common/template-he.wml")->slurp_utf8;
my $qp_slidy = path("lib/presentations/qp/common/slidy.js")->slurp_utf8;

sub get_quad_pres_files
{
    my $args       = shift || {};
    my $dir_base   = $args->{dir};
    my $lang       = $args->{lang} // 'he';
    my $css_params = $args->{css} // +();
    my $dir        = "lib/presentations/qp/$dir_base";
    my $dest_dir   = $args->{dest_dir};

    write_on_change( scalar( path("$dir/src/slidy.js") ), \$qp_slidy );
    $css_tt->process( "lib/presentations/qp/common/style.css.tt2",
        $css_params, "$dir/src/style.css" );

    my $serve_fn = "$dir/serve.pl";
    write_on_change( scalar( path($serve_fn) ), \<<"EOF");
#!/usr/bin/env perl

use strict;
use warnings;

use lib "\$ENV{HOME}/apps/test/quadpres/share/quad-pres/perl5";
use Shlomif::Quad::Pres::CGI;

Shlomif::Quad::Pres::CGI->new->run;
EOF

    my $dot_q = "$dir/.quadpres";
    path($dot_q)->mkpath;
    path("$dot_q/is_root")->spew_utf8('');

    write_on_change( scalar( path("$dir/Contents.pm") ), \<<'EOF');
package Contents;

use strict;
use warnings;

use File::Basename qw/ dirname /;
use YAML::XS qw/ LoadFile /;

my $contents = LoadFile( dirname(__FILE__) . '/Contents.yml' );

sub get_contents
{
    return $contents;
}

1;
EOF
    write_on_change( scalar( path("$dir/template.wml") ),
        ( $lang eq 'en' ? \$qp_template_en_text : \$qp_template_he_text ) );
    path("$dir/.wmlrc")->spew_utf8(<<"EOF");
-DROOT~src --passoption=2,-X3074 -DTHEME=shlomif-text
EOF

    path("$dir/quadpres.ini")->spew_utf8(<<"EOF");
[quadpres]
server_dest_dir=./rendered
setgid_group=

[upload]
util=rsync
tt_upload_path=[% ENV.T2_DEST %]/$dest_dir/

[hard-disk]
dest_dir=./hard-disk-html
EOF

    chmod oct("0755"), $serve_fn;

    my $include_cb = $args->{'include_cb'} || sub { return 1; };

    my $dir_src = "$dir/src";

    my @files = File::Find::Object::Rule->name('*.html.wml')->in( $dir_src, );

    foreach my $f (@files)
    {
        $f =~ s{\A\Q$dir_src\E/}{}ms;
        $f =~ s{\.wml\z}{};
    }

    return +( $dir_base =~ tr#/-#__#r ) => +{
        dest_dir    => $dest_dir,
        lang        => $lang,
        'src_dir'   => $dir,
        'src_files' => [
            sort     { $a cmp $b }
                grep { $include_cb->($_) }

                # Filtering out explicitly because it has its own separate
                # dependency.
                grep { $_ ne "index.html" } @files
        ],
    };
}

$tt->process(
    $template_fh,
    {
        docs_4     => [ grep { $_->{db_ver} != 5 } @documents ],
        docs_5     => [ grep { $_->{db_ver} == 5 } @documents ],
        fmts       => \@end_formats,
        top_header => <<"EOF",
### This file is auto-generated from gen-dobook-make-helpers.pl
EOF
        quadp_presentations => {
            map { get_quad_pres_files($_) } (
                (
                    map {
                        +{
                            lang     => 'en',
                            dir      => "perl-for-newbies/$_",
                            dest_dir => "lecture/Perl/Newbies/lecture$_",
                            }
                    } ( 1 .. 5 )
                ),
                {
                    lang     => 'en',
                    dir      => "Autotools",
                    dest_dir => "lecture/Autotools/slides",
                },
                {
                    lang     => 'en',
                    dir      => "CatB",
                    dest_dir => "lecture/CatB/slides",
                },
                {
                    lang     => 'en',
                    dir      => "Gimp/1.2",
                    dest_dir => "lecture/Gimp/1/slides",
                },
                {
                    lang     => 'en',
                    dir      => "Gimp/2.2",
                    dest_dir => "lecture/Gimp/1/2.2-slides",
                },
                {
                    lang     => 'en',
                    dir      => "haskell-for-perl-programmers",
                    dest_dir => "lecture/Perl/Haskell/slides",
                },
                {
                    css_params => { heb => 1, interact => 1, },
                    dir        => "joel-test",
                    dest_dir   => "lecture/joel-test/heb-slides",
                },
                {
                    lang     => 'en',
                    dir      => "web-publishing-with-LAMP",
                    dest_dir => "lecture/LAMP/slides",
                },
                {
                    lang     => 'en',
                    dir      => "Freecell-Solver/1",
                    dest_dir => "lecture/Freecell-Solver/slides",
                },
                {
                    lang     => 'en',
                    dir      => "Freecell-Solver/The-Next-Pres",
                    dest_dir => "lecture/Freecell-Solver/The-Next-Pres/slides",
                },
                {
                    lang     => 'en',
                    dir      => "Freecell-Solver/project-intro",
                    dest_dir => "lecture/Freecell-Solver/project-intro/slides",
                },
                {
                    lang     => 'en',
                    dir      => "LM-Solve",
                    dest_dir => "lecture/LM-Solve/slides",
                },
                {
                    lang     => 'en',
                    dir      => "meta-data-database-access",
                    dest_dir => "lecture/mini/mdda/slides",
                },
                {
                    lang     => 'en',
                    dir      => "Quad-Pres",
                    dest_dir => "lecture/Quad-Pres/slides",
                },
                {
                    lang     => 'en',
                    dir      => "welcome-to-linux/Basic_Use-2",
                    dest_dir => "lecture/W2L/Basic_Use/slides",
                },
                {
                    css_params => { heb => 1, interact => 1, },
                    dir        => "welcome-to-linux/Blitz",
                    dest_dir   => "lecture/W2L/Blitz/slides",
                },
                {
                    lang     => 'en',
                    dir      => "welcome-to-linux/Development",
                    dest_dir => "lecture/W2L/Development/slides",
                },
                {
                    css_params => { heb => 1, interact => 1, },
                    dir        => "welcome-to-linux/Mini-Intro",
                    dest_dir   => "lecture/W2L/Mini-Intro/slides",
                },
                {
                    lang     => 'en',
                    dir      => "welcome-to-linux/Networking",
                    dest_dir => "lecture/W2L/Network/slides",
                },
                {
                    lang     => 'en',
                    dir      => "welcome-to-linux/Technion",
                    dest_dir => "lecture/W2L/Technion/slides",
                },
                {
                    lang       => 'en',
                    dir        => "Website-Meta-Lecture",
                    include_cb => sub {
                        my $fn = shift;
                        return ( $fn !~ m{\Aexamples/} );
                    },
                    dest_dir => "lecture/WebMetaLecture/slides",
                },
            )
        },
    },
    $make_fh
) or die $tt->error();

close($template_fh);
close($make_fh);

# Remove multiple consecutive \ns
path($gen_make_fn)->edit_utf8(
    sub {
        s/\n\n+/\n\n/g;
    }
);

HTML::Latemp::GenWmlHSects->new->run;

$pm->wait_all_children;
