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
XML_NS = "{http://www.w3.org/XML/1998/namespace}"
dbns = "http://docbook.org/ns/docbook"
ns = {
    "db": dbns,
    "ncx": "http://www.daisy.org/z3986/2005/ncx/",
    "xhtml": XHTML_NAMESPACE,
    "xml": XML_NS,
}
with open(in_fn, "rb") as fh:
    xml = fh.read()
root = etree.XML(xml)
node = root.xpath(xpath, namespaces=ns, )[0]
print(etree.tostring(node).decode('utf-8'), end='')
