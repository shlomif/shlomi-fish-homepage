#! /usr/bin/env perl

use strict;
use warnings;
use 5.014;
use autodie;

use Carp::Always;

use Docker::CLI::Wrapper::Container v0.0.4 ();

package Docker::CLI::Wrapper::Container;

sub commit
{
    my ( $self, $args ) = @_;

    $self->docker(
        { cmd => [ 'commit', $self->container(), $args->{label}, ] } );

    return;
}

sub run_docker_commit
{
    my ( $self, $args ) = @_;

    $self->docker(
        {
            cmd => [ 'run', "-d", $args->{label}, ],
        }
    );

    return;
}

package Docker::CLI::Wrapper::Container::Config;

use Moo;

has [
    qw/ container install_langpack package_manager_install_cmd pip_options setup_package_manager setup_script_cmd snapshot_names_base sys_deps /
] => ( is => 'ro', required => 1 );

package main;

my $NOSYNC  = "LD_PRELOAD=/usr/lib64/nosync/nosync.so";
my $EN      = "export $NOSYNC";
my $configs = {
    'debian:sid' => Docker::CLI::Wrapper::Container::Config->new(
        {
            container                   => "shlomi_fish_homesite_debian",
            install_langpack            => "false",
            package_manager_install_cmd =>
                "sudo eatmydata apt-get --no-install-recommends install -y",
            pip_options           => "--break-system-packages",
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
                    cookiecutter
                    graphicsmagick
                    hspell
                    hunspell-en-gb
                    libdb5.3-dev
                    libdbd-sqlite3-perl
                    libexpat1-dev
                    libgd-dev
                    libgdbm-compat-dev
                    libgdbm-dev
                    libgmp-dev
                    libhunspell-dev
                    libncurses-dev
                    libpcre2-dev
                    libpcre3-dev
                    libperl-dev
                    libprimesieve-dev
                    libpython3-dev
                    libxml2-dev
                    lynx
                    perl
                    pysassc
                    python3
                    python3-all
                    python3-dev
                    python3-venv
                    python3-virtualenv
                    ruby-dev
                    ruby-rspec
                    silversearcher-ag
                    txt2html
                    vim
                    xsltproc
                    xz-utils
                    zip
                    /,
            ],
        }
    ),
    'fedora:39' => Docker::CLI::Wrapper::Container::Config->new(
        {
            container                   => "shlomi_fish_homesite_fedora",
            install_langpack            => "true",
            package_manager_install_cmd => "$NOSYNC sudo dnf -y install",

            # pip_options                 => "--break-system-packages",
            pip_options           => "",
            setup_package_manager => "sudo dnf -y install nosync ; $EN ;",
            setup_script_cmd      => "$EN",
            snapshot_names_base   => "shlomif/hpage_fedora",
            sys_deps              => [
                qw/
                    GraphicsMagick
                    docbook-dtds
                    docbook-style-xsl
                    docbook5-style-xsl
                    gd-devel
                    gdbm-devel
                    gmp-devel
                    hspell-devel
                    libdb-devel
                    libxml2-devel
                    libxslt
                    libxslt-devel
                    ncurses-devel
                    pcre-devel
                    perl-DBD-SQLite
                    perl-Inline-Python
                    perl-XML-Parser
                    perl-generators
                    primesieve-devel
                    python3
                    python3-devel
                    python3-libsass
                    ruby-devel
                    rubygem-nokogiri
                    rubygem-rexml
                    rubygem-rspec
                    sgml-common
                    the_silver_searcher
                    vim
                    virtualenv
                    which
                    xz
                    /,
            ],
        }
    ),
};

