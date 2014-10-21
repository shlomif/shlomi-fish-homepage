#!/usr/bin/perl

use strict;
use warnings;

use lib '/home/shlomi/apps/test/quadpres/share/quad-pres/perl5/';

use Shlomif::Quad::Pres;
use Shlomif::Quad::Pres::FS;
use Shlomif::Quad::Pres::Config;

use File::Copy;
use File::Basename;

require Contents;

my $contents = Contents::get_contents();

my $dest_dir = "rendered";

if ($dest_dir !~ /\/$/)
{
    $dest_dir .= "/";
}

my $cfg = Shlomif::Quad::Pres::Config->new();
my $group = $cfg->get_setgid_group();

my $render_all = 0;

my $quadpres_obj =
    Shlomif::Quad::Pres->new(
        $contents,
        'doc_id' => "/",
        'mode' => "server",
    );

my $all_in_one_dir = "all-in-one";
mkdir($all_in_one_dir);;
my $all_fn = "$all_in_one_dir/index.html";
open my $all_in_one_out_fh, ">", $all_fn;

my $is_first = 1;

sub copy_with_creating_dir
{
    my ($src_fn, $dest_fn) = @_;
    File::Path::mkpath([dirname($dest_fn)]);
    return copy($src_fn, $dest_fn);
}

sub _get_file_mtime
{
    my ($self,$path) = @_;

    return (stat($path))[9];
}

sub calc_page_id
{
    my $link_path_ref = shift;

    my @link_path = @$link_path_ref;

    if (@link_path && $link_path[-1] =~ s{\.html\z}{})
    {
        push @link_path, "PAGE";
    }
    else
    {
        push @link_path, "DIR";
    }

    return join ("--", "page", @link_path);
}

sub render_to_all_in_one
{
    my (%arguments) = (@_);

    my $path_ref = $arguments{'path'};
    my $branch = $arguments{'branch'};

    my (@path);

    @path = @{$path_ref};

    my $p = join("/", @path);

    {
        my $filename;

        my $is_dir = exists($branch->{'subs'});

        if ($is_dir)
        {
            # It is a directory
            $filename = ($dest_dir . "/" . $p);
            $filename .= "/index.html";
        }
        else
        {
            $filename = ($dest_dir . "/" . $p);
        }

        open my $in, "<", $filename;
        local $/;
        my $text = <$in>;

        if (! $is_first)
        {
            $text =~ s{.*?(<table class="page-nav-bar top")}{$1}ms;
        }
        else
        {
            $text =~ s{<link rel="(?:top|next|first|last)".*?/>}{}gms;
        }
        $is_first = 0;

        # Remove the trailing stuff.
        $text =~ s{<table class="page-nav-bar bottom".*}{}ms;

        my $fix_internal_link = sub {
            my $link_text = shift;

            my $is_current_dir = $is_dir;

            # Preserve absolute links to the outside world.
            if ($link_text =~ m{\A[\w\-\+]+:})
            {
                return $link_text;
            }

            my @link_path = @path;

            foreach my $component (split(m{/}, $link_text))
            {
                if ($component eq ".")
                {
                    if (! $is_current_dir)
                    {
                        pop(@link_path);
                        $is_current_dir = 1;
                    }
                }
                elsif ($component eq "..")
                {
                    pop(@link_path);
                }
                else
                {
                    if (! $is_current_dir)
                    {
                        pop(@link_path);
                        $is_current_dir = 1;
                    }

                    push @link_path, $component;
                }
            }

            return "#" . calc_page_id(\@link_path);
        };


        # Fix the internal links
        $text =~
            s{(<a href=")([^"]+)(")}
             {$1 . $fix_internal_link->($2) . $3}egms
            ;

        my $div_tag =
            qq{<div class="page" id="} . calc_page_id(\@path) .qq{">\n}
            ;

        if ($text !~ s{(<body[^>]*>)}{$1$div_tag}ms)
        {
            $text = $div_tag . $text;
        }

        print {$all_in_one_out_fh} $text, qq{\n</div>\n};
        close($in);
    }
    if (exists($branch->{'images'}))
    {
        foreach my $image (@{$branch->{'images'}})
        {
            my $src_filename = $dest_dir . "/" . $p . "/" . $image ;
            my $dest_filename = $all_in_one_dir . "/" . $p . "/" . $image ;

            my $src_mtime = _get_file_mtime(undef, $src_filename);
            my $dest_mtime = _get_file_mtime(undef, $dest_filename);

            if ((! -e $dest_filename) ||
                ($src_mtime > $dest_mtime)
                )
            {
                copy_with_creating_dir($src_filename, $dest_filename);
            }
        }
    }

}

$quadpres_obj->traverse_tree(\&render_to_all_in_one);

print {$all_in_one_out_fh} "\n</body></html>\n";
close($all_in_one_out_fh);

system("cp", "-a", $all_in_one_dir, "/var/www/html/shlomi/perl/p4n-lecture1-all-in-one");
