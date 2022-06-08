#!/usr/bin/env perl

use strict;
use warnings;
use lib './lib';

use utf8;

use Path::Tiny qw/ path /;
use XML::LibXML                ();
use HTML::Latemp::Local::Paths ();
use Shlomif::DocBookClean      ();

my $PRE_DEST = HTML::Latemp::Local::Paths->new->t2_pre_dest;
my $dom      = XML::LibXML->load_xml( location =>
        'lib/pages/t2/philosophy/putting-all-cards-on-the-table.xhtml' );

sub _xpc
{
    my $node = shift;

    my $xpc = XML::LibXML::XPathContext->new($node);

    $xpc->registerNs( 'xhtml', 'http://www.w3.org/1999/xhtml' );

    return $xpc;
}
my $xpc   = _xpc($dom);
my @nodes = $xpc->findnodes(q{//xhtml:div[@class='section']});

# print @nodes;
#
foreach my $sect (@nodes)
{
    my $id    = $xpc->findvalue( q{xhtml:h2/@id}, $sect );
    my $title = $xpc->findnodes( q{xhtml:h2}, $sect )->[0]->textContent;

    my $contents = <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Section «$title» of Putting all the Cards on the Table (2003)</title>
<meta charset="utf-8" />
<meta name="author" content="Shlomi Fish" />
<meta name="keywords" content="" />
<style>
a:hover { background-color: palegreen;}
</style>
</head>
<body>

@{[$sect->toString()]}

</body>
</html>
EOF
    my $fh = path(
qq#$PRE_DEST/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/$id.xhtml#,
    );
    Shlomif::DocBookClean::cleanup_docbook( \$contents, $fh, );

    $fh->spew_utf8($contents);
}
