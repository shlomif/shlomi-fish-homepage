package Shlomif::Homepage::GenScreenplaysMak;

use strict;
use warnings;

use Moo;

use Path::Tiny   qw/ path /;
use File::Update qw( write_on_change );
use YAML::XS     ();

use XML::Grammar::Screenplay::FromProto::API::ListImages ();
use XML::Grammar::Screenplay::FromProto::Parser::QnD     ();

package Shlomif::Homepage::GenScreenplaysMak::Lister;

use Moo;
use File::Update qw( write_on_change );

sub calc_doc__from_proto_text
{
    my ( $self, $xml_out_fh, $args ) = @_;

    my $ret = XML::Grammar::Screenplay::API::ImageListDoc->new(
        {
            parser_class => 'XML::Grammar::Screenplay::FromProto::Parser::QnD',
            %$args,
        }
    );
    my $xml_text = $ret->convert($args);
    $ret->_xml($xml_text);
    write_on_change( $xml_out_fh, \$xml_text );
    my $xml_parser = XML::LibXML->new();
    $xml_parser->validation(0);
    $ret->_dom( $xml_parser->parse_string( $ret->_xml() ) );

    return $ret;
}

package Shlomif::Homepage::GenScreenplaysMak;

my $image_lister = Shlomif::Homepage::GenScreenplaysMak::Lister->new( {} );

my $graphics_dir_bn_var = 'SCREENPLAYS__GRAPHICS_DIR_BN_VAR';

