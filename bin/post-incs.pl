#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny qw/ path /;
use HTML::Tidy ();

my $tidy = HTML::Tidy->new(
    {
        'input_xml'     => 1,
        'output_xml'    => 1,
        'char_encoding' => 'utf8',
    }
);

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

        # Disabling tidyp for the time being due to:
        # https://github.com/petdance/tidyp/issues/21 .
        if (0)
        {
            $text = $tidy->clean($text);
        }

        $text =~ s# +$##gms;
        $text =~ s#(</div>|</li>|</html>)\n\n#$1\n#g;

        # Remove surrounding space of tags.
        $text =~
            s#\s*(</?(?:body|(?:br /)|div|head|li|ol|p|title|ul)>)\s*#$1#gms;

        # Remove document trailing space.
        $text =~ s#\s+\z##ms;

        if ( $text ne $orig_text )
        {
            $_f->()->spew_utf8($text);
        }
    };
    if ( my $err = $@ )
    {
        # In case there's an error - fail and need to rebuild.
        $_f->()->remove();
        die $err;
    }
}
