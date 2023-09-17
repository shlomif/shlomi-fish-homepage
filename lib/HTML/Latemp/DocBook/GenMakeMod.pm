package HTML::Latemp::DocBook::GenMakeMod;

use strict;
use warnings;

use Moo;

use Path::Tiny                        qw/ path /;
use Template                          ();
use HTML::Latemp::DocBook::DocsList   ();
use HTML::Latemp::DocBook::EndFormats ();

has [ 'dest_var', 'post_dest_var' ] => ( is => 'ro', required => 1 );
has [ 'disable_docbook4', ]         => ( is => 'ro', default  => '', );

my $gen_make_fh = path("lib/make/generated/sf-homepage-docbooks-generated.mak");

sub generate
{
    my ( $self, $args ) = @_;

    my $tt        = Template->new( {} );
    my $documents = HTML::Latemp::DocBook::DocsList->new->docs_list;

    my $output = '';
    $tt->process(
        "lib/make/docbook/sf-homepage-docbook-gen.tt",
        {
            docbook_versions => [ 5, ],
            DEST             => $self->dest_var,
            POST_DEST        => $self->post_dest_var,
            docs_5           => [@$documents],
            fmts             =>
                scalar( HTML::Latemp::DocBook::EndFormats->new->get_formats ),
            top_header => <<"EOF",
### This file is auto-generated from gen-dobook-make-helpers.pl
EOF
        },
        ( \$output ),
    ) or die $tt->error();

    $output =~ s/\n{2,}/\n/g;
    my $L =
qq=\tcp -f lib/sgml/shlomif-docbook/xsl-stylesheets/style.css \$(POST_DEST)/humour/human-hacking/human-hacking-field-guide-v2--english/style.css\n=;
    $output =~ s/^\Q$L\E//ms or die;

    $gen_make_fh->touchpath()->spew_utf8($output);

    return;
}

1;
