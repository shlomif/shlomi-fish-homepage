package HTML::Spelling::Site::Whitelist;

use strict;
use warnings;
use autodie;

use MooX (qw( late ));

use IO::All qw/ io /;

has '_general_whitelist' => (is => 'ro', default => sub { return []; });
has '_records' => (is => 'ro', default => sub { return []; });
has '_was_parsed' => (is => 'rw', default => '');
has 'filename' => (is => 'ro', isa => 'Str', required => 1);

sub get_general_whitelist_as_array_ref
{
    my ($self) = @_;

    $self->parse;

    return $self->_general_whitelist;
}

sub get_records_whitelists_as_array_ref_of_records
{
    my ($self) = @_;

    $self->parse;

    return $self->_records;
}

sub parse
{
    my ($self) = @_;

    if (!$self->_was_parsed())
    {

        my $rec;
        open my $fh, '<:encoding(utf8)', $self->filename;
        my $found_global = 0;
        while (my $l = <$fh>)
        {
            chomp($l);
            # Whitespace or comment - skip.
            if ($l !~ /\S/ or ($l =~ /\A\s*#/))
            {
                # Do nothing.
            }
            elsif ($l =~ s/\A====\s+//)
            {
                if ($l =~ /\AGLOBAL:\s*\z/)
                {
                    if (defined($rec))
                    {
                        die "GLOBAL is not the first directive.";
                    }
                    $found_global = 1;
                }
                elsif ($l =~ /\AIn:\s*(.*)/)
                {
                    my @filenames = split /\s*,\s*/, $1;

                    if (defined($rec))
                    {
                        push @{$self->_records}, $rec;
                    }

                    my %found;
                    foreach my $fn (@filenames)
                    {
                        if (exists $found{$fn})
                        {
                            die "Filename <<$fn>> appears twice in line <<=== In: $l>>";
                        }
                        $found{$fn} = 1;
                    }
                    $rec = {
                        'files' => [ sort { $a cmp $b } @filenames],
                        'words' => [],
                    },
                }
                else
                {
                    die "Unknown directive <<==== $l>>!";
                }
            }
            else
            {
                if (defined($rec))
                {
                    push @{$rec->{'words'}}, $l;
                }
                else
                {
                    if (!$found_global)
                    {
                        die "GLOBAL not found before first word.";
                    }
                    push @{$self->_general_whitelist}, $l;
                }
            }
        }
        push @{$self->_records}, $rec;
        close ($fh);
    }
    $self->_was_parsed(1);

    return;
}

sub _rec_sorter
{
    my ($a_aref, $b_aref, $idx) = @_;

    return (
        (@$a_aref == $idx) ? -1
        : (@$b_aref == $idx) ? 1
        : (($a_aref->[$idx] cmp $b_aref->[$idx])
        ||
        _rec_sorter($a_aref, $b_aref, $idx+1))
    );
}

sub _sort_words
{
    my $words_aref = shift;

    return [sort { $a cmp $b } @$words_aref];
}

sub get_sorted_text
{
    my ($self) = @_;

    $self->parse;

    my %_gen = map { $_ => 1 } @{$self->_general_whitelist};

    return join '',
    map { "$_\n" }
    (
        "==== GLOBAL:", '',
        @{_sort_words($self->_general_whitelist)}, '',
        (map
            { ("==== In: ".join(' , ', @{$_->{files}})), '',
                (@{ _sort_words(
                            [grep { !exists($_gen{$_}) } @{$_->{words}}]
                    )
                  }
                ), ''
            }
            sort { _rec_sorter($a->{files}, $b->{files}, 0) }
            @{$self->_records}
        )
    );
}

sub _get_io
{
    my ($self) = @_;

    return io->encoding('utf8')->file($self->filename);
}

sub is_sorted
{
    my ($self) = @_;

    $self->parse;

    return ($self->_get_io->all eq $self->get_sorted_text);
}

sub write_sorted_file
{
    my ($self) = @_;

    $self->parse;

    $self->_get_io->print($self->get_sorted_text);

    return;
}

1;

