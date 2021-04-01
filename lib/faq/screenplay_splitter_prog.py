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


SCREENPLAY_SECTION_FORMAT = '''<?xml version="1.0" encoding="utf-8"?>
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


def generic_generate(
        OUT_DN, output_dirname,
        path_to_all_in_one, path_to_images="",
        path_to_input="ongoing-text.html",):
    base_path = '../' * (OUT_DN.count('/') - 3)
    full_out_dirname = OUT_DN + (output_dirname or '')
    TOP_LEVEL_CLASS = 'screenplay'
    XHTML_NS = XHTML_NAMESPACE
    XML_NS = "{http://www.w3.org/XML/1998/namespace}"
    ns = {
        "xhtml": XHTML_NS,
        "xml": XML_NS,
    }

    splitter = XhtmlSplitter(
        input_fn=(OUT_DN + "/" + path_to_input),
        output_dirname=full_out_dirname,
        section_format=SCREENPLAY_SECTION_FORMAT,
        container_elem_xpath=("//xhtml:div[@class='" + TOP_LEVEL_CLASS + "']"),
        ns=ns,
        base_path=base_path,
        path_to_all_in_one=path_to_all_in_one,
        path_to_images=path_to_images,
    )
    splitter.process()


def generic_generate_from_tt2_generated_xhtml5(**args):
    TOP_LEVEL_ID = 'main_text_wrapper'
    return generic_generate_from_(
        container_elem_xpath=("//xhtml:div[@id='" + TOP_LEVEL_ID + "']"),
        **args,
    )


def generic_generate_from_db5(**args):
    TOP_LEVEL_CLASS = 'article'
    return generic_generate_from_(
        container_elem_xpath=(
            "//xhtml:section[@class='" + TOP_LEVEL_CLASS + "']"
        ),
        **args,
    )


def generic_generate_from_(
        container_elem_xpath,
        OUT_DN, base_path, output_dirname,
        path_to_all_in_one, path_to_images="",
        path_to_input="ongoing-text.html",):
    full_out_dirname = OUT_DN + (output_dirname or '')
    XHTML_NS = XHTML_NAMESPACE
    XML_NS = "{http://www.w3.org/XML/1998/namespace}"
    ns = {
        "xhtml": XHTML_NS,
        "xml": XML_NS,
    }

    splitter = XhtmlSplitter(
        container_elem_xpath=container_elem_xpath,
        input_fn=(OUT_DN + "/" + path_to_input),
        output_dirname=full_out_dirname,
        section_format=SCREENPLAY_SECTION_FORMAT,
        ns=ns,
        base_path=base_path,
        path_to_all_in_one=path_to_all_in_one,
        path_to_images=path_to_images,
    )
    splitter.process()


def main():
    generic_generate(
        OUT_DN="./dest/post-incs/t2/humour/Summerschool-at-the-NSA/",
        output_dirname="indiv-nodes/",
        path_to_all_in_one="../ongoing-text.html",
    )
    generic_generate(
        OUT_DN="./dest/post-incs/t2/humour/Selina-Mandrake/",
        output_dirname="temp2del/",
        path_to_all_in_one="../ongoing-text.html",
    )
    generic_generate(
        OUT_DN="./dest/post-incs/t2/humour/Terminator/Liberation/",
        output_dirname="temp2del/",
        path_to_all_in_one="../ongoing-text.html",
        path_to_images="../",
    )
    generic_generate(
        OUT_DN="./dest/post-incs/t2/humour/Muppets-Show-TNI/",
        output_dirname="temp2del/",
        path_to_all_in_one="../Summer-Glau-and-Chuck-Norris.html",
        path_to_input="Summer-Glau-and-Chuck-Norris.html",
        path_to_images="../",
    )
    generic_generate_from_tt2_generated_xhtml5(
        OUT_DN=("./dest/post-incs/t2/philosophy/culture/" +
                "case-for-commercial-fan-fiction/"),
        base_path=("../" * 4),
        output_dirname="indiv-nodes/",
        path_to_all_in_one="../",
        path_to_input="./index.xhtml",
        path_to_images="./",
    )


def sample_docbook5_call__disabled():
    generic_generate_from_db5(
        OUT_DN="./dest/post-incs/t2/philosophy" +
        "/philosophy/putting-all-cards-on-the-table-2013/",
        base_path=("../" * 3),
        output_dirname="temp2del/",
        path_to_all_in_one="./DocBook5" +
        "/putting-all-cards-on-the-table-2013.raw.html",
        path_to_input="./DocBook5" +
        "/putting-all-cards-on-the-table-2013.raw.html",
        path_to_images="./",
    )


if __name__ == '__main__':
    main()
