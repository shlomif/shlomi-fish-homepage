package MyNavData::Hosts;

use strict;
use warnings;

my $hosts = {
    t2 => {
        base_url => "http://www.shlomifish.org/",
    },
    vipe => {
        base_url => "http://www.shlomifish.org/Vipe/",
    },
};

sub get_hosts
{
    return $hosts;
}

1;
