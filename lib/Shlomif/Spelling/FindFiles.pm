package Shlomif::Spelling::FindFiles;

use strict;
use warnings;

use Moo;

use HTML::Spelling::Site::Finder ();
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

sub _individual_pages
{
    my ($args) = @_;
    my $paths = $args->{paths} or die "no paths";
    return [ map { $_ . qq#/[a-zA-Z_\\-0-9\\.]*?\\.xhtml# } @$paths ];
}

# q#philosophy/culture/my-real-person-fan-fiction/take2/index.xhtml\z#,
my @prunes = (
    q#MANIFEST\.html\z#,
    q#lecture/.*?/[a-zA-Z_\-0-9\.]*?--all-in-one-html/#,
    q#philosophy/foss-other-beasts/revision-2/#,
    q#humour/aphorisms/twitter-tweets-archive/#,
q#philosophy/politics/drug-legalisation/case-for-drug-legalisation--hebrew-v3/#,
    q#guide2ee/undergrad#,
    q#(?:humour/TheEnemy/(?:The-Enemy-(?:English-)?rev|TheEnemy))#,
q#(?:humour/by-others/(?:English-is-a-Crazy-Language|darien|funroll-loops|hitchhiker|how-many-newsgroup-readers|oded-c|s-stands-for-simple|technion-bit-1|top-12-things-likely|was-the-death-star-attack|grad-student-jokes-from-jnoakes|the-fountainhead-starring-skull-force|if-people-bought-cars))#,
    q#humour/fortunes/__FORTS-show-cgi-rawxhtmls/#,
    q#humour/fortunes/__FORTS-show-cgi-xhtmls/#,
    q#humour/fortunes/all-in-one#,
    q#humour/fortunes/source-files-list.html#,
    q#humour/human-hacking/.*arabic#,
    q#humour/human-hacking/human-hacking-field-guide/#,
    q#humour/human-hacking/hebrew-v2#,
    q#humour/humanity/ongoing-text-hebrew#,
    q#lecture/Lambda-Calculus/slides/shriram\.scm#,
    q#lecture/HTML-Tutorial/v1/xhtml1/hebrew#,
    q#js/MathJax/(?:test|docs)/#,
q#philosophy/culture/case-for-commercial-fan-fiction/screenplays-shortage-reduced-version\.xhtml#,
q#philosophy/computers/high-quality-software/what-makes-software-high-quality#,
    q#philosophy/computers/open-source/linus-torvalds-bus-factor/index#,
    q#js/jquery-ui#,
    q#Iglu/shlomif/gamla#,
    q#open-source/anti/TIOBE/Berke-Durak--anti-TIOBE--Mirror#,
    q#open-source/resources/how-to-contribute-to-my-projects/HACKING.html\z#,
    q#open-source/resources/tech-tips/#,
    q#philosophy/culture/my-real-person-fan-fiction/index.xhtml\z#,
q#philosophy/philosophy/putting-cards-on-the-table-2019-2020/indiv-sections/#,
q#philosophy/philosophy/putting-cards-on-the-table-2019-2020/putting-cards-on-the-table-2019-2020/#,
    q#philosophy/philosophy/putting-cards-on-the-table-2019-2020/DocBook5/#,
q#philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/#,
    q#philosophy/philosophy/putting-all-cards-on-the-table-2013/DocBook5/#,
    q#philosophy/philosophy/SummerNSA-2014-09-call-for-action/DocBook5/#,
    q#philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.xhtml\z#,
    q#philosophy/psychology/why-openly-bipolar-people-should-not-be-medicated/#,
    q#rindolf/#,
    q#humour/by-others/how-to-make-square-corners-with-CSS/#,
    q#philosophy/by-others/sscce/#,
    q#philosophy/case-for-file-swapping/case-for-file-swapping/#,
    q#philosophy/case-for-file-swapping/revision-2/#,
    (
        @{
            _individual_pages(
                {
                    paths => [
                        q#lecture/shlomif-cocktails/shlomif-cocktails#,
q#open-source/projects/Park-Lisp/park-lisp-informal-spec#,
q#philosophy/case-for-file-swapping/revision-3/case-for-file-swapping-rev3#,
q#philosophy/computers/education/introductory-language/introductory-language#,
q#philosophy/computers/high-quality-software/rev2/what-makes-software-high-quality-rev2#,
q#philosophy/computers/how-to-share-code-for-getting-help/how-to-share-code-online#,
q#philosophy/computers/open-source/foss-licences-wars/foss-licences-wars#,
q#philosophy/computers/open-source/foss-licences-wars/rev2/foss-licences-wars-rev2#,
q#philosophy/computers/software-management/end-of-it-slavery/end-of-it-slavery#,
q#philosophy/computers/software-management/perfect-workplace/perfect-it-workplace#,
q#philosophy/computers/software-management/perfect-workplace/v2/perfect-it-workplace-v2#,
q#philosophy/computers/web/validate-your-html/validate-your-html#,
q#philosophy/culture/multiverse-cosmology/multiverse-cosmology-v0.4.x#,
q#philosophy/culture/multiverse-cosmology/why-the-so-called-real-world-makes-little-sense/why-the-so-called-real-world-makes-little-sense#,
                        q#philosophy/fan-pages/samantha-smith/samsmith#,
q#philosophy/foss-other-beasts/version-3/foss-and-other-beasts-v3#,
                        q#philosophy/obj-oss/objectivism-and-open-source#,
                        q#philosophy/obj-oss/rev2/objectivism-and-open-source#,
q#philosophy/perl-newcomers/v1/usability-of-perl-world-for-newcomers#,
q#philosophy/psychology/hypomanias/dealing-with-hypomanias#
                    ],
                }
            )
        },
    ),
);

my $LAX_MODE = (
    ( ( $ENV{SKIP_SPELL_CHECK} // '' ) =~ m#(?:\A|,)en\:lax(?:,|\z)#ms )
    ? 1
    : 0
);
if ($LAX_MODE)
{
    push @prunes,
        (
        q#humour/fortunes/sharp-perl\.html#,
        q#humour/fortunes/sharp-programming\.html#,
        q#humour/fortunes/shlomif\.html#,
        q#lecture/C-and-CPP/bad-elements/c-and-cpp-elements-to-avoid/#,
q#open-source/projects/Spark/mission/Spark-Pre-Birth-of-a-Modern-Lisp/[a-zA-Z0-9\-_]*\.xhtml#,
q#philosophy/computers/high-quality-software/reflections-on-software-quality-trends/#,
        q#philosophy/fan-pages/samantha-smith/index\.xhtml#,
        );
}

my $PRUNE_RE_S = qq#\\A#
    . quotemeta($POST_DEST) . q#/(?:#
    . ( join "|", ( map { "(?:$_)" } @prunes ) ) . ")";
my $PRUNE_RE       = qr#$PRUNE_RE_S#;
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
                           ( $path =~ $PRUNE_RE )
                        || ( $path =~ $RAW_HTML_REGEX )
                        || ( $path =~ m#indiv-nodes/# )
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
