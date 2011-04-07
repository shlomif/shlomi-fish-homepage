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

package Shlomif::Homepage::FortuneCollections;

use strict;
use warnings;

use utf8;

use Carp;
use Data::Dumper;

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
        'id' => "shlomif",
        desc => "a collection of my own quotes.",
        text => "shlomif",
        title => "Quotes by Shlomi Fish",
    },
    {
        'id' => "shlomif-fav",
        desc => "Favourite quotes I collected from various sources.",
        text => "shlomif-fav",
        title => "Other Favourite Quotes",
    },
    {
        'id' => "friends",
        desc => "quotes from the scripts of the T.V. show Friends. They cover the first three seasons.",
        text => "friends",
        title => "Excerpts from the T.V. Show “Friends”",
    },
    {
        'id' => "joel-on-software",
        desc => "quotes from the <a href=\"http://www.joelonsoftware.com/\">Joel on Software</a> site.",
        text => "joel-on-software",
        title => "Quotes from the site “Joel on Software”",
    },
    {
        'id' => "nyh-sigs",
        desc => <<"EOF",
a collection of quotes found in the
signatures of <a href="http://nadav.harel.org.il/">Nadav Har'El</a>,
as collected using an automated script.
EOF
        text => "nyh-sigs",
        title => "Nadav Har’El’s Signatures",
    },
    {
        'id' => "osp_rules",
        desc => <<"EOF",
"The Rules of Open-Source Programming".
Also check a <a href="http://www.advogato.org/article/395.html">discussion of it</a> on 
<a href="http://www.advogato.org/">Advogato</a>.
EOF
        text => "osp_rules",
        title => "Rules of Open Source Programming",
    },
    {
        'id' => "paul-graham",
        desc => <<"EOF",
Quotes from the essays and writings
of <a href="http://www.paulgraham.com/">Paul Graham</a>.
EOF
        text => "paul-graham",
        title => "Paul Graham Quotes",
    },
    {
        'id' => "subversion",
        desc => <<"EOF",
Excerpts from the online 
<a href="http://subversion.tigris.org/">Subversion</a> folklore.
EOF
        text => "subversion",
        title => "Quotes from the Online Folklore of the Subversion Version Control System",
    },
    {
        'id' => "tinic",
        desc => <<"EOF",
the ultimate collection of reasons why
"there is no IGLU cabal", and other Israeli Linux on-line folklore.
EOF
        text => "tinic",
        title => "Quotes from the online Linux-IL Folklore",
    },
    {
        'id' => "sharp-perl",
        desc => "a collection of conversations from Freenode's #perl",
        text => "#perl",
        title => "Quotes from the Freenode #perl channel",
    },
    {
        'id' => "sharp-programming",
        desc => "a collection of conversations from Freenode's ##programming",
        text => "##programming",
        title => "Quotes from the Freenode ##programming channel",
    },
    {
        'id' => "shlomif-factoids",
        desc => "a collection of factoids about people and things (e.g: Chuck Norris)",
        text => "shlomif-factoids",
        title => "Funny Factoids about People and Things (Chuck Norris, etc.)",
    },
)
);

sub get_fortune_records
{
    return \@forts;
}

1;

