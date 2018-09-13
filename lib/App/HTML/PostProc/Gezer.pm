package App::HTML::PostProc::Gezer;

use strict;
use warnings;
use 5.014;

use MooX qw/ late /;
use Getopt::Long qw/ GetOptionsFromArray /;

use Cache::File ();
use Data::Munge qw/ list2re /;
use File::Update qw/ modify_on_change write_on_change /;
use Path::Tiny qw/ path /;

has '_minifier_conf_fn' => ( is => 'rw', isa => 'Str' );
has [ '_temp_dir', '_proc_dir' ] => ( is => 'rw' );

my $XMLNS_NEEDLE = <<'EOF';
 xmlns:db="http://docbook.org/ns/docbook" xmlns:d="http://docbook.org/ns/docbook" xmlns:vrd="http://www.shlomifish.org/open-source/projects/XML-Grammar/Vered/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xhtml="http://www.w3.org/1999/xhtml"
EOF

my @NEEDLES = $XMLNS_NEEDLE =~ m#\b(xmlns:[a-zA-Z_]+="[^"]+")#g;

my $ALTERNATIVES_TEXT = list2re @NEEDLES;

sub _summary
{
    my $text_ref = shift;
    if ( index( $$text_ref, q#<!DOCTYPE html># ) >= 0 )
    {
        return $$text_ref =~
            s%(<table(?:\s+(?:class|style)="[^"]*"\s*)*) summary=""%$1%g;
    }
    else
    {
        my $r1 = $$text_ref =~ s%<main\b%<div class="main"%g;
        my $r2 = $$text_ref =~ s%</main>%</div>%g;
        return $r1 || $r2;
    }
}

sub _call_minifier
{
    my ( $self, $filenames ) = @_;
    my $KEY = 'HTML_POST_INCS_DATA_DIR';
    my $cache =
        Cache::File->new( cache_root => ( $ENV{$KEY} || '/tmp/cacheroot' ) );

    my @queue;
    my $_proc_dir = Path::Tiny->tempdir;
    $self->_proc_dir($_proc_dir);
    my $temp_dir = $self->_temp_dir;
    foreach my $rec (@$filenames)
    {
        my $temp_bn = $rec->{temp_bn};
        my $src     = $temp_dir->child($temp_bn);
        my $k       = $src->slurp;
        my $e       = $cache->entry($k);
        if ( $e->exists )
        {
            $_proc_dir->child($temp_bn)->spew( $e->get );
            $src->remove;
        }
        else
        {
            push @queue, [ $e, $temp_bn ];
        }
    }
    if (@queue)
    {
        system(
            'html-minifier', '-c', $self->_minifier_conf_fn, '--input-dir',
            $temp_dir . '',
            '--output-dir', $_proc_dir . '',
        ) and die "html-min $!";
        foreach my $fn (@queue)
        {
            $fn->[0]->set( scalar( $_proc_dir->child( $fn->[1] )->slurp ),
                '100000 days' );
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
    my $mode;
    my $conf;
    my $texts_dir;
    GetOptionsFromArray(
        $argv,
        'mode=s'          => \$mode,
        'source-dir=s'    => \$source_dir,
        'dest-dir=s'      => \$dest_dir,
        'texts-dir=s'     => \$texts_dir,
        'minifier-conf=s' => \$conf,
    ) or die "$!";

    if ( $mode ne 'minify' )
    {
        die qq#--mode should be "minify"!#;
    }
    $self->_minifier_conf_fn($conf);
    my $temp_dir = Path::Tiny->tempdir;
    $self->_temp_dir($temp_dir);
    my $counter = 0;

    my $APPLY_TEXTS = $ENV{APPLY_TEXTS};
    my $INCS        = !$ENV{NO_I};
    my $FORTUNES    = $ENV{F};
    my $ALWAYS_MIN  = $ENV{ALWAYS_MIN};

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

                if ($INCS)
                {
                    $text =~
s#^\({5}include[= ](['"])([^'"]+)\1\){5}\n#path("lib/$2")->slurp_utf8#egms;
                    $text =~
s#\({5}chomp_inc[= ](['"])([^'"]+)\1\){5}#my ($l) = path("lib/$2")->lines_utf8({count => 1});chomp$l;$l#egms;
                }

                if ($FORTUNES)
                {
                    foreach my $class (qw(info irc-conversation))
                    {
                        my $table_from = qq{<table class="$class">};
                        my $table_to   = qq{<table class="$class" summary="">};

                        $text =~ s#\Q$table_from\E#$table_to#g;
                    }
                }

                $text =~ s# +$##gms;
                $text =~ s#</(?:div|li|html)>\n\K\n##g;

                $text =~ s#\s+xml:space="[^"]*"##g;
                $text =~ s#(<div)(?:\s+(?:$ALTERNATIVES_TEXT))+#$1 #gms;

                # Remove surrounding space of tags.
                $text =~
s#\s*(</?(?:body|(?:br /)|div|head|li|ol|p|title|ul)>)\s*#$1#gms;

                # Remove document trailing space.
                $text =~ s#\s+\z##ms;

                my $temp_bn = ( ++$counter ) . ".html";
                my $temp_fh = $temp_dir->child($temp_bn);
                $temp_fh->spew_utf8($text);
                my $rec = +{
                    bn      => $bn,
                    temp_bn => $temp_bn,
                };
                if ( $ALWAYS_MIN // ( $text ne $orig_text ) )
                {
                    push @filenames, $rec;
                }
                elsif ($APPLY_TEXTS)
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

    my $_proc_dir = $self->_proc_dir;
    if ($APPLY_TEXTS)
    {
        my %TEXTS =
            ( map { $_ => path("$texts_dir/texts/$_")->slurp_utf8 }
                path("$texts_dir/texts-lists.txt")->lines_utf8( { chomp => 1 } )
            );

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
            modify_on_change( scalar( $_proc_dir->child( $rec->{temp_bn} ) ),
                $cb );
        }
    }
    foreach my $rec ( @filenames, @ad_filenames, @raw_filenames )
    {
        my $d = path("$dest_dir/$rec->{bn}");
        $d->parent->mkpath;
        write_on_change( $d,
            \( $_proc_dir->child( $rec->{temp_bn} )->slurp_utf8 ) );
    }
    $self->_temp_dir(undef);
    $self->_proc_dir(undef);
    return;
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
