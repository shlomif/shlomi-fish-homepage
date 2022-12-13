package Shlomif::FortuneFilter;

use strict;
use warnings;

use URI::Find ();
use WWW::Shorten::IsGd;

our @ISA         = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [qw()] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT      = qw();
our $VERSION     = '0.000001';
require Exporter;

my $shorten_finder = URI::Find->new(
    sub {
        my ( $obj, $text ) = @_;
        return makeashorterlink($text);
    }
);

my $finder = URI::Find->new(
    sub {
        my ( $obj, $text ) = @_;
        return "";
    }
);

sub new
{
    my $class = shift;
    my $arg   = shift;
    my $self  = {};

    bless( $self, $class );
    return $self;
}

sub _handle
{
    my ( $self, $ll ) = @_;
    my @o;
    foreach my $l (@$ll)
    {
        if (
            length($l) > 80
            and do
            {
                $finder->find( \$l );
                $l =~ s#\s+\z##ms;
                length($l) > 80;
            }
            )
        {
            return -1;
        }
        else
        {
            # else...
        }
        push @o, $l;
    }
    print join "\n", @o, '%', "";
    return 0;
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

Shlomif::FortuneFilter->new->run;
1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
