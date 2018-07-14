package Shlomif::Spelling::FindFiles;

use strict;
use warnings;

use MooX qw/late/;
use List::MoreUtils qw/any/;

use HTML::Spelling::Site::Finder;

my @prunes = (
    qr#^dest/t2/MANIFEST\.html$#,
    qr#philosophy/foss-other-beasts/revision-2/#,
qr#philosophy/politics/drug-legalisation/case-for-drug-legalisation--hebrew-v3/#,
    qr#guide2ee/undergrad#,
    qr#(?:humour/TheEnemy/(?:The-Enemy-(?:English-)?rev|TheEnemy))#,
qr#(?:humour/by-others/(?:English-is-a-Crazy-Language|darien|funroll-loops|hitchhiker|how-many-newsgroup-readers|oded-c|s-stands-for-simple|technion-bit-1|top-12-things-likely|was-the-death-star-attack|grad-student-jokes-from-jnoakes|the-fountainhead-starring-skull-force|if-people-bought-cars))#,
    qr#humour/bits/facts/(?:Chuck-Norris|XSLT)#,
    qr#^dest/t2/humour/fortunes/all-in-one#,
    qr#^dest/t2/humour/fortunes/joel#,
    qr#^dest/t2/humour/fortunes/nyh-sig#,
    qr#^dest/t2/humour/fortunes/osp#,
    qr#^dest/t2/humour/fortunes/paul#,
    qr#^dest/t2/humour/fortunes/sharp#,
    qr#^dest/t2/humour/fortunes/shlomif#,
    qr#^dest/t2/humour/fortunes/source-files-list.html#,
    qr#^dest/t2/humour/fortunes/subversion.html#,
    qr#^dest/t2/humour/fortunes/tinic.html#,
    qr#humour/human-hacking/.*arabic#,
    qr#humour/human-hacking/human-hacking-field-guide/#,
    qr#humour/human-hacking/hebrew-v2#,
    qr#humour/humanity/ongoing-text-hebrew#,
    qr#lecture/Lambda-Calculus/slides/shriram\.scm#,
    qr#lecture/HTML-Tutorial/v1/xhtml1/hebrew#,
    qr#js/MathJax/(?:test|docs)/#,
qr#dest/t2/philosophy/computers/high-quality-software/what-makes-software-high-quality#,
qr#dest/t2/philosophy/computers/open-source/linus-torvalds-bus-factor/index#,
    qr#\.raw\.html$#,
    qr#^\Qdest/t2/js/jquery-ui\E#,
    qr#^\Qdest/t2/Iglu/shlomif/gamla\E#,
    qr#^\Qdest/t2/open-source/anti/TIOBE/Berke-Durak--anti-TIOBE--Mirror\E#,
    qr#^\Qdest/t2/open-source/resources/tech-tips/\E#,
qr#^\Qdest/t2/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/\E#,
qr#^\Qdest/t2/philosophy/philosophy/putting-all-cards-on-the-table-2013/DocBook5/\E#,
qr#^\Qdest/t2/philosophy/philosophy/SummerNSA-2014-09-call-for-action/DocBook5/\E#,
qr#^\Qdest/t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.html\E\z#,
    qr#^\Qdest/t2/humour/by-others/how-to-make-square-corners-with-CSS/#,
    qr#^\Qdest/t2/philosophy/by-others/sscce/#,
);

sub list_htmls
{
    my ($self) = @_;

    return HTML::Spelling::Site::Finder->new(
        {
            root_dir => 'dest/t2',
            prune_cb => sub {
                my ($path) = @_;
                return any { $path =~ $_ } @prunes;
            },
        }
    )->list_all_htmls;
}

1;
