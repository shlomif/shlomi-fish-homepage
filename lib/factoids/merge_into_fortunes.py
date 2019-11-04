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


def main():
    root = etree.parse("./lib/factoids/shlomif-factoids-lists.xml")
    target_root = etree.parse("./t2/humour/fortunes/shlomif-factoids.xml")
    max_idxs = defaultdict(int)
    for targetelem in target_root.xpath("./list/fortune"):
        id_ = targetelem.get("id")
        match = re.match("^[a-z\\-]+-fact-([a-z]+)-([0-9]+)$", id_)
        if match:
            category = match.group(1)
            idx = int(match.group(2))
            max_idxs[category] = max(max_idxs[category], idx)
            print('ID: {} cat: {} idx: {}'.format(id_, category, idx))
    print(max_idxs)
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


main()
