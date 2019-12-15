#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import sys

from lxml import etree
from lxml.html import XHTML_NAMESPACE

XHTML_NS = XHTML_NAMESPACE
XML_NS = "{http://www.w3.org/XML/1998/namespace}"
DOCBOOK5_NS = "http://docbook.org/ns/docbook"
XLINK_NS = "http://www.w3.org/1999/xlink"
ns = {
    "db": DOCBOOK5_NS,
    "xhtml": XHTML_NS,
    "xlink": XLINK_NS,
    "xml": XML_NS,
}


class Docbook5AddHomepage:
    def __init__(self, input_fn):
        self.input_fn = input_fn
        self.root = etree.parse(input_fn)

    def process(self):
        def xpath(node, query):
            return node.xpath(query, namespaces=ns)

        def first(node, query):
            return xpath(node, query)[0]
        author = first(
            self.root,
            "db:info/db:author")
        if not len(xpath(author, "./db:affiliation")):
            e1 = etree.Element("{"+DOCBOOK5_NS+"}affiliation")
            e2 = etree.Element("{"+DOCBOOK5_NS+"}address")
            new_elem = etree.Element(
                    "uri", type="homepage",
            )
            new_elem.set("{"+XLINK_NS+"}href", "https://www.shlomifish.org/")
            new_elem.text = "Shlomi Fish’s Homepage"
            e2.append(new_elem)
            e1.append(e2)
            author.append(e1)
        self.root.write(self.input_fn)


def main(fn):
    splitter = Docbook5AddHomepage(fn)
    splitter.process()


if __name__ == '__main__':
    main(sys.argv[1])
