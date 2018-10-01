#! /bin/bash
#
# .travis.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
set -e
set -x
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
    sudo apt-get update -qq
    sudo apt-get --no-install-recommends install -y ack-grep asciidoc build-essential cmake cpanminus dbtoepub docbook-defguide docbook-xsl docbook-xsl-ns fortune-mod hunspell inkscape myspell-en-gb libdb5.3-dev libgd-dev libhunspell-dev libncurses-dev libpcre3-dev libperl-dev libxml2-dev mercurial myspell-en-gb lynx optipng perl python3 python3-setuptools python3-pip silversearcher-ag tidy valgrind wml xsltproc xz-utils zip
    sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
    cpanm local::lib

elif test "$cmd" = "install"
then
    cpanm --notest Alien::Tidyp YAML::XS
    bash -x bin/install-tidyp-systemwide.bash
    cpanm --notest HTML::Tidy
    h=~/Docs/homepage/homepage
    mkdir -p "$h"
    git clone https://github.com/shlomif/shlomi-fish-homepage "$h/trunk"

elif test "$cmd" = "build"
then
    export SCREENPLAY_COMMON_INC_DIR="$PWD/screenplays-common"
    cd .
    m()
    {
        make DBTOEPUB="/usr/bin/ruby $(which dbtoepub)" \
            DOCBOOK5_XSL_STYLESHEETS_PATH=/usr/share/xml/docbook/stylesheet/docbook-xsl-ns \
        "$@"
    }
    m
    m test
fi
