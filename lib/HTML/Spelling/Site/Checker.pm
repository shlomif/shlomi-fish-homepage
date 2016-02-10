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
has 'whitelist_fn' => (is => 'ro', isa => 'Str', required => 1);
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

    my @current_whitelists_list = ($self->_general_whitelist);
    open my $fh, '<:encoding(utf8)', $self->whitelist_fn;
    while (my $l = <$fh>)
    {
        chomp($l);
        # Whitespace or comment - skip.
        if ($l !~ /\S/ or ($l =~ /\A\s*#/))
        {
            # Do nothing.
        }
        elsif ($l =~ /\A====\s*(.*)/)
        {
            @current_whitelists_list =
            (
                map { $self->_per_filename_whitelists->{$_} ||= +{} }
                split /\s*,\s*/, $1
            );
        }
        else
        {
            foreach my $w (@current_whitelists_list)
            {
                $w->{$l} = 1;
            }
        }
    }
    close ($fh);

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

