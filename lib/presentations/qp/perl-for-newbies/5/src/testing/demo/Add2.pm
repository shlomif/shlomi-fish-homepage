package Add2;

use strict;
use warnings;

use vars qw(@EXPORT_OK @ISA);

use Exporter;

@ISA = (qw(Exporter));

@EXPORT_OK = (qw(add));

sub add
{
    my $x = shift;
    my $y = shift;

    return $x+$y;
}

1;

