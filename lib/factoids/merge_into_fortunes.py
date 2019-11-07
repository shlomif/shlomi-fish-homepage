#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""

"""

import re
from collections import defaultdict
from copy import deepcopy

from lxml import etree

XML_NS = "{http://www.w3.org/XML/1998/namespace}"
ns = {"xml": XML_NS, }
FULL_NAMES = {"chuck": "Chuck Norris",
              "emma-watson": "Emma Watson",
              "nsa": "NSA",
              "taylor-swift": "Taylor Swift", }


class FortunesMerger:
    """docstring for FortunesMerger"""
    def __init__(self, input_fn, merge_into_fn):
        self.input_fn = input_fn
        self.root = etree.parse(input_fn)
        self.target_root = etree.parse(merge_into_fn)
        self.max_idxs = defaultdict(int)
        self.max_idxs_ids = {}
        self.target_list = self.target_root.xpath("./list")[0]
        for targetelem in self.target_root.xpath("./list/fortune"):
            id_ = targetelem.get("id")
            match = re.match("^[a-z\\-]+-fact-([a-z\\-]+)-([0-9]+)$", id_)
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
            '^([a-z_\\-]*)_facts$', list_id).group(1).replace('_', '-')
        # print(list_id, facts_basename)
        fact = found_fact[0]
        facts_to_add = []
        while fact is not None:
            facts_to_add.append(deepcopy(fact))
            fact = fact.getnext()
        # print("\t{}".format(len(facts_to_add)))
        target_idx = self.target_list.index(
            self.target_list.xpath(
                "./fortune[@id='{}']".format(
                    self.max_idxs_ids[facts_basename]))[0])
        full_name = FULL_NAMES[facts_basename]
        for idx, iter_fact in enumerate(facts_to_add):
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


def main():
    obj = FortunesMerger(
        "./lib/factoids/shlomif-factoids-lists.xml",
        "./t2/humour/fortunes/proto--shlomif-factoids.xml")
    obj.process()
    with open("./t2/humour/fortunes/shlomif-factoids.xml", "wb") as f:
        f.write(etree.tostring(obj.target_root, pretty_print=True))


main()
