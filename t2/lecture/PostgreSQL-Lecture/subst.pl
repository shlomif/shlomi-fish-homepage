use strict;
use warnings;

use Path::Tiny qw/ path /;

my $header = path("header.txt")->slurp_utf8;

foreach my $f ( glob("*.html") )
{
    print "\$f == $f\n";
    my $text = path($f)->slurp_utf8;

    $text =~
s{</head>}{<link rel="stylesheet" href="style.css" type="text/css" media="screen" title="Normal" />\n</head>};
    $text =~ s{<body bgcolor="#FFFFFF">}{<body>};

    path($f)->spew_utf8($text);
}
