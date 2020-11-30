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
XHTML_SECTION_TAG = '{' + XHTML_NAMESPACE + '}section'

# Removed:
# <script src="{base_path}js/main_all.js"></script>
SECTION_FORMAT = '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Shlomi Fish’s FAQ - {title}</title>
<meta charset="utf-8"/>
<meta name="description" content=
"Shlomi Fish’s Frequently Asked Questions (FAQ) List - {title}"/>
<link rel="stylesheet" href="{base_path}faq-indiv.css" media="screen" title=
"Normal"/>
<link rel="stylesheet" href="{base_path}print.css" media="print"/>
<link rel="shortcut icon" href="{base_path}favicon.ico" type=
"image/x-icon"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
</head>
<body class="faq_indiv_entry">
<div class="header" id="header">
<a href="{base_path}"><img src="{base_path}images/evilphish.png"
alt="EvilPHish site logo"/></a>
<div class="leading_path"><a href="{base_path}">Shlomi Fish’s
Homepage</a> → <a href="../" title=
"Information about this Site">Meta Info</a> → <a href="./" title=
"Frequently Asked Questions and Answers List (FAQ)">FAQ</a>
{breadcrumbs_trail}
→ <b>{title}</b>
</div>
</div>
<div id="faux">
<main class="main faq">
{body}</main>
</div>
<footer>
<div class="foot_left">
<ul class="bt_nav">
<li><a href="{base_path}">Home</a></li>
<li><a href="{base_path}me/">About</a></li>
<li><a href="{base_path}me/contact-me/">Contact Us</a></li>
<li><a href="{base_path}meta/privacy-policy/">Privacy Policy</a></li>
<li><a href="{base_path}meta/anti-spam-policy/">Anti-Spam
Policy</a></li>
<li><a href="{base_path}meta/FAQ/" title=
"Frequently asked questions list">FAQ</a></li>
<li><a href="{base_path}me/blogs/">RSS/Atom Feeds</a></li>
</ul>
<p>Written, designed, and maintained by Shlomi Fish, <a href=
"mailto:shlomif@shlomifish.org">shlomif@shlomifish.org</a>.</p>
</div>
<a href="{base_path}"><img src="{base_path}images/bk2hp-v2.min.svg" class=
"bk2hp" alt="Back to my Homepage"/></a></footer>
</body>
</html>'''

OUT_DN = "./dest/post-incs/t2/meta/FAQ"


TOP_LEVEL_CLASS = 'faq fancy_sects lim_width wrap-me'


class FaqSplitter:
    def __init__(self, input_fn):
        self.input_fn = input_fn
        self.root = etree.parse(input_fn)

    def process(self):
        os.makedirs(OUT_DN, exist_ok=True)

        def xpath(node, query):
            return node.xpath(query, namespaces=ns)

        def first(node, query):
            return xpath(node, query)[0]

        def calc_id_and_header_esc(header_tag):
            h_tag = first(header_tag, "./*[@id]")
            id_ = first(h_tag, "./@id")
            header_text = first(h_tag, "./text()")
            header_esc = html.escape(header_text)
            return id_, header_esc

        for list_elem in xpath(
                self.root,
                "//xhtml:div[@class='" + TOP_LEVEL_CLASS + "']" +
                "//xhtml:section"):
            parents = []
            p_iter = list_elem.getparent()
            # print(etree.tostring(p_iter))
            # print(p_iter.tag)
            while p_iter.tag == XHTML_SECTION_TAG:
                res = xpath(p_iter, "./xhtml:header[*/@id]")
                assert len(res) == 1
                id_, header_esc = calc_id_and_header_esc(res[0])
                rec = {'id': id_, 'header_esc': header_esc, }
                parents.append(rec)
                p_iter = p_iter.getparent()
            for a_el in xpath(list_elem, "./descendant::xhtml:a"):
                href = a_el.get('href')
                if href is None:
                    continue
                if href.startswith('#'):
                    a_el.set("href", "./" + href)
            header_tag = first(list_elem, "./xhtml:header")
            id_, header_esc = calc_id_and_header_esc(header_tag)

            a_tag = first(header_tag, "./xhtml:a[@class='indiv_node']")
            a_tag.set("class", "back_to_faq")
            a_tag.set("href", "./#"+id_)
            # print([id_, header_text])
            formats = {
                'base_path': "../../",
                'body': etree.tostring(list_elem).decode('utf-8'),
                'title': header_esc,
                'breadcrumbs_trail': ''.join(
                    [" → <a href=\"{id}.xhtml\">{header_esc}</a>".format(**rec)
                     for rec in reversed(parents)]),
            }
            with open("{}/{}.xhtml".format(OUT_DN, id_), "wt") as f:
                f.write(SECTION_FORMAT.format(**formats))
            # print(etree.tostring(id_))


def main():
    splitter = FaqSplitter(
        OUT_DN + "/index.xhtml")
    splitter.process()


if __name__ == '__main__':
    main()
