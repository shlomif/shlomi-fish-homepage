package Shlomif::Homepage::NavData::JSON;

use strict;
use warnings;

use MyNavData;

use JSON qw(encode_json);

sub output_fully_expanded_as_json
{
    my $class = shift;

    my %params =
    MyNavData->generic_get_params(
        {
            fully_expanded => 1,
        },
    );

    my $filter_out_seperators;

    $filter_out_seperators = sub {
        my ($sub_tree) = @_;

        my @keys = (grep { $_ ne 'subs' } keys %{$sub_tree});

        my $has_subs = exists($sub_tree->{subs});

        return {
            (map { $_ => $sub_tree->{$_} } @keys),
            $has_subs
            ?  (subs => [ map { $filter_out_seperators->($_) }
                    grep { ! exists($_->{separator}) }
                    @{$sub_tree->{subs}}
                ])
            : (),
        },
    };

    return encode_json($filter_out_seperators->($params{tree_contents})->{'subs'});
}

1;
