#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""
Merge / propagate recent items from the
lib/factoids/shlomif-factoids-lists.xml file
into t2/humour/fortunes/shlomif-factoids.xml .

DRY - https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
"""

import os
import re

from lxml import etree
from lxml.html import XHTML_NAMESPACE

XHTML_NS = XHTML_NAMESPACE
XML_NS = "{http://www.w3.org/XML/1998/namespace}"
ns = {
    "xhtml": XHTML_NS,
    "xml": XML_NS,
}
FULL_NAMES = {"chuck": "Chuck Norris",
              "emma-watson": "Emma Watson",
              "nsa": "NSA",
              "taylor-swift": "Taylor Swift", }

ID_IS_FACTOID_RE = re.compile("^[a-z\\-]+-fact-([a-z\\-]+)-([0-9]+)$")
BASENAME_EXTRACT_RE = re.compile('^([a-z_\\-]*)_facts$')

XHTML_START_FMT = '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US">
<head>
<title>Shlomi Fish’s FAQ - {title}</title>
<meta charset="utf-8" />
<meta name="description" content=
"Shlomi Fish’s Frequently Asked Questions (FAQ) List" />
<link rel="stylesheet" href="../../style.css" media="screen" title=
"Normal" />
<link rel="stylesheet" href="../../print.css" media="print" />
<link rel="shortcut icon" href="../../favicon.ico" type=
"image/x-icon" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<script src="../../js/main_all.js"></script>
</head>
<body>
<main class="main" id="main">
'''

XHTML_END_FMT = '''</main>
<footer>
<a href="../../"><img src="../../images/bk2hp-v2.min.svg" class=
"bk2hp" alt="Back to my Homepage" /></a></footer>
</body>
</html>'''


class FortunesMerger:
    def __init__(self, input_fn, merge_into_fn):
        self.input_fn = input_fn
        self.root = etree.parse(input_fn)

    def process(self):
        OUT_DN = './faq-out'
        os.makedirs(OUT_DN, exist_ok=True)
        for list_elem in self.root.xpath(
                "//xhtml:div[@class='faq fancy_sects lim_width wrap-me']" +
                "//xhtml:section", namespaces=ns):
            h_tag = list_elem.xpath("./xhtml:header/*[@id]", namespaces=ns)[0]
            id_ = h_tag.xpath("./@id", namespaces=ns)[0]
            header_text = h_tag.xpath("./text()", namespaces=ns)[0]
            # print([id_, header_text])
            with open("{}/{}.xhtml".format(OUT_DN, id_), "wt") as f:
                f.write(XHTML_START_FMT.format(title=header_text) +
                        etree.tostring(list_elem).decode('utf-8') +
                        XHTML_END_FMT.format(title=header_text)
                        )
            # print(etree.tostring(id_))


def main():
    xml_propagator = FortunesMerger(
        "./dest/post-incs/t2/meta/FAQ/index.xhtml",
        "./t2/humour/fortunes/proto--shlomif-factoids.xml")
    xml_propagator.process()


main()
