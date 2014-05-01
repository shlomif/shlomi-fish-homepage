#!/usr/bin/perl

use strict;
use warnings;

use File::Find::Object;

my $finder = File::Find::Object->new({}, "dest");

my $before_size = 0;
my $after_size = 0;

my %skip =
(
    map { $_ => 1 }
    (
        "humour/RoadToHeaven/Road-To-Heaven-abstract.html",
        "humour/TheEnemy/TheEnemy_eng.html",
        "humour.html",
        "me/contact-me/index.html",
        "open-source/resources/israel/guide-to-israeli-foss-resources/index.html",
        "philosophy/computers/web/create-a-great-personal-homesite/index.html",
        "philosophy/politics/drug-legalisation/hebrew.html",
        "philosophy/computers/web/which-wiki/update-2006-07/index.html",
        "philosophy/open-letter/open_letter.html",
        "rwlock/index.html",
    )

);

FILES_LOOP:
while (my $r = $finder->next())
{
    if ($r =~ m{\.html\z})
    {
        my $base = $r;
        if (($base =~ s{\Adest/t2-homepage/}{}) && (exists($skip{$base})))
        {
            next FILES_LOOP;
        }
        $before_size += (-s $r);
        if (system(qw(tidy -utf8 -q -config lib/tidy.rc -m), $r))
        {
            system("gvim", "-p",
                ((-e "t2/$base.wml") ? "t2/$base.wml" : "t2/$base"),
                $r,
            );
            die "Tidy failed on '$r'\n";
        }
        $after_size += (-s $r);
    }
}
print "Before size: $before_size\n";
print "After size: $after_size\n";

