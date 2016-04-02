#!/bin/bash

set -x

export XML_CATALOG_FILES="/etc/xml/catalog $(pwd)/markup-validator/htdocs/sgml-lib/catalog.xml"

m()
{
    make DBTOEPUB="/usr/bin/ruby $(which dbtoepub)" \
        DOCBOOK5_XSL_STYLESHEETS_PATH=/usr/share/xml/docbook/stylesheet/docbook-xsl-ns \
    "$@"
}

if ./gen-helpers.pl && m && m test ; then
    echo $'\n\n\nSuccess\n\n\n'
else
    echo "Error in executing the main build script." 1>&2
    exit -1
fi
