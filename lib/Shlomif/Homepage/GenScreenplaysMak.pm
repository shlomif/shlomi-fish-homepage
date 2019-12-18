package Shlomif::Homepage::GenScreenplaysMak;

use strict;
use warnings;

use Moo;

use Path::Tiny qw/ path /;
use YAML::XS ();

sub _calc_screenplay_doc_makefile_lines
{
    my ( $screenplay_vcs_base_dir, $record ) = @_;

    my $base        = $record->{base};
    my $github_repo = $record->{github_repo};
    my $subdir      = $record->{subdir};
    my $docs        = $record->{docs};
    my $suburl      = $record->{suburl};

    my $vcs_dir_var = "${base}__VCS_DIR";

    my @ret =
        ("$vcs_dir_var = $screenplay_vcs_base_dir/$github_repo/$subdir\n");

    my @epubs;
    my $copy_screenplay_mak = '';
    my @copy_screenplay_mak__targets;

    foreach my $doc (@$docs)
    {
        my $doc_base = $doc->{base};
        my $suf      = $doc->{suffix};

        my $gen_name = sub {
            return "${base}_${suf}_" . shift;
        };

        my $src_varname    = $gen_name->("SCREENPLAY_XML_SOURCE");
        my $src_xhtmlname  = $gen_name->("SCREENPLAY_XHTML_INTERMEDIATE");
        my $dest_xhtmlname = $gen_name->("SCREENPLAY_XHTML_INTERMEDIATE_DEST");
        my $dest_varname   = $gen_name->("TXT_FROM_VCS");
        my $epub_dest_varname = $gen_name->("EPUB_FROM_VCS");
        my $src_vcs_dir_var   = $gen_name->("SCREENPLAY_XML__SRC_DIR");

        push @epubs, $epub_dest_varname;

        push @ret, "$src_vcs_dir_var = \$($vcs_dir_var)/screenplay\n\n",
"$src_varname = \$($src_vcs_dir_var)/${doc_base}.screenplay-text.txt\n\n",
"$src_xhtmlname = \$($src_vcs_dir_var)/${doc_base}.screenplay-text.xhtml\n\n",
"$dest_xhtmlname = \$(SCREENPLAY_XML_HTML_DIR)/${doc_base}.html\n\n",
            "$dest_varname = \$(SCREENPLAY_XML_TXT_DIR)/${doc_base}.txt\n\n",
"$epub_dest_varname = \$(SCREENPLAY_XML_EPUB_DIR)/${doc_base}.epub\n\n",
            (     "\$($dest_varname): \$($src_varname)\n" . "\t"
                . q/$(call COPY)/
                . "\n\n" ),

            <<"EOF",
\$($epub_dest_varname): \$($dest_xhtmlname) \$($src_vcs_dir_var)/scripts/prepare-epub.pl
\texport EBOOKMAKER="\$\$PWD/lib/ebookmaker/ebookmaker"; orig_dir="\$\$PWD"; perl -I "\$(SCREENPLAY_COMMON_INC_DIR)" \$($src_vcs_dir_var)/scripts/prepare-epub.pl --output "\$\@" "\$($dest_xhtmlname)"
EOF
            ;
        if ( defined($suburl) )
        {
            my $target_bn = $doc->{txt_target_bn} // "$doc_base.txt";
            my $target    = "\$(POST_DEST_HUMOUR)/$suburl/$target_bn";
            $copy_screenplay_mak .=
qq^${target}: \$(SCREENPLAY_XML_TXT_DIR)/$doc_base.txt\n\t\$(call COPY)\n\n^;
            push @copy_screenplay_mak__targets, $target;
        }
    }

    return +{
        copy_screenplay_mak          => $copy_screenplay_mak,
        copy_screenplay_mak__targets => \@copy_screenplay_mak__targets,
        rec                          => $record,
        lines                        => \@ret,
        epubs                        => \@epubs,
    };
}

