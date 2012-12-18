package Shlomif::Homepage::NavData::JSON;

use strict;
use warnings;

use MyNavData;

use JSON qw(encode_json);
use YAML::Syck ();

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

    my ($id_persistence) = YAML::Syck::LoadFile($id_persistence_filename);

    $id_persistence ||= {
        id_persistence => { next_id => 1, paths_ids => { }, },
    };

    my $ptr = $id_persistence->{id_persistence};

    my $get_id_from_cache = sub
    {
        my $url = shift;
        if (! exists($ptr->{paths_ids}->{$url}))
        {
            $ptr->{paths_ids}->{$url} = ($ptr->{next_id}++);
        }
        return $ptr->{paths_ids}->{$url};
    };

    my $process_sub_tree;

    $process_sub_tree = sub
    {
        my ($sub_tree) = @_;

        my @keys = (grep { $_ ne 'subs' } keys %{$sub_tree});

        my $has_subs = exists($sub_tree->{subs});

        return
        {
            (exists($sub_tree->{url})
                ? (id => $get_id_from_cache->($sub_tree->{url}))
                : ()
            ),
            (map { $_ => $sub_tree->{$_} } @keys),
            $has_subs
            ?  (subs => [ map { $process_sub_tree->($_) }
                    grep { ! exists($_->{separator}) }
                    @{$sub_tree->{subs}}
                ])
            : (),
        };
    };

    my $ret = encode_json(
        $process_sub_tree->($params{tree_contents})->{'subs'}
    );

    YAML::Syck::DumpFile(
        $id_persistence_filename, $id_persistence,
    );

    return $ret;
}

1;
