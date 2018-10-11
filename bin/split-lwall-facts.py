#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""

"""
import re

lines = open('t2/humour/fortunes/shlomif-factoids.xml', 'r').readlines()[
        3187:3227]
s = ''.join(lines)

matches = re.findall('<li>(.*?)</li>', s, re.S)
n = 2
for x in matches:
    print(
        ('''
      <fortune id="shlomif-fact-larry-wall-fact-%(n)d">
          <meta>
              <title>Shlomi Fish’s Larry Wall Fact #%(n)d</title>
          </meta>
          <quote>
              <body>
              <p>
                %(x)s
              </p>
              </body>
              <info>
                  <author>Shlomi Fish</author>
                  <work href="http://www.shlomifish.org/humour/bits/''' +
         'facts/Larry-Wall/">Shlomif Fish’s "Larry Wall Facts"</work>' +
            "\n</info>\n</quote>\n</fortune>\n"
         ) % {'n': n, 'x': x.strip(), }
    )
    n += 1
