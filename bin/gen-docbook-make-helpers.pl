#!/usr/bin/perl

use strict;
use warnings;

use Template;

use File::Find::Object::Rule;

my @documents =
(
    {
        id => "case-for-drug-legalisation",
        path => "philosophy/politics/drug-legalisation",
        base => "case-for-drug-legalisation",
    },
    {
        id => "case-for-file-swapping-rev3",
        path => "philosophy/case-for-file-swapping/revision-3",
        base => "case-for-file-swapping-rev3",
    },
    {
        id => "dealing-with-hypomanias", 
        path => "philosophy/psychology/hypomanias/", 
        base => "dealing-with-hypomanias",
        work_in_progress => 1,
    },
    {
        id => "end-of-it-slavery", 
        path => "philosophy/computers/software-management/end-of-it-slavery", 
        base => "end-of-it-slavery",
    },
    {
        id => "foss-and-other-beasts",
        path => "philosophy/foss-other-beasts/revision-2",
        base => "foss-and-other-beasts",
    },
    
    {
        id => "introductory-language", 
        path => "philosophy/computers/education/introductory-language", 
        base => "introductory-language",
    },
    
    {
        id => "isr-pales-conflict-solution", 
        path => "philosophy/israel-pales", 
        base => "isr-pales-conflict-solution",
    },
    
    {
        id => "objectivism-and-open-source",
        path => "philosophy/obj-oss",
        base => "objectivism-and-open-source",
    },
    
    {
        id => "rindolf-spec",
        path => "rindolf",
        base => "rindolf-spec",
    },
    
    {
        id => "the-eternal-jew",
        path => "philosophy/the-eternal-jew",
        base => "the-eternal-jew",
    },
    
    {
        id => "what-makes-software-high-quality", 
        path => "philosophy/computers/high-quality-software", 
        base => "what-makes-software-high-quality",
    },
    
    {
        id => "what-makes-software-high-quality-rev2", 
        path => "philosophy/computers/high-quality-software/rev2", 
        base => "what-makes-software-high-quality-rev2",
    },
    {
        id => "perfect-it-workplace", 
        path => "philosophy/computers/software-management/perfect-workplace", 
        base => "perfect-it-workplace",
    },
    {
        id => "perfect-it-workplace-rev2", 
        path =>  "philosophy/computers/software-management/perfect-workplace/rev2",
        base => "perfect-it-workplace-rev2",
        work_in_progress => 1,
    },
    
    {
        id => "foss-licences-wars", 
        path => "philosophy/computers/open-source/foss-licences-wars", 
        base => "foss-licences-wars",
        work_in_progress => 1,
    },
);

sub process_simple_end_format
{
    my $fmt = shift;

    my %f = %$fmt;

    if (!exists($f{dir}))
    {
        $f{dir} = lc($f{var});
    }

    return \%f;
}

my @end_formats = 
(
    (
        map { process_simple_end_format($_) }
        (
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
            var => "FO",
            ext => ".fo",
            skip_install => 1,
        },
        {
            var => "INDIVIDUAL_XHTML",
            ext => "",
            dir => "indiv-nodes",
        },
        )
    )
);

my $tt = Template->new({});

open my $make_fh, ">", "lib/make/docbook/sf-homepage-docbooks-generated.mak";
open my $template_fh, "<", "lib/make/docbook/sf-homepage-db-gen.tt";

sub get_quad_pres_files
{
    my $dir = shift;
    my $args = shift || {};

    my $include_cb = $args->{'include_cb'} || sub { return 1; };

    my $dir_src = "$dir/src";

    my @files = File::Find::Object::Rule->name('*.html.wml')->in(
        $dir_src,
    );

    foreach my $f (@files)
    {
        $f =~ s{\A\Q$dir_src\E/}{}ms;
        $f =~ s{\.wml\z}{};
    }

    return
    [
        'src_dir' => $dir,
        'src_files' =>
        [ 
            sort { $a cmp $b }
            grep { $include_cb->($_) }
            grep { $_ ne "index.html" } 
            @files
        ],
    ];
}

sub get_p4n_files
{
    my $n = shift;

    return get_quad_pres_files("lib/presentations/qp/perl-for-newbies/$n");
}

$tt->process($template_fh, 
    {
        docs => \@documents,
        fmts => \@end_formats,
        top_header => <<"EOF",
### This file is auto-generated from gen-dobook-make-helpers.pl
EOF
        quadp_presentations =>
        {
            (map 
                {
                    (
                        "p4n$_" => 
                        {
                            dest_dir => "lecture/Perl/Newbies/lecture$_",
                            @{get_p4n_files($_)},
                        },
                    )
                }
                (1 .. 5)
            ),
            'lamp' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/web-publishing-with-LAMP",
                )},
                dest_dir => "lecture/LAMP/slides",
            },
            'catb' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/CatB",
                )},
                dest_dir => "lecture/CatB/slides",
            },
            'joel_test' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/joel-test",
                )},
                dest_dir => "lecture/joel-test/heb-slides",
            },
            'haskell_for_perlers' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/haskell-for-perl-programmers",
                )},
                dest_dir => "lecture/Perl/Haskell/slides",
            },
            'gimp_2_2' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/Gimp/2.2",
                )},
                dest_dir => "lecture/Gimp/1/2.2-slides",
            },
            'gimp_1_2' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/Gimp/1.2",
                )},
                dest_dir => "lecture/Gimp/1/slides",
            },
            'autotools' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/Autotools",
                )},
                dest_dir => "lecture/Autotools/slides",
            },
            'website_meta_lect' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/Website-Meta-Lecture",
                    {
                        include_cb => sub {
                            my $fn = shift;
                            return ($fn !~ m{\Aexamples/})
                        },
                    },
                )},
                dest_dir => "lecture/WebMetaLecture/slides",
            },
            'freecell_solver_1' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/Freecell-Solver/1",
                )},
                dest_dir => "lecture/Freecell-Solver/slides",
            },
            'freecell_solver_the_next_pres' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/Freecell-Solver/The-Next-Pres",
                )},
                dest_dir => "lecture/Freecell-Solver/The-Next-Pres/slides",
            },
            'freecell_solver_project_intro' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/Freecell-Solver/project-intro",
                )},
                dest_dir => "lecture/Freecell-Solver/project-intro/slides",
            },
            'lm_solve' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/LM-Solve",
                )},
                dest_dir => "lecture/LM-Solve/slides",
            },
            'mdda' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/meta-data-database-access",
                )},
                dest_dir => "lecture/mini/mdda/slides",
            },
            'w2l_basic_use' =>
            {
                @{get_quad_pres_files(
                    "lib/presentations/qp/welcome-to-linux/Basic_Use-2",
                )},
                dest_dir => "lecture/W2L/Basic_Use/slides",
            },
        },
    },
    $make_fh
);

close ($template_fh);
close ($make_fh);
