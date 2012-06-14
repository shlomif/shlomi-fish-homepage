#!/usr/bin/perl

use strict;
use warnings;

use lib '/home/shlomi/apps/test/quadpres//share/quad-pres/perl5';

use Shlomif::Quad::Pres;

require Contents;

my $contents = Contents::get_contents();
my $document_name = "finale/book.html";

my $qp = Shlomif::Quad::Pres->new(
            $contents,
            'doc_id' => $document_name,
            'mode' => "server",
            );

my $text = $qp->get_navigation_bar();

my $subject = $qp->get_subject();

my $contents_tree = $qp->get_contents();

my $title = $qp->get_title();


my @controls =
        (
            { 'title' => "Contents", 'link' => "top", 'func' => "get_contents_url"},
            { 'title' => "Up", 'link' => "up", 'func' => "get_up_url"},
            { 'title' => "Prev", 'link' => "prev", 'func' => "get_prev_url"},
            { 'title' => "Next", 'link' => "next", 'func' => "get_next_url"},
            { 'title' => "First", 'link' => "first", 'func' => "get_contents_url", 'hide' => 1, },
            { 'title' => "Last", 'link' => "last", 'func' => "get_last_url", 'hide' => 1, },
        );


   foreach my $c (@controls)
   {
       my $func = $c->{'func'};
       $c->{'url'} = $qp->get_control_url($qp->$func());
   }

use Data::Dumper;
my $d = Data::Dumper->new([\@controls],['$controls']);
print $d->Dump();

