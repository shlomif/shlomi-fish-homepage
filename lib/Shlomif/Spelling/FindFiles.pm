package Shlomif::Spelling::FindFiles;

use strict;
use warnings;

use Moo;
use List::Util 1.34 qw/ any /;

use HTML::Spelling::Site::Finder ();
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

my @prunes = (
    qr#\A\Q$POST_DEST\E/MANIFEST\.html\z#,
    qr#\A\Q$POST_DEST\E/lecture/.*?/[a-zA-Z_\-0-9\.]*?--all-in-one-html/#,
    qr#\A\Q$POST_DEST\E/philosophy/foss-other-beasts/revision-2/#,
qr#\A\Q$POST_DEST\E/philosophy/politics/drug-legalisation/case-for-drug-legalisation--hebrew-v3/#,
    qr#\A\Q$POST_DEST\E/guide2ee/undergrad#,
qr#\A\Q$POST_DEST\E/(?:humour/TheEnemy/(?:The-Enemy-(?:English-)?rev|TheEnemy))#,
qr#\A\Q$POST_DEST\E/(?:humour/by-others/(?:English-is-a-Crazy-Language|darien|funroll-loops|hitchhiker|how-many-newsgroup-readers|oded-c|s-stands-for-simple|technion-bit-1|top-12-things-likely|was-the-death-star-attack|grad-student-jokes-from-jnoakes|the-fountainhead-starring-skull-force|if-people-bought-cars))#,
    qr#\A\Q$POST_DEST\E/humour/fortunes/all-in-one#,

    qr#\A\Q$POST_DEST\E/humour/fortunes/sharp-perl#,
    qr#\A\Q$POST_DEST\E/humour/fortunes/source-files-list.html#,
    qr#\A\Q$POST_DEST\E/humour/human-hacking/.*arabic#,
    qr#\A\Q$POST_DEST\E/humour/human-hacking/human-hacking-field-guide/#,
    qr#\A\Q$POST_DEST\E/humour/human-hacking/hebrew-v2#,
    qr#\A\Q$POST_DEST\E/humour/humanity/ongoing-text-hebrew#,
    qr#\A\Q$POST_DEST\E/lecture/Lambda-Calculus/slides/shriram\.scm#,
    qr#\A\Q$POST_DEST\E/lecture/HTML-Tutorial/v1/xhtml1/hebrew#,
    qr#\A\Q$POST_DEST\E/js/MathJax/(?:test|docs)/#,
qr#\Q$POST_DEST\E/philosophy/computers/high-quality-software/what-makes-software-high-quality#,
qr#\Q$POST_DEST\E/philosophy/computers/open-source/linus-torvalds-bus-factor/index#,
    qr#\A\Q$POST_DEST\E/js/jquery-ui#,
    qr#\A\Q$POST_DEST\E/Iglu/shlomif/gamla#,
    qr#\A\Q$POST_DEST\E/open-source/anti/TIOBE/Berke-Durak--anti-TIOBE--Mirror#,
    qr#\A\Q$POST_DEST\E/open-source/resources/tech-tips/#,
qr#\A\Q$POST_DEST\E/philosophy/culture/my-real-person-fan-fiction/index.xhtml\z#,
qr#\A\Q$POST_DEST\E/philosophy/philosophy/putting-cards-on-the-table-2019-2020/indiv-sections/#,
qr#\A\Q$POST_DEST\E/philosophy/philosophy/putting-cards-on-the-table-2019-2020/putting-cards-on-the-table-2019-2020/#,
qr#\A\Q$POST_DEST\E/philosophy/philosophy/putting-cards-on-the-table-2019-2020/DocBook5/#,
qr#\A\Q$POST_DEST\E/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/#,
qr#\A\Q$POST_DEST\E/philosophy/philosophy/putting-all-cards-on-the-table-2013/DocBook5/#,
qr#\A\Q$POST_DEST\E/philosophy/philosophy/SummerNSA-2014-09-call-for-action/DocBook5/#,
qr#\A\Q$POST_DEST\E/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.xhtml\z#,
qr#\A\Q$POST_DEST\E/philosophy/psychology/why-openly-bipolar-people-should-not-be-medicated/#,
    qr#\A\Q$POST_DEST\E/rindolf/#,
    qr#\A\Q$POST_DEST\E/humour/by-others/how-to-make-square-corners-with-CSS/#,
    qr#\A\Q$POST_DEST\E/philosophy/by-others/sscce/#,
qr#\A\Q$POST_DEST\E/philosophy/case-for-file-swapping/case-for-file-swapping/#,
    qr#\A\Q$POST_DEST\E/philosophy/case-for-file-swapping/revision-2/#,
);

my $RAW_HTML_REGEX = qr#\.raw\.html\z#;

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
                        || ( $path =~ $RAW_HTML_REGEX )
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
