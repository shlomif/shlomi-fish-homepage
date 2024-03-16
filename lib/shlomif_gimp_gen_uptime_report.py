#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2017 Brad Jones
#
# Licensed under the terms of the MIT license.

"""

NOTE!!! Currently this program is work-in-progress and does not do the right
thing, and I have problems running gimp's "python-fu-eval" on my Fedora 39
x86-64 system.

Based on https://www.makeuseof.com/tag/automating-gimp-scripts/ . Thanks!

"""

# from gimpfu import *

from gimpfu import gimp
from gimpfu import main
from gimpfu import pdb
from gimpfu import PF_FONT
from gimpfu import PF_SPINNER
from gimpfu import PF_STRING
from gimpfu import PIXELS
from gimpfu import register
from gimpfu import RGB


def _my_gimp_quit(arg):
    pdb.gimp_quit(arg)


def test_script(customtext, font, size):
    img = gimp.Image(1, 1, RGB)
    layer = pdb.gimp_text_fontname(
        img, None, 0, 0, customtext, 10, True, size, PIXELS, font
    )
    img.resize(layer.width, layer.height, 0, 0)
    gimp.Display(img)
    gimp.displays_flush()


register(
    "python_test",
    "TEST",
    "TEST",
    "Brad Jones",
    "Brad Jones",
    "2017",
    "TEST",
    "",
    [
        (PF_STRING, "customtext", "Text string", 'Scripting is handy!'),
        (PF_FONT, "font", "Font", "Sans"),
        (PF_SPINNER, "size", "Font size", 100, (1, 3000, 1)),
    ],
    [],
    test_script, menu="<Image>/File/Create"
)

main()
