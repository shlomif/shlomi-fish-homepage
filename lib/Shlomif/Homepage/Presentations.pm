package Shlomif::Homepage::Presentations;

use strict;
use warnings;
use autodie;

use Template                 ();
use Path::Tiny               qw/ path /;
use File::Update             qw/ write_on_change /;
use File::Find::Object::Rule ();

use Moo;

{
    my $qp_base   = path("lib/presentations/qp");
    my $qp_common = $qp_base->child("common");

    sub _common_path
    {
        return $qp_common->child(@_);
    }

    sub _common_slurp
    {
        return _common_path(@_)->slurp_utf8;
    }
    my $qp_slidy            = _common_slurp("slidy.js");
    my $css_tt              = Template->new( {} );
    my $qp_template_en_text = _common_slurp("template-en.wml");
    my $qp_template_he_text = _common_slurp("template-he.wml");

    sub _get_quad_pres_files
    {
        my $args     = shift || {};
        my $dir_base = $args->{dir};
        my $lang     = $args->{lang}
            or die "lang in $dir_base is not specified!";
        my $css_params = $args->{css} // +();
        my $dir        = "lib/presentations/qp/$dir_base";
        my $dest_dir   = $args->{dest_dir};

        write_on_change( scalar( path("$dir/src/slidy.js") ), \$qp_slidy );
        $css_tt->process( _common_path("style.css.tt2") . '',
            $css_params, "$dir/src/style.css" )
            or die "$!";

        my $serve_fn = "$dir/serve.pl";
        write_on_change( scalar( path($serve_fn) ), \<<"EOF");
#!/usr/bin/env perl

use strict;
use warnings;

use lib "\$ENV{HOME}/apps/test/quadpres/share/quad-pres/perl5";
use Shlomif::Quad::Pres::CGI ();

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
        write_on_change(
            scalar( path("$dir/template.wml") ),
            (
                $lang eq 'en'
                ? \$qp_template_en_text
                : \$qp_template_he_text
            )
        );
        path("$dir/.wmlrc")->spew_utf8(<<"EOF");
-DROOT~src --passoption=2,-X3330 -DTHEME=shlomif-text
EOF

        my $ini_dest_dir = qq#[% ENV.PRE_DEST %]/$dest_dir#;
        path("$dir/quadpres.ini")->spew_utf8(<<"EOF");
[quadpres]
tt_server_dest_dir=$ini_dest_dir
setgid_group=

[upload]
util=rsync
tt_upload_path=$ini_dest_dir/

[hard-disk]
dest_dir=./hard-disk-html
EOF

        chmod oct("0755"), $serve_fn;

        my $include_cb = $args->{'include_cb'} || sub { return 1; };

        my $dir_src = "$dir/src";

        my @files =
            File::Find::Object::Rule->name('*.html.wml')->in( $dir_src, );

        foreach my $f (@files)
        {
            $f =~ s{\A\Q$dir_src\E/}{}ms;
            $f =~ s{\.wml\z}{};
        }

        return +( $dir_base =~ tr#/-#__#r ) => +{
            all_in_one_html_dir =>
                scalar( $dest_dir =~ s#\z#--all-in-one-html#r ),
            dest_dir    => $dest_dir,
            lang        => $lang,
            'src_dir'   => $dir,
            'src_files' => [
                sort { $a cmp $b }
                grep { $include_cb->($_) }

                # Filtering out explicitly because it has its own separate
                # dependency.
                grep { $_ ne "index.html" } @files
            ],
        };
    }
}

my $quadp_presentations = {
    map { _get_quad_pres_files($_) } (
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
            dest_dir => "lecture/Gimp/2.2-slides",
        },
        {
            lang     => 'en',
            dir      => "haskell-for-perl-programmers",
            dest_dir => "lecture/Perl/Haskell/slides",
        },
        {
            lang       => 'he',
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
            lang       => 'he',
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
            lang       => 'he',
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
};

sub quadp_presentations
{
    return $quadp_presentations;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
