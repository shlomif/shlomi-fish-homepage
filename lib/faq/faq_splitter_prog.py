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

from split_into_sections import XHTML_ARTICLE_TAG
from split_into_sections import XHTML_SECTION_TAG
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
<body class="fancy_sects faq_indiv_entry">
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
<main class="faq faux main">
{body}</main>
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
<link rel="stylesheet" href="{base_path}print.css" media="print"/>
<link rel="shortcut icon" href="{base_path}favicon.ico" type=
"image/x-icon"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
</head>
<body class="fancy_sects faq_indiv_entry">
<div class="header" id="header">
<a href="{base_path}"><img src="{base_path}images/evilphish-flipped.png"
alt="EvilPHish site logo"/></a>
<div class="leading_path"><a href="{base_path}">Shlomi Fish’s
Homepage</a> →
<a href="{path_to_all_in_one}" title="{main_title}">{main_title}</a>
{breadcrumbs_trail}
→ <b>{title}</b>
</div>
</div>
<main class="faq faux main">
{body}</main>
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

BACK_TO_SOURCE_PAGE_CSS_CLASS = "back_to_faq"
INDIVIDUAL_NODE_CSS_CLASS = "indiv_node"


def _wrap(ns):
    return ns
    return '{' + ns + '}'


XML_NS = "http://www.w3.org/XML/1998/namespace"
NAMESPACES = {
    "xhtml": _wrap(XHTML_NAMESPACE),
    "xml": _wrap(XML_NS),
}


def generate_from_image_macros_page(
        OUT_DN, base_path, relative_output_dirname,
        path_to_all_in_one, path_to_images="",
        path_to_input="index.xhtml",):
    # full_out_dirname = OUT_DN + (output_dirname or '')
    # TOP_LEVEL_CLASS = 'article'

    output_dirname = OUT_DN + "/" + relative_output_dirname
    splitter = XhtmlSplitter(
        back_to_source_page_css_class=BACK_TO_SOURCE_PAGE_CSS_CLASS,
        individual_node_css_class=INDIVIDUAL_NODE_CSS_CLASS,
        input_fn=(OUT_DN + "/" + path_to_input),
        output_dirname=output_dirname,
        relative_output_dirname=relative_output_dirname,
        section_format=IMAGE_MACRO_SECTION_FORMAT,
        container_elem_xpath=(
            "//xhtml:div[./xhtml:article]"
        ),
        ns=NAMESPACES,
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
        path_to_images="../",
        # path_to_images="",
    )


def main():
    _faq_gen()
    gen_image_macros_call()
    _screenplays_main()


def _faq_gen():
    # XHTML_NS = '{' + XHTML_NAMESPACE + '}'
    OUT_DN = "./dest/post-incs/t2/meta/FAQ"
    TOP_LEVEL_CLASS = 'faq fancy_sects lim_width wrap-me'
    splitter = XhtmlSplitter(
        back_to_source_page_css_class=BACK_TO_SOURCE_PAGE_CSS_CLASS,
        individual_node_css_class=INDIVIDUAL_NODE_CSS_CLASS,
        input_fn=(OUT_DN + "/index.xhtml"),
        output_dirname=OUT_DN,
        section_format=FAQ_SECTION_FORMAT,
        container_elem_xpath=("//xhtml:div[@class='" + TOP_LEVEL_CLASS + "']"),
        ns=NAMESPACES,
    )
    splitter.process()


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
<body class="fancy_sects faq_indiv_entry screenplay_indiv_entry">
<div class="header" id="header">
<a href="{base_path}"><img src="{base_path}images/evilphish-flipped.png"
alt="EvilPHish site logo"/></a>
<div class="leading_path"><a href="{base_path}">Shlomi Fish’s
Homepage</a> →
<a href="{path_to_all_in_one}" title="{main_title}">{main_title}</a>
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


def generic_generate_from_(
        container_elem_xpath,
        OUT_DN, base_path, output_dirname,
        path_to_all_in_one, path_to_images="",
        path_to_input="ongoing-text.html", latemp_plain_html=False,
        xhtml_article_tag=XHTML_ARTICLE_TAG,
        xhtml_section_tag=XHTML_SECTION_TAG,
        ):
    full_out_dirname = OUT_DN + (output_dirname or '')

    splitter = XhtmlSplitter(
        back_to_source_page_css_class=BACK_TO_SOURCE_PAGE_CSS_CLASS,
        individual_node_css_class=INDIVIDUAL_NODE_CSS_CLASS,
        container_elem_xpath=container_elem_xpath,
        input_fn=(OUT_DN + "/" + path_to_input),
        output_dirname=full_out_dirname,
        section_format=SCREENPLAY_SECTION_FORMAT,
        ns=NAMESPACES,
        base_path=base_path,
        path_to_all_in_one=path_to_all_in_one,
        path_to_images=path_to_images,
        relative_output_dirname=output_dirname,
        latemp_plain_html=latemp_plain_html,
        xhtml_article_tag=xhtml_article_tag,
        xhtml_section_tag=xhtml_section_tag,
    )
    splitter.process()


