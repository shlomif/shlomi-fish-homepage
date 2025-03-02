#! /usr/bin/env perl

use strict;
use warnings;
use 5.014;
use autodie;

use Carp::Always;

use Docker::CLI::Wrapper::Container v0.0.4 ();

package Docker::CLI::Wrapper::Container::Config;

use Moo;

has [
    qw/ container install_langpack package_manager_install_cmd setup_package_manager setup_script_cmd sys_deps /
] => ( is => 'ro', required => 1 );

package main;

my $NOSYNC  = "LD_PRELOAD=/usr/lib64/nosync/nosync.so";
my $EN      = "export $NOSYNC";
my $configs = {
    'fedora:41' => Docker::CLI::Wrapper::Container::Config->new(
        {
            container                   => "shlomi_fish_homesite_fedora",
            install_langpack            => "true",
            package_manager_install_cmd => "$NOSYNC sudo dnf -y install",

            setup_package_manager => "sudo dnf -y install nosync ; $EN ;",
            setup_script_cmd      => "$EN",
            sys_deps              => [
                qw/
                    perl
                    /,
            ],
        }
    ),
};

sub run_config
{
    my ( $self, $args ) = @_;

    my $cleanup = $args->{cleanup};
    my $sys     = $args->{sys};

    my $cfg = $configs->{$sys}
        or die "no $sys config";

    my $container                   = $cfg->container();
    my $install_langpack            = $cfg->install_langpack();
    my $package_manager_install_cmd = $cfg->package_manager_install_cmd();
    my $setup_package_manager       = $cfg->setup_package_manager();
    my $setup_script_cmd            = $cfg->setup_script_cmd();
    my $sys_deps                    = $cfg->sys_deps();

    my $obj = Docker::CLI::Wrapper::Container->new(
        { container => $container, sys => $sys, }, );

    if ( -f "/etc/fedora-release" )
    {
        @{ $obj->docker_cmd_line_prefix } = (
            @{ $obj->docker_cmd_line_prefix },
            "--cgroup-manager", "cgroupfs",
        );
    }

    my @deps = (
        sort { $a cmp $b } (
            qw/
                git
                nodejs
                npm
                /,
            @$sys_deps,
        )
    );

    if (
        not(    -d "./.git"
            and -d "./bin"
            and -f "./Tests/gmake-unit.t" )
        )
    {
        die "Must be run as \"$^X bin/docker-ci-run.pl\"!";
    }

    $obj->clean_up();
    $obj->run_docker();
    my $temp_git_repo_path = "../temp-git";
    {
        # else...
        $obj->do_system( { cmd => [ "rm", "-fr", $temp_git_repo_path ] } );
        $obj->do_system(
            {
                cmd => [
                    'git',                  'clone',
                    '--recurse-submodules', '.',
                    $temp_git_repo_path
                ]
            }
        );
        $obj->do_system(
            {
                cmd => [
qq#find lib -name .git | xargs dirname | perl -lnE 'system(qq[d=../temp-git/\$_ ; if test -d \\\$d ; then exit 0 ; fi ; mkdir -p `dirname \\\$d` ;cp -a \$_/ ../temp-git/\$_]);'
#,
                ]
            }
        );

        $obj->docker(
            {
                cmd => [
                    'cp',
                    ( $temp_git_repo_path . "" ),
                    ( $obj->container() . ":/temp-git" ),
                ]
            }
        );
    }
    $obj->exe_bash_code( { code => "mkdir -p /temp-git", } );
    my $locale = <<"EOSCRIPTTTTTTT";
export LC_ALL=en_US.UTF-8
export LANG="\$LC_ALL"
export LANGUAGE="en_US:en"
EOSCRIPTTTTTTT

    my $script = <<"EOSCRIPTTTTTTT";
set -e -x
$locale
mv /temp-git ~/source
true || ls -lR /root
$setup_package_manager
cd ~/source
if $install_langpack
then
    $package_manager_install_cmd glibc-langpack-en glibc-locale-source
    # localedef --verbose --force -i en_US -f UTF-8 en_US.UTF-8
    # localedef --force -i en_US -f UTF-8 en_US.UTF-8
fi
$package_manager_install_cmd @deps
EOSCRIPTTTTTTT

    $obj->exe_bash_code( { code => $script, } );

    $script = <<"EOSCRIPTTTTTTT";
set -e -x
$locale
$setup_script_cmd
cd ~/source
bash -x bin/install-npm-deps.sh
EOSCRIPTTTTTTT
    $obj->exe_bash_code( { code => $script, } );

    # Shutting down is important as otherwise the VM continues to run
    # in the background, and consume CPU and RAM, and slow down the subsequent
    # runs.
    $obj->clean_up();

    return;
}

my $cleanup;

# enable hires wallclock timing if possible
use Benchmark ':hireswallclock';

my %times;

my @systems_names = ( sort { $a cmp $b } ( keys %$configs ) );
SYSTEMS:
foreach my $sys (@systems_names)
{
    $times{$sys} = timeit(
        1,
        sub {
            __PACKAGE__->run_config(
                {
                    cleanup => $cleanup,
                    sys     => $sys,
                }
            );
            return;
        }
    );
}

TIMES:
foreach my $sys (@systems_names)
{
    print $sys, ": ", timestr( $times{$sys} ), "\n";
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
