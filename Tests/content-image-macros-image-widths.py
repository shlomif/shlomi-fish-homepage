#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import re
import unittest

from PIL import Image

from lxml import html


# The WIDTH might be changed in the future
WIDTH = 600


class MyTests(unittest.TestCase):
    def test_case4fanfic(self):
        input_fn = 'dest/post-incs/t2/philosophy/culture/' + \
            'case-for-commercial-fan-fiction/' + \
            'indiv-nodes/starved_of_employees.xhtml'
        root = html.parse(input_fn)
        descs = root.xpath(
            ".//div[@class='leading_path']/" +
            "a[@href='all_people_are_good.xhtml']")
        self.assertEqual(len(descs), 1)
        desc_text = descs[0].xpath('text()')[0]
        m = re.match(
            "^.*?All People", desc_text)
        self.assertTrue(m)

    def test_putting_cards_2021_links(self):
        input_fn = 'dest/post-incs/t2/philosophy/philosophy/' + \
            'putting-cards-on-the-table-2019-2020/' + \
            'indiv-nodes/Taylor_Swift.xhtml'
        root = html.parse(input_fn)
        descs = root.xpath(
            "//a[@title='Amateurs vs. Professionals']")
        self.assertEqual(len(descs), 1, 'single link')
        # desc_text = descs[0].xpath('@href/text()')[0]
        desc_text = descs[0].get('href')
        m = re.match(
            "^\\.\\./#amateurs$", desc_text)
        self.assertTrue(m, 'right relative link: ' + desc_text)

        descs = root.xpath(
            "./head/link[@media='print']")
        self.assertEqual(len(descs), 1, 'single print link')
        # desc_text = descs[0].xpath('@href/text()')[0]
        desc_text = descs[0].get('href')
        self.assertEqual(
            desc_text, "../../../../print.css",
            'right relative link: ' + desc_text)

    def test_faq_desc(self):
        input_fn = './dest/post-incs/t2/meta/FAQ/your_name.xhtml'
        root = html.parse(input_fn)
        descs = root.xpath(".//head/meta[@name='description']")
        self.assertEqual(len(descs), 1)
        desc_text = descs[0].get('content')
        m = re.match(
            "^.*?What can you say about your name", desc_text)
        self.assertTrue(m)

    def test_rindolfism(self):
        input_fn = \
            './dest/post-incs/t2/me/rindolfism/index.xhtml'
        root = html.parse(input_fn)
        links = root.xpath(
            ".//section[header/*/@id='neo_semitism']" +
            "/section[header/*/@id='rindolfism_canon']")
        self.assertEqual(len(links), 0)
        links = root.xpath(
            ".//section[header/*/@id='rindolfism']" +
            "/section[header/*/@id='rindolfism_canon']")
        self.assertEqual(len(links), 1)

    def _helper_indiv_nodes_test(self, root, xpath_str):
        """docstring for _helper_indiv_nodes_test"""
        articles = root.xpath(xpath_str)
        self.assertTrue(len(articles), "count articles")
        for art in articles:
            link = art.xpath("./header/a[./text() = 'Node Link']")
            self.assertEqual(len(link), 1)
            href = link[0].get("href")
            self.assertTrue(href.startswith("indiv-nodes/"))

    def _get_base_dir_path(self):
        return './dest/post-incs/t2/humour/image-macros/'

    def test_image_macros__relative_links(self):
        base_dir_path = self._get_base_dir_path()
        fragments_dir = base_dir_path + "indiv-nodes/"
        fragment_fn = fragments_dir + "GNU_slash_Linux.xhtml"
        import os
        self.assertTrue(os.stat(fragment_fn).st_size > 200)
        root = html.parse(fragment_fn)
        imgs = root.xpath(".//article/img")
        for img in imgs:
            src = img.get("src")
            self.assertTrue(src)
            m = re.match(
                "^(?:\\.\\./){3}(humour/images/[A-Za-z0-9_.\\-]+)$", src)
            self.assertTrue(m)
        fragment_fn = fragments_dir + "interesting_hypothesis.xhtml"
        root = html.parse(fragment_fn)
        good = False
        bad = False
        node_link_href = ""
        for atag in root.xpath(".//a"):
            href = atag.get("href")
            if "back_to_faq" in (atag.get('class') or ''):
                node_link_href = href
            elif href == '../../../humour/image-macros/#standup_philosopher':
                good = True
            elif href == '../../humour/image-macros/#standup_philosopher':
                bad = True
        self.assertTrue(good, "relative link")
        self.assertTrue((not bad), "relative link [bad]")
        self.assertEqual(
            node_link_href,
            "../#interesting_hypothesis",
            "node_link_href",
        )

    def test_image_macros_widths(self):
        base_dir_path = self._get_base_dir_path()
        input_fn = (base_dir_path + 'index.xhtml')
        root = html.parse(input_fn)
        self._helper_indiv_nodes_test(root, ".//article")
        imgs = root.xpath(".//article/img")
        self.assertTrue(len(imgs) > 5)
        for img in imgs:
            src = img.get("src")
            self.assertTrue(src)
            m = re.match(
                "^(?:\\.\\./){2}(humour/images/[A-Za-z0-9_.\\-]+)$", src)
            self.assertTrue(m, "'{}' matches".format(src))
            path = m.group(1)
            if "interesting-hypothesis" not in path:
                self.assertTrue(re.match(".*\\.webp$", path))
            wanted_width = 800 if ("little-red-riding" in path) else WIDTH
            self.assertEqual(
                Image.open("./dest/post-incs/t2/" + path).size[0],
                wanted_width,
                "image {} has wanted_width={}".format(path, wanted_width)
                )

    def test_terminator_liberation(self):
        """docstring for test_terminator_liberation"""
        input_fn = './dest/post-incs/t2/humour/Terminator/Liberation/' + \
            'ongoing-text.html'
        root = html.parse(input_fn)
        self._helper_indiv_nodes_test(root, ".//section")

    def test_qoheleth(self):
        base_path_fn = './dest/post-incs/t2/humour/' + \
            'So-Who-The-Hell-Is-Qoheleth/'
        input_fn = base_path_fn + 'ongoing-text.html'
        root = html.parse(input_fn)
        imgs = root.xpath(".//img[contains(@alt, 'Standup-Philosopher')]")
        self.assertEqual(len(imgs), 1)
        for img in imgs:
            src = img.get("src")
            self.assertTrue(src)
            m = re.match("^(images/[A-Za-z0-9_.\\-]+)$", src)
            self.assertTrue(m)
            path = m.group(1)
            self.assertTrue(re.match(".*\\.webp$", path))
            self.assertEqual(
                Image.open(base_path_fn + path).size[0],
                WIDTH,
                "image {} has WIDTH={}".format(path, WIDTH)
                )


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