def generic_generate(
        OUT_DN, output_dirname,
        path_to_all_in_one, path_to_images="",
        path_to_input="ongoing-text.html",):
    base_path = '../' * (OUT_DN.count('/') - 3)
    full_out_dirname = OUT_DN + (output_dirname or '')
    TOP_LEVEL_CLASS = 'screenplay'

    splitter = XhtmlSplitter(
        back_to_source_page_css_class=BACK_TO_SOURCE_PAGE_CSS_CLASS,
        individual_node_css_class=INDIVIDUAL_NODE_CSS_CLASS,
        input_fn=(OUT_DN + "/" + path_to_input),
        output_dirname=full_out_dirname,
        relative_output_dirname=output_dirname,
        section_format=SCREENPLAY_SECTION_FORMAT,
        container_elem_xpath=("//xhtml:div[@class='" + TOP_LEVEL_CLASS + "']"),
        ns=NAMESPACES,
        base_path=base_path,
        path_to_all_in_one=path_to_all_in_one,
        path_to_images=path_to_images,
    )
    splitter.process()


def generic_generate_from_tt2_generated_plain_html5(**args):
    TOP_LEVEL_ID = 'main_text_wrapper'
    return generic_generate_from_(
        container_elem_xpath=("//div[@id='" + TOP_LEVEL_ID + "']"),
        latemp_plain_html=True,
        xhtml_article_tag='article',
        xhtml_section_tag='section',
        **args,
    )


def generic_generate_from_tt2_generated_xhtml5(**args):
    TOP_LEVEL_ID = 'main_text_wrapper'
    return generic_generate_from_(
        container_elem_xpath=("//xhtml:div[@id='" + TOP_LEVEL_ID + "']"),
        **args,
    )


def _screenplays_main():
    for OUT_DN in [
        "./dest/post-incs/t2/humour/Buffy/A-Few-Good-Slayers/",
        "./dest/post-incs/t2/humour/Selina-Mandrake/",
        "./dest/post-incs/t2/humour/So-Who-The-Hell-Is-Qoheleth/",
        "./dest/post-incs/t2/humour/Star-Trek/We-the-Living-Dead/",
        "./dest/post-incs/t2/humour/Summerschool-at-the-NSA/",
        "./dest/post-incs/t2/humour/Terminator/Liberation/",
        "./dest/post-incs/t2/humour/humanity/",
            ]:
        generic_generate(
            OUT_DN=OUT_DN,
            output_dirname="indiv-nodes/",
            path_to_all_in_one="../ongoing-text.html",
            path_to_images="../",
        )

    for OUT_DN in [
        "./dest/post-incs/t2/humour/TOneW-the-Fountainhead/",
            ]:
        for part in [1, 2]:
            path_to_input = "TOW_Fountainhead_{}.html".format(part)
            generic_generate(
                OUT_DN=OUT_DN,
                output_dirname="part{}-indiv-nodes/".format(part),
                path_to_input=path_to_input,
                path_to_all_in_one=("../" + path_to_input),
                path_to_images="../",
            )

    for OUT_DN in [
        "./dest/post-incs/t2/humour/Blue-Rabbit-Log/",
            ]:
        for part in [1]:
            path_to_input = "part-{}.html".format(part)
            generic_generate(
                OUT_DN=OUT_DN,
                output_dirname="part-{}-indiv-nodes/".format(part),
                path_to_input=path_to_input,
                path_to_all_in_one=("../" + path_to_input),
                path_to_images="../",
            )

    for OUT_DN in [
        "./dest/post-incs/t2/humour/Queen-Padme-Tales/",
            ]:
        for part_suf in [
            "Planting-Trees",
            "Queen-Amidala-vs-the-Klingon-Warriors",
                ]:
            part = "Queen-Padme-Tales--" + part_suf
            path_to_input = "{}.html".format(part)
            generic_generate(
                OUT_DN=OUT_DN,
                output_dirname="{}-indiv-nodes/".format(part),
                path_to_input=path_to_input,
                path_to_all_in_one=("../" + path_to_input),
                path_to_images="../",
            )

    for OUT_DN in [
        "./dest/post-incs/t2/humour/Muppets-Show-TNI/",
            ]:
        for part in [
                "Harry-Potter",
                "Jennifer-Lawrence",
                "Summer-Glau-and-Chuck-Norris",
                ]:
            path_to_input = "{}.html".format(part)
            generic_generate(
                OUT_DN=OUT_DN,
                output_dirname="{}-indiv-nodes/".format(part),
                path_to_input=path_to_input,
                path_to_all_in_one=("../" + path_to_input),
                path_to_images="../",
            )

    generic_generate_from_tt2_generated_plain_html5(
        OUT_DN=("./dest/post-incs/t2/philosophy/culture/" +
                "case-for-commercial-fan-fiction/"),
        base_path=("../" * 4),
        output_dirname="indiv-nodes/",
        path_to_all_in_one="../",
        path_to_input="./index.xhtml",
        path_to_images="./",
    )


def generic_generate_from_db5(**args):
    TOP_LEVEL_CLASS = 'article'
    return generic_generate_from_(
        container_elem_xpath=(
            "//xhtml:section[@class='" + TOP_LEVEL_CLASS + "']"
        ),
        **args,
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
