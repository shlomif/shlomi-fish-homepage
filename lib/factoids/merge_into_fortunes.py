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


def main():
    root = etree.parse("./lib/factoids/shlomif-factoids-lists.xml")
    target_root = etree.parse(
        "./t2/humour/fortunes/proto--shlomif-factoids.xml")
    max_idxs = defaultdict(int)
    max_idxs_ids = {}
    max_idxs_elems = {}
    target_list = target_root.xpath("./list")[0]
    for targetelem in target_root.xpath("./list/fortune"):
        id_ = targetelem.get("id")
        match = re.match("^[a-z\\-]+-fact-([a-z\\-]+)-([0-9]+)$", id_)
        if match:
            category = match.group(1)
            idx = int(match.group(2))
            if max_idxs[category] < idx:
                max_idxs[category] = idx
                max_idxs_ids[category] = id_
                max_idxs_elems[category] = targetelem

            print('ID: {} cat: {} idx: {}'.format(id_, category, idx))
    print(max_idxs)
    print(max_idxs_ids)
    for list_elem in root.xpath("./list"):
        list_id = list_elem.get("{}id".format(XML_NS))
        found_fact = list_elem.xpath("./fact[@xml:id = '{}']".format(
            list_id + '--startaddmore'), namespaces=ns)
        if found_fact:
            facts_basename = re.match(
                '^([a-z_\\-]*)_facts$', list_id).group(1).replace('_', '-')
            print(list_id, facts_basename)
            fact = found_fact[0]
            facts_to_add = []
            while fact is not None:
                facts_to_add.append(deepcopy(fact))
                fact = fact.getnext()
            print("\t{}".format(len(facts_to_add)))
            target_idx = target_list.index(
                target_list.xpath(
                    "./fortune[@id='{}']".format(
                        max_idxs_ids[facts_basename]))[0])
            full_name = FULL_NAMES[facts_basename]
            for idx, iter_fact in enumerate(facts_to_add):
                newidx = idx + max_idxs[facts_basename] + 1
                new_elem = etree.Element(
                    "fortune", id="{}-fact-{}-{}".format(
                        "shlomif",
                        facts_basename,
                        newidx
                        ))
                meta = etree.SubElement(new_elem, "meta")
                title = etree.SubElement(meta, "title")
                title.text = "Shlomi Fish’s {} Fact #{}".format(
                    full_name, newidx)
                quote = etree.SubElement(new_elem, "quote")
                quote.insert(0, iter_fact.xpath(
                    "./lang[@xml:lang='en-US']/body", namespaces=ns)[0])
                info = etree.SubElement(quote, "info")
                author = etree.SubElement(info, "author")
                author.text = "Shlomi Fish"
                work = etree.SubElement(
                    info,
                    "work",
                    href="http://www.shlomifish.org/" +
                    "humour/bits/facts/{}/".format(
                        full_name.replace(' ', '-')))
                work.text = ("{} Facts by " +
                             "Shlomi Fish and Friends").format(full_name)
                target_list.insert(target_idx+idx+1, new_elem)

    with open("./t2/humour/fortunes/shlomif-factoids.xml", "wb") as f:
        f.write(etree.tostring(target_root, pretty_print=True))


main()
