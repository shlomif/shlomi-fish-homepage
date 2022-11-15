#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

"""

"""

import re

import click

from lxml import etree


@click.command()
@click.option('--input', required=True, type=str,
              help='The number of sides in each die')
@click.option('--output', required=True, type=str,
              help='The number of sides in each die')
def main(input, output):
    ns = {"svg": "http://www.w3.org/2000/svg", }
    with open(input, "rb") as fh:
        xml = fh.read()
    root = etree.XML(xml)
    el = root.xpath(
        ".//svg:path",
        namespaces=ns,
    )[0]
    css = el.get("style")
    newcss = re.sub("(stroke:)[^;]+(;|\\Z)", "\\1black\\2", css)
    el.set("style", newcss)
    text = etree.tostring(root)
    with open(output, "wb") as ofh:
        ofh.write(text)


if __name__ == '__main__':
    main()
