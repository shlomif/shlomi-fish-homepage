#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use IO::All qw/ io /;
use XML::LibXML;

my $dom = XML::LibXML->load_xml(
    location =>
    'lib/pages/t2/philosophy/putting-all-cards-on-the-table.xhtml'
);

sub _xpc
{
    my $node = shift;

    my $xpc = XML::LibXML::XPathContext->new($node);

    $xpc->registerNs('xhtml', 'http://www.w3.org/1999/xhtml');

    return $xpc;
}


my @nodes = _xpc($dom)->findnodes(q{//xhtml:div[@class='section']});

# print @nodes;
#
foreach my $sect (@nodes)
{
    my $id = _xpc($sect)->findvalue(q{xhtml:h2/@id});
    my $title = _xpc($sect)->findnodes(q{xhtml:h2})->[0]->textContent;

    io->file(
        qq#dest/t2/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/$id.xhtml#,
    )->utf8->print(<<"EOF");
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>Section «$title» of Putting all the Cards on the Table (2003)</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="author" content="Shlomi Fish" />
<meta name="keywords" content="" />
<style type="text/css">
a:hover { background-color: palegreen;}
</style>
</head>
<body>

@{[$sect->toString()]}

</body>
</html>
EOF

}
