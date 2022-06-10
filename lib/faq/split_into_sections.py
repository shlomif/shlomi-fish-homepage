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

import copy
import html
import os
import re
import lxml.html
# from io import StringIO

from lxml import etree
from lxml.html import XHTML_NAMESPACE


XHTML_SECTION_TAG = '{' + XHTML_NAMESPACE + '}section'
XHTML_ARTICLE_TAG = '{' + XHTML_NAMESPACE + '}article'
XHTML_PREFIX = bytes(
                    '<?xml version="1.0" encoding="utf-8"?><!DOCTYPE html>',
                    "utf-8"
                )
HTML_PREFIX = bytes("<!DOCTYPE html>", "utf-8")


class MyXmlNoResultsFoundError(Exception):
    """docstring for MyXmlNoResultsFoundError"""
    def __init__(self, arg):
        super(MyXmlNoResultsFoundError, self).__init__(arg)


def _xpath(ns, node, query):
    # print(query, ns)
    return node.xpath(query, namespaces=ns)


def _first(ns, node, query, debug):
    mylist = _xpath(ns, node, query)
    if not len(mylist):
        # import pdb
        if debug:
            print(etree.tostring(node))
            __import__('pdb').set_trace()
        raise MyXmlNoResultsFoundError(
            "node={} , query={}".format(etree.tostring(node)[:800], query)
        )
    return mylist[0]


