package HTML::Latemp::DocBook::DocsList;

use strict;
use warnings;
use autodie;

use Moo;

use List::MoreUtils qw(any);
use YAML::XS ();

my @documents = @{ YAML::XS::LoadFile("./lib/docbook/docs.yaml") };

foreach my $d (@documents)
{
    if ( !exists( $d->{db_ver} ) )
    {
        $d->{db_ver} = 4;
    }
    elsif ( !( any { $d->{db_ver} eq $_ } ( 4, 5 ) ) )
    {
        die "Illegal db_ver $d->{db_ver}!";
    }

    if ( !exists( $d->{custom_css} ) )
    {
        $d->{custom_css} = 0;
    }

    if ( !exists( $d->{del_revhistory} ) )
    {
        $d->{del_revhistory} = 0;
    }
}

sub docs_list
{
    my $self = shift;

    return \@documents;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
