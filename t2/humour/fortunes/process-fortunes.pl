#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

use XML::Writer;

use List::MoreUtils (qw(any));

package XML::Grammar::Fortune::FromText;

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(
    qw(
        _id
        _xml_writer
        _unix_fortune_files_paths
    ));

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my $self = shift;
    my $args = shift;

    $self->_unix_fortune_files_paths($args->{unix_fortune_files_paths});

    $self->_id(0);

    return 0;
}

sub process_all_input
{
    my $self = shift;

    my $

    foreach my $path (@{$self->_unix_fortune_files_paths()})
    {
        $self->_process_fortune_file($path);
    }
}

sub _process_fortune_file
{
    my $self = shift;

    my $fort_file = shift;

    my $writer = XML::Writer(OUTPUT => \*STDOUT);

    $self->_xml_writer($writer);

    $writer->startTag("collection");
    $writer->emptyTag("head");
    $writer->startTag("list");

    my $fh = io()->file($fort_file);

    $fh->autoclose(1);

    my $line = $fh->chomp->getline();
    while (defined($line))
    {
        my @fortune_lines;
        push @fortune_lines, $line;
        GET_FORTUNE_LINES:
        while (defined($line = $fh->chomp->getline()))
        {
            if ($line eq "%")
            {
                last GET_FORTUNE_LINES;
            }
            push @fortune_lines, $line;
        }

        # OK we got the fortune lines - no process them:
        $self->_process_single_fortune(
            {
                path => $fort_file,
                lines => \@fortune_lines,
            }
        );
    }
    continue
    {
        if (defined($line))
        {
            $line = $fh->chomp->getline();
        }
    }

    $writer->endTag(); # list.
    $writer->endTag(); # collection.

    $writer->end();
}

sub _get_next_id
{
    my $self = shift;

    return "PLOC-IDENT" . $self->_id($self->_id()+1);
}

sub process_single_fortune
{
    my $self = shift;
    my $args = shift;

    my $lines = $args->{lines};

    my $writer = $self->_xml_writer();

    $writer->startTag("fortune", "id" => $self->_get_next_id());

    if (any { $_ =~ m{\A *<[^>]+>} } @$lines)
    {
        # This is an IRC conversation.
        
    }
    else
    {
        # It's not an IRC conversation: process it as raw.
    }
}

package main;

use IO::All;

sub read_fortune_files_list
{
    my @lines = io("Makefile")->getlines();

    my @f;
    GET_FORTUNE_FILES_LOOP:
    while (my $l = shift(@lines))
    {
        if ($l =~ m{\AFILES *=})
        {
            my $first_time = 1;
            $l = shift(@lines);
            while ($first_time || $l =~ m{[a-z]})
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

$convert->process_all_input();
