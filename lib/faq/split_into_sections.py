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


XHTML_SECTION_TAG = '{' + XHTML_NAMESPACE + '}section'
XHTML_ARTICLE_TAG = '{' + XHTML_NAMESPACE + '}article'


class MyXmlNoResultsFoundError(Exception):
    """docstring for MyXmlNoResultsFoundError"""
    def __init__(self, arg):
        super(MyXmlNoResultsFoundError, self).__init__(arg)


def _xpath(ns, node, query):
    return node.xpath(query, namespaces=ns)


def _first(ns, node, query):
    mylist = _xpath(ns, node, query)
    if not len(mylist):
        raise MyXmlNoResultsFoundError(
            "node={} , query={}".format(node, query)
        )
    return mylist[0]


class XhtmlSplitter:
    def __init__(
            self, input_fn, output_dirname,
            section_format, container_elem_xpath,
            ns,
            xhtml_article_tag=XHTML_ARTICLE_TAG,
            xhtml_section_tag=XHTML_SECTION_TAG, base_path=None,
            path_to_all_in_one="./",
            path_to_images="",
            relative_output_dirname="",
            ):
        self.input_fn = input_fn
        self.ns = ns
        self.output_dirname = output_dirname
        self.relative_output_dirname = relative_output_dirname
        self.section_format = section_format
        self.container_elem_xpath = container_elem_xpath
        self.xhtml_article_tag = xhtml_article_tag
        self.xhtml_section_tag = xhtml_section_tag
        self.section_tags = set([
            self.xhtml_article_tag, self.xhtml_section_tag, ])

        # self.root = etree.parse(input_fn)
        self.initial_xml_string = open(input_fn, 'rb').read()
        self.base_path = (base_path or "../../")
        self.path_to_all_in_one = path_to_all_in_one
        self.path_to_images = path_to_images

    def _calc_root(self):
        self.root = etree.XML(self.initial_xml_string)
        self.main_title = _first(
            self.ns,
            self.root, './xhtml:head/xhtml:title/text()'
        )
        self.main_title_esc = html.escape(self.main_title)
        self.container_elem = _first(
            self.ns,
            self.root, self.container_elem_xpath
        )

    def _write_master_xml_file(self):
        tree_s = etree.tostring(self.root)
        should = False
        with open(self.input_fn, 'rb') as ifh:
            curr = ifh.read()
            should = curr != tree_s
        if should:
            with open(self.input_fn, 'wb') as ofh:
                ofh.write(tree_s)

    def process(self):
        SECTION_FORMAT = self.section_format
        output_dirname = self.output_dirname
        os.makedirs(output_dirname, exist_ok=True)

        def calc_id_and_header_esc(header_tag):
            h_tag = _first(self.ns, header_tag, "./*[@id]")
            id_ = _first(self.ns, h_tag, "./@id")
            header_text = _first(self.ns, h_tag, "./text()")
            header_esc = html.escape(header_text)
            return id_, header_esc

        self._calc_root()

        def _list_sections():
            """docstring for _list_sections"""
            return _xpath(
                self.ns,
                self.container_elem,
                ".//xhtml:article | .//xhtml:section")

        def _add_prefix(prefix, suffix, list_elem):
            """docstring for _add_prefix"""
            header_tag = _first(self.ns, list_elem, "./xhtml:header")
            try:
                a_tag = _first(
                    self.ns, header_tag, "./xhtml:a[@class='indiv_node']")
            except MyXmlNoResultsFoundError:
                id_, header_esc = calc_id_and_header_esc(header_tag)
                a_tag_href_val = (prefix + id_ + suffix)
                a_tag = etree.XML(
                    (
                        "<xhtml:a xmlns:xhtml=\"{xhtml}\" class=\"indiv_node\""
                        + " href=\"{href}\">Node Link</xhtml:a>"
                    ).format(href=a_tag_href_val, **self.ns)
                )
                header_tag.append(a_tag)

        for list_elem in _list_sections():
            _add_prefix(
                prefix=(self.relative_output_dirname),
                suffix=".xhtml",
                list_elem=list_elem)
        self._write_master_xml_file()

        self._calc_root()

        if len(self.path_to_images):
            for img_elem in _xpath(self.ns,
                                   self.container_elem, ".//xhtml:img"):
                img_elem.set("src", self.path_to_images + img_elem.get("src"))

        for list_elem in _list_sections():
            _add_prefix(
                prefix=(self.path_to_all_in_one + "#"),
                suffix="",
                list_elem=list_elem)
            parents = []
            p_iter = list_elem.getparent()
            while p_iter.tag in self.section_tags:
                res = _xpath(self.ns, p_iter, "./xhtml:header[*/@id]")
                assert len(res) == 1
                id_, header_esc = calc_id_and_header_esc(res[0])
                rec = {'id': id_, 'header_esc': header_esc, }
                parents.append(rec)
                p_iter = p_iter.getparent()
            for a_el in _xpath(self.ns, list_elem, "./descendant::xhtml:a"):
                href = a_el.get('href')
                if href is None:
                    continue
                if href.startswith('#'):
                    a_el.set("href", self.path_to_all_in_one + href)
            header_tag = _first(self.ns, list_elem, "./xhtml:header")
            id_, header_esc = calc_id_and_header_esc(header_tag)

            a_tag = _first(
                self.ns, header_tag, "./xhtml:a[@class='indiv_node']"
            )
            a_tag.set("class", "back_to_faq")
            a_tag_href_val = (self.path_to_all_in_one + "#" + id_)
            a_tag.set("href", a_tag_href_val)
            if len(self.path_to_images):
                for a_elem in _xpath(self.ns,
                                     list_elem, ".//xhtml:a"):
                    href = a_elem.get("href")
                    if href.startswith(("http:", "https:", )):
                        continue
                    a_elem.set(
                        "href", self.path_to_images + href
                    )
            formats = {
                'base_path': self.base_path,
                'body': etree.tostring(list_elem).decode('utf-8'),
                'main_title': self.main_title_esc,
                'title': header_esc,
                'breadcrumbs_trail': ''.join(
                    [" → <a href=\"{id}.xhtml\">{header_esc}</a>".format(**rec)
                     for rec in reversed(parents)]),
            }
            with open("{}/{}.xhtml".format(output_dirname, id_), "wt") as f:
                f.write(SECTION_FORMAT.format(**formats))
