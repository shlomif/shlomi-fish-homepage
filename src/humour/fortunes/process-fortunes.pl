#!/usr/bin/env perl

use strict;
use warnings;

package XML::Grammar::Fortune::FromText;

use XML::Writer ();

use List::Util 1.34 qw/ any /;

use MooX (qw( late ));

has '_id' => ( is => 'rw', isa => 'Int', default => sub { return 0; }, );
has '_xml_writer' => ( is => 'rw', isa => 'Maybe[XML::Writer]' );
has 'unix_fortune_files_paths' => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1
);

sub process_all_input
{
    my $self = shift;

    foreach my $path ( @{ $self->unix_fortune_files_paths() } )
    {
        $self->_process_fortune_file($path);
    }
}

sub _calc_irc_title
{
    my ( $self, $args ) = @_;

    my $lines     = $args->{lines_ref};
    my $last_word = $args->{last_word};

    if ( defined($last_word) && $last_word =~ m{\A[\*<]} )
    {
        return;
    }
    else
    {
        my $last_line = pop(@$lines);
        $last_line =~ m{\A *(?:-- *)?(.*)};
        return $1;
    }
}

sub _process_fortune_file
{
    my $self = shift;

    my $fort_file = shift;

    my $xml_outfile = "$fort_file-non-format.xml";

    open my $xml_out, ">:encoding(UTF-8)", $xml_outfile;

    my $writer = XML::Writer->new( OUTPUT => $xml_out );

    $self->_xml_writer($writer);

    $writer->xmlDecl("utf-8");

    $writer->startTag("collection");
    $writer->emptyTag("head");
    $writer->startTag("list");

    open my $fh, "<", $fort_file;
    binmode $fh, ":encoding(UTF-8)";

    my $line = <$fh>;
    chomp($line);
    while ( defined($line) )
    {
        my @fortune_lines;
        push @fortune_lines, $line;
    GET_FORTUNE_LINES:
        while ( defined( $line = <$fh> ) )
        {
            chomp($line);
            if ( $line eq "%" )
            {
                last GET_FORTUNE_LINES;
            }
            push @fortune_lines, $line;
        }

        # OK we got the fortune lines - no process them:
        $self->_process_single_fortune(
            {
                path  => $fort_file,
                lines => \@fortune_lines,
            }
        );
    }
    continue
    {
        if ( defined($line) )
        {
            $line = <$fh>;
            chomp($line);
        }
    }
    close($fh);

    $writer->endTag();    # list.
    $writer->endTag();    # collection.

    $writer->end();

    close($xml_out);

    system( "xmllint", "--format", "--output", "$fort_file.xml", $xml_outfile );
    unlink($xml_outfile);
}

sub _get_next_id
{
    my $self = shift;

    return "PLOC-IDENT" . $self->_id( $self->_id() + 1 );
}

sub _calc_default_title
{
    my ( $self, $title ) = @_;

    return (
        defined($title)
        ? $title
        : "QUACKPROLOKOG==UNKNOWN-TITLE"
    );
}

sub _process_single_fortune
{
    my $self = shift;
    my $args = shift;

    my $lines = $args->{lines};

    my $writer = $self->_xml_writer();

    $writer->startTag( "fortune", "id" => $self->_get_next_id() );

    my $out_meta = sub {
        my $args = shift;

        $writer->startTag("meta");
        $writer->startTag("title");
        $writer->characters( $args->{text} );
        $writer->endTag("title");
        $writer->endTag("meta");
    };

    if ( any { $_ =~ m{\A +<[^>]+>} } @$lines )
    {
        my $title;
        if ( $lines->[-1] =~ m{\A *([^ ]+)} )
        {
            $title = $self->_calc_irc_title(
                {
                    lines_ref => $lines,
                    last_word => $1
                }
            );
        }
        $out_meta->(
            {
                text => $self->_calc_default_title($title),
            }
        );

        $writer->startTag("irc");
        $writer->startTag("body");

        # This is an IRC conversation.
        my $line;
        my ( $who, $text, $type );

        my $start_new_elem = sub {
            my $new_type = shift;
            my ( $nw, $nt ) = ( $1, $2 );
            if ( defined($who) )
            {
                $writer->startTag( $type, "who" => $who );
                $writer->characters($text);
                $writer->endTag();    # $type
            }
            ( $who, $text, $type ) = ( $nw, $nt, $new_type );
        };

        $line = shift(@$lines);

        while ( @$lines || defined($line) )
        {
            if ( $line =~ m{\A\s+<([^>]+)>\s+(.+)} )
            {
                $start_new_elem->("saying");
            }
            elsif ( $line =~ m{\A\s+\*\s+(\S+)\s+(.+)} )
            {
                $start_new_elem->("me_is");
            }
            elsif ( $line =~ m{\A\s+-->\s+(\S+)\s+(.+)} )
            {
                $start_new_elem->("joins");
            }
            elsif ( $line =~ m{\A\s+<--\s+(\S+)\s+(.+)} )
            {
                $start_new_elem->("leaves");
            }
            else
            {
                $line =~ m{\A\s+(.*)};
                $text .= " $1";
            }
        }
        continue
        {
            $line = shift(@$lines);
        }

        $start_new_elem->("dont_care");

        $writer->endTag("body");

        $writer->startTag("info");
        $writer->endTag("info");
        $writer->endTag("irc");
    }
    else
    {
        $out_meta->( { text => $self->_calc_default_title(undef) } );

        # It's not an IRC conversation: process it as raw.
        $writer->startTag("raw");
        $writer->startTag("body");
        $writer->startTag("text");
        $writer->cdata( join( "\n", @$lines, "" ) );
        $writer->endTag("text");
        $writer->endTag("body");
        $writer->startTag("info");
        $writer->endTag("info");
        $writer->endTag("raw");
    }

    $writer->endTag();    # fortune
}

package main;

use Path::Tiny qw/ path /;

sub read_fortune_files_list
{
    my @lines = path("Makefile")->lines_utf8;

    my @f;
GET_FORTUNE_FILES_LOOP:
    while ( my $l = shift(@lines) )
    {
        if ( $l =~ m{\AFILES *=} )
        {
            my $first_time = 1;
            $l = shift(@lines);
            while ( $first_time || $l =~ m{[a-z]} )
            {
                $first_time = 0;
                $l =~ m{([a-z_\-]+)};
                push @f, $1;
            }
            continue
            {
                $l = shift(@lines);
            }
            last GET_FORTUNE_FILES_LOOP;
        }
    }

    return \@f;
}

my $fortunes_list = read_fortune_files_list();

# print join(" ", @$fortunes_list), "\n";

my $converter = XML::Grammar::Fortune::FromText->new(
    {
        unix_fortune_files_paths => $fortunes_list,
    }
);

binmode STDOUT, ":encoding(UTF-8)";
$converter->process_all_input();
