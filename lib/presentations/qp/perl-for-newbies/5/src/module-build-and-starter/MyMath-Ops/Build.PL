use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MyMath::Ops',
    license             => 'perl',
    dist_author         => q{Perl Newbie <perl-newbie@perl-begin.org>},
    dist_version_from   => 'lib/MyMath/Ops.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'MyMath::Ops-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
