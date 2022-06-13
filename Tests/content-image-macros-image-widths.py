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

    def test_faq_indiv_node_links(self):
        input_fn = './dest/post-incs/t2/meta/FAQ/your_name.xhtml'
        root = html.parse(input_fn)
        headers = root.xpath(".//section/header[h3/@id='your_name']")
        self.assertEqual(len(headers), 1)
        goodlinks = headers[0].xpath(
            "./span[@class='indiv_node']/a[contains(@href, '#your_name') "
            "and contains(text(), 'Node Link')]"
        )
        self.assertEqual(len(goodlinks), 1)
        badlinks = headers[0].xpath(
            "./a[@class='indiv_node' and contains(@href, 'your_name') "
            "and contains(text(), 'Node Link')]"
        )
        self.assertEqual(len(badlinks), 0)

    def _helper_indiv_nodes_test(self, root, xpath_str, name):
        """docstring for _helper_indiv_nodes_test"""
        articles = root.xpath(xpath_str)
        self.assertTrue(len(articles), "count articles " + name)
        for idx, art in enumerate(articles):
            link = art.xpath("./header/span/a[./text() = 'Node Link']")
            self.assertEqual(
                len(link), 1, "len link idx={idx} name={name}".format(
                    idx=idx,
                    name=name,
                )
            )
            href = link[0].get("href")
            self.assertTrue(href.startswith("indiv-nodes/"), name)

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
        self._helper_indiv_nodes_test(
            root, ".//article", base_dir_path
        )
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
        main = root.xpath(".//*[@id='index']")[0]
        self._helper_indiv_nodes_test(
            main,
            ".//section",
            "test_terminator_liberation"
        )
        scene = main.xpath(
            ".//section[@id='scene-emma-watson-and-the-children-get-icecream']"
        )
        self.assertEqual(len(scene), 1, "scene", )
        prev = scene[0].xpath(
            "./header/span/a[@class='previous']"
            "[contains(./text(), 'Prev')]"
        )
        self.assertEqual(len(prev), 1, "prev", )
        href = prev[0].get("href")
        self.assertEqual(
            href,
            "indiv-nodes/emma-watson-finishes-telling-a-story.xhtml",
            "prev href",
        )

        next_ = scene[0].xpath(
            "./header/span/a[@class='next'][contains(./text(), 'Next')]"
        )
        self.assertEqual(len(next_), 1, "next", )
        href = next_[0].get("href")
        self.assertEqual(
            href,
            "indiv-nodes/emulating-arnie-as-hamlet.xhtml",
            "next href",
        )

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
