#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""
Split Shlomi Fish's FAQ-list into individual
sections or questions.
"""

import html
import os

from lxml import etree
from lxml.html import XHTML_NAMESPACE

XHTML_NS = XHTML_NAMESPACE
XML_NS = "{http://www.w3.org/XML/1998/namespace}"
ns = {
    "xhtml": XHTML_NS,
    "xml": XML_NS,
}

SECTION_FORMAT = '''<?xml version="1.0" encoding="utf-8"?>
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
<body class="faq_indiv_entry">
<div id="faux">
<main class="main faq">
{body}</main>
</div>
<footer>
<a href="../../"><img src="../../images/bk2hp-v2.min.svg" class=
"bk2hp" alt="Back to my Homepage" /></a></footer>
</body>
</html>'''

OUT_DN = "./dest/post-incs/t2/meta/FAQ"


class FortunesMerger:
    def __init__(self, input_fn):
        self.input_fn = input_fn
        self.root = etree.parse(input_fn)

    def process(self):
        os.makedirs(OUT_DN, exist_ok=True)

        def _xpath(node, query):
            return node.xpath(query, namespaces=ns)

        def _first(node, query):
            return _xpath(node, query)[0]
        for list_elem in _xpath(
                self.root,
                "//xhtml:div[@class='faq fancy_sects lim_width wrap-me']" +
                "//xhtml:section"):
            header_tag = _first(list_elem, "./xhtml:header")

            h_tag = _first(header_tag, "./*[@id]")
            id_ = _first(h_tag, "./@id")
            header_text = _first(h_tag, "./text()")
            header_esc = html.escape(header_text)

            a_tag = _first(header_tag, "./xhtml:a[@class='indiv_node']")
            a_tag.set("class", "back_to_faq")
            a_tag.set("href", "./#"+id_)
            # print([id_, header_text])
            formats = {
                'title': header_esc,
                'body': etree.tostring(list_elem).decode('utf-8'),
            }
            with open("{}/{}.xhtml".format(OUT_DN, id_), "wt") as f:
                f.write(SECTION_FORMAT.format(**formats))
            # print(etree.tostring(id_))


def main():
    xml_propagator = FortunesMerger(
        OUT_DN + "/index.xhtml")
    xml_propagator.process()


main()