sub run_config
{
    my ( $self, $args ) = @_;

    my $cleanrun   = $args->{cleanrun};
    my $cleanup    = $args->{cleanup};
    my $force_load = $args->{force_load};
    my $sys        = $args->{sys};

    my $cfg = $configs->{$sys}
        or die "no $sys config";

    my $container                   = $cfg->container();
    my $install_langpack            = $cfg->install_langpack();
    my $package_manager_install_cmd = $cfg->package_manager_install_cmd();
    my $pip_options                 = $cfg->pip_options();
    my $setup_package_manager       = $cfg->setup_package_manager();
    my $setup_script_cmd            = $cfg->setup_script_cmd();
    my $sys_deps                    = $cfg->sys_deps();
    my $snapshot_names_base         = $cfg->snapshot_names_base();

    my $obj = Docker::CLI::Wrapper::Container->new(
        { container => $container, sys => $sys, }, );

    my @deps = (
        sort { $a cmp $b } (
            qw/
                cmake
                cmake-data
                cpanminus
                cppcheck
                expat
                fortune-mod
                hunspell
                g++
                gcc
                git
                golang
                inkscape
                lynx
                make
                nodejs
                npm
                optipng
                primesieve
                pypy3
                python3
                python3-cookiecutter
                python3-pip
                python3-setuptools
                python3-virtualenv
                rsync
                ruby
                tidy
                virtualenv
                zip
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
        $obj->clean_up();
        if ($cleanup)
        {
            die "doing only --cleanup!";
        }
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
        my $suf = '--clones';
        $obj->docker(
            {
                cmd => [
                    'cp',
                    ( "../trunk" . $suf . "" ),
                    ( $obj->container() . ":/temp-git" . $suf ),
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
mv /temp-git--clones ~/source--clones
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
$locale
$setup_script_cmd
pydeps="beautifulsoup4 bs4 click cookiecutter cssselect lxml pycotap rebookmaker vnu_validator weasyprint zenfilter Pillow WebTest"
sudo -H bash -c "$setup_script_cmd ; `which python3` -m pip install $pip_options \$pydeps"
# cpanm -vvv IO::Async
cpanm --notest IO::Async
cpanm --notest App::Deps::Verify App::XML::DocBook::Builder Pod::Xhtml
cpanm --notest HTML::T5
# For wml
cpanm --notest Bit::Vector Carp::Always Class::XSAccessor GD Getopt::Long IO::All Image::Size List::MoreUtils Path::Tiny Term::ReadKey
# For quadp
cpanm --notest Class::XSAccessor Config::IniFiles HTML::Links::Localize
sudo bash -c "$setup_script_cmd ; cpanm --notest @cpan_deps"
sudo cpanm --notest https://salsa.debian.org/reproducible-builds/strip-nondeterminism.git
cd ~/source
pwd
ls -l
ls -l bin/ || true
perl bin/my-cookiecutter.pl
deps-app plinst --notest -i bin/common-required-deps.yml -i bin/required-modules.yml
gem install asciidoctor compass compass-blueprint
PATH="\$HOME/bin:\$PATH"
( cd .. && git clone https://github.com/thewml/wml-extended-apis.git && cd wml-extended-apis/xhtml/1.x && bash Install.bash )
( cd .. && git clone https://github.com/thewml/latemp.git && cd latemp/support-headers && perl install.pl )
( cd .. && git clone https://github.com/shlomif/wml-affiliations.git && cd wml-affiliations/wml && bash Install.bash )
bash -x bin/install-npm-deps.sh
bash bin/install-git-cmakey-program-system-wide.bash 'git' 'installer' 'https://github.com/shlomif/quad-pres'
bash bin/install-git-cmakey-program-system-wide.bash 'git' 'src' 'https://github.com/thewml/website-meta-language.git'
bash bin/install-git-cmakey-program-system-wide.bash 'git' 'installer' 'https://github.com/thewml/latemp.git'
echo '{"amazon_sak":"invalid"}' > "\$HOME"/.shlomifish-amazon-sak.json
( cd "\$HOME" && git clone https://github.com/w3c/markup-validator.git )
pwd
echo "HOME=\$HOME"
if false
then
    virtualenv -p `which pypy3` /pypyenv
    source /pypyenv/bin/activate
else
    virtualenv -p `which python3` /python_3_env
    source /python_3_env/bin/activate
fi

`which python3` -m pip install \$pydeps
export LD_LIBRARY_PATH="/usr/local/lib:\$LD_LIBRARY_PATH"
cmake_build_is_already_part_of_test_sh='true'
if test "\$cmake_build_is_already_part_of_test_sh" != "true"
then
    true # bash -c "mkdir b ; cd b ; make && cd .. && rm -fr b"
fi
if true
then
    a="`pwd`"
    mkdir -p \$HOME/src
    cd \$HOME/src
    git clone https://github.com/tdewolff/minify.git
    cd minify
    make install
    cd "\$a"
else
    gourl="github.com/tdewolff/minify/cmd/minify"
    # go mod init
    go mod init shlomifish.org/golang/m
    if ! go get -u "\$gourl"
    then
        go install "\$gourl\@latest"
    fi
fi
find / -name minify | perl -lpE '\$_ = "find-result=(\$_)"'
PATH="\$PATH:\$HOME/go/bin"
_local_dbtoepubdir="`pwd`/lib/repos/xslt10-stylesheets/xsl/epub/bin"
_local_dbtoepub="\${_local_dbtoepubdir}/dbtoepub"
if test -e "\$_local_dbtoepub"
then
    export DBTOEPUB="/usr/bin/ruby \$_local_dbtoepub"
    PATH="\$PATH:\${_local_dbtoepubdir}"
elif test -x /usr/bin/dbtoepub
then
    export DBTOEPUB="/usr/bin/ruby \$(which dbtoepub)"
fi
which dbtoepub
# bash bin/rebuild
TIDYALL_DATA_DIR="\$HOME/tidyall_d" bash -x bin/run-ci-build.bash
EOSCRIPTTTTTTT
    $obj->exe_bash_code( { code => $script, } );

    # $obj->clean_up();
    return;
}

use Getopt::Long qw/ GetOptions /;

my $output_fn;
my $force_load;
my $cleanrun;
my $cleanup;
GetOptions(
    "cleanrun!"   => \$cleanrun,
    "cleanup!"    => \$cleanup,
    "force-load!" => \$force_load,
    "output|o=s"  => \$output_fn,
) or die $!;

# foreach my $sys ( grep { /debian/ } sort { $a cmp $b } ( keys %$configs ) )
foreach my $sys ( grep { /fedora/ } sort { $a cmp $b } ( keys %$configs ) )
{
    __PACKAGE__->run_config(
        {
            cleanrun   => $cleanrun,
            cleanup    => $cleanup,
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
