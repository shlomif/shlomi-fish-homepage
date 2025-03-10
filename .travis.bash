#! /bin/bash
#
# .travis.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
set -e
set -x
# export PERL_CPANM_OPT="-v"
arg_name="$1"
shift
if test "$arg_name" != "--cmd"
then
    echo "usage : $0 --cmd [cmd]"
    exit -1
fi
cmd="$1"
shift
if false
then
    :

elif test "$cmd" = "before_install"
then

    if test -e /etc/lsb-release
    then
        . /etc/lsb-release
        sudo add-apt-repository -y ppa:inkscape.dev/stable
        sudo apt -q update
        sudo apt -y install inkscape
    fi
    cpanm --local-lib=~/perl_modules local::lib
    if test "$DISTRIB_ID" = 'Ubuntu'
    then
        if test "$DISTRIB_RELEASE" = '14.04'
        then
            sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
        fi
        eval "$(GIMME_GO_VERSION=1.16 gimme)"
    elif test -e /etc/fedora-release
    then
        sudo dnf --color=never install -y hspell-devel perl-devel ruby-devel
    fi
    eval "$(GIMME_GO_VERSION=1.16 gimme)"
    (
        _minify_fallback()
        {
            sudo ln -s /bin/true /usr/bin/minify
        }
        mkdir -p $HOME/src
        cd $HOME/src
        git clone https://github.com/tdewolff/minify.git
        (
            cd minify
            make SHELL=/bin/bash install || _minify_fallback
        )
        rm -fr minify
    )
    which minify
    eval "$(perl -I ~/perl_modules/lib/perl5 -Mlocal::lib=$HOME/perl_modules)"
    PERL_CPANM_OPT+=" --quiet "
    export PERL_CPANM_OPT
    cpanm -v --notest IO::Async
    cpanm --notest App::Deps::Verify App::XML::DocBook::Builder Pod::Xhtml
    export CPATH="${CPATH}:/usr/include/tidy"
    cpanm HTML::T5
    # For wml
    cpanm --notest Bit::Vector Carp::Always Class::XSAccessor GD Getopt::Long Image::Size List::MoreUtils Path::Tiny Term::ReadKey
    # For quadp
    cpanm --notest Class::XSAccessor Config::IniFiles HTML::Links::Localize
    bash bin/install-git-cmakey-program-system-wide.bash 'git' 'src' 'https://github.com/thewml/website-meta-language.git'
    bash bin/install-git-cmakey-program-system-wide.bash 'git' 'installer' 'https://github.com/thewml/latemp.git'
    sudo -H `which python3` -m pip install Pillow WebTest appdirs beautifulsoup4 bottle bs4 click cookiecutter cssselect lxml numpy pycotap rebookmaker scour soupsieve vnu_validator weasyprint webtest zenfilter
    perl bin/my-cookiecutter.pl
    # For various sites
    cpanm --notest HTML::Toc XML::Feed
    deps-app plinst --notest -i bin/common-required-deps.yml -i bin/required-modules.yml
    gem install asciidoctor compass compass-blueprint rexml
    PATH="$HOME/bin:$PATH"
    ( cd .. && git clone https://github.com/thewml/wml-extended-apis.git && cd wml-extended-apis/xhtml/1.x && bash Install.bash )
    ( cd .. && git clone https://github.com/thewml/latemp.git && cd latemp/support-headers && perl install.pl )
    ( cd .. && git clone https://github.com/shlomif/wml-affiliations.git && cd wml-affiliations/wml && bash Install.bash )
    bash -x bin/install-npm-deps.sh
    bash bin/install-git-cmakey-program-system-wide.bash 'git' 'installer' 'https://github.com/shlomif/quad-pres'
    echo '{"amazon_sak":"invalid"}' > "$HOME"/.shlomifish-amazon-sak.json
    ( cd "$HOME" && git clone https://github.com/w3c/markup-validator.git )
    pwd
    echo "HOME=$HOME"
    bash -x bin/install-npm-deps.sh
    if ! test -e /usr/bin/gmake
    then
        sudo ln -s /usr/bin/make /usr/bin/gmake
    fi



elif test "$cmd" = "build"
then
    export SCREENPLAY_COMMON_INC_DIR="$PWD/screenplays-common"
    cd .
    m()
    {
        make DBTOEPUB="${DBTOEPUB:-/usr/bin/ruby $(which dbtoepub)}" \
            DOCBOOK5_XSL_STYLESHEETS_PATH=/usr/share/xml/docbook/stylesheet/docbook-xsl-ns \
        "$@"
    }
    m
    m test
fi
