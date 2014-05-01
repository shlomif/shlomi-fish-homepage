package Contents;

use strict;

my $contents =
{
    'title' => "Web Publishing Using LAMP",
    'subs' =>
    [
        {
            'title' => "Introduction - What is LAMP?",
            'url' => "intro",
            'subs' =>
            [
                {
                    'title' => "L is...",
                    'url' => "L.html",
                },
                {
                    'title' => "A is...",
                    'url' => "A.html",
                },
                {
                    'title' => "M is...",
                    'url' => "M.html",
                },
                {
                    'title' => "P is...",
                    'url' => "P.html",
                },
                {
                    'title' => "Order of Importance",
                    'url' => "order_of_importance.html",
                },
            ],
        },
        {
            'title' => "What can you serve?",
            'url' => "what-serve",
            'subs' =>
            [
                {
                    'title' => "HTML",
                    'url' => "html.html",
                },
                {
                    'title' => "CSS",
                    'url' => "css",
                    'subs' =>
                    [
                        {
                            'title' => "CSS Layout and Positioning",
                            'url' => "layout.html",
                        },
                    ],
                },
                {
                    'title' => "Images",
                    'url' => "images.html",
                },
                {
                    'title' => "JavaScript",
                    'url' => "java-script.html",
                },
                {
                    'title' => "Frames",
                    'url' => "frames.html",
                },
                {
                    'title' => "Java (Client-Side)",
                    'url' => "java.html",
                },
                {
                    'title' => "Flash",
                    'url' => "flash.html",
                },
                {
                    'title' => "Dynamic HTML",
                    'url' => "dynamic-html.html",
                },
                {
                    'title' => "Media",
                    'url' => "media.html",
                },
            ]
        },
        {
            'title' => "What's on the server?",
            'url' => "server-technologies",
            'subs' =>
            [
                {
                    'title' => "How much Generated Content do you Need?",
                    'url' => "how-much.html",
                },
                {
                    'title' => "Overview of Common Server-Side Scripting Technologies",
                    'url' => "sss-overview",
                    'subs' =>
                    [
                        {
                            'title' => "Perl",
                            'url' => "perl.html",
                        },
                        {
                            'title' => "PHP",
                            'url' => "php.html",
                        },
                        {
                            'title' => "Python",
                            'url' => "python.html",
                        },
                        {
                            'title' => "Other Technologies",
                            'url' => "other",
                            'subs' =>
                            [
                                {
                                    'title' => "Ruby",
                                    'url' => "ruby.html",
                                },
                                {
                                    'title' => "OCaml",
                                    'url' => "ocaml.html",
                                },
                                {
                                    'title' => "Tcl",
                                    'url' => "tcl.html",
                                },
                                {
                                    'title' => "Java Server Pages (JSP)",
                                    'url' => "JSP.html",
                                },
                                {
                                    'title' => "Java Servelets",
                                    'url' => "servelets.html",
                                },
                                {
                                    'title' => "CGI, FastCGI C/C++ Scripts",
                                    'url' => "c-cgi.html",
                                },
                                {
                                    'title' => "Web-server Extensions",
                                    'url' => "extensions.html",
                                },
                                {
                                    'title' => "Writing your own Web-Server",
                                    'url' => "web-server.html",
                                },
                            ],
                        },
                    ],
                },
            ],
        },
        {
            'title' => "Content Management Systems",
            'url' => "cms",
            'subs' =>
            [
                {
                    'title' => "Examples of Server-Installed CMSes",
                    'url' => "server-installed.html",
                },
                {
                    'title' => "Examples of Content-Generating CMSes",
                    'url' => "content-generating.html",
                },
            ],
        },
        {
            'title' => "Databases",
            'url' => "databases",
            'subs' =>
            [
                {
                    'title' => "Overview of SQL Databases",
                    'url' => "sql.html",
                },
                {
                    'title' => "Non-SQL Databases",
                    'url' => "non-sql.html",
                },
                {
                    'title' => "Compatibility between Databases",
                    'url' => "compatibility.html",
                },
                {
                    'title' => "Do you need a Database?",
                    'url' => "necessity.html",
                },
            ],
        },
        {
            'title' => "Know your Enemy - Web Browsers Coverage",
            'url' => "web-browsers",
            'subs' =>
            [
                {
                    'title' => "Netscape Navigator 4.x",
                    'url' => "nn4.html",
                },
                {
                    'title' => "Internet Explorer 5.0, 5.5, 6.0",
                    'url' => "msie.html",
                },
                {
                    'title' => "Mozilla",
                    'url' => "mozilla.html",
                },
                {
                    'title' => "KHTML/Safari",
                    'url' => "khtml.html",
                },
                {
                    'title' => "Opera",
                    'url' => "opera.html",
                },
            ],
        },
        {
            'title' => "Designing for Compatibility",
            'url' => "compatibility",
            'subs' =>
            [
                {
                    'title' => "Why it is Important to Support non-MSIE Browsers",
                    'url' => "non-msie.html",
                },
                {
                    'title' => "Why it is Important to Keep Your Site Standards Compliant",
                    'url' => "standards.html",
                },
                {
                    'title' => "Why it is Important to Keep Your Site Clean of Unnecessary Embellishments",
                    'url' => "embellishments.html",
                },
                {
                    'title' => "Some Words of Wisdom",
                    'url' => "words-of-wisdom.html",
                },
            ],
        },
        {
            'title' => "Legal Notes",
            'url' => "legal-notes",
            'subs' =>
            [
                {
                    'title' => "Should you fear the GPL?",
                    'url' => "gpl.html",
                },
            ],
        },
    ],
    'images' =>
    [
        'style.css',
    ],
};

sub get_contents
{
    return $contents;
}

1;
