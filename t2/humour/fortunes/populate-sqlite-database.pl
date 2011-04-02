#!/usr/bin/perl

use strict;
use warnings;

use File::Spec::Functions qw( catpath splitpath rel2abs );

# The Directory containing the script.
my $script_dir = catpath( ( splitpath( rel2abs $0 ) )[ 0, 1 ] );

my $db_base_name = "fortunes-shlomif-lookup.sqlite3";

use HTML::TreeBuilder::LibXML;
use DBI;
use File::Spec;
use IO::All;

my $dbh = DBI->connect("dbi:SQLite:dbname=$script_dir/$db_base_name","","");

my @lines = io->file("$script_dir/fortunes-list.mak")->getlines();
my @file_bases = (map { /(\b[a-z_\-]+\b)/g } @lines);

foreach my $basename (@file_bases)
{
    my $tree = HTML::TreeBuilder::LibXML->new_from_file("./dest/t2-homepage/humour/fortunes/$basename.html");

    my $nodes_list = $tree->findnodes(q{//div[@class = "fortune"]});

    while (defined(my $node = shift(@$nodes_list)))
    {
        my $id = $node->findnodes(q{//h3[@id]})->[0]->id;
        print "\n\n\n[[[START ID=$id]]]\n";
        print $node->as_XML();
        print "\n[[[END]]]\n\n\n";
    }
}
