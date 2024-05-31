package App::TempGezer;

# ABSTRACT: HTML Postprocessor and frontend to html-minifier

use strict;
use warnings;
use 5.014;

use Carp::Always;
use Moo;
use Getopt::Long qw/ GetOptionsFromArray /;

use CHI          ();
use Data::Munge  qw/ list2re /;
use DBI          ();
use File::Update qw/ modify_on_change write_on_change /;
use Path::Tiny   qw/ path /;

$App::TempGezer::VERSION = '0.0.4';

has '_minifier_conf_fn'          => ( is => 'rw', );
has [ '_temp_dir', '_proc_dir' ] => ( is => 'rw', );

my $XMLNS_NEEDLE = <<'EOF';
 xmlns:db="http://docbook.org/ns/docbook" xmlns:d="http://docbook.org/ns/docbook" xmlns:vrd="http://www.shlomifish.org/open-source/projects/XML-Grammar/Vered/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xhtml="http://www.w3.org/1999/xhtml"
EOF

my @NEEDLES = $XMLNS_NEEDLE =~ m#\b(xmlns:[a-zA-Z_]+="[^"]+")#g;

my $ALTERNATIVES_TEXT = list2re @NEEDLES;

my $full_db_path = "node_modules/sects.sqlite3";

my $dbh = DBI->connect( "dbi:SQLite:dbname=$full_db_path",
    "", "", { RaiseError => 1 } );

$dbh->begin_work;

my $sth = $dbh->prepare("SELECT data FROM t WHERE str_id = ? AND url = ?");

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
        my $r1 = $$text_ref =~
s%(<main(?:\s+(?:class|id|style)="[^"]*"\s*)*>)%my $s = $1; $s=~s/main/div/;$s=~s/(\sclass=")/${1}main /;$s%egms;
        my $r2 = $$text_ref =~ s%</main>%</div>%g;
        return $r1 || $r2;
    }
}

sub _call_minifier
{
    my ( $self, $filenames, $ad_filenames ) = @_;
    my $KEY   = 'HTML_POST_INCS_DATA_DIR';
    my $cache = CHI->new(
        driver   => 'File',
        root_dir => (
            $ENV{$KEY}
                || (
                ( $ENV{TMPDIR} || '/tmp' ) . '/html-post-proc-gezer-cache' )
        )
    );

    my @queue;
    my $_proc_dir = Path::Tiny->tempdir;
    $self->_proc_dir($_proc_dir);
    my $temp_dir = $self->_temp_dir;
    foreach my $rec ( @$filenames, @$ad_filenames )
    {
        my $temp_bn = $rec->{temp_bn};
        my $src     = $temp_dir->child($temp_bn);
        my $k       = $src->slurp;
        my $e       = $cache->get($k);
        if ( defined $e )
        {
            $_proc_dir->child($temp_bn)->spew($e);
            $src->remove;
        }
        else
        {
            push @queue, [ $k, $temp_bn ];
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
            $cache->set( $fn->[0],
                scalar( $_proc_dir->child( $fn->[1] )->slurp ),
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
s#^\({5}include[= ](['"])cache/combined/([^'"]+)/([^/\)\'\"]+)\1\){5}\n#$sth->fetchrow_arrayref($2, $1)->[0]#egms;
                    $text =~
s#\({5}chomp_inc[= ](['"])cache/combined/([^'"]+)/([^/\)\'\"]+)\1\){5}#my $l = $sth->fetchrow_arrayref($2, $1)->[0]; chomp$l; $l#egms;
                }

                $text =~ s# +$##gms;
                $text =~ s#</(?:div|li|html)>\n\K\n##g;

                # $text =~ s#\s+xml:space="[^"]*"##g;
                $text =~ s#(<div)(?:\s+(?:$ALTERNATIVES_TEXT))+#$1 #gms;

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

    $self->_call_minifier( \@filenames, \@ad_filenames );

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
    foreach my $rec (@raw_filenames)
    {
        my $temp_bn = $rec->{temp_bn};
        $_proc_dir->child($temp_bn)
            ->spew_raw( $temp_dir->child($temp_bn)->slurp_raw );
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

=pod

=encoding UTF-8

=head1 NAME

App::Gezer - HTML Postprocessor and frontend to html-minifier .

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
