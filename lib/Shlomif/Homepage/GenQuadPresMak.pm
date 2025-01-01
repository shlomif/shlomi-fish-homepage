package Shlomif::Homepage::GenQuadPresMak;

use strict;
use warnings;

use Moo;

use File::Update        qw/ write_on_change /;
use Path::Tiny          qw/ path /;
use Template            ();
use Text::VimColor 0.29 ();

use Shlomif::Homepage::Presentations ();

my $gen_quadpres_fn = "lib/make/generated/sf-homepage-quadpres-generated.mak";

my $WMLECT_EXAMPLES_FNS = <<'EOF';
APIs/grid/index.html.wml
APIs/toc/index.html.wml
bolding/template.wml
common_look/Makefile
common_look/download.html.wml
common_look/index.html.wml
common_look/links.html.wml
common_look/template.wml
faq-l/answers.html.wml
faq-l/api.wml
faq-l/index.html.wml
faq-l/questions.wml
frames/Makefile
frames/navbar-frame.html.wml
frames/navbar.wml
frames/template.wml
meta-tag/template.wml
EOF

sub generate
{
    my ( $self, $args ) = @_;

    foreach my $fn ( split /\n/, $WMLECT_EXAMPLES_FNS )
    {
        my $ffn  = "lib/presentations/qp/Website-Meta-Lecture/src/examples/$fn";
        my $dest = path("$ffn.html");
        if ( not $dest->exists() )
        {
            my $syntax = Text::VimColor->new(
                file           => $ffn,
                html_full_page => 1,
                xhtml5         => 1,
            );

            write_on_change( $dest,
                \( $syntax->html =~ s#(<meta[^/>]+[^/])>#$1/>#gr ) );
        }
    }
    my $tt = Template->new( {} );
    $tt->process(
        "lib/make/docbook/sf-homepage-quadpres-gen.tt",
        {
            top_header => <<"EOF",
### This file is auto-generated from gen-dobook-make-helpers.pl
EOF
            quadp_presentations => scalar(
                Shlomif::Homepage::Presentations->new->quadp_presentations
            ),
        },
        sub {
            my $text = shift;
            $text =~ s/\n\n+/\n/g;
            path($gen_quadpres_fn)->spew_utf8($text);
            return;
        },
    ) or die $tt->error();

    return;
}

1;
