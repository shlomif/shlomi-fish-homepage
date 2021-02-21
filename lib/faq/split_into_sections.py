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


class XhtmlSplitter:
    def __init__(
            self, input_fn, output_dirname,
            section_format, container_elem_xpath,
            xhtml_section_tag, ns):
        self.input_fn = input_fn
        self.ns = ns
        self.output_dirname = output_dirname
        self.section_format = section_format
        self.container_elem_xpath = container_elem_xpath
        self.xhtml_section_tag = xhtml_section_tag

        self.root = etree.parse(input_fn)

    def process(self):
        SECTION_FORMAT = self.section_format
        OUT_DN = self.output_dirname
        os.makedirs(OUT_DN, exist_ok=True)

        def xpath(node, query):
            return node.xpath(query, namespaces=self.ns)

        def first(node, query):
            mylist = xpath(node, query)
            if not len(mylist):
                raise Exception(
                    "node={} , query={}".format(node, query)
                )
            return mylist[0]

        def calc_id_and_header_esc(header_tag):
            h_tag = first(header_tag, "./*[@id]")
            id_ = first(h_tag, "./@id")
            header_text = first(h_tag, "./text()")
            header_esc = html.escape(header_text)
            return id_, header_esc

        container_elem = first(
            self.root, self.container_elem_xpath)
        for list_elem in xpath(
                container_elem,
                ".//xhtml:section"):
            parents = []
            p_iter = list_elem.getparent()
            # print(etree.tostring(p_iter))
            # print(p_iter.tag)
            while p_iter.tag == self.xhtml_section_tag:
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
