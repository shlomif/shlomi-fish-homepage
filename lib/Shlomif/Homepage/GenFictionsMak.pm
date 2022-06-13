package Shlomif::Homepage::GenFictionsMak;

use strict;
use warnings;

use Moo;

use Path::Tiny qw/ path /;
use YAML::XS   ();

sub _calc_fiction_story_makefile_lines
{
    my ( $doc_record, $fiction_docs_basenames, $o ) = @_;

    my $base        = $doc_record->{base};
    my $github_repo = $doc_record->{github_repo};
    my $subdir      = $doc_record->{subdir};

    my $vcs_dir_var = "${base}__VCS_DIR";

    my @ret = ("$vcs_dir_var := \$(FICTION_VCS_BASE_DIR)/$github_repo\n\n");

    foreach my $doc ( @{ $doc_record->{docs} } )
    {
        my $doc_base = $doc->{base};
        my $suf      = $doc->{suf};
        my $type     = $doc->{type};

        my $bsuf = "${base}_${suf}";

        my ( $src_varname, $from_vcs_varname, $src_suffix,
            $dest_suffix, $dest_dir_var, $make_cmd, $dest_expr );

        if ( $type eq 'fiction-text' )
        {
            push @$fiction_docs_basenames, $doc_base;

            $src_varname      = "${bsuf}_FICTION_XML_SOURCE";
            $src_suffix       = 'fiction-text.txt';
            $from_vcs_varname = "${bsuf}_FICTION_TXT_FROM_VCS";
            $dest_suffix      = 'xml';
            $dest_dir_var     = 'FICTION_XML_XML_DIR';
            $make_cmd         = 'translate_fiction_text_to_xml';
            $dest_expr        = $doc->{dest_expr};
        }
        elsif ( $type eq 'docbook5' )
        {
            $src_varname      = "${bsuf}_DOCBOOK5_SOURCE";
            $src_suffix       = 'db5.xml';
            $from_vcs_varname = "${bsuf}_DOCBOOK5_FROM_VCS";
            $dest_suffix      = 'xml';
            $dest_dir_var     = 'DOCBOOK5_XML_DIR';
            $make_cmd         = 'COPY';
        }

        push @ret,
"$src_varname := \$($vcs_dir_var)/$subdir/text/$doc_base.$src_suffix\n",
            "$from_vcs_varname := \$($dest_dir_var)/$doc_base.$dest_suffix\n\n",
            "\$($from_vcs_varname): \$($src_varname)\n\t\$(call $make_cmd)\n\n";
        if ( defined $dest_expr )
        {
            push @ret, "${dest_expr}: \$($src_varname)\n\t\$(call COPY)\n\n";
        }
    }

    push @$o, @ret;

    return;
}

sub generate
{
    my $self     = shift;
    my $args     = shift;
    my $git_task = $args->{git_task};

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
                    base      => "human-hacking-field-guide-v2--hebrew",
                    type      => "fiction-text",
                    suf       => "HEB",
                    dest_expr => q#$(HHFG_HEB_V2_POST_DEST)#,
                },
            ],
        },
        {
            base        => "POPE",
            github_repo => "The-Pope-Died-on-Sunday",
            subdir      => "Pope",
            docs        => [
                {
                    base      => "The-Pope-Died-on-Sunday-english",
                    type      => "fiction-text",
                    suf       => "ENG",
                    dest_expr =>
q#$(POST_DEST_POPE)/The-Pope-Died-on-Sunday-english.txt#,
                },
                {
                    base      => "The-Pope-Died-on-Sunday-hebrew",
                    type      => "fiction-text",
                    suf       => "HEB",
                    dest_expr =>
                        q#$(POST_DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.txt#,
                },
            ],
        },
    ];

    my $fiction_vcs_base_dir = 'lib/fiction-xml/from-vcs';

FICT:
    my @fiction_docs_basenames;
    my @o;

    foreach my $doc_record (@$fiction_data)
    {
        my $github_repo = $doc_record->{github_repo};
        $git_task->( $fiction_vcs_base_dir, $github_repo );
        _calc_fiction_story_makefile_lines( $doc_record,
            \@fiction_docs_basenames, \@o );
    }

    my $dir  = path("lib/make/docbook");
    my $spew = sub {
        my ( $fn, $strs ) = @_;
        return $dir->child($fn)->spew_utf8(@$strs);
    };

    $spew->(
        "sf-fictions.mak",
        [ "FICTION_VCS_BASE_DIR := $fiction_vcs_base_dir\n\n", @o ],
    );
    $spew->(
        "sf-fictions-list.mak",
        ["FICTION_DOCS_FROM_GEN := @fiction_docs_basenames\n"],
    );

    return;
}

1;

__END__
