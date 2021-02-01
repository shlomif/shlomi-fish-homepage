package Shlomif::Homepage::GenScreenplaysMak;

use strict;
use warnings;

use Moo;

use Path::Tiny qw/ path /;
use YAML::XS ();

sub _calc_screenplay_doc_makefile_lines
{
    my ( $_epub_map, $screenplay_vcs_base_dir, $record ) = @_;

    my $base        = $record->{base};
    my $github_repo = $record->{github_repo};
    my $subdir      = $record->{subdir};
    my $docs        = $record->{docs};
    my $suburl      = $record->{suburl};

    my $vcs_dir_var = "${base}__VCS_DIR";

    my @ret =
        ("$vcs_dir_var := $screenplay_vcs_base_dir/$github_repo/$subdir\n");

    my @epubs;
    my $copy_screenplay_mak = '';
    my @copy_screenplay_mak__targets;

    foreach my $doc ( sort { $a->{base} cmp $b->{base} } @$docs )
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
        my $epub_dest_path = $_epub_map->{ $doc_base . '.epub' }
            // ( die "epub_dest_path returned undef for doc_base=$doc_base ." );

        push @ret, "$src_vcs_dir_var := \$($vcs_dir_var)/screenplay\n",
"$src_varname := \$($src_vcs_dir_var)/${doc_base}.screenplay-text.txt\n",
"$src_xhtmlname := \$($src_vcs_dir_var)/${doc_base}.screenplay-text.xhtml\n",
            "$dest_xhtmlname := \$(SCREENPLAY_XML_HTML_DIR)/${doc_base}.html\n",
            "$dest_varname := \$(SCREENPLAY_XML_TXT_DIR)/${doc_base}.txt\n",
            "$epub_dest_varname := $epub_dest_path\n",
            (     "\$($dest_varname): \$($src_varname)\n" . "\t"
                . q/$(call COPY)/
                . "\n\n" ),

            <<"EOF",
\$($epub_dest_varname): \$($dest_xhtmlname) \$($src_vcs_dir_var)/scripts/prepare-epub.pl
\tSCREENPLAY_COMMON_INC_DIR="\$(SCREENPLAY_COMMON_INC_DIR)" REBOOKMAKER="\$(REBOOKMAKER)" perl -I "\$(SCREENPLAY_COMMON_INC_DIR)" \$($src_vcs_dir_var)/scripts/prepare-epub.pl --output "\$\@" "\$($dest_xhtmlname)"
EOF
            ;
        if ( defined($suburl) )
        {
            my $target_bn = $doc->{txt_target_bn} // "$doc_base.txt";
            my $target    = "\$(POST_DEST_HUMOUR)/$suburl/$target_bn";
            my $target_varname =
                "POST_DEST_TXT__${base}__${doc_base}" =~ s/-/_/gr;
            my $target_var_deref = "\$($target_varname)";
            $copy_screenplay_mak .=
qq^$target_varname := ${target}\n\n${target_var_deref}: \$(SCREENPLAY_XML_TXT_DIR)/$doc_base.txt\n\t\$(call COPY)\n\n^;
            push @copy_screenplay_mak__targets, $target_var_deref;
        }
    }

    return +{
        copy_screenplay_mak          => $copy_screenplay_mak,
        copy_screenplay_mak__targets => \@copy_screenplay_mak__targets,
        docs                         => $docs,
        github_repo                  => $github_repo,
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

    my $epub_dests_varname        = 'SCREENPLAY_XML__EPUBS_DESTS';
    my $raw_htmls__dests__varname = 'SCREENPLAY_XML__RAW_HTMLS__DESTS';
    my $epub_dests                = <<'EOF';
$(POST_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-part-1.epub \
$(POST_DEST)/humour/Buffy/A-Few-Good-Slayers/Buffy--a-Few-Good-Slayers.epub \
$(POST_DEST)/humour/humanity/Humanity-Movie.epub \
$(POST_DEST)/humour/humanity/Humanity-Movie-hebrew.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Harry-Potter.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Jennifer-Lawrence.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Summer-Glau-and-Chuck-Norris.epub   \
$(POST_DEST)/humour/Queen-Padme-Tales/Queen-Padme-Tales--Planting-Trees.epub \
$(POST_DEST)/humour/Queen-Padme-Tales/Queen-Padme-Tales--Queen-Amidala-vs-the-Klingon-Warriors.epub \
$(POST_DEST)/humour/Selina-Mandrake/selina-mandrake-the-slayer.epub \
$(POST_DEST)/humour/Star-Trek/We-the-Living-Dead/Star-Trek--We-the-Living-Dead.epub \
$(POST_DEST)/humour/So-Who-The-Hell-Is-Qoheleth/So-Who-the-Hell-is-Qoheleth.epub \
$(POST_DEST)/humour/Summerschool-at-the-NSA/Summerschool-at-the-NSA.epub \
$(POST_DEST)/humour/Terminator/Liberation/Terminator--Liberation.epub \
$(POST_DEST)/humour/TOneW-the-Fountainhead/TOW_Fountainhead_1.epub \
$(POST_DEST)/humour/TOneW-the-Fountainhead/TOW_Fountainhead_2.epub \
EOF

    my @_files    = ( $epub_dests =~ /(\$\(POST_DEST\)\S+)/g );
    my $_epub_map = +{ map { ( split m#/#, $_, -1 )[-1] => $_ } @_files };
    my @_htmls_files =
        map { s/\.epub\z/\.raw.html/r =~ s#\A\$\(POST_DEST\)/#\$(PRE_DEST)/#r }
        @_files;

    my $_htmls_dests = join "", map { "$_ \\\n" } @_htmls_files;
    my @records      = (
        map {
            _calc_screenplay_doc_makefile_lines( $_epub_map,
                $screenplay_vcs_base_dir, $_ )
        } sort { $a->{base} cmp $b->{base} }
            @{ YAML::XS::LoadFile("./lib/screenplay-xml/list.yaml") }
    );
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
        "\n\nSCREENPLAY_DOCS_FROM_GEN := \\\n",
        ( map { "\t$_->{base} \\\n" } map { @{ $_->{docs} } } @records ),
        "\n\nSCREENPLAY_DOCS__DEST_EPUBS := \\\n",
        ( map { "\t\$($_) \\\n" } map { @{ $_->{epubs} } } @records ),
        "\n",
"$epub_dests_varname := \\\n$epub_dests\n$raw_htmls__dests__varname := \\\n$_htmls_dests\n",
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
        $clone_cb->( $github_repo->{github_repo} );
    }
    $clone_cb->('screenplays-common');

    return;
}
1;

__END__
