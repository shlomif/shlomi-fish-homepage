package Shlomif::Homepage::LongStories;

use strict;
use warnings;

use utf8;

use Shlomif::WrapAsUtf8 qw(_wrap_as_utf8);

use Shlomif::Homepage::LongStories::Story;

use parent ('Exporter');

our @EXPORT_OK = (qw(
    get_nav_block
));

my @_Stories =
(
    map { Shlomif::Homepage::LongStories::Story->new($_) }
    (
        {
            id => 'tow_the_fountainhead',
            tagline => "<i>The Fountainhead</i> may have been good enough in the 60’s, but we’re in the Information Age now",
        },
        {
            id => 'hhfg',
            tagline => "Who said girls can’t code?",
        },
        {
            id => 'we_the_living_dead',
            tagline => "From perfection to imperfection; from finity to infinity" ,
        },
        {
            id => 'selina_mandrake',
            tagline => "Caught between Post-modernism and the New Age",
        },
        {
            id => 'summerschool_at_the_nsa',
            tagline => "As the sling shoots, grown men will cry",
        },
        {
            id => 'buffy_a_few_good_slayers',
            tagline => "I learned more from my students than I have from my teachers." ,
        },
        {
            id => 'who_is_qoheleth',
            tagline => "What had been, is what will be. There is nothing new under the sun." ,
        },
        {
            id => 'muppets_show_tni',
            tagline => "Muppets!" ,
        },

    )
);

my %_Stories_by_id = (map { $_->id() => $_ } @_Stories);

sub get_tagline
{
    my ($class, $id) = @_;

    return $_Stories_by_id{$id}->tagline;
}

sub render_tagline
{
    my ($class, $id) = @_;

    _wrap_as_utf8 (sub {
            print qq#<h2 id="tagline">@{[$class->get_tagline($id)]}</h2>\n#;
        },
    );

    return;
}
1;

