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

STDOUT->autoflush(1);

my $full_db_path = "$script_dir/$db_base_name";

# To reset the database.
# May not be a good idea in the future.
unlink($full_db_path, "$full_db_path-journal");

my $dbh = DBI->connect("dbi:SQLite:dbname=$full_db_path","","");

$dbh->do("CREATE TABLE fortune_cookies (id INTEGER PRIMARY KEY ASC, str_id VARCHAR(255), text TEXT)");

$dbh->do("CREATE UNIQUE INDEX fortune_strings ON fortune_cookies ( str_id )");

my $insert_sth = $dbh->prepare("INSERT INTO fortune_cookies (str_id, text) VALUES(?, ?)");

my @lines = io->file("$script_dir/fortunes-list.mak")->getlines();
my @file_bases = (map { /(\b[a-z_\-]+\b)/g } @lines);

foreach my $basename (@file_bases)
{
    my $tree = HTML::TreeBuilder::LibXML->new_from_file("./lib/fortunes/xhtmls/$basename.xhtml");

    my $nodes_list = $tree->findnodes(q{//div[@class = "fortune"]});

    my $count = @$nodes_list;

    my $idx = 0;

    while (defined(my $node = shift(@$nodes_list)))
    {
        printf ("%-70s\r", "$basename $idx/$count");
        my $id = $node->findnodes(q{descendant::h3[@id]})->[0]->id;

        if (! $id)
        {
            die "No ID in file '$basename' in " . $node->as_XML . "!";
        }

        $insert_sth->execute($id, $node->as_XML());

        # Some debugging statement.
        # print "\n\n\n[[[START ID=$id]]]\n";
        # print $node->as_XML();
        # print "\n[[[END]]]\n\n\n";
    }
    continue
    {
        $idx++;
    }
}
