package Shlomif::Homepage::NavData::JSON;

use strict;
use warnings;

use JSON::MaybeXS qw( decode_json );
use Path::Tiny qw/ path /;

use MyNavData;

use HTML::Widgets::NavMenu::ToJSON;
use HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML;

use Shlomif::Homepage::Paths;

my $T2_DEST       = Shlomif::Homepage::Paths->new->t2_dest;
my %keys_briefing = (
    subs   => 's',
    id     => 'i',
    title  => 't',
    url    => 'u',
    text   => 'x',
    expand => 'e',
    re     => 'r',
    skip   => 's',
    bool   => 'b',
    host   => 'h',
    capt   => 'c',
);

sub _map_data
{
    my ($thing) = @_;

    if ( ref $thing eq '' )
    {
        return $thing;
    }
    if ( ref $thing eq 'ARRAY' )
    {
        return [ map { _map_data($_) } @$thing ];
    }
    if ( ref $thing eq 'HASH' )
    {
        return +{
            map {
                my $k = $_;
                exists( $keys_briefing{$k} )
                    ? ( $keys_briefing{$k} => _map_data( $thing->{$k} ) )
                    : ( die "Unknown key $k" );
                }
                keys(%$thing)
        };
    }
    die "Ref == " . ref($thing);
}

sub output_fully_expanded_as_json
{
    my $class = shift;

    my %params = MyNavData->generic_get_params(
        {
            fully_expanded => 1,
        },
    );

    my $id_persistence_filename = File::Spec->catfile(
        File::Spec->curdir(), 'lib',
        'Shlomif',            'Homepage',
        'NavData',            'JSON_Data_Persistence.yml',
    );

    my $persistence =
        HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML->new(
        {
            filename => $id_persistence_filename,
        }
        );

    my $verbose_keys_json = HTML::Widgets::NavMenu::ToJSON->new(
        {
            data_persistence_store => $persistence,
            tree_contents          => $params{tree_contents},
        }
    )->output_as_json();

    my $verbose_keys_data = decode_json($verbose_keys_json);

    my $brief_keys_data = _map_data($verbose_keys_data);

    my $brief_keys_json = JSON::MaybeXS->new( utf8 => 1, canonical => 1 )
        ->encode($brief_keys_data);

    path("$T2_DEST/_data/n.json")->spew($brief_keys_json);

    return $verbose_keys_json;
}

1;
