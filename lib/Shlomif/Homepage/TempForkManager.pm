package Shlomif::Homepage::TempForkManager;

use strict;
use warnings;
use 5.014;

use Parallel::Map qw/ pmap_void /;

sub new
{
    my $class = shift;

    my $self = bless +{}, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my ( $self, $args ) = @_;

    return;
}

sub run
{
    my ( $self, $args ) = @_;

    my $WITH_PM   = !$args->{disable_fork};
    my $items     = $args->{items};
    my $stream_cb = $args->{stream_cb};
    my $cb        = $args->{process_item};
    my $batch_cb  = $args->{process_batch};

    if ( $stream_cb && $items )
    {
        die "Do not specify both stream_cb and items!";
    }
    if ( $batch_cb && $cb )
    {
        die "Do not specify both process_item and process_batch!";
    }
    $batch_cb //= sub {
        foreach my $item ( @{ shift() } )
        {
            $cb->($item);
        }
        return;
    };
    my $nproc      = $args->{nproc};
    my $batch_size = $args->{batch_size};

    # Return prematurely on empty input to avoid calling $ch with undef()
    # at least once.
    if ($items)
    {
        if ( not @$items )
        {
            return;
        }
        $stream_cb = sub {
            my ($args) = @_;
            my $size = $args->{size};

            return +{ items =>
                    scalar( @$items ? [ splice @$items, 0, $size ] : undef() ),
            };
        };
    }

    my $batch = $stream_cb->( { size => 1 } )->{items};
    return if not defined $batch;
    $batch_cb->($batch);
    my @batches;
    if ($WITH_PM)
    {
        pmap_void sub { $batch_cb->(shift); Future->done; }, generate => sub {
            return $stream_cb->( { size => $batch_size } )->{items} // ();
            },
            ;
    }
    else
    {
        while (
            defined(
                $batch = $stream_cb->( { size => $batch_size } )->{items}
            )
            )
        {
            $batch_cb->($batch);
        }
    }
    return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Parallel::ForkManager::Segmented - use Parallel::ForkManager on batches /
segments of items.

=head1 VERSION

version 0.6.0

=head1 SYNOPSIS

    use Parallel::ForkManager::Segmented ();
    use Path::Tiny qw/ path /;

    my $NUM    = 30;
    my $temp_d = Path::Tiny->tempdir;

    my @queue = ( 1 .. $NUM );
    my $proc  = sub {
        my $fn = shift;
        $temp_d->child($fn)->spew_utf8("Wrote $fn .\n");
        return;
    };
    Parallel::ForkManager::Segmented->new->run(
        {
            WITH_PM      => 1,
            items        => \@queue,
            nproc        => 3,
            batch_size   => 8,
            process_item => $proc,
        }
    );

=head1 DESCRIPTION

This module builds upon L<Parallel::ForkManager> allowing one to pass a
batch (or "segment") of several items for processing inside a worker. This
is done in order to hopefully reduce the forking/exiting overhead.

=head1 METHODS

=head2 my $obj = Parallel::ForkManager::Segmented->new;

Initializes a new object.

=head2 $obj->run(+{ %ARGS });

Runs the processing. Accepts the following named arguments:

=over 4

=item * process_item

A reference to a subroutine that accepts one item and processes it.

=item * items

A reference to the array of items.

=item * stream_cb

A reference to a callback for returning new batches of items (cannot
be specified along with 'items'.)

Accepts a hash ref with the key 'size' specifying an integer of the maximal
item count.

Returns a hash ref with the key 'items' pointing to an array reference of
items or undef() upon end-of-stream.

E.g:

        $stream_cb = sub {
            my ($args) = @_;
            my $size = $args->{size};

            return +{ items =>
                    scalar( @$items ? [ splice @$items, 0, $size ] : undef() ),
            };
        };

Added at version 0.4.0.

=item * nproc

The number of child processes to use.

=item * batch_size

The number of items in each batch.

=item * disable_fork

Disable forking and use of L<Parallel::ForkManager> and process the items
serially.

=item * process_batch

[Added in v0.2.0.]

A reference to a subroutine that accepts a reference to an array of a whole batch
that is processed as a whole. If specified, C<process_item> is not used.

Example:

    use strict;
    use warnings;
    use Test::More tests => 30;
    use Parallel::ForkManager::Segmented ();
    use Path::Tiny qw/ path /;

    {
        my $NUM    = 30;
        my $temp_d = Path::Tiny->tempdir;

        my @queue = ( 1 .. $NUM );
        my $proc  = sub {
            foreach my $fn ( @{ shift(@_) } )
            {
                $temp_d->child($fn)->spew_utf8("Wrote $fn .\n");
            }
            return;
        };
        Parallel::ForkManager::Segmented->new->run(
            {
                WITH_PM       => 1,
                items         => \@queue,
                nproc         => 3,
                batch_size    => 8,
                process_batch => $proc,
            }
        );
        foreach my $i ( 1 .. $NUM )
        {
            # TEST*30
            is( $temp_d->child($i)->slurp_utf8, "Wrote $i .\n", "file $i", );
        }
    }

=back

=head1 SEE ALSO

=over 4

=item * L<Parallel::ForkManager>

=item * L<IO::Async::Function> - a less snowflake approach.

=item * L<https://perl-begin.org/uses/multitasking/>

=back

=for :stopwords cpan testmatrix url bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<https://metacpan.org/release/Parallel-ForkManager-Segmented>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<https://rt.cpan.org/Public/Dist/Display.html?Name=Parallel-ForkManager-Segmented>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.cpanauthors.org/dist/Parallel-ForkManager-Segmented>

=item *

CPAN Testers

The CPAN Testers is a network of smoke testers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/P/Parallel-ForkManager-Segmented>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=Parallel-ForkManager-Segmented>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=Parallel::ForkManager::Segmented>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-parallel-forkmanager-segmented at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/Public/Bug/Report.html?Queue=Parallel-ForkManager-Segmented>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/shlomif/perl-Parallel-ForkManager-Segmented>

  git clone https://github.com/shlomif/perl-Parallel-ForkManager-Segmented.git

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://github.com/shlomif/parallel-forkmanager-segmented/issues>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
