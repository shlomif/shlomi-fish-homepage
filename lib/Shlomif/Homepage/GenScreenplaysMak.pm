package Shlomif::Homepage::GenScreenplaysMak;

use strict;
use warnings;

use Moo;

use Path::Tiny   qw/ path /;
use File::Update qw( write_on_change );
use YAML::XS     ();

use Shlomif::Homepage::GenScreenplaysMak::ImageLister ();

my $image_lister = Shlomif::Homepage::GenScreenplaysMak::ImageLister->new( {} );

my $graphics_dir_bn_var = 'SCREENPLAYS__GRAPHICS_DIR_BN_VAR';
my $SOURCE_PIVOT_BN     = "All-in-an-Atypical-Day-Work";

sub _vcs_add
{
    my ($paths) = @_;

    system( "git", "add", @$paths, );

    return;
}

sub _calc_screenplay_doc_makefile_lines
{
    my ( $dest_records, $dest_dir_vars, $images_copy_ref, $tt_proc_targets,
        $addprefixes, $_epub_map, $screenplay_vcs_base_dir, $record )
        = @_;

    my $base             = $record->{base};
    my $github_repo      = $record->{github_repo};
    my $base_github_repo = $github_repo;
    my $should_clone     = 1;
    if ( ref($base_github_repo) eq 'HASH' )
    {
        $should_clone     = 0;
        $base_github_repo = $base_github_repo->{tempname};
    }
    my $subdir = $record->{subdir};
    my $docs   = $record->{docs};
    my $suburl = $record->{suburl};

    my $vcs_dir_var          = "${base}__VCS_DIR";
    my $graphics_dir_var     = "${base}_SCREENPLAY_IMAGES__SOURCE_PREFIX";
    my $dest_dir_var         = "${base}_SCREENPLAY_IMAGES__POST_DEST";
    my $dest_prefix_dir_var  = "${base}_SCREENPLAY_IMAGES__POST_DEST_PREFIX";
    my $files_var            = "${base}_SCREENPLAY_IMAGES__BASE";
    my $src_vcs_dir_var      = "${base}_SCREENPLAY_XML__SRC_DIR";
    my $src_prepare_epub_var = "${base}_SCREENPLAY_EPUB_PREPARATION_SCRIPT";

    ++$dest_dir_vars->{$dest_dir_var};
    my @ret = (
        "$vcs_dir_var := $screenplay_vcs_base_dir/$base_github_repo/$subdir\n",
        "$graphics_dir_var := \$($vcs_dir_var)/\$($graphics_dir_bn_var)\n",
"$dest_prefix_dir_var := \$(POST_DEST_HUMOUR)/@{[ $suburl // '']}/images\n",
        "$src_vcs_dir_var := \$($vcs_dir_var)/screenplay\n",
"$src_prepare_epub_var := \$($src_vcs_dir_var)/scripts/prepare-epub.pl\n",
    );

    if ( not $should_clone )
    {
        my $src_fn =
"lib/screenplay-xml/txt/scripts/${base_github_repo}-prepare-epub.pl";
        my $src_obj = path($src_fn);
        if ( not -e $src_obj )
        {
            my $pivot_fn =
                path(
"lib/screenplay-xml/txt/scripts/$SOURCE_PIVOT_BN-prepare-epub.pl"
                );
            my $pivot_body = $pivot_fn->slurp_utf8();

            $src_obj->spew_utf8(
                qq%die "PLEASE EDIT ME!!!";\n\n% . $pivot_body );
            _vcs_add( [ $src_obj, ], );
        }
        push @ret,
            (     "\n\$($src_prepare_epub_var): ${src_fn}\n" . "\t"
                . qq#\$(MKDIR) \$($src_vcs_dir_var)/scripts# . "\n" . "\t"
                . q/$(call COPY)/
                . "\n\n" );
    }

    my @epubs;
    my @generate_file_list_promises;
    my $copy_screenplay_mak = '';
    my @copy_screenplay_mak__targets;

    my @files_vars = ($files_var);
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

        {
            my $xml_out_fh  = path("lib/screenplay-xml/xml/${doc_base}.xml");
            my $text_out_fh = path("lib/screenplay-xml/txt/${doc_base}.txt");

            my $fn_dir =
                path(
                "$screenplay_vcs_base_dir/$base_github_repo/$subdir/screenplay"
                );
            if (0)
            {
                $fn_dir->mkpath();
                my $placeholder = $fn_dir->child("PLACEHOLDER");
                if ( not -e $placeholder )
                {
                    $placeholder->spew_raw("");
                    _vcs_add( [ $placeholder, ], );
                }
            }
            my $fn = $fn_dir->child("${doc_base}.screenplay-text.txt");
            if ( not $should_clone )
            {
                $fn_dir->mkpath;

                if ( $doc->{tt2} )
                {
                    my $tt_out_fh = path(
"lib/screenplay-xml/tt2-txt/${doc_base}.screenplay-text.txt.tt2"
                    );
                    if ( not -f $fn )
                    {
                        if ( not -e $tt_out_fh )
                        {
                            my $source = path(
"lib/screenplay-xml/tt2-txt/$SOURCE_PIVOT_BN.screenplay-text.txt.tt2"
                            );
                            STDERR->print(
"File '$tt_out_fh' did not exist. Populating from $source\n"
                            );
                            $source->copy($tt_out_fh);
                            _vcs_add( [ $tt_out_fh, ], );
                        }
                        my $img_bn = "evilphish-svg--facing-right.min.svg.png";
                        my $img_out_fh = path(
"lib/screenplay-xml/from-vcs/$doc_base/$doc_base/graphics/$img_bn"
                        );
                        if ( not -e $img_out_fh )
                        {
                            my $source = path(
"lib/screenplay-xml/from-vcs/$SOURCE_PIVOT_BN/$SOURCE_PIVOT_BN/graphics"
                                    . "/$img_bn" );
                            $img_out_fh->parent()->mkpath();
                            STDERR->print(
"File '$img_out_fh' did not exist. Populating from $source\n"
                            );
                            $source->copy($img_out_fh);
                            _vcs_add( [ $img_out_fh, ], );
                        }
                    }
                    push @$tt_proc_targets,
qq[\$($src_varname) : \$(SCREENPLAY_XML_TT2_TXT_DIR)/${doc_base}.screenplay-text.txt.tt2\n\t\$(call MY_TT_PROCESSOR)];
                    system("$^X bin/my-tt-processor.pl -o '$fn' '$tt_out_fh'");
                    if ( not -f $fn )
                    {
                        STDERR->print("File '$fn' does not exist.\n");
                    }
                }
                else
                {
                    $text_out_fh->copy($fn);
                }
                my $gfx_out_dir = path("$fn_dir/../graphics/");
                my $gfx_bn      = "Green-d10-dice.png";
                my $gfx_out     = $gfx_out_dir->child($gfx_bn);
                $gfx_out_dir->mkpath();
                my $gfx_src =
                    path("lib/screenplay-xml/txt/scripts/graphics/$gfx_bn");
                $gfx_src->copy($gfx_out);
            }

            push @generate_file_list_promises, sub {
                my $got_doc;
                eval {
                    write_on_change( $text_out_fh, \( $fn->slurp_utf8 ) );
                    $got_doc = $image_lister->calc_doc__from_proto_text(
                        $xml_out_fh,
                        {
                            source => {
                                file => "$fn",
                            },
                        }
                    );
                };
                return [
                    $files_var,
                    (
                        $got_doc
                        ? [
                            map {
                                my $uri = $_->uri();
                                $uri =~ s#\A(?:\./)?images/##ms
                                    or die "non matching uri='$uri'";
                                $uri
                            } @{ $got_doc->list_images() }
                            ]
                        : []
                    ),
                ];
            };
        }

        push @epubs, $epub_dest_varname;
        my $epub_dest_path = $_epub_map->{ $doc_base . '.epub' }
            // ( die "epub_dest_path returned undef for doc_base=$doc_base ." );

        push @ret,
"$src_varname := \$($src_vcs_dir_var)/${doc_base}.screenplay-text.txt\n",
"$src_xhtmlname := \$($src_vcs_dir_var)/${doc_base}.screenplay-text.xhtml\n",
            "$dest_xhtmlname := \$(SCREENPLAY_XML_HTML_DIR)/${doc_base}.html\n",
            "$dest_varname := \$(SCREENPLAY_XML_TXT_DIR)/${doc_base}.txt\n",
            "$epub_dest_varname := $epub_dest_path\n",
            (     "\$($dest_varname): \$($src_varname)\n" . "\t"
                . q/$(call COPY)/
                . "\n\n" ),
            <<"EOF",
\$($epub_dest_varname): \$($dest_xhtmlname) \$($src_prepare_epub_var)
\tSCREENPLAY_COMMON_INC_DIR="\$(SCREENPLAY_COMMON_INC_DIR)" REBOOKMAKER="\$(REBOOKMAKER)" perl -I "\$(SCREENPLAY_COMMON_INC_DIR)" \$($src_prepare_epub_var) --output "\$\@" "\$($dest_xhtmlname)"
EOF
            ;

        my $gen_deref = sub { return sprintf( "\$(%s)", $gen_name->(shift) ); };

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
    $$images_copy_ref .=
          "\$($dest_dir_var): " . "\$("
        . $dest_prefix_dir_var . ")/%: " . "\$("
        . $graphics_dir_var . ")/%\n";
    my $addprefix =
        "$dest_dir_var = \$(addprefix \$($dest_prefix_dir_var)/,"
        . join( q# #, map { "\$($_)" } @files_vars ) . ")\n";
    ++( $addprefixes->{$addprefix} );

    push @$dest_records,
        +{
        base_github_repo             => $base_github_repo,
        copy_screenplay_mak          => $copy_screenplay_mak,
        copy_screenplay_mak__targets => \@copy_screenplay_mak__targets,
        docs                         => $docs,
        epubs                        => \@epubs,
        generate_file_list_promises  => \@generate_file_list_promises,
        github_repo                  => $github_repo,
        lines                        => \@ret,
        should_clone                 => $should_clone,
        };

    return;
}

sub _basename
{
    my ($fn) = @_;

    return ( ( split m#/#, $fn, -1 )[-1] );
}

sub generate
{
    my ( $self, $args ) = @_;

    my $git_task = $args->{git_task};

    my $screenplay_vcs_base_dir = 'lib/screenplay-xml/from-vcs';

    my $epub_dests_varname        = 'SCREENPLAY_XML__EPUBS_DESTS';
    my $raw_htmls__dests__varname = 'SCREENPLAY_XML__RAW_HTMLS__DESTS';
    my $epub_dests                = <<'EOF';
$(POST_DEST)/humour/All-in-an-Atypical-Day-Work/All-in-an-Atypical-Day-Work.epub \
$(POST_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-part-1.epub \
$(POST_DEST)/humour/Buffy/A-Few-Good-Slayers/Buffy--a-Few-Good-Slayers.epub \
$(POST_DEST)/humour/Cookie-Monster--The-Slayer/Cookie-Monster--The-Slayer.epub \
$(POST_DEST)/humour/He-Damsel-in-Distress-and-a-Distressing-Damsel/He-Damsel-in-Distress-and-a-Distressing-Damsel.epub \
$(POST_DEST)/humour/How-to-Play-Strip-Dungeons-and-Dragons/How-to-Play-Strip-Dungeons-and-Dragons.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Harry-Potter.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Jennifer-Lawrence.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Summer-Glau-and-Chuck-Norris.epub   \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Tiffany-Alvord.epub \
$(POST_DEST)/humour/Queen-Padme-Tales/Queen-Padme-Tales--Nighttime-Flight.epub \
$(POST_DEST)/humour/Queen-Padme-Tales/Queen-Padme-Tales--Planting-Trees.epub \
$(POST_DEST)/humour/Queen-Padme-Tales/Queen-Padme-Tales--Queen-Amidala-vs-the-Klingon-Warriors.epub \
$(POST_DEST)/humour/Queen-Padme-Tales/Queen-Padme-Tales--Take-It-Over.epub \
$(POST_DEST)/humour/Queen-Padme-Tales/Queen-Padme-Tales--The-Fifth-Sith.epub \
$(POST_DEST)/humour/Selina-Mandrake/selina-mandrake-the-slayer.epub \
$(POST_DEST)/humour/So-Who-The-Hell-Is-Qoheleth/So-Who-the-Hell-is-Qoheleth.epub \
$(POST_DEST)/humour/Star-Trek/We-the-Living-Dead/Star-Trek--We-the-Living-Dead.epub \
$(POST_DEST)/humour/Summerschool-at-the-NSA/Summerschool-at-the-NSA.epub \
$(POST_DEST)/humour/TOneW-the-Fountainhead/TOW_Fountainhead_1.epub \
$(POST_DEST)/humour/TOneW-the-Fountainhead/TOW_Fountainhead_2.epub \
$(POST_DEST)/humour/Terminator/Liberation/Terminator--Liberation.epub \
$(POST_DEST)/humour/The-10th-Muse/The-10th-Muse--Athena-Gets-Laid.epub \
$(POST_DEST)/humour/The-10th-Muse/The-10th-Muse--Trojan-War-Reenactment.epub \
$(POST_DEST)/humour/bits/How-Ronda-Rousey-Lost-her-UFC-Streak/How-Ronda-Rousey-Lost-her-UFC-Streak.epub \
$(POST_DEST)/humour/bits/One-does-not-simply-start-a-story-with-And-they-all-lived-happily-ever-after/One-does-not-simply-start-a-story-with-And-they-all-lived-happily-ever-after.epub \
$(POST_DEST)/humour/bits/Who-will-ride-Princess-Celestia/Who-will-ride-Princess-Celestia.epub \
$(POST_DEST)/humour/humanity/Humanity-Movie-hebrew.epub \
$(POST_DEST)/humour/humanity/Humanity-Movie.epub \
$(POST_DEST)/humour/tempbits/end-game-for-shlomif-as-a-false-prophet/end-game-for-shlomif-as-a-false-prophet.epub \
$(POST_DEST)/humour/usr-bin-perl/usr-bin-perl--total.epub \
EOF

    my @_files    = ( $epub_dests =~ /(\$\(POST_DEST\)\S+)/g );
    my $_epub_map = +{ map { _basename($_) => $_ } @_files };
    my @_htmls_files =
        map { s/\.epub\z/\.raw.html/r =~ s#\A\$\(POST_DEST\)/#\$(PRE_DEST)/#r }
        @_files;

    my $_htmls_dests  = join "", map { "$_ \\\n" } @_htmls_files;
    my $addprefixes   = +{};
    my $dest_dir_vars = +{};
    my $images_copy   = '';

    my @records;
    my $tt_proc_targets = [];
    foreach my $record ( sort { $a->{base} cmp $b->{base} }
        @{ YAML::XS::LoadFile("./lib/screenplay-xml/list.yaml") } )
    {
        _calc_screenplay_doc_makefile_lines(
            ( \@records ),
            $dest_dir_vars, ( \$images_copy ),
            $tt_proc_targets,
            $addprefixes, $_epub_map, $screenplay_vcs_base_dir, $record,
        );
    }
    path("lib/make/generated/screenplays-copy-operations.mak")->spew_utf8(
        ( map { $_->{copy_screenplay_mak} } @records ),
        (
            "SCREENPLAY_SOURCES_ON_POST_DEST__EXTRA_TARGETS = ",
            join(
                " ",
                (
                    sort { $a cmp $b }
                    map  { @{ $_->{copy_screenplay_mak__targets} } } @records
                )
            )
        ),
        "\n",
    );

    my $CLEAN_NAMESPACES_FUNC_NAME = 'SCREENPLAYS_CLEAN_XML_NS';
    my $CLEAN_NAMESPACES_FUNC__BODY =
        qq{\$1 \$(PERL) -lp bin/screenplay-xml-remove-ns.pl < \$< > \$\@};

    my $clean_ns = sub {
        my ($fn) = @_;
        my $bn = _basename($fn);
        $bn =~ s/\.raw(\.html)\z/$1/;
        my $heb_filt = '';
        if ( $bn =~ /hebrew/ )
        {
            $heb_filt = "DIR=rtl";
        }
        return "${fn}: \$(SCREENPLAY_XML_HTML_DIR)/${bn}\n"
            . sprintf( "\t\$(call %s,%s)\n\n",
            $CLEAN_NAMESPACES_FUNC_NAME, $heb_filt );
    };

    path("lib/make/generated/shlomif-screenplays.mak")->spew_utf8(
        ("$CLEAN_NAMESPACES_FUNC_NAME = $CLEAN_NAMESPACES_FUNC__BODY\n\n"),
        "$graphics_dir_bn_var := graphics\n",
        ( map { @{ $_->{lines} } } @records ),
        "\n\nSCREENPLAY_DOCS_FROM_GEN := \\\n",
        ( map { "\t$_->{base} \\\n" } map { @{ $_->{docs} } } @records ),
        "\n\nSCREENPLAY_DOCS__DEST_EPUBS := \\\n",
        ( map { "\t\$($_) \\\n" } map { @{ $_->{epubs} } } @records ),
        "\n",
"$epub_dests_varname := \\\n$epub_dests\n$raw_htmls__dests__varname := \\\n$_htmls_dests\n",
        ( map { $clean_ns->($_) } @_htmls_files ),
        (
            "\nALL_SCREENPLAYS__SCREENPLAY_IMAGES__POST_DESTS = ",
            join( ' ', map { "\$($_)" } sort keys %$dest_dir_vars ),
            "\n"
        ),
        ( "\n", ( join( "\n\n", @{$tt_proc_targets} ) ), "\n", ),
    );

    my $DIR = "lib/make/";
    path("${DIR}generated/copies-generated-screenplay-images.mak")
        ->spew_utf8($images_copy);
    my $clone_cb = sub {
        my ($bn) = @_;
        $git_task->( $screenplay_vcs_base_dir, $bn );
        return;
    };

    foreach my $github_repo (@records)
    {
        if ( $github_repo->{should_clone} )
        {
            $clone_cb->( $github_repo->{github_repo} );
        }
    }
    $clone_cb->('screenplays-common');

    return {
        addprefixes                 => [ sort keys %$addprefixes ],
        generate_file_list_promises =>
            [ map { @{ $_->{generate_file_list_promises} } } @records ]
    };
}

1;

__END__
