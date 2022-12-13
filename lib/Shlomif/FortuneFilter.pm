package Shlomif::FortuneFilter;

use strict;
use warnings;

our @ISA         = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [qw()] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT      = qw();
our $VERSION     = '0.000001';
require Exporter;

sub new
{
    my $class = shift;
    my $arg   = shift;
    my $self  = {};

    bless( $self, $class );
    return $self;
}

sub run
{
    my ( $self, ) = @_;

    my @lines;

    while ( my $l = <> )
    {
        chomp $l;
        if ( $l eq "%" )
        {
            if (@lines)
            {
                $self->_handle( \@lines );
            }
            else
            {
                # else...
            }
            @lines = ();
        }
        else
        {
            push @lines, $l;

            # else...
        }
    }
    if (@lines)
    {
        $self->_handle( \@lines );
    }
    return;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