class XhtmlSplitter:
    def __init__(
            self, input_fn, output_dirname,
            section_format, container_elem_xpath,
            back_to_source_page_css_class,
            individual_node_css_class,
            ns,
            xhtml_article_tag=XHTML_ARTICLE_TAG,
            xhtml_section_tag=XHTML_SECTION_TAG,
            base_path=None,
            path_to_all_in_one="./",
            path_to_images="",
            relative_output_dirname="",
            input_is_plain_html=False,
            list_sections_format=None,
            main_title=None,
    ):
        self.main_title = main_title
        self.list_sections_format = (
            list_sections_format or
            ("self::node()[local-name()='article' or local-name()='section']")
        )

        self._indiv_node = individual_node_css_class
        self.back_to_source_page_css_class = back_to_source_page_css_class
        self._back_re_css = re.compile(
            "\\b(?:" + re.escape(self.back_to_source_page_css_class) + ")\\b",
            re.M | re.S
        )
        self.input_fn = input_fn
        self.ns = ns
        self.output_dirname = output_dirname
        self.relative_output_dirname = relative_output_dirname
        self.section_format = section_format
        self.input_is_plain_html = input_is_plain_html
        self._fromstring = (
            lxml.html.fragment_fromstring
            if self.input_is_plain_html
            else etree.XML
        )
        self._xhtml_xmlns = (
            "" if self.input_is_plain_html
            else " xmlns:xhtml=\"{xhtml}\""
        )
        self.xhtml_prefix = (
            "" if self.input_is_plain_html else
            "xhtml:"
            # (""+'{' + 'xhtml' + '}' + "")
            # (""+'{' + XHTML_NAMESPACE + '}' + "")
        )
        self.xhtml_article_tag = xhtml_article_tag
        self.xhtml_section_tag = xhtml_section_tag
        self.container_elem_xpath = container_elem_xpath.format(
            xhtml_prefix=self.xhtml_prefix
        )
        self.section_tags = set([
            self.xhtml_article_tag, self.xhtml_section_tag, ])
        if self.input_is_plain_html:
            self._whole_r_mode = 'rt'
        else:
            self._whole_r_mode = 'rb'
        self._r_mode = 'rb'
        self._w_mode = 'wb'
        self._protect_attr_name = "donotprocess"

        # self.root = etree.parse(input_fn)
        with open(input_fn, self._whole_r_mode) as fh:
            self.initial_xml_string = fh.read()
        self.base_path = (base_path or "../../")
        self.path_to_all_in_one = path_to_all_in_one
        self.path_to_images = path_to_images

        def _xhtml_to_string(dom, add_prefix):
            ret = etree.tostring(dom)
            if add_prefix:
                return XHTML_PREFIX + ret
            else:
                return ret

        def _html_to_string(dom, add_prefix):
            ret = lxml.html.tostring(dom)
            if add_prefix:
                return HTML_PREFIX + ret
            else:
                return ret

        self._to_string_cb = (
            _html_to_string
            if self.input_is_plain_html else _xhtml_to_string)

    def _process_title(self, header_text):
        """docstring for _process_title"""
        return re.sub(
            " - Shlomi Fish['’]s Homesite\\Z",
            "",
            header_text,
            flags=(re.M | re.S)
        )

    def _get_header(self, elem):
        """docstring for _get_header"""

        return _first(
            self.ns, elem, self._header_xpath,
            False,
        )

    def _calc_root(self):
        self.root = (
            etree.HTML
            if self.input_is_plain_html
            else etree.XML
        )(
            self.initial_xml_string
        )
        self._header_xpath = "./{xhtml_prefix}header".format(
            xhtml_prefix=self.xhtml_prefix
        )
        main_title_xpath = \
            './/{xhtml_prefix}head/{xhtml_prefix}title/text()'.format(
                xhtml_prefix=self.xhtml_prefix
            )
        # print('main_title_xpath = ', main_title_xpath)
        if not self.main_title:
            self.main_title = _first(
                self.ns,
                self.root,
                main_title_xpath,
                True,
            )
        self.main_title = self._process_title(self.main_title)
        self.main_title_esc = html.escape(self.main_title)
        self.container_elem = _first(
            self.ns,
            self.root,
            '//' + self.container_elem_xpath.format(
                xhtml_prefix=self.xhtml_prefix,
            ),
            True,
        )

        class TreeNode:
            def __init__(s, elem, childs):
                # s.elem = copy.deepcopy(elem)
                s.elem = elem
                s.childs = childs

            def myiter(self, coord_prefix):
                # yield (coord_prefix, self.elem)
                yield coord_prefix
                for idx, el in enumerate(self.childs):
                    yield from el.myiter(
                        coord_prefix=coord_prefix+[idx],
                    )

            def __repr__(self):
                """docstring for __repr__"""
                return "{" + str(self.elem) + " => [" +\
                    ", ".join([str(x) for x in self.childs]) + "]" + "}"

        def genTreeNode(elem):
            kids = []
            for x in elem:
                kids += wrap_genTreeNode(x)
            if _xpath(
                self.ns,
                elem,
                self.list_sections_format.format(
                    xhtml_prefix=self.xhtml_prefix
                    )):
                return [TreeNode(elem=elem, childs=kids)]
            else:
                return kids

        def wrap_genTreeNode(elem):
            """docstring for wrap_genTreeNode"""
            ret = genTreeNode(elem)
            assert isinstance(ret, list)
            return ret

        self.tree = wrap_genTreeNode(self.container_elem)
        if len(self.tree) > 1:
            self.tree = [
                TreeNode(elem=self.container_elem, childs=self.tree, )
            ]
        assert len(self.tree) == 1
        self._coords_list = [c for c in self._calc_list_sections()]
        if False:
            print(self.list_sections_format)
            print('tree =', self.tree)

    def _write_file(self, fn, text):
        should = True
        try:
            with open(fn, self._r_mode) as ifh:
                curr = ifh.read()
                should = curr != text
        except FileNotFoundError:
            pass
        if should:
            with open(fn, self._w_mode) as ofh:
                ofh.write(text)

    def _write_master_xml_file(self):
        tree_s = self._to_string_cb(
            dom=self.root, add_prefix=True,
        )
        return self._write_file(self.input_fn, tree_s)

    def _list_sections(self):
        """docstring for _list_sections"""
        return self._coords_list

    def _calc_list_sections(self):
        yield from self.tree[0].myiter(coord_prefix=[],)

    def _lookup_list_elem(self, coords):
        """docstring for _lookup_list_elem"""
        ret = self.tree[0]
        prev = prev_coords = None
        next_ = next_coords = None
        for i, c in enumerate(coords):
            arr = ret.childs
            ret = arr[c]
            if i == len(coords) - 1:
                if c > 0:
                    pc = c - 1
                    prev_coords = coords[:i] + [pc]
                    assert len(prev_coords) == len(coords)
                    prev = arr[pc].elem
                    assert (prev is not None)
                nc = c + 1
                if nc < len(arr):
                    next_coords = coords[:i] + [nc]
                    assert len(next_coords) == len(coords)
                    next_ = arr[nc].elem
                    assert (next_ is not None)

        elem = ret.elem
        return ((prev_coords, prev), (coords, elem), (next_coords, next_))

    def _is_protected(self, elem):
        """docstring for _protect"""
        return elem.get(self._protect_attr_name)

    def _protect(self, elem):
        """docstring for _protect"""
        elem.set(self._protect_attr_name, "true")

    def process(self):
        self.c = \
            ("putting-cards-on-the-table-2019-2020/" in self.output_dirname)
        SECTION_FORMAT = self.section_format
        output_dirname = self.output_dirname
        os.makedirs(output_dirname, exist_ok=True)

        def calc_id_and_header_esc(header_tag):
            h_tag = _first(self.ns, header_tag, "./*[@id]", True)
            id_ = h_tag.get('id')
            header_text = h_tag.text
            header_text = self._process_title(header_text)
            header_esc = html.escape(header_text)
            return id_, header_esc

        self._calc_root()

        def _add_prefix(prefix, suffix, list_elem, prev):
            """docstring for _add_prefix"""
            # print('input_fn = ', self.input_fn)
            try:
                header_tag = self._get_header(list_elem)
            except MyXmlNoResultsFoundError:
                return
            try:
                a_tag = _first(
                    self.ns,
                    header_tag,
                    ("./{xhtml_prefix}span/{xhtml_prefix}a"
                     "[@class='{_indiv_node}']").format(
                        _indiv_node=self._indiv_node,
                        xhtml_prefix=self.xhtml_prefix
                    ),
                    False,
                )
            except MyXmlNoResultsFoundError:
                id_, header_esc = calc_id_and_header_esc(header_tag)
                a_tag_href_val = (prefix + id_ + suffix)

                prev_fmt = ""
                prev_href = None
                if prev is not None:
                    prev_fmt = (
                        "<{xhtml_prefix}a" + self._xhtml_xmlns
                        + " class=\"previous\""
                        + " href=\"{prev_href}\">"
                        + "Previous Node</{xhtml_prefix}a>"
                    )
                    prev_header_tag = self._get_header(prev)

                    prev_id_, _ = \
                        calc_id_and_header_esc(prev_header_tag)
                    prev_href = (prefix + prev_id_ + suffix)

                next_fmt = ""
                next_href = None
                if next_ is not None:
                    next_fmt = (
                        "<{xhtml_prefix}a" + self._xhtml_xmlns
                        + " class=\"next\""
                        + " href=\"{next_href}\">"
                        + "Next Node</{xhtml_prefix}a>"
                    )
                    next_header_tag = self._get_header(next_)

                    next_id_, _ = \
                        calc_id_and_header_esc(next_header_tag)
                    next_href = (prefix + next_id_ + suffix)

                node_fmt = (
                    "<{xhtml_prefix}a" + self._xhtml_xmlns
                    + " class=\"{_indiv_node}\""
                    + " href=\"{href}\">Node Link</{xhtml_prefix}a>"
                )
                tot = (
                    "<{xhtml_prefix}span" + self._xhtml_xmlns
                    + " class=\"{_indiv_node}\">"
                )
                for fmt in [prev_fmt, node_fmt, next_fmt, ]:
                    if not fmt:
                        continue
                    tot += fmt
                tot += (
                    "</{xhtml_prefix}span>"
                )
                a_tag = self._fromstring(tot.format(
                    href=a_tag_href_val,
                    _indiv_node=self._indiv_node,
                    next_href=next_href,
                    prev_href=prev_href,
                    xhtml_prefix=self.xhtml_prefix,
                    **self.ns,
                ))
                header_tag.append(a_tag)

        for coords in self._list_sections():
            ((prev_coords, prev), (coords2, list_elem),
             (next_coords, next_)) = \
                    self._lookup_list_elem(coords)
            _add_prefix(
                prefix=(self.relative_output_dirname),
                suffix=".xhtml",
                list_elem=list_elem,
                prev=prev,
            )
        self._write_master_xml_file()

        # self._calc_root()

        if len(self.path_to_images):
            for img_elem in _xpath(self.ns,
                                   self.container_elem,
                                   ".//{xhtml_prefix}img".format(
                                       xhtml_prefix=self.xhtml_prefix
                                                                   )):
                src_path = img_elem.get("src")
                if src_path.startswith(("http:", "https:", )):
                    continue
                img_elem.set("src", self.path_to_images + src_path)
                self._protect(img_elem)

        # print(list(self._list_sections()))
        for coords in self._list_sections():
            ((prev_coords, prev), (coords2, list_elem),
             (next_coords, next_)) = \
                    self._lookup_list_elem(coords)
            _add_prefix(
                prefix=(self.path_to_all_in_one + "#"),
                suffix="",
                list_elem=list_elem,
                prev=prev,
            )
            parents = []
            p_iter = list_elem.getparent()
            while p_iter.tag in self.section_tags:
                res = _xpath(
                    self.ns,
                    p_iter,
                    "./{xhtml_prefix}header[*/@id]".format(
                        xhtml_prefix=self.xhtml_prefix
                    )
                )
                # print(self.input_fn, res)
                if len(res) == 0:
                    break
                assert len(res) == 1
                id_, header_esc = calc_id_and_header_esc(res[0])
                rec = {'id': id_, 'header_esc': header_esc, }
                parents.append(rec)
                p_iter = p_iter.getparent()

            def _a_tags(list_elem):
                """docstring for _atags"""
                return _xpath(
                    self.ns,
                    list_elem,
                    "./descendant::{xhtml_prefix}a".format(
                        xhtml_prefix=self.xhtml_prefix
                    )
                )
            for a_el in _a_tags(list_elem):
                href = a_el.get('href')
                if href is None:
                    continue
                if href.startswith('#'):
                    a_el.set("href", self.path_to_all_in_one + href)
                    self._protect(a_el)
            try:
                header_tag = self._get_header(list_elem)
            except MyXmlNoResultsFoundError:
                continue
            id_, header_esc = calc_id_and_header_esc(header_tag)

            a_tag = _first(
                self.ns,
                header_tag,
                ("./{xhtml_prefix}span/{xhtml_prefix}a"
                 "[@class='{_indiv_node}']").format(
                    _indiv_node=self._indiv_node,
                    xhtml_prefix=self.xhtml_prefix
                ), True
            )
            a_tag.set("class", self.back_to_source_page_css_class)
            a_tag_href_val = (self.path_to_all_in_one + "#" + id_)
            a_tag.set("href", a_tag_href_val)
            self._protect(a_tag)
            if len(self.path_to_images) and (
                    True):  # len(self.path_to_all_in_one) == 0):
                # assert not self.c
                for a_elem in _a_tags(list_elem):
                    if self._is_protected(a_elem):
                        continue
                    href = a_elem.get("href")
                    if href.startswith(("http:", "https:", )):
                        continue
                    if self._back_re_css.search(a_elem.get("class") or ""):
                        continue
                    a_elem.set(
                        "href", self.path_to_images + href
                    )
                    self._protect(a_elem)
                    if self.c:
                        # assert not ("../../" in a_elem.get("href"))
                        pass
            output_list_elem = copy.deepcopy(list_elem)
            for a_elem in _xpath(
                    self.ns,
                    output_list_elem,
                    "./descendant::*[@" + self._protect_attr_name + "]",
                    ):
                if self._is_protected(a_elem):
                    a_elem.attrib.pop(self._protect_attr_name)
            body_string = self._to_string_cb(
                dom=output_list_elem, add_prefix=False,
            )
            formats = {
                'base_path': self.base_path,
                'body': (body_string.decode('utf-8')),
                'main_title': self.main_title_esc,
                'path_to_all_in_one': self.path_to_all_in_one,
                'title': header_esc,
                'breadcrumbs_trail': ''.join(
                    [" → <a href=\"{id}.xhtml\">{header_esc}</a>".format(**rec)
                     for rec in reversed(parents)]),
            }
            fn = "{}/{}.xhtml".format(output_dirname, id_)
            _out_page_text = SECTION_FORMAT.format(**formats)
            _out_page_text = _out_page_text.encode()
            self._write_file(fn, _out_page_text)
