#!/usr/bin/perl

use strict;
use warnings;

use File::Find::Object;

my $ff = File::Find::Object->new({}, "t2");

my @deps;
while (defined(my $result = $ff->next_obj()))
{
    if (   $result->is_dir()
        && @{$result->dir_components()}
        && $result->dir_components()->[-1] eq ".svn"
       )
    {
        $ff->prune();
    }
    elsif ((! $result->is_dir()) && $result->basename() =~ m{\.wml\z})
    {
        open my $in, "<", $result->path()
            or die "Cannot open " . $result->path() . "$!";
        while (my $line = <$in>)
        {
            my $string = qq{#include "../lib/};
            if ($line =~ s{\A\Q$string\E}{})
            {
                $line =~ s{".*}{}ms;
                push @deps, { file => $result->path(), dep => $line };
            }
        }
        close($in);
    }
}

open my $deps_mak, ">", "deps.mak";
print {$deps_mak} "# Extra dependencies\n\n";
foreach my $dep (@deps)
{
    my $file = $dep->{'file'};
    my $depends_on = $dep->{'dep'};
    $file =~ s{\At2/}{};
    $file =~ s{\.wml\z}{};

    print {$deps_mak} qq{\$(T2_DEST)/$file :  lib/$depends_on\n\n},
}
close($deps_mak);

