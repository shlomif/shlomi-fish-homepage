#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

my @filenames;
foreach my $fn (@ARGV)
{
    my $_f = sub {
        return path($fn);
    };

    eval {
        my $orig_text = $_f->()->slurp_utf8;
        my $text      = $orig_text;

        if ( !$ENV{NO_I} )
        {
            $text =~
s#^\({5}include "([^"]+)"\){5}\n#path("lib/$1")->slurp_utf8#egms;
            $text =~
s#\({5}chomp_inc='([^']+)'\){5}#my ($l) = path("lib/$1")->lines_utf8({count => 1});chomp$l;$l#egms;
        }

        if ( $ENV{F} )
        {
            foreach my $class (qw(info irc-conversation))
            {
                my $table_from = qq{<table class="$class">};
                my $table_to   = qq{<table class="$class" summary="">};

                $text =~ s#\Q$table_from\E#$table_to#g;
            }
        }

        $text =~ s# +$##gms;
        $text =~ s#(</div>|</li>|</html>)\n\n#$1\n#g;

        # Remove surrounding space of tags.
        $text =~
            s#\s*(</?(?:body|(?:br /)|div|head|li|ol|p|title|ul)>)\s*#$1#gms;

        # Remove document trailing space.
        $text =~ s#\s+\z##ms;

        my $minify = $ENV{ALWAYS_MIN};
        if ( $text ne $orig_text )
        {
            $_f->()->spew_utf8($text);
            $minify ||= 1;
        }
        if ($minify)
        {
            push @filenames, $fn;
        }
    };
    if ( my $err = $@ )
    {
        # In case there's an error - fail and need to rebuild.
        $_f->()->remove();
        die $err;
    }
}
system(
    'bin/batch-inplace-html-minifier',
    '-c', 'bin/html-min-cli-config-file.conf',
    '--keep-closing-slash', @filenames
) and die "html-min $!";
