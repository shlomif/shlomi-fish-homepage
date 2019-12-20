package Shlomif::Spelling::FindFiles;

use strict;
use warnings;

use MooX qw/late/;
use List::MoreUtils qw/any/;

use HTML::Spelling::Site::Finder ();
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

my @prunes = (
    qr#^\Q$POST_DEST\E/MANIFEST\.html$#,
    qr#\A\Q$POST_DEST\E/lecture/.*?/[a-zA-Z_\-0-9\.]*?--all-in-one-html/#,
    qr#philosophy/foss-other-beasts/revision-2/#,
qr#philosophy/politics/drug-legalisation/case-for-drug-legalisation--hebrew-v3/#,
    qr#guide2ee/undergrad#,
    qr#(?:humour/TheEnemy/(?:The-Enemy-(?:English-)?rev|TheEnemy))#,
qr#(?:humour/by-others/(?:English-is-a-Crazy-Language|darien|funroll-loops|hitchhiker|how-many-newsgroup-readers|oded-c|s-stands-for-simple|technion-bit-1|top-12-things-likely|was-the-death-star-attack|grad-student-jokes-from-jnoakes|the-fountainhead-starring-skull-force|if-people-bought-cars))#,
    qr#^\Q$POST_DEST\E/humour/fortunes/all-in-one#,
    qr#^\Q$POST_DEST\E/humour/fortunes/sharp#,
    qr#^\Q$POST_DEST\E/humour/fortunes/source-files-list.html#,
    qr#humour/human-hacking/.*arabic#,
    qr#humour/human-hacking/human-hacking-field-guide/#,
    qr#humour/human-hacking/hebrew-v2#,
    qr#humour/humanity/ongoing-text-hebrew#,
    qr#lecture/Lambda-Calculus/slides/shriram\.scm#,
    qr#lecture/HTML-Tutorial/v1/xhtml1/hebrew#,
    qr#js/MathJax/(?:test|docs)/#,
qr#\Q$POST_DEST\E/philosophy/computers/high-quality-software/what-makes-software-high-quality#,
qr#\Q$POST_DEST\E/philosophy/computers/open-source/linus-torvalds-bus-factor/index#,
    qr#\.raw\.html$#,
    qr#^\Q$POST_DEST\E/js/jquery-ui#,
    qr#^\Q$POST_DEST\E/Iglu/shlomif/gamla#,
    qr#^\Q$POST_DEST/open-source/anti/TIOBE/Berke-Durak--anti-TIOBE--Mirror\E#,
    qr#^\Q$POST_DEST/open-source/resources/tech-tips/\E#,
qr#^\Q$POST_DEST/philosophy/culture/my-real-person-fan-fiction/index.xhtml\E$#,
qr#^\Q$POST_DEST/philosophy/philosophy/putting-cards-on-the-table-2019-2020/indiv-sections/\E#,
qr#^\Q$POST_DEST/philosophy/philosophy/putting-cards-on-the-table-2019-2020/putting-cards-on-the-table-2019-2020/\E#,
qr#^\Q$POST_DEST/philosophy/philosophy/putting-cards-on-the-table-2019-2020/DocBook5/\E#,
qr#^\Q$POST_DEST/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/\E#,
qr#^\Q$POST_DEST/philosophy/philosophy/putting-all-cards-on-the-table-2013/DocBook5/\E#,
qr#^\Q$POST_DEST/philosophy/philosophy/SummerNSA-2014-09-call-for-action/DocBook5/\E#,
qr#^\Q$POST_DEST/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.xhtml\E\z#,
qr#^\Q$POST_DEST/philosophy/psychology/why-openly-bipolar-people-should-not-be-medicated/\E#,
    qr#^\Q$POST_DEST/rindolf/\E#,
    qr#^\Q$POST_DEST\E/humour/by-others/how-to-make-square-corners-with-CSS/#,
    qr#^\Q$POST_DEST\E/philosophy/by-others/sscce/#,
qr#^\Q$POST_DEST\E/philosophy/case-for-file-swapping/case-for-file-swapping/#,
    qr#^\Q$POST_DEST\E/philosophy/case-for-file-swapping/revision-2/#,
);

sub list_htmls
{
    my ($self) = @_;

    return HTML::Spelling::Site::Finder->new(
        {
            root_dir => $POST_DEST,
            prune_cb => sub {
                my ($path) = @_;
                return (
                    ( any { $path =~ $_ } @prunes )
                        || (
                        (
                            $path =~
m#\A\Q$POST_DEST\E/meta/FAQ/([a-zA-Z0-9_\-\.]+)\.xhtml\z#
                        )
                        and ( $1 ne "index" )
                        )
                );
            },
        }
    )->list_all_htmls;
}

1;
