#!/usr/bin/perl -w

use strict;

use CGI;
use Contents;
use Quad::Pres;

my $q = CGI->new();

#print $q->header();

my $contents = Contents::get_contents();

my $document_name = $ENV{'REQUEST_URI'};

$document_name =~ s/^.*serve.pl\/?//;

my $p = Quad::Pres->new($contents, $document_name, 'cgi');

$p->render();