sub _calc_screenplay_doc_makefile_lines
{
    my ( $dest_records, $dest_dir_vars, $images_copy_ref, $addprefixes,
        $_epub_map, $screenplay_vcs_base_dir, $record )
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

    my $vcs_dir_var         = "${base}__VCS_DIR";
    my $graphics_dir_var    = "${base}_SCREENPLAY_IMAGES__SOURCE_PREFIX";
    my $dest_dir_var        = "${base}_SCREENPLAY_IMAGES__POST_DEST";
    my $dest_prefix_dir_var = "${base}_SCREENPLAY_IMAGES__POST_DEST_PREFIX";
    my $files_var           = "${base}_SCREENPLAY_IMAGES__BASE";

    ++$dest_dir_vars->{$dest_dir_var};
    my @ret = (
        "$vcs_dir_var := $screenplay_vcs_base_dir/$base_github_repo/$subdir\n",
        "$graphics_dir_var := \$($vcs_dir_var)/\$($graphics_dir_bn_var)\n",
"$dest_prefix_dir_var := \$(POST_DEST_HUMOUR)/@{[ $suburl // '']}/images\n",
    );

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

        {
            my $xml_out_fh  = path("lib/screenplay-xml/xml/${doc_base}.xml");
            my $text_out_fh = path("lib/screenplay-xml/txt/${doc_base}.txt");

            my $fn_dir =
                path(
                "$screenplay_vcs_base_dir/$base_github_repo/$subdir/screenplay"
                );
            my $fn = $fn_dir->child("${doc_base}.screenplay-text.txt");
            if ( not $should_clone )
            {
                $fn_dir->mkpath;

                $text_out_fh->copy($fn);
                my $gfx_out_dir = path("$fn_dir/../graphics/");
                my $gfx_bn      = "Green-d10-dice.png";
                my $gfx_out     = $gfx_out_dir->child($gfx_bn);
                $gfx_out_dir->mkpath();
                my $gfx_src =
                    path("lib/screenplay-xml/txt/scripts/graphics/$gfx_bn");
                $gfx_src->copy($gfx_out);
            }

            push @generate_file_list_promises, sub {
                write_on_change( $text_out_fh, \( $fn->slurp_utf8 ) );
                my $got_doc = $image_lister->calc_doc__from_proto_text(
                    $xml_out_fh,
                    {
                        source => {
                            file => "$fn",
                        },
                    }
                );
                return [
                    $files_var,
                    [
                        map {
                            my $uri = $_->uri();
                            $uri =~ s#\A(?:\./)?images/##ms
                                or die "non matching uri='$uri'";
                            $uri
                        } @{ $got_doc->list_images() }
                    ]
                ];
            };
        }
        my $src_varname    = $gen_name->("SCREENPLAY_XML_SOURCE");
        my $src_xhtmlname  = $gen_name->("SCREENPLAY_XHTML_INTERMEDIATE");
        my $dest_xhtmlname = $gen_name->("SCREENPLAY_XHTML_INTERMEDIATE_DEST");
        my $dest_varname   = $gen_name->("TXT_FROM_VCS");
        my $epub_dest_varname    = $gen_name->("EPUB_FROM_VCS");
        my $src_vcs_dir_var      = $gen_name->("SCREENPLAY_XML__SRC_DIR");
        my $src_prepare_epub_var = $gen_name->("EPUB_PREPARATION_SCRIPT");

        push @epubs, $epub_dest_varname;
        my $epub_dest_path = $_epub_map->{ $doc_base . '.epub' }
            // ( die "epub_dest_path returned undef for doc_base=$doc_base ." );

        push @ret, "$src_vcs_dir_var := \$($vcs_dir_var)/screenplay\n",
"$src_prepare_epub_var := \$($src_vcs_dir_var)/scripts/prepare-epub.pl\n",
"$src_varname := \$($src_vcs_dir_var)/${doc_base}.screenplay-text.txt\n",
"$src_xhtmlname := \$($src_vcs_dir_var)/${doc_base}.screenplay-text.xhtml\n",
            "$dest_xhtmlname := \$(SCREENPLAY_XML_HTML_DIR)/${doc_base}.html\n",
            "$dest_varname := \$(SCREENPLAY_XML_TXT_DIR)/${doc_base}.txt\n",
            "$epub_dest_varname := $epub_dest_path\n",
            (     "\$($dest_varname): \$($src_varname)\n" . "\t"
                . q/$(call COPY)/
                . "\n\n" ),
            (
            $should_clone
            ? ()
            : (
"\$($src_prepare_epub_var): lib/screenplay-xml/txt/scripts/${doc_base}-prepare-epub.pl\n"
                    . "\t"
                    . qq#\$(MKDIR) \$($src_vcs_dir_var)/scripts# . "\n" . "\t"
                    . q/$(call COPY)/
                    . "\n\n" )
            ),

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
$(POST_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-part-1.epub \
$(POST_DEST)/humour/Buffy/A-Few-Good-Slayers/Buffy--a-Few-Good-Slayers.epub \
$(POST_DEST)/humour/Cookie-Monster--The-Slayer/Cookie-Monster--The-Slayer.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Harry-Potter.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Jennifer-Lawrence.epub \
$(POST_DEST)/humour/Muppets-Show-TNI/Muppets-Show--Summer-Glau-and-Chuck-Norris.epub   \
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
$(POST_DEST)/humour/bits/Who-will-ride-Princess-Celestia/Who-will-ride-Princess-Celestia.epub \
$(POST_DEST)/humour/humanity/Humanity-Movie-hebrew.epub \
$(POST_DEST)/humour/humanity/Humanity-Movie.epub \
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
    foreach my $doc ( sort { $a->{base} cmp $b->{base} }
        @{ YAML::XS::LoadFile("./lib/screenplay-xml/list.yaml") } )
    {
        _calc_screenplay_doc_makefile_lines(
            ( \@records ),
            $dest_dir_vars, ( \$images_copy ),
            $addprefixes, $_epub_map, $screenplay_vcs_base_dir, $doc,
        );
    }
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
        "$graphics_dir_bn_var := graphics\n",
        ( map { @{ $_->{lines} } } @records ),
        "\n\nSCREENPLAY_DOCS_FROM_GEN := \\\n",
        ( map { "\t$_->{base} \\\n" } map { @{ $_->{docs} } } @records ),
        "\n\nSCREENPLAY_DOCS__DEST_EPUBS := \\\n",
        ( map { "\t\$($_) \\\n" } map { @{ $_->{epubs} } } @records ),
        "\n",
"$epub_dests_varname := \\\n$epub_dests\n$raw_htmls__dests__varname := \\\n$_htmls_dests\n",
        (
            map {
                my $fn = $_;
                my $x  = _basename($fn);
                $x =~ s/\.raw(\.html)\z/$1/;
                my $heb_filt = '';
                if ( $x =~ /hebrew/ )
                {
                    $heb_filt = "DIR=rtl";
                }
                "${fn}: \$(SCREENPLAY_XML_HTML_DIR)/${x}"
                    . sprintf( "\n\t\$(call %s,%s)\n\n",
                    $CLEAN_NAMESPACES_FUNC_NAME, $heb_filt );
            } @_htmls_files
        ),
        (
            "\nALL_SCREENPLAYS__SCREENPLAY_IMAGES__POST_DESTS = ",
            join( ' ', map { "\$($_)" } sort keys %$dest_dir_vars ),
            "\n"
        ),
    );

    my $DIR = "lib/make/";
    path("${DIR}copies-generated-screenplay-images.mak")
        ->spew_utf8($images_copy);
    my $clone_cb = sub {
        my ($r) = @_;

        return $git_task->( $screenplay_vcs_base_dir, $r );
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
