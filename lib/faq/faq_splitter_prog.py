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
<title>Shlomi Fish’s FAQ - {title}</title>
<meta charset="utf-8"/>
<meta name="description" content=
"Shlomi Fish’s Frequently Asked Questions (FAQ) List - {title}"/>
<link rel="stylesheet" href="{base_path}faq-indiv.css" media="screen" title=
"Normal"/>
<link rel="stylesheet" href="{base_path}print.css" media="print"/>
<link rel="shortcut icon" href="{base_path}favicon.ico" type=
"image/x-icon"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
</head>
<body class="faq_indiv_entry">
<div class="header" id="header">
<a href="{base_path}"><img src="{base_path}images/evilphish-flipped.png"
alt="EvilPHish site logo"/></a>
<div class="leading_path"><a href="{base_path}">Shlomi Fish’s
Homepage</a> → <a href="../" title=
"Information about this Site">Meta Info</a> → <a href="./" title=
"Frequently Asked Questions and Answers List (FAQ)">FAQ</a>
{breadcrumbs_trail}
→ <b>{title}</b>
</div>
</div>
<div id="faux">
<main class="main faq">
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

IMAGE_MACRO_SECTION_FORMAT = '''<?xml version="1.0" encoding="utf-8"?>
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


def generate_from_image_macros_page(
        OUT_DN, base_path, relative_output_dirname,
        path_to_all_in_one, path_to_images="",
        path_to_input="index.xhtml",):
    # full_out_dirname = OUT_DN + (output_dirname or '')
    # TOP_LEVEL_CLASS = 'article'
    XHTML_NS = XHTML_NAMESPACE
    XML_NS = "{http://www.w3.org/XML/1998/namespace}"
    ns = {
        "xhtml": XHTML_NS,
        "xml": XML_NS,
    }

    output_dirname = OUT_DN + "/" + relative_output_dirname
    splitter = XhtmlSplitter(
        input_fn=(OUT_DN + "/" + path_to_input),
        output_dirname=output_dirname,
        relative_output_dirname=relative_output_dirname,
        section_format=IMAGE_MACRO_SECTION_FORMAT,
        container_elem_xpath=(
            "//xhtml:div[./xhtml:article]"
        ),
        ns=ns,
        base_path=base_path,
        path_to_all_in_one=path_to_all_in_one,
        path_to_images=path_to_images,
    )
    splitter.process()


def gen_image_macros_call():
    generate_from_image_macros_page(
        OUT_DN="./dest/post-incs/t2/humour/image-macros/",
        base_path=("../" * 3),
        relative_output_dirname="indiv-nodes/",
        path_to_all_in_one="../",
        path_to_input="./index.xhtml",
        # path_to_images="../../../images/",
    )


def main():
    OUT_DN = "./dest/post-incs/t2/meta/FAQ"
    TOP_LEVEL_CLASS = 'faq fancy_sects lim_width wrap-me'
    XHTML_NS = XHTML_NAMESPACE
    XML_NS = "{http://www.w3.org/XML/1998/namespace}"
    ns = {
        "xhtml": XHTML_NS,
        "xml": XML_NS,
    }

    splitter = XhtmlSplitter(
        input_fn=(OUT_DN + "/index.xhtml"),
        output_dirname=OUT_DN,
        section_format=FAQ_SECTION_FORMAT,
        container_elem_xpath=("//xhtml:div[@class='" + TOP_LEVEL_CLASS + "']"),
        ns=ns,
    )
    splitter.process()
    gen_image_macros_call()


if __name__ == '__main__':
    main()
