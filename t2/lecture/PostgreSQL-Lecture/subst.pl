use strict;
use warnings;

use IO::All;

my $header = io()->file("header.txt")->slurp();

foreach my $f (glob("*.html"))
{
    print "\$f == $f\n";
    my $text = io()->file($f)->slurp();

    $text =~ s{</head>}{<link rel="stylesheet" href="style.css" type="text/css" media="screen, projection" title="Normal" />\n</head>};
    $text =~ s{<body bgcolor="#FFFFFF">}{<body>};

    io()->file($f)->print($text);
}
