package ShlomifFortunesMake;

use strict;
use warnings;
use autodie;

my $DIR = __FILE__ =~ s#(?:/|\A)[^/]*\z##r;

my $VERSION_FILE = ( ( $DIR || '.' ) . '/' . 'ver.txt' );

sub version_file
{
    return $VERSION_FILE;
}

sub ver
{
    my ($class) = @_;

    my $fn = $class->version_file;

    open my $in, '<', $fn;
    chomp( my $ret = <$in> );
    close $in;

    return $ret;
}

sub dist_base
{
    my ($class) = @_;

    return 'fortunes-shlomif';
}

sub dist_dir
{
    my ($class) = @_;

    return $class->dist_base . '-' . $class->ver;
}

sub package_base
{
    my ($class) = @_;

    return $class->dist_dir . '.tar.gz';
}

1;
