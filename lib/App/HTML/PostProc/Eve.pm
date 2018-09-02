package App::HTML::PostProc::Eve;

use strict;
use warnings;
use 5.014;

use MooX qw/ late /;
use Getopt::Long qw/ GetOptionsFromArray /;

use Cache::File ();
use Data::Munge qw/ list2re /;
use File::Update qw/ modify_on_change write_on_change /;
use Path::Tiny qw/ path /;

my $XMLNS_NEEDLE = <<'EOF';
 xmlns:db="http://docbook.org/ns/docbook" xmlns:d="http://docbook.org/ns/docbook" xmlns:vrd="http://www.shlomifish.org/open-source/projects/XML-Grammar/Vered/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xhtml="http://www.w3.org/1999/xhtml"
EOF

my @needles = $XMLNS_NEEDLE =~ m#\b(xmlns:[a-zA-Z_]+="[^"]+")#g;

my $ALTERNATIVES_TEXT = list2re @needles;

sub _summary
{
    my $text_ref = shift;
    if ( index( $$text_ref, q#<!DOCTYPE html># ) >= 0 )
    {
        return $$text_ref =~ s%<table summary=""%<table%g;
    }
    return '';
}

sub _call_minifier
{
    my ( $self, $filenames ) = @_;
    my $KEY = 'HTML_POST_INCS_DATA_DIR';
    my $cache =
        Cache::File->new( cache_root => ( $ENV{KEY} || '/tmp/cacheroot' ) );

    my @queue;
    foreach my $fn ( ( map { $_->{temp} } @$filenames ), )
    {
        my $k = path($fn)->slurp;
        my $e = $cache->entry($k);
        if ( $e->exists )
        {
            path($fn)->spew( $e->get );
        }
        else
        {
            push @queue, [ $e, $fn ];
        }
    }
    if (@queue)
    {
        system(
            'bin/batch-inplace-html-minifier',
            '-c', 'bin/html-min-cli-config-file.conf',
            '--keep-closing-slash', map { $_->[1] } @queue
        ) and die "html-min $!";
        foreach my $fn (@queue)
        {
            $fn->[0]->set( scalar( path( $fn->[1] )->slurp ), '100000 days' );
        }
    }
    return;
}

sub run
{
    my ( $self, $args ) = @_;

    my @filenames;
    my @ad_filenames;
    my @raw_filenames;
    my $argv = $args->{ARGV};
    my $source_dir;
    my $dest_dir;
    GetOptionsFromArray(
        $argv,
        'source-dir=s' => \$source_dir,
        'dest-dir=s'   => \$dest_dir,
    ) or die "$!";
    my $temp_dir = Path::Tiny->tempdir;
    my $counter  = 0;

    foreach my $bn (@$argv)
    {
        my $_f = sub {
            return path("$source_dir/$bn");
        };

        eval {
            PROCESS_FILE:
            {
                my $orig_text = $_f->()->slurp_utf8;
                my $text      = $orig_text;

                if ( $text =~ /^<!-- Project Wonderful/ms )
                {
                    last PROCESS_FILE;
                }

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

                $text =~ s#\s+xml:space="[^"]*"##g;
                $text =~ s#(<div)(?:\s+(?:$ALTERNATIVES_TEXT))+#$1 #gms;

                # Remove surrounding space of tags.
                $text =~
s#\s*(</?(?:body|(?:br /)|div|head|li|ol|p|title|ul)>)\s*#$1#gms;

                # Remove document trailing space.
                $text =~ s#\s+\z##ms;

                my $minify = $ENV{ALWAYS_MIN};
                if ( $text ne $orig_text )
                {
                    $minify //= 1;
                }
                my $temp_fh = $temp_dir->child( ( ++$counter ) . ".html" );
                $temp_fh->spew_utf8($text);
                my $fn  = $temp_fh . '';
                my $rec = +{
                    bn   => $bn,
                    temp => $fn,
                };
                if ($minify)
                {
                    push @filenames, $rec;
                }
                elsif ( $ENV{APPLY_ADS} )
                {
                    push @ad_filenames, $rec;
                }
                else
                {
                    push @raw_filenames, $rec;
                }
            }
        };
        if ( my $err = $@ )
        {
            # In case there's an error - fail and need to rebuild.
            $_f->()->remove();
            die $err;
        }
    }

    $self->_call_minifier( \@filenames );

    if ( $ENV{APPLY_ADS} )
    {
        my $dir = "lib/ads/";
        my %TEXTS = ( map { $_ => path("$dir/texts/$_")->slurp_utf8 }
                path("$dir/texts-lists.txt")->lines_utf8( { chomp => 1 } ) );

        my $cb = %TEXTS
            ? sub {
            my $text_ref = shift;
            my $r1 =
                ( $$text_ref =~
                    s%<div id="([^"]+)">Placeholder</div>%"\n" . $TEXTS{$1}%egms
                );
            my $r2 = _summary($text_ref);
            return ( $r1 || $r2 );
            }
            : \&_summary;

        foreach my $rec ( @filenames, @ad_filenames )
        {
            modify_on_change( scalar( path( $rec->{temp} ) ), $cb );
        }
    }
    foreach my $rec ( @filenames, @ad_filenames, @raw_filenames )
    {
        my $d = path("$dest_dir/$rec->{bn}");
        $d->parent->mkpath;
        write_on_change( $d, \( path( $rec->{temp} )->slurp_utf8 ) );
    }
}

1;
__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
