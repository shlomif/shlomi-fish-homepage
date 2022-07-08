#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use File::Spec::Functions qw( catpath splitpath rel2abs );
use List::Util            qw/ min /;
use YAML::XS              qw/ LoadFile /;

# The Directory containing the script.
my $script_dir = catpath( ( splitpath( rel2abs $0 ) )[ 0, 1 ] );

my $db_base_name = "fortunes-shlomif-lookup.sqlite3";

use HTML::TreeBuilder::LibXML ();
use DBI                       ();

use Shlomif::Homepage::FortuneCollections ();

# STDOUT->autoflush(1);

my $full_db_path = "$script_dir/$db_base_name";
my $yaml_path    = "$script_dir/fortunes-shlomif-ids-data.yaml";

my ( $yaml, ) = LoadFile($yaml_path);
$yaml = ( $yaml->{files} or die );

# say $yaml;

# To reset the database.
# May not be a good idea in the future.
foreach my $fn ( $full_db_path, "$full_db_path-journal" )
{
    if ( -e $fn )
    {
        unlink($fn);
    }
}

my $dbh = DBI->connect( "dbi:SQLite:dbname=$full_db_path",
    "", "", { RaiseError => 1 } );

$dbh->begin_work;

$dbh->do(
"CREATE TABLE fortune_collections (id INTEGER PRIMARY KEY ASC, str_id VARCHAR(60), desc TEXT, title VARCHAR(100), tooltip TEXT)"
);

$dbh->do(
"CREATE UNIQUE INDEX fortune_collections_strings ON fortune_collections ( str_id )"
);

$dbh->do(
"CREATE TABLE fortune_cookies (id INTEGER PRIMARY KEY ASC, str_id VARCHAR(255), title TEXT, text TEXT, info_text TEXT, collection_id INTEGER, desc TEXT, date TEXT)"
);

$dbh->do("CREATE UNIQUE INDEX fortune_strings ON fortune_cookies ( str_id )");

my $insert_sth = $dbh->prepare(
"INSERT INTO fortune_cookies (collection_id, str_id, title, text, info_text, desc, date) VALUES(?, ?, ?, ?, ?, ?, ?)"
);

my $collections_aref =
    Shlomif::Homepage::FortuneCollections->new->sorted_fortunes;

{
    my $col_insert_sth = $dbh->prepare(<<'EOF');
INSERT INTO fortune_collections (str_id, title, tooltip, desc)
VALUES(?, ?, ?, ?)
EOF

    foreach my $col (@$collections_aref)
    {
        $col_insert_sth->execute( $col->id(), $col->text(), $col->title(),
            $col->desc() );
    }
}

my @file_bases = ( map { $_->id() } @$collections_aref );

my $collection_query_id_sth =
    $dbh->prepare(q{SELECT id FROM fortune_collections WHERE str_id = ?});

# We put the work within one large commit per the advice on
# Freenode's #perl by tm604 and jql , and to avoid these errors:
# http://stackoverflow.com/questions/21054245/attempt-to-write-a-readonly-database-django-w-selinux-error

# my $global_idx = 0;
sub _find_h3
{
    my $node = shift;
    return $node->findnodes(q{descendant::h3[@id]})->[0];
}

sub _find_info
{
    my $node = shift;
    return $node->findnodes(q{descendant::table[@class='info']})->[0];
}

sub _next_fortune
{
    my $fh  = shift;
    my $ret = "";
    while ( !eof($fh) )
    {
        my $line = <$fh>;
        chomp $line;
        if ( $line eq "%" )
        {
            return \$ret;
        }
        $ret .= "$line\n";
    }
    return \$ret;
}

foreach my $basename (@file_bases)
{
    my $collection_id;
    my $file_yaml = $yaml->{"$basename.xml"};

    my $rv = $collection_query_id_sth->execute($basename);

    if ( not( ($collection_id) = $collection_query_id_sth->fetchrow_array() ) )
    {
        die "Cannot find for '$basename'!";
    }

    my $tree = HTML::TreeBuilder::LibXML->new_from_file(
        "./lib/fortunes/xhtmls/$basename.xhtml");

    my $nodes_list   = $tree->findnodes(q{//div[@class = "fortune"]});
    my $plaintext_fn = "dest/pre-incs/t2/humour/fortunes/$basename";
    open my $plaintext_fh, '<:encoding(utf8)', $plaintext_fn;

    # my $count = @$nodes_list;
    # my $idx = 0;

    foreach my $node (@$nodes_list)
    {
        # printf( "%-70s\r", "$basename $idx/$count ($global_idx)" );

        my $h3_node = _find_h3($node);

        my $id    = $h3_node->id;
        my $title = $h3_node->string_value();

        if ( !$id )
        {
            die "No ID in file '$basename' in " . $node->as_XML . "!";
        }

        # my $clone = $node->clone();
        my $clone = $node;
        my $h3    = _find_h3($clone);
        $h3->detach();
        my $info = _find_info($clone);
        $info->detach();

        my $body = join( "", map { $_->as_XML(); } $clone->childNodes() );
        my $desc = _next_fortune($plaintext_fh);
        substr( $$desc, min( 500, length($$desc) ) ) = '';
        $$desc =~ s#(?:\A|\S)\K\s*\S+\z##ms;
        my $date = $file_yaml->{$id}->{'date'}
            or Carp::confess("no date for id = $id ; basename = $basename .");
        $insert_sth->execute( $collection_id, $id, $title, $body,
            scalar( $info->as_XML() ),
            $$desc, $date, );
    }

=begin removed
    continue
    {
        # ++$idx;
        # ++$global_idx;
    }
=end removed

=cut

    close $plaintext_fh;
}

$dbh->commit;

$insert_sth->finish;
$collection_query_id_sth->finish;

$dbh->disconnect;

sub _reproducible_builds
{
    open my $fh, '+<:raw', $full_db_path;
    seek( $fh, 99, 0 );
    print {$fh} chr( oct('302') );
    close $fh;
    return;
}
_reproducible_builds();
