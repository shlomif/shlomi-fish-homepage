package HTML::Latemp::DocBook::GenMake;

use strict;
use warnings;

use Moo;

use Path::Tiny qw/ path /;
use Template                          ();
use HTML::Latemp::DocBook::DocsList   ();
use HTML::Latemp::DocBook::EndFormats ();

has [ 'dest_var', 'post_dest_var' ] => ( is => 'ro', required => 1 );

my $gen_make_fn = "lib/make/docbook/sf-homepage-docbooks-generated.mak";

sub generate
{
    my ( $self, $args ) = @_;

    my $tt = Template->new( {} );
    my $documents = HTML::Latemp::DocBook::DocsList->new->docs_list;

    $tt->process(
        "lib/make/docbook/sf-homepage-docbook-gen.tt",
        {
            DEST      => $self->dest_var,
            POST_DEST => $self->post_dest_var,
            docs_4    => [ grep { $_->{db_ver} != 5 } @$documents ],
            docs_5    => [ grep { $_->{db_ver} == 5 } @$documents ],
            fmts =>
                scalar( HTML::Latemp::DocBook::EndFormats->new->get_formats ),
            top_header => <<"EOF",
### This file is auto-generated from gen-dobook-make-helpers.pl
EOF
        },
        $gen_make_fn,
    ) or die $tt->error();

    path($gen_make_fn)->edit_utf8(
        sub {
            s/\n\n+/\n\n/g;
        }
    );

    return;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
