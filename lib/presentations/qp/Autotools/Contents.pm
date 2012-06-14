package Contents;

use strict;

my $contents =
{
    'title' => "GNU Autoconf, Automake and Libtool",
    'subs' =>
    [
        {
            'url' => "intro.html",
            'title' => "Introduction",
        },
        {
            'url' => "how_it_fits.html",
            'title' => "How it all fits together",
        },
        {
            'url' => "simple_project",
            'title' => "A Simple Project",
            'subs' =>
            [
                {
                    'url' => "Makefile.am.html",
                    'title' => "The Makefile.am file",
                },
                {
                    'url' => "configure.in.html",
                    'title' => "The configure.in file",
                },
            ],
        },
        {
            'url' => "common_macros",
            'title' => "Commonly Used configure.in macros",
            'subs' =>
            [
                {
                    'url' => "AC_DEFINE.html",
                    'title' => "AC_DEFINE",
                },
                {
                    'url' => "AC_CHECK_LIB.html",
                    'title' => "AC_CHECK_LIB",
                },
                {
                    'url' => "AC_ARG_ENABLE.html",
                    'title' => "AC_ARG_ENABLE",
                },
                {
                    'url' => "AC_OUTPUT.html",
                    'title' => "AC_OUTPUT",
                },
                {
                    'url' => "AC_CHECK_FUNCS.html",
                    'title' => "AC_CHECK_FUNCS",
                },
                {
                    'url' => "AC_CHECK_HEADERS.html",
                    'title' => "AC_CHECK_HEADERS",
                },
            ],
        },
        {
            'url' => "changequote.html",
            'title' => "Using changequote",
        },
        {
            'url' => "Makefile_am",
            'title' => "Format of the Makefile.am File",
            'subs' =>
            [
                {
                    'url' => "super.html",
                    'title' => "Super Targets",
                },
                {
                    'url' => "sources.html",
                    'title' => "Specifying the source files",
                },
                {
                    'url' => "ldadd.html",
                    'title' => "Linking with internal libraries",
                },
                {
                    'url' => "headers.html",
                    'title' => "Library Headers",
                },
                {
                    'url' => "extra_dist.html",
                    'title' => "EXTRA_DIST",
                },
                {
                    'url' => "plain.html",
                    'title' => "Plain Rules",
                },
                {
                    'url' => "lt-version.html",
                    'title' => "Libtool Library Versioning",
                },
            ],
        },
        {
            'url' => "acconfig.h",
            'title' => "Format of acconfig.h",
            'subs' =>
            [
                {
                    'url' => "example.html",
                    'title' => "Example",
                },
            ],
        },
        {
            'url' => "issues",
            'title' => "Various Issues",
            'subs' =>
            [
                {
                    'url' => "sub-dir.html",
                    'title' => "Creating a Sub-Directory with a Different Configuration",
                },
                {
                    'url' => "mylib-config.html",
                    'title' => "mylibrary-config program",
                },
                {
                    'url' => "rpm-spec.html",
                    'title' => "Creating an RPM Spec",
                },
            ],
        },
        {
            'url' => "links.html",
            'title' => "Links and References",
        },
    ],
    'images' =>
    [
        'acconfig.h/acconfig.h',
        'changequote/configure.in',
        'common_macros/AC_ARG_ENABLE/configure.in',
        'common_macros/AC_CHECK_LIB/configure.in',
        'common_macros/AC_DEFINE/configure.in',
        'common_macros/AC_OUTPUT/configure.in',
        'Makefile_am/sources/Makefile.am',
        'processing-diagram.png',
        'simple_project/configure.in',
        'simple_project/Makefile.am',
        'style.css',
    ],
};

sub get_contents
{
    return $contents;
}
