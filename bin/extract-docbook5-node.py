#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

"""
Extract nodes from XML documents while preserving namespaces
(as opposed to xmllint).
"""

from lxml import etree
from lxml.html import XHTML_NAMESPACE
import sys

in_fn = sys.argv.pop(1)
xpath = sys.argv.pop(1)
baseurl = sys.argv.pop(1)
XML_NS = "{http://www.w3.org/XML/1998/namespace}"
dbns = "http://docbook.org/ns/docbook"
ns = {
    "db": dbns,
    "ncx": "http://www.daisy.org/z3986/2005/ncx/",
    "xhtml": XHTML_NAMESPACE,
    "xlink": "http://www.w3.org/1999/xlink",
    "xml": XML_NS,
}
with open(in_fn, "rb") as fh:
    xml = fh.read()
root = etree.XML(xml)
for node in root.xpath(xpath, namespaces=ns, ):
    attr = '{xlink}href'.format(xlink=("{" + ns['xlink'] + "}"))
    for link in node.xpath(".//*[starts-with(@xlink:href, '#')]",
                           namespaces=ns, ):
        link.set(attr, baseurl + link.get(attr))
    print(etree.tostring(node).decode('utf-8'), end='')
