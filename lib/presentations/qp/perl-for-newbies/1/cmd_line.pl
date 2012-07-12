#!/usr/bin/perl -w

use strict;

#use CGI;
use Contents;
use Quad::Pres;

#my $q = CGI->new();

#print $q->header();

my $contents = Contents::get_contents();

my $document_name = shift || "";

my $render_type = shift || "harddisk";

unless (grep { $_ eq $render_type } ("server", "harddisk"))
{
    die "Improper rendering type $render_type!\n";
}

my $p = Quad::Pres->new($contents, $document_name, $render_type);

$p->render();


