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
into src/humour/fortunes/shlomif-factoids.xml .

DRY - https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
"""

import os
import re
from collections import defaultdict
from copy import deepcopy

from lxml import etree

XML_NS = "{http://www.w3.org/XML/1998/namespace}"
ns = {"xml": XML_NS, }
FULL_NAMES = {"chuck": "Chuck Norris",
              "emma-watson": "Emma Watson",
              "nsa": "NSA",
              "taylor-swift": "Taylor Swift",
              "xena": "Xena the Warrior Princess",
              }

ID_IS_FACTOID_RE = re.compile("^[a-z\\-]+-fact-([a-z\\-]+)-([0-9]+)$")
BASENAME_EXTRACT_RE = re.compile('^([a-z_\\-]*)_facts$')


class FortunesMerger:
    def __init__(self, input_fn, merge_into_fn):
        self.input_fn = input_fn
        self.merge_into_fn = merge_into_fn
        self.root = etree.parse(input_fn)
        self.target_root = etree.parse(merge_into_fn)
        self.max_idxs = defaultdict(int)
        self.max_idxs_ids = {}
        self.target_list = self.target_root.xpath("./list")[0]
        for targetelem in self.target_root.xpath("./list/fortune"):
            id_ = targetelem.get("id")
            match = re.match(ID_IS_FACTOID_RE, id_)
            if match:
                category = match.group(1)
                idx = int(match.group(2))
                if self.max_idxs[category] < idx:
                    self.max_idxs[category] = idx
                    self.max_idxs_ids[category] = id_

    def process(self):
        for list_elem in self.root.xpath("./list"):
            self._process_list_elem(list_elem)

    def _process_list_elem(self, list_elem):
        list_id = list_elem.get("{}id".format(XML_NS))
        found_fact = list_elem.xpath("./fact[@xml:id = '{}']".format(
            list_id + '--startaddmore'), namespaces=ns)
        if not found_fact:
            return
        facts_basename = re.match(
            BASENAME_EXTRACT_RE,
            list_id).group(1).replace('_', '-')
        fact = found_fact[0]
        facts_to_add = []
        while fact is not None:
            facts_to_add.append(deepcopy(fact))
            fact = fact.getnext()
        target_idx = self.target_list.index(
            self.target_list.xpath(
                "./fortune[@id='{}']".format(
                    self.max_idxs_ids[facts_basename]))[0])
        full_name = FULL_NAMES[facts_basename]
        for idx, iter_fact in enumerate(facts_to_add):
            self._process_fact(
                idx, iter_fact, full_name, target_idx, facts_basename)

    def _process_fact(self, idx, iter_fact, full_name,
                      target_idx, facts_basename):
        author_str = 'Shlomi Fish'
        newidx = idx + self.max_idxs[facts_basename] + 1
        new_elem = etree.Element(
            "fortune", id="{}-fact-{}-{}".format(
                "shlomif",
                facts_basename,
                newidx
                ))
        meta = etree.SubElement(new_elem, "meta")
        title = etree.SubElement(meta, "title")
        title.text = "{}’s {} Fact #{}".format(
            author_str, full_name, newidx)
        quote = etree.SubElement(new_elem, "quote")
        quote.insert(0, iter_fact.xpath(
            "./lang[@xml:lang='en-US']/body", namespaces=ns)[0])
        info = etree.SubElement(quote, "info")
        author = etree.SubElement(info, "author")
        author.text = author_str
        work = etree.SubElement(
            info,
            "work",
            href="http://www.shlomifish.org/" +
            "humour/bits/facts/{}/".format(
                full_name.replace(' ', '-')))
        work.text = ("{} Facts by " +
                     "{} and Friends").format(full_name, author_str)
        self.target_list.insert(target_idx+idx+1, new_elem)

    def write_to_file(self, out_fn):
        with open(out_fn, "wb") as f:
            f.write(
                etree.tostring(self.target_root, pretty_print=True))
        t = max([os.stat(fn).st_mtime for fn in
                 [self.input_fn, self.merge_into_fn, __file__]
                 ]) + 1
        os.utime(out_fn, (t, t))


def main():
    FORTS_DIR = "./src/humour/fortunes"
    xml_propagator = FortunesMerger(
        "./lib/factoids/shlomif-factoids-lists.xml",
        "{}/proto--shlomif-factoids.xml".format(FORTS_DIR))
    xml_propagator.process()
    xml_propagator.write_to_file(
        "{}/shlomif-factoids.xml".format(FORTS_DIR))


main()
