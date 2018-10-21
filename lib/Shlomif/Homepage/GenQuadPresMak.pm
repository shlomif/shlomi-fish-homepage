package Shlomif::Homepage::GenQuadPresMak;

use strict;
use warnings;

use Moo;

use Path::Tiny qw/ path /;
use Template                         ();
use Shlomif::Homepage::Presentations ();

my $gen_quadpres_fn = "lib/make/docbook/sf-homepage-quadpres-generated.mak";

sub generate
{
    my ( $self, $args ) = @_;

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
        $gen_quadpres_fn,
    ) or die $tt->error();

    path($gen_quadpres_fn)->edit_utf8(
        sub {
            s/\n\n+/\n\n/g;
        }
    );

    return;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
