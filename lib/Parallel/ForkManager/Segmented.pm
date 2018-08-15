package Parallel::ForkManager::Segmented;

use strict;
use warnings;
use 5.014;

use List::MoreUtils qw/ natatime /;
use Parallel::ForkManager ();

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

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

    my $WITH_PM    = !$args->{disable_fork};
    my $items      = $args->{items};
    my $cb         = $args->{process_item};
    my $nproc      = $args->{nproc};
    my $batch_size = $args->{batch_size};

    my $pm;

    if ($WITH_PM)
    {
        $pm = Parallel::ForkManager->new($nproc);
    }
    $cb->( shift @$items );
    my $it = natatime $batch_size, @$items;
ITEMS:
    while ( my @batch = $it->() )
    {
        if ($WITH_PM)
        {
            my $pid = $pm->start;

            if ($pid)
            {
                next ITEMS;
            }
        }
        foreach my $item (@batch)
        {
            $cb->($item);
        }
        if ($WITH_PM)
        {
            $pm->finish;    # Terminates the child process
        }
    }
    if ($WITH_PM)
    {
        $pm->wait_all_children;
    }
    return;
}

1;
