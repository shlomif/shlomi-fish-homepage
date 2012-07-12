package Contents;

use strict;

my $contents =
{
    'title' => "WebMetaLecture - a lecture about WebMetaLanguage",
    'subs' =>
    [
        {
            'url' => "intro.html",
            'title' => "Introduction",
        },
        {
            'url' => "why_static_html.html",
            'title' => "Why Static HTML?",
        },
        {
            'url' => "methodology.html",
            'title' => "The WML Methodology",
        },
        {
            'url' => "html_is_wml.html",
            'title' => "HTML is WML!",
        },
        {
            'url' => "common_look",
            'title' => "Example 1 : Common Look and Feel",
            'subs' =>
            [
                {
                    'url' => "template.html",
                    'title' => "The Template File",
                },
                {
                    'url' => "pages.html",
                    'title' => "The Individual Pages",
                },
                {
                    'url' => "makefile.html",
                    'title' => "The Makefile",
                },
                {
                    'url' => "final.html",
                    'title' => "The Final Site",
                },
            ],
        },
        {
            'url' => "bolding",
            'title' => "Example 2 : Bolding the NavBar entry of the Existing Page",
            'subs' =>
            [
                {
                    'url' => "template.html",
                    'title' => "The New Template File",
                },
                {
                    'url' => "final.html",
                    'title' => "The New Final Site",
                },
            ],
        },
        {
            'url' => "meta-tag",
            'title' => "Example 3 : Creating a Meta-Tag",
            'subs' =>
            [
                {
                    'url' => "template.html",
                    'title' => "The New Template File",
                },
                {
                    'url' => "final.html",
                    'title' => "The Final Site",
                },
            ],
        },
        {
            'url' => "frames",
            'title' => "Example 4 : Frames-Enabled and Non-Frames-Enabled Sites",
            'subs' =>
            [
                {
                    'url' => "makefile.html",
                    'title' => "The Modified Makefile",
                },
                {
                    'url' => "navbar.html",
                    'title' => "New File: navbar.wml",
                },
                {
                    'url' => "template.html",
                    'title' => "The Modified Template",
                },
                {
                    'url' => "navbar-frame.html",
                    'title' => "navbar-frame.html.wml",
                },
                {
                    'url' => "final.html",
                    'title' => "The Final Site",
                },
            ],
        },
        {
            'url' => "faq-l",
            'title' => "Example 5 : An FAQ List",
            'subs' =>
            [
                {
                    'url' => "questions.html",
                    'title' => "questions.wml - the data",
                },
                {
                    'url' => "api.html",
                    'title' => "api.wml - the code",
                },
                {
                    'url' => "index_answers.html",
                    'title' => "index.html.wml and answers.html.wml",
                },
                {
                    'url' => "result.html",
                    'title' => "The Result",
                },
            ],
        },
        {
            'url' => "apis",
            'title' => "Demonstrating Some APIs",
            'subs' =>
            [
                {
                    'url' => "grid.html",
                    'title' => "grid",
                },
                {

                    'url' => "toc.html",
                    'title' => "toc",
                },
            ],
        },
    ],
    'images' =>
    [
        'style.css',
        qw(
        examples/APIs/grid/index.html.wml
        examples/APIs/grid/index.html.wml.html
        examples/APIs/toc/index.html
        examples/APIs/toc/index.html.wml
        examples/APIs/toc/index.html.wml.html
        examples/APIs/toc/Makefile
        examples/bolding/dest/download.html
        examples/bolding/dest/index.html
        examples/bolding/dest/links.html
        examples/bolding/dest/my-document.pdf
        examples/bolding/dest/my-non-existent-archive.tar.gz
        examples/bolding/dest/style.css
        examples/bolding/download.html.wml
        examples/bolding/index.html.wml
        examples/bolding/links.html.wml
        examples/bolding/Makefile
        examples/bolding/style.css
        examples/bolding/template.wml
        examples/bolding/template.wml.html
        examples/bolding/upload.sh
        examples/common_look/dest/download.html
        examples/common_look/dest/index.html
        examples/common_look/dest/links.html
        examples/common_look/dest/my-document.pdf
        examples/common_look/dest/my-non-existent-archive.tar.gz
        examples/common_look/dest/style.css
        examples/common_look/download.html.wml
        examples/common_look/download.html.wml.html
        examples/common_look/index.html.wml
        examples/common_look/index.html.wml.html
        examples/common_look/links.html.wml
        examples/common_look/links.html.wml.html
        examples/common_look/Makefile
        examples/common_look/Makefile.html
        examples/common_look/style.css
        examples/common_look/template.wml
        examples/common_look/template.wml.html
        examples/common_look/upload.sh
        examples/faq-l/answers.html
        examples/faq-l/answers.html.wml
        examples/faq-l/answers.html.wml.html
        examples/faq-l/api.wml
        examples/faq-l/api.wml.html
        examples/faq-l/index.html
        examples/faq-l/index.html.wml
        examples/faq-l/index.html.wml.html
        examples/faq-l/Makefile
        examples/faq-l/questions.wml
        examples/faq-l/questions.wml.html
        examples/faq-l/upload.sh
        examples/frames/dest/download.html
        examples/frames/dest/download.html.frames.html
        examples/frames/dest/frames.html
        examples/frames/dest/index.html
        examples/frames/dest/index.html.frames.html
        examples/frames/dest/links.html
        examples/frames/dest/links.html.frames.html
        examples/frames/dest/my-document.pdf
        examples/frames/dest/my-non-existent-archive.tar.gz
        examples/frames/dest/navbar-frame.html
        examples/frames/dest/style.css
        examples/frames/download.html.wml
        examples/frames/frames.html
        examples/frames/index.html.wml
        examples/frames/links.html.wml
        examples/frames/Makefile
        examples/frames/Makefile.html
        examples/frames/navbar-frame.html.wml
        examples/frames/navbar-frame.html.wml.html
        examples/frames/navbar.wml
        examples/frames/navbar.wml.html
        examples/frames/style.css
        examples/frames/template.wml
        examples/frames/template.wml.html
        examples/frames/upload.sh
        examples/meta-tag/dest/download.html
        examples/meta-tag/dest/index.html
        examples/meta-tag/dest/links.html
        examples/meta-tag/dest/my-document.pdf
        examples/meta-tag/dest/my-non-existent-archive.tar.gz
        examples/meta-tag/dest/style.css
        examples/meta-tag/download.html.wml
        examples/meta-tag/index.html.wml
        examples/meta-tag/links.html.wml
        examples/meta-tag/Makefile
        examples/meta-tag/style.css
        examples/meta-tag/template.wml
        examples/meta-tag/template.wml.html
        examples/meta-tag/upload.sh
        examples/upload-all.sh
        )
    ],
};

sub get_contents
{
    return $contents;
}

