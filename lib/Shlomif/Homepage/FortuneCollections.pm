package Shlomif::Homepage::FortuneCollections::Record;

use strict;
use warnings;

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(qw(
    id
    text
    title
    desc
    ));

package Shlomif::Homepage::FortuneCollections;

use strict;
use warnings;

use Carp;
use Data::Dumper;

sub _init_fortune
{
    my $rec = shift;

    foreach my $req_field (qw(id desc))
    {
        if (!exists($rec->{$req_field}))
        {
            Carp::confess("Field $req_field does not exist in record for ".
                Dumper($rec) . "!");
        }
    }

    return Shlomif::Homepage::FortuneCollections::Record->new($rec);
}

my @forts =
(
    map { _init_fortune($_) }
(
    {
        'id' => "shlomif",
        desc => "a collection of my own quotes."
    },
    {
        'id' => "shlomif-fav",
        desc => "Favourite quotes I collected from various sources.",
    },
    {
        'id' => "friends",
        desc => "quotes from the scripts of the T.V. show Friends. They cover the first three seasons.",
    },
    {
        'id' => "joel-on-software",
        desc => "quotes from the <a href=\"http://www.joelonsoftware.com/\">Joel on Software</a> site.",
    },
    {
        'id' => "nyh-sigs",
        desc => <<"EOF",
a collection of quotes found in the
signatures of <a href="http://nadav.harel.org.il/">Nadav Har'El</a>,
as collected using an automated script.
EOF
    },
    {
        'id' => "osp_rules",
        desc => <<"EOF",
"The Rules of Open-Source Programming".
Also check a <a href="http://www.advogato.org/article/395.html">discussion of it</a> on 
<a href="http://www.advogato.org/">Advogato</a>.
EOF
    },
    {
        'id' => "paul-graham",
        desc => <<"EOF",
Quotes from the essays and writings
of <a href="http://www.paulgraham.com/">Paul Graham</a>.
EOF
    },
    {
        'id' => "subversion",
        desc => <<"EOF",
Excerpts from the online 
<a href="http://subversion.tigris.org/">Subversion</a> folklore.
EOF
    },
    {
        'id' => "tinic",
        desc => <<"EOF",
the ultimate collection of reasons why
"there is no IGLU cabal", and other Israeli Linux on-line folklore.
EOF
    },
    {
        'id' => "sharp-perl",
        desc => "a collection of conversations from Freenode's #perl",
    },
    {
        'id' => "sharp-programming",
        desc => "a collection of conversations from Freenode's ##programming",
    },
    {
        'id' => "shlomif-factoids",
        desc => "a collection of factoids about people and things (e.g: Chuck Norris)",
    },
)
);

sub get_fortune_records
{
    return \@forts;
}

1;

