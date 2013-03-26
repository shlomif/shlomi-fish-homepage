#!/usr/bin/perl

use strict;
use warnings;

use File::Spec::Functions qw( catpath splitpath rel2abs );

# The Directory containing the script.
my $script_dir = catpath( ( splitpath( rel2abs $0 ) )[ 0, 1 ] );

my $db_base_name = "fortunes-shlomif-lookup.sqlite3";

use HTML::TreeBuilder::LibXML;
use DBI;

use Shlomif::Homepage::FortuneCollections;

STDOUT->autoflush(1);

my $full_db_path = "$script_dir/$db_base_name";

# To reset the database.
# May not be a good idea in the future.
unlink($full_db_path, "$full_db_path-journal");

my $dbh = DBI->connect("dbi:SQLite:dbname=$full_db_path","","");

$dbh->do("CREATE TABLE fortune_collections (id INTEGER PRIMARY KEY ASC, str_id VARCHAR(60), desc TEXT, title VARCHAR(100), tooltip TEXT)");

$dbh->do("CREATE UNIQUE INDEX fortune_collections_strings ON fortune_collections ( str_id )");

$dbh->do("CREATE TABLE fortune_cookies (id INTEGER PRIMARY KEY ASC, str_id VARCHAR(255), title TEXT, text TEXT, collection_id INTEGER)");

$dbh->do("CREATE UNIQUE INDEX fortune_strings ON fortune_cookies ( str_id )");


my $insert_sth = $dbh->prepare("INSERT INTO fortune_cookies (collection_id, str_id, title, text) VALUES(?, ?, ?, ?)");

my $collections_aref = Shlomif::Homepage::FortuneCollections->sorted_fortunes();

{
    my $col_insert_sth = $dbh->prepare(<<'EOF');
INSERT INTO fortune_collections (str_id, title, tooltip, desc)
VALUES(?, ?, ?, ?)
EOF

    $dbh->begin_work;

    foreach my $col (@$collections_aref)
    {
        $col_insert_sth->execute($col->id(), $col->text(), $col->title(), $col->desc());
    }

    $dbh->commit;

}

my @file_bases = ( map { $_->id() } @$collections_aref);

my $collection_query_id_sth = $dbh->prepare(
    q{SELECT id FROM fortune_collections WHERE str_id = ?}
);

# We split the work to 50-items batches per the advice on
# Freenode's #perl by tm604 and jql.
$dbh->begin_work;

my $global_idx = 0;

foreach my $basename (@file_bases)
{
    my $collection_id;

    my $rv = $collection_query_id_sth->execute($basename);

    if ( not (($collection_id) = $collection_query_id_sth->fetchrow_array()) )
    {
        die "Cannot find for '$basename'!";
    }

    my $tree = HTML::TreeBuilder::LibXML->new_from_file("./lib/fortunes/xhtmls/$basename.xhtml");

    my $nodes_list = $tree->findnodes(q{//div[@class = "fortune"]});

    my $count = @$nodes_list;

    my $idx = 0;

    while (defined(my $node = shift(@$nodes_list)))
    {
        printf ("%-70s\r", "$basename $idx/$count ($global_idx)");

        my $h3_node = $node->findnodes(q{descendant::h3[@id]})->[0];

        my $id = $h3_node->id;
        my $title = $h3_node->string_value();

        if (! $id)
        {
            die "No ID in file '$basename' in " . $node->as_XML . "!";
        }

        $insert_sth->execute($collection_id, $id, $title, $node->as_XML());

        # Some debugging statement.
        # print "\n\n\n[[[START ID=$id]]]\n";
        # print $node->as_XML();
        # print "\n[[[END]]]\n\n\n";
    }
    continue
    {
        $idx++;

        if ((++$global_idx) % 100 == 0)
        {
            $dbh->commit;
            $dbh->begin_work;
        }
    }
}

# Commit the remaining items.
$dbh->commit;
