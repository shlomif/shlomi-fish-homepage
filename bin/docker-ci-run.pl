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
    qw/ container package_manager_install_cmd setup_package_manager setup_script_cmd snapshot_names_base sys_deps /
] => ( is => 'ro', required => 1 );

package main;

my $NOSYNC  = "LD_PRELOAD=/usr/lib64/nosync/nosync.so";
my $EN      = "export $NOSYNC";
my $configs = {
    'debian:sid' => Docker::CLI::Wrapper::Container::Config->new(
        {
            container                   => "shlomi_fish_homesite_debian",
            package_manager_install_cmd =>
                "sudo eatmydata apt-get --no-install-recommends install -y",
            setup_package_manager => <<'EOF',
if false
then
    cat /etc/apt/sources.list
    sed -r -i -e 's#^(deb *)[^ ]+( *buster +main.*)$#\1http://mirror.isoc.org.il/pub/debian\2#' /etc/apt/sources.list
    cat /etc/apt/sources.list
fi
# exit 5
su -c "apt-get update"
su -c "apt-get -y install eatmydata netselect-apt sudo"
# sudo netselect-apt -c israel -t 3 -a amd64 # -n buster
sudo apt-get update -qq
EOF
            setup_script_cmd    => "true",
            snapshot_names_base => "shlomif/hpage_debian",
            sys_deps            => [

                # libpython3-all
                # myspell-hw
                qw/
                    build-essential
                    /,
            ],
        }
    ),
    'fedora:36' => Docker::CLI::Wrapper::Container::Config->new(
        {
            container                   => "shlomi_fish_homesite_fedora",
            package_manager_install_cmd => "$NOSYNC sudo dnf -y install",
            setup_package_manager       => "sudo dnf -y install nosync ; $EN ;",
            setup_script_cmd            => "$EN",
            snapshot_names_base         => "shlomif/hpage_fedora",
            sys_deps                    => [
                qw/
                /,
            ],
        }
    ),
};

sub run_config
{
    my ( $self, $args ) = @_;

    my $cleanrun   = $args->{cleanrun};
    my $force_load = $args->{force_load};
    my $sys        = $args->{sys};

    my $cfg = $configs->{$sys}
        or die "no $sys config";

    my $container                   = $cfg->container();
    my $package_manager_install_cmd = $cfg->package_manager_install_cmd();
    my $setup_package_manager       = $cfg->setup_package_manager();
    my $setup_script_cmd            = $cfg->setup_script_cmd();
    my $sys_deps                    = $cfg->sys_deps();
    my $snapshot_names_base         = $cfg->snapshot_names_base();

    my $obj = Docker::CLI::Wrapper::Container->new(
        { container => $container, sys => $sys, }, );

    my @deps = (
        sort { $a cmp $b } (
            qw/
                nodejs
                npm
                /,
            @$sys_deps,
        )
    );
    my @cpan_deps = (
        qw/
            App::Deps::Verify
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
        die "Must be run as \"$^X bin/docker-ci-run.pl\"!";
    }

    my $commit    = $snapshot_names_base . "_1";
    my $from_snap = 0;
    if ($cleanrun)
    {
        $obj->run_docker();
    }
    else
    {
        eval {
            my $snap_obj = Docker::CLI::Wrapper::Container->new(

                # { container => $commit, sys => $sys, },
                { container => $container, sys => $sys, },
            );
            $snap_obj->run_docker_commit( { label => $commit, } );
            $obj = $snap_obj;
        };
        if ($@)
        {
            if ($force_load)
            {
                die qq#could not load sys='$sys'!#;
            }

            $obj->clean_up();
            $obj->run_docker();
        }
        else
        {
            $from_snap = 1;
        }
    }
    my $temp_git_repo_path = "../temp-git";
    if ($from_snap)
    {
        # body...
    }
    else
    {
        # else...
        $obj->do_system( { cmd => [ "rm", "-fr", $temp_git_repo_path ] } );
        $obj->do_system(
            { cmd => [ 'git', 'clone', '.', $temp_git_repo_path ] } );
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
    my $script = <<"EOSCRIPTTTTTTT";
set -e -x
export LC_ALL=en_US.UTF-8
export LANG="\$LC_ALL"
export LANGUAGE="en_US:en"
mv /temp-git ~/source
true || ls -lR /root
$setup_package_manager
cd ~/source
if false
then
    $package_manager_install_cmd glibc-langpack-en glibc-locale-source
    # localedef --verbose --force -i en_US -f UTF-8 en_US.UTF-8
    localedef --force -i en_US -f UTF-8 en_US.UTF-8
fi
$package_manager_install_cmd @deps
sudo ln -sf /usr/bin/make /usr/bin/gmake
EOSCRIPTTTTTTT

    if ($from_snap)
    {
        # body...
    }
    else
    {
        $obj->exe_bash_code( { code => $script, } );
        if ( not $cleanrun )
        {
            $obj->commit( { label => $commit, } );
        }
    }

    $script = <<"EOSCRIPTTTTTTT";
set -e -x
$setup_script_cmd
cd ~/source
pwd
ls -l
ls -l bin/ || true
bash -x bin/install-npm-deps.sh
EOSCRIPTTTTTTT
    $obj->exe_bash_code( { code => $script, } );

    # $obj->clean_up();
    return;
}

use Getopt::Long qw/ GetOptions /;

my $output_fn;
my $force_load;
my $cleanrun;
GetOptions(
    "cleanrun!"   => \$cleanrun,
    "force-load!" => \$force_load,
    "output|o=s"  => \$output_fn,
) or die $!;

# foreach my $sys ( grep { /debian/ } sort { $a cmp $b } ( keys %$configs ) )
foreach my $sys ( grep { /debian/ } sort { $a cmp $b } ( keys %$configs ) )
{
    __PACKAGE__->run_config(
        {
            cleanrun   => $cleanrun,
            force_load => $force_load,
            sys        => $sys,
        }
    );
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
