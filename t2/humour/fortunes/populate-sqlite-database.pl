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

my $dbh = DBI->connect("dbi:SQLite:dbname=$script_dir/$db_base_name","","");

foreach my $file_path (glob("./dest/t2-homepage/humour/fortunes/*.html"))
{
    my $tree = HTML::TreeBuilder::LibXML->new;

    $tree->load($file_path);

    my $nodes_list = $tree->findnodes(q{//div[contains(@class, 'fortune')]});

    while (defined(my $node = $nodes_list->shift()))
    {
        print "\n\n\n[[[START]]]\n";
        print $node->toString();
        print "\n[[[END]]]\n\n\n";
    }
}
