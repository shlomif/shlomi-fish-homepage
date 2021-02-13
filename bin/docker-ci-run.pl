#! /usr/bin/env perl

use strict;
use warnings;
use 5.014;
use autodie;

use Docker::CLI::Wrapper::Container v0.0.4 ();

package Docker::CLI::Wrapper::Container::Config;

use Moo;

has [
    qw/ container package_manager_install_cmd setup_package_manager sys_deps /]
    => ( is => 'ro', required => 1 );

package main;

my $configs = {
    'debian:10' => Docker::CLI::Wrapper::Container::Config->new(
        {
            container                   => "shlomi_fish_homesite_deb10",
            package_manager_install_cmd =>
                "sudo eatmydata apt-get --no-install-recommends install -y",
            setup_package_manager => <<'EOF',
sed -r -i -e 's#^(deb )[^ ]+( +buster main.*)\$#\\1http://mirror.isoc.org.il/pub/debian/\\2#' /etc/apt/sources.list
su -c "apt-get update"
su -c "apt-get -y install eatmydata sudo"
sudo apt-get update -qq
EOF
            sys_deps => [
                qw/
                    libgmp-dev
                    libprimesieve-dev
                    ruby-rspec
                    python3-virtualenv
                    python3-venv
                    /,
            ],
        }
    ),
    'fedora:33' => Docker::CLI::Wrapper::Container::Config->new(
        {
            container                   => "shlomi_fish_homesite_fedora33",
            package_manager_install_cmd => "sudo dnf -y install",
            setup_package_manager       => '',
            sys_deps                    => [
                qw/ gmp-devel primesieve-devel rubygem-rspec virtualenv which/,
            ],
        }
    ),
};

sub run_config
{
    my ( $self, $sys ) = @_;

    my $cfg = $configs->{$sys}
        or die "no $sys config";

    my $container                   = $cfg->container();
    my $package_manager_install_cmd = $cfg->package_manager_install_cmd();
    my $setup_package_manager       = $cfg->setup_package_manager();
    my $sys_deps                    = $cfg->sys_deps();

    my $obj = Docker::CLI::Wrapper::Container->new(
        { container => $container, sys => $sys, },
    );

    my @deps = (
        sort { $a cmp $b } (
            qw/
                cmake
                cmake-data
                cpanminus
                cppcheck
                g++
                gcc
                git
                make
                nodejs
                npm
                primesieve
                pypy3
                python3
                python3-cookiecutter
                python3-pip
                python3-setuptools
                python3-virtualenv
                ruby
                virtualenv
                /,
            @$sys_deps,
        )
    );
    my @cpan_deps = (
        qw/
            Carp::Always
            File::Which
            IO::All
            List::MoreUtils
            Math::BigInt::GMP
            Math::GMP
            MooX
            MooX::late
            Path::Tiny
            String::ShellQuote
            Test::Code::TidyAll
            Test::Differences
            Test::File::IsSorted
            Test::PerlTidy
            Test::TrailingSpace
            Tree::AVL
            /
    );

    if (
        not(    -d "./.git"
            and -d "./bin"
            and -f "./Tests/gmake-unit.t" )
        )
    {
        die "Must be run as \"$^X util-code/docker-ci-run.pl\"!";
    }

    $obj->clean_up();
    $obj->run_docker();
    $obj->do_system( { cmd => [ "rm", "-fr", "./temp-git" ] } );
    $obj->do_system( { cmd => [ 'git', 'clone', '.', "./temp-git" ] } );
    $obj->docker(
        { cmd => [ 'cp', "./temp-git", $obj->container() . ":source", ] } );
    my $script = <<"EOSCRIPTTTTTTT";
set -e -x
$setup_package_manager
cd source
$package_manager_install_cmd @deps
sudo ln -sf /usr/bin/make /usr/bin/gmake
if false
then
    git clone https://github.com/kimwalisch/primesieve
    cd primesieve
    cmake .
    make -j2
    sudo make install
    cd ..
    rm -fr primesieve
fi
sudo cpanm --notest @cpan_deps
virtualenv -p `which pypy3` /pypyenv
source /pypyenv/bin/activate
pydeps="flake8 six"
`which python3` -m pip install \$pydeps
export LD_LIBRARY_PATH="/usr/local/lib:\$LD_LIBRARY_PATH"
cmake_build_is_already_part_of_test_sh='true'
if test "\$cmake_build_is_already_part_of_test_sh" != "true"
then
    true # bash -c "mkdir b ; cd b ; make && cd .. && rm -fr b"
fi
bash bin/rebuild
EOSCRIPTTTTTTT

    $obj->exe_bash_code( { code => $script, } );
    $obj->clean_up();
    return;
}

foreach my $sys ( grep { /fedora/ } sort { $a cmp $b } ( keys %$configs ) )
{
    __PACKAGE__->run_config($sys);
}

print "Success!\n";
exit(0);

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2019 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