sub generate
{
    my $self     = shift;
    my $args     = shift;
    my $git_task = $args->{git_task};

    my $screenplay_vcs_base_dir = 'lib/screenplay-xml/from-vcs';

    my @records = (
        map {
            _calc_screenplay_doc_makefile_lines( $screenplay_vcs_base_dir, $_ )
        } @{ YAML::XS::LoadFile("./lib/screenplay-xml/list.yaml") }
    );
    my $epub_dests_varname = 'SCREENPLAY_XML__EPUBS_DESTS';
    my $epub_dests         = <<'EOF';
$(SRC_POST_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-part-1.epub \
$(SRC_POST_DEST)/humour/Buffy/A-Few-Good-Slayers/Buffy--a-Few-Good-Slayers.epub \
$(SRC_POST_DEST)/humour/humanity/Humanity-Movie.epub \
$(SRC_POST_DEST)/humour/humanity/Humanity-Movie-hebrew.epub \
$(SRC_POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Harry-Potter.epub \
$(SRC_POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Jennifer-Lawrence.epub \
$(SRC_POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Summer-Glau-and-Chuck-Norris.epub   \
$(SRC_POST_DEST)/humour/Selina-Mandrake/selina-mandrake-the-slayer.epub \
$(SRC_POST_DEST)/humour/Star-Trek/We-the-Living-Dead/Star-Trek--We-the-Living-Dead.epub \
$(SRC_POST_DEST)/humour/So-Who-The-Hell-Is-Qoheleth/So-Who-the-Hell-is-Qoheleth.epub \
$(SRC_POST_DEST)/humour/Summerschool-at-the-NSA/Summerschool-at-the-NSA.epub \
$(SRC_POST_DEST)/humour/Terminator/Liberation/Terminator--Liberation.epub \
$(SRC_POST_DEST)/humour/TOneW-the-Fountainhead/TOW_Fountainhead_1.epub \
$(SRC_POST_DEST)/humour/TOneW-the-Fountainhead/TOW_Fountainhead_2.epub \
EOF

    my @_files = ( $epub_dests =~ /(\$\(SRC_POST_DEST\)\S+)/g );
    my @_htmls_files =
        map { my $x = $_; $x =~ s/\.epub\z/\.raw.html/; $x } @_files;

    my $_htmls_dests = join "", map { "$_ \\\n" } @_htmls_files;
    path("lib/make/docbook/screenplays-copy-operations.mak")->spew_utf8(
        ( map { $_->{copy_screenplay_mak} } @records ),
        (
            "SCREENPLAY_SOURCES_ON_POST_DEST__EXTRA_TARGETS = ",
            join(
                " ",
                (
                    sort    { $a cmp $b }
                        map { @{ $_->{copy_screenplay_mak__targets} } }
                        @records
                )
            )
        ),
        "\n",
    );

    my $CLEAN_NAMESPACES_FUNC_NAME = 'SCREENPLAYS_CLEAN_XML_NS';
    my $CLEAN_NAMESPACES_FUNC__BODY =
        qq{\$1 \$(PERL) -lp bin/screenplay-xml-remove-ns.pl < \$< > \$\@};

    path("lib/make/docbook/sf-screenplays.mak")->spew_utf8(
        ("$CLEAN_NAMESPACES_FUNC_NAME = $CLEAN_NAMESPACES_FUNC__BODY\n\n"),
        ( map { @{ $_->{lines} } } @records ),
        "\n\nSCREENPLAY_DOCS_FROM_GEN = \\\n",
        ( map { "\t$_->{base} \\\n" } map { @{ $_->{rec}->{docs} } } @records ),
        "\n\nSCREENPLAY_DOCS__DEST_EPUBS = \\\n",
        ( map { "\t\$($_) \\\n" } map { @{ $_->{epubs} } } @records ),
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
                my $x = [ split m#/#, $_ ]->[-1];
                $x =~ s/\.raw(\.html)\z/$1/;
                my $heb_filt = '';
                if ( $x =~ /hebrew/ )
                {
                    $heb_filt = "DIR=rtl";
                }
                "$_: \$(SCREENPLAY_XML_HTML_DIR)/"
                    . $x
                    . sprintf( "\n\t\$(call %s,%s)\n\n",
                    $CLEAN_NAMESPACES_FUNC_NAME, $heb_filt );
            } @_htmls_files
        ),
    );

    my $clone_cb = sub {
        my ($r) = @_;

        return $git_task->( $screenplay_vcs_base_dir, $r );
    };

    foreach my $github_repo (@records)
    {
        $clone_cb->( $github_repo->{rec}->{github_repo} );
    }
    $clone_cb->('screenplays-common');

    return;
}
1;

__END__
