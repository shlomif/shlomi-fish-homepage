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

from lxml.html import XHTML_NAMESPACE

from split_into_sections import XhtmlSplitter


# Removed:
# <script src="{base_path}js/main_all.js"></script>
FAQ_SECTION_FORMAT = '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>{main_title} - {title}</title>
<meta charset="utf-8"/>
<meta name="description" content=
"{main_title} - {title}"/>
<link rel="stylesheet" href="{base_path}faq-indiv.css" media="screen"/>
<link rel="stylesheet" href="{base_path}screenplay.css" media="screen"
title="Normal"/>
<link rel="stylesheet" href="{base_path}print.css" media="print"/>
<link rel="shortcut icon" href="{base_path}favicon.ico" type=
"image/x-icon"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
</head>
<body class="faq_indiv_entry screenplay_indiv_entry">
<div class="header" id="header">
<a href="{base_path}"><img src="{base_path}images/evilphish-flipped.png"
alt="EvilPHish site logo"/></a>
<div class="leading_path"><a href="{base_path}">Shlomi Fish’s
Homepage</a> → <a href="./" title="{main_title}">{main_title}</a>
{breadcrumbs_trail}
→ <b>{title}</b>
</div>
</div>
<div id="faux">
<main class="main faq screenplay">
{body}</main>
</div>
<footer>
<div class="foot_left">
<ul class="bt_nav">
<li><a href="{base_path}">Home</a></li>
<li><a href="{base_path}me/">About</a></li>
<li><a href="{base_path}me/contact-me/">Contact Us</a></li>
<li><a href="{base_path}meta/privacy-policy/">Privacy Policy</a></li>
<li><a href="{base_path}meta/anti-spam-policy/">Anti-Spam
Policy</a></li>
<li><a href="{base_path}meta/FAQ/" title=
"Frequently asked questions list">FAQ</a></li>
<li><a href="{base_path}me/blogs/">RSS/Atom Feeds</a></li>
</ul>
<p>Written, designed, and maintained by Shlomi Fish, <a href=
"mailto:shlomif@shlomifish.org">shlomif@shlomifish.org</a>.</p>
</div>
<a href="{base_path}"><img src="{base_path}images/bk2hp-v2.min.svg" class=
"bk2hp" alt="Back to my Homepage"/></a></footer>
</body>
</html>'''


def generic_generate(OUT_DN, base_path, output_dirname, path_to_all_in_one):
    output_dirname = OUT_DN + \
        ("" if output_dirname is None else output_dirname)
    TOP_LEVEL_CLASS = 'screenplay'
    XHTML_NS = XHTML_NAMESPACE
    XML_NS = "{http://www.w3.org/XML/1998/namespace}"
    ns = {
        "xhtml": XHTML_NS,
        "xml": XML_NS,
    }
    XHTML_SECTION_TAG = '{' + XHTML_NAMESPACE + '}section'

    splitter = XhtmlSplitter(
        input_fn=(OUT_DN + "/ongoing-text.html"),
        output_dirname=output_dirname,
        section_format=FAQ_SECTION_FORMAT,
        container_elem_xpath=("//xhtml:div[@class='" + TOP_LEVEL_CLASS + "']"),
        ns=ns,
        xhtml_section_tag=XHTML_SECTION_TAG,
        base_path=base_path,
        path_to_all_in_one=path_to_all_in_one,
    )
    splitter.process()


def generate(**args):
    return generic_generate(
            OUT_DN="./dest/post-incs/t2/humour/Summerschool-at-the-NSA/",
            **args,
    )


def generate_selina(**args):
    return generic_generate(
            OUT_DN="./dest/post-incs/t2/humour/Selina-Mandrake/",
            **args,
    )


def main():
    generate(
        base_path=None,
        output_dirname=None,
        path_to_all_in_one="./ongoing-text.html",
    )
    generate(
        base_path=("../"*3),
        output_dirname="temp2del/",
        path_to_all_in_one="../ongoing-text.html",
    )
    generate_selina(
        base_path=("../"*3),
        output_dirname="temp2del/",
        path_to_all_in_one="../ongoing-text.html",
    )


if __name__ == '__main__':
    main()
