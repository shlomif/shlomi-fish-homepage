package Shlomif::FindLib;

use strict;
use warnings;

my $mod = 'Shlomif/FindLib.pm';
my $path = $INC{$mod} =~ s#/\Q$mod\E\z##r;

sub lib_path
{
    return $path;
}

sub rel_path
{
    my $class = shift;
    my $path = shift;

    return join("/", $class->lib_path(), @$path);
}
1;

