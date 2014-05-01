package Shlomif::Homepage::NavData::JSON;

use strict;
use warnings;

use MyNavData;

use HTML::Widgets::NavMenu::ToJSON;
use HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML;

sub output_fully_expanded_as_json
{
    my $class = shift;

    my %params =
    MyNavData->generic_get_params(
        {
            fully_expanded => 1,
        },
    );

    my $id_persistence_filename =
        File::Spec->catfile(
            File::Spec->curdir(),
            'lib', 'Shlomif', 'Homepage', 'NavData',
            'JSON_Data_Persistence.yml',
        );

    my $persistence =
        HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML->new(
            {
                filename => $id_persistence_filename,
            }
        );

    return HTML::Widgets::NavMenu::ToJSON->new(
        {
            data_persistence_store => $persistence,
            tree_contents => $params{tree_contents},
        }
    )->output_as_json();
}

1;
