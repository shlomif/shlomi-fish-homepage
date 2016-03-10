package HTML::Spelling::Site::Checker;

use strict;
use warnings;
use autodie;
use utf8;

use MooX qw/late/;

use HTML::Parser 3.00 ();
use Text::Hunspell;
use List::MoreUtils qw(any);
use JSON::MaybeXS qw(decode_json);
use IO::All qw/ io /;

has '_inside' => (is => 'rw', isa => 'HashRef', default => sub { return +{};});
has '_general_whitelist' => (is => 'rw', default => sub { +{}; });
has '_per_filename_whitelists' => (is => 'rw', default => sub { +{}; });
has 'whitelist_parser' => (is => 'ro', required => 1);
has 'check_word_cb' => (is => 'ro', isa => 'CodeRef', required => 1);

sub _tag
{
    my ($self, $tag, $num) = @_;

    $self->_inside->{$tag} += $num;

    return;
}

sub _populate_whitelists
{
    my ($self) = @_;

    foreach my $w (@{$self->whitelist_parser->get_general_whitelist_as_array_ref})
    {
        $self->_general_whitelist->{$w} = 1;
    }

    foreach my $rec (@{$self->whitelist_parser->get_records_whitelists_as_array_ref_of_records})
    {
        my @lists;
        foreach my $fn (@{$rec->{files}})
        {
            push @lists,
            ($self->_per_filename_whitelists->{$fn} //= +{});
        }

        foreach my $w (@{$rec->{words}})
        {
            foreach my $l (@lists)
            {
                $l->{$w} = 1;
            }
        }
    }

    return;
}

sub spell_check
{
    my ($self, $args) = @_;

    my $files = $args->{files};

    $self->_populate_whitelists;

    binmode STDOUT, ":encoding(utf8)";

    my $calc_cache_io = sub {
        return io->file('./Tests/data/cache/spelling-timestamp.json');
    };

    my $write_cache = sub {
        my $ref = shift;
        $calc_cache_io->()->print(
            JSON::MaybeXS->new(canonical => 1)->encode($ref)
        );
    };

    if (! $calc_cache_io->()->exists())
    {
        $write_cache->(+{});
    }

    my $timestamp_cache = decode_json(scalar($calc_cache_io->()->slurp()));

    my $_general_whitelist = $self->_general_whitelist;
    my $_per_filename_whitelists = $self->_per_filename_whitelists;

    my $check_word = $self->check_word_cb;

    FILENAMES_LOOP:
    foreach my $filename (@$files)
    {
        my $file_whitelist = $_per_filename_whitelists->{$filename} || +{};

        if (exists($timestamp_cache->{$filename}) and
            $timestamp_cache->{$filename} <= (io->file($filename)->mtime())
        )
        {
            next FILENAMES_LOOP;
        }

        my $file_is_ok = 1;

        my $process_text = sub
        {
            if (any {
                    exists($self->_inside->{$_}) and $self->_inside->{$_} > 0
                } qw(script style))
            {
                return;
            }

            my $text = shift;

            my @lines = split /\n/, $text, -1;

            foreach my $l (@lines)
            {

                my $mispelling_found = 0;

                my $mark_word = sub {
                    my ($word) = @_;

                    $word =~ s{’(ve|s|m|d|t|ll|re)\z}{'$1};
                    $word =~ s{[’']\z}{};
                    if ($word =~ /[A-Za-z]/)
                    {
                        $word =~ s{\A(?:(?:ֹו?(?:ש|ל|מ|ב|כש|לכש|מה|שה|לכשה|ב-))|ו)-?}{};
                        $word =~ s{'?ים\z}{};
                    }

                    my $verdict =
                    (
                        (!exists($_general_whitelist->{$word}))
                        &&
                        (!exists($file_whitelist->{$word}))
                        &&
                        ($word !~ m#\A[\p{Hebrew}\-'’]+\z#)
                        &&
                        (!($check_word->($word)))
                    );

                    $mispelling_found ||= $verdict;

                    return $verdict ? "«$word»" : $word;
                };

                $l =~ s/
                # Not sure this regex to match a word is fully
                # idiot-proof, but we can amend it later.
                ([\w'’-]+)
                /$mark_word->($1)/egx;

                if ($mispelling_found)
                {
                    $file_is_ok = 0;
                    printf {*STDOUT}
                    (
                        "%s:%d:%s\n",
                        $filename,
                        1,
                        $l
                    );
                }
            }
        };

        open(my $fh, "<:utf8", $filename);

        HTML::Parser->new(api_version => 3,
            handlers    => [start => [sub { return $self->_tag(@_); }, "tagname, '+1'"],
                end   => [sub { return $self->_tag(@_); }, "tagname, '-1'"],
                text  => [$process_text, "dtext"],
            ],
            marked_sections => 1,
        )->parse_file($fh);

        close ($fh);

        if ($file_is_ok)
        {
            $timestamp_cache->{$filename} = io->file($filename)->mtime();
        }
    }

    $write_cache->($timestamp_cache);

    print "\n";

    return;
}

1;

