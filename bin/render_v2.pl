#! /usr/bin/env perl

use strict;
use warnings;
use 5.014;
use Cwd ();

BEGIN
{
    use vars qw/ $HOME /;
    $HOME = $ENV{HOME};
}
use lib "$HOME/apps/test/wml/lib64/wml";
use lib "$HOME/apps/test/wml/lib64/wml";

use WML_Frontends::Wml::Runner ();

my (@dests) = @ARGV;

my $PWD       = Cwd::getcwd();
my @WML_FLAGS = (
    qq%
--passoption=2,-X3074 --passoption=2,-I../lib/ --passoption=3,-I../lib/ --passoption=3,-w -I../lib/ -I$HOME/apps/latemp/lib/wml/include/ --passoption=2,-I$HOME/apps/latemp/lib/wml/include/ -I$HOME/.latemp/lib/ --passoption=2,-I$HOME/.latemp/lib/ -p1-3,5,7 -DROOT~. -DLATEMP_THEME=sf.org1 -I $HOME/apps/wml
% =~ /(\S+)/g
);

my $T2_SRC_DIR = 't2';
my $T2_DEST    = "dest/$T2_SRC_DIR";

chdir($T2_SRC_DIR);

my $obj = WML_Frontends::Wml::Runner->new;

foreach my $dest (@dests)
{
    my $lfn = $dest =~ s#\A\Q$T2_DEST\E/##mrs;
    $obj->run_with_ARGV(
        {
            ARGV => [
                "-o",       "$PWD/$dest",
                @WML_FLAGS, "-DLATEMP_FILENAME=$lfn",
                "$lfn.wml"
            ],
        }
    ) and die "$!";
}
