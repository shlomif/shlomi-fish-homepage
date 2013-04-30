package Shlomif::Homepage::FortuneCollections::Record;

use strict;
use warnings;

use utf8;

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(qw(
    id
    text
    title
    desc
    ));

sub nav_record
{
    my ($self) = @_;

    return
    {
        text => scalar($self->text()),
        url => sprintf(
            "humour/fortunes/%s.html",
            scalar($self->id())
        ),
        title => scalar($self->title()),
    };
}

package Shlomif::Homepage::FortuneCollections;

use strict;
use warnings;

use utf8;

use Carp;
use Data::Dumper;

use Shlomif::WrapAsUtf8 (qw(_wrap_as_utf8));

sub _init_fortune
{
    my $rec = shift;

    foreach my $req_field (qw(id desc text title))
    {
        if (!exists($rec->{$req_field}))
        {
            Carp::confess("Field $req_field does not exist in record for "
                . Dumper($rec) . "!");
        }
    }

    return Shlomif::Homepage::FortuneCollections::Record->new($rec);
}

my @forts =
(
    map { _init_fortune($_) }
(
    {
        id => "shlomif",
        desc => "A collection of my own quotes.",
        text => "shlomif",
        title => "Quotes by Shlomi Fish",
    },
    {
        id => "shlomif-fav",
        desc => "Favourite quotes I collected from various sources.",
        text => "shlomif-fav",
        title => "Other Favourite Quotes",
    },
    {
        id => "friends",
        desc => "Quotes from the scripts of the T.V. show Friends. They cover the first three seasons.",
        text => "friends",
        title => "Excerpts from the T.V. Show Friends",
    },
    {
        id => "joel-on-software",
        desc => qq{Quotes from the <a href="http://www.joelonsoftware.com/">Joel on Software</a> site.},
        text => "joel-on-software",
        title => "Quotes from the site “Joel on Software”",
    },
    {
        id => "nyh-sigs",
        desc => <<"EOF",
a collection of quotes found in the
signatures of <a href="http://nadav.harel.org.il/">Nadav Har’El</a>,
as collected using an automated script.
EOF
        text => "nyh-sigs",
        title => "Nadav Har’El’s Signatures",
    },
    {
        id => "osp_rules",
        desc => <<"EOF",
“The Rules of Open-Source Programming”.
Also check a <a href="http://www.advogato.org/article/395.html">discussion of it</a> on
<a href="http://www.advogato.org/">Advogato</a>.
EOF
        text => "osp_rules",
        title => "Rules of Open Source Programming",
    },
    {
        id => "paul-graham",
        desc => <<"EOF",
Quotes from the essays and writings
of <a href="http://www.paulgraham.com/">Paul Graham</a>.
EOF
        text => "paul-graham",
        title => "Paul Graham Quotes",
    },
    {
        id => "subversion",
        desc => <<"EOF",
Excerpts from the online
<a href="http://subversion.tigris.org/">Subversion</a> folklore.
EOF
        text => "subversion",
        title => "Quotes from the Online Folklore of the Subversion Version Control System",
    },
    {
        id => "tinic",
        desc => <<"EOF",
The ultimate collection of reasons why
“there is no IGLU cabal”, and other Israeli Linux on-line folklore.
EOF
        text => "tinic",
        title => "Quotes from the online Linux-IL Folklore",
    },
    {
        id => "sharp-perl",
        desc => "A collection of conversations from Freenode’s #perl .",
        text => "#perl",
        title => "Quotes from the Freenode #perl channel",
    },
    {
        id => "sharp-programming",
        desc => "A collection of conversations from Freenode’s ##programming .",
        text => "##programming",
        title => "Quotes from the Freenode ##programming channel",
    },
    {
        id => "shlomif-factoids",
        desc => "A collection of factoids about people and things (e.g: Chuck Norris).",
        text => "shlomif-factoids",
        title => "Funny Factoids about People and Things (Chuck Norris, etc.)",
    },
)
);

sub get_fortune_records
{
    return \@forts;
}

sub sorted_fortunes
{
    return
    [
        sort { $a->id() cmp $b->id() }
        @{get_fortune_records()}
    ];
}

sub nav_data
{
    return [ map { $_->nav_record() } @{sorted_fortunes()} ] ;
}

sub print_single_fortune_record_toc_entry
{
    my ($class, $r) = @_;

    my $id = $r->id;
    my $desc = $r->desc;

    _wrap_as_utf8(
        sub
        {
            print <<"EOF";
<li>
<p>
<a href="$id.html"><b>$id</b></a>
(<a href="$id.xml">XML</a>, <a href="$id">Plaintext</a>) -
$desc
</p>
</li>
EOF
        },
    );

    return;
}

sub print_fortune_records_toc
{
    my ($class) = @_;

    foreach my $r (@{$class->get_fortune_records()})
    {
        $class->print_single_fortune_record_toc_entry($r);
    }

    return;
}

1;

