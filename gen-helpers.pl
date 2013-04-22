#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Latemp::GenMakeHelpers;
use File::Find::Object::Rule;
use IO::All;
use File::Which qw(which);
use YAML::XS (qw(LoadFile));

use List::MoreUtils;

{
    my @not_found;

    foreach my $cmd (
        io->file("./bin/needed-executables.txt")->chomp->getlines()
    )
    {
        if (not
            (
                ($cmd =~ m{\A/})
                ? (-e $cmd)
                : (defined(scalar(which($cmd))))
            )
        )
        {
            push @not_found, $cmd;
        }
    }

    if (@not_found)
    {
        print "The following commands could not be found:\n\n";
        foreach my $cmd (sort { $a cmp $b } @not_found)
        {
            print "$cmd\n";
        }
        exit(-1);
    }
}

{
    my ($yaml_data) = LoadFile("./bin/required-modules.yml");

    my $required_modules = $yaml_data->{required}->{modules};

    my @not_found;

    foreach my $m (sort { $a cmp $b } keys(%$required_modules))
    {
        my $v = $required_modules->{$m};
        local $SIG{__WARN__} = sub {};
        my $verdict = eval( "use $m " . ($v ||'') . ';' );
        my $Err = $@;

        if ($Err)
        {
            push @not_found, $m;
        }
    }

    if (@not_found)
    {
        print "The following modules could not be found:\n\n";
        foreach my $module (@not_found)
        {
            print "$module\n";
        }
        exit(-1);
    }
}

my $generator =
    HTML::Latemp::GenMakeHelpers->new(
        'hosts' =>
        [ map {
            +{ 'id' => $_, 'source_dir' => $_,
                'dest_dir' => "\$(ALL_DEST_BASE)/$_-homepage"
            }
        } (qw(common t2 vipe)) ],
    );

$generator->process_all();


my $text = io("include.mak")->slurp();
$text =~ s!^(T2_DOCS = .*)humour/fortunes/index\.html!$1!m;
$text =~ s!^(T2_IMAGES = .*)humour/fortunes/show\.cgi!$1!m;
$text =~ s{ *humour/fortunes/\S+\.tar\.gz}{}g;
io("include.mak")->print($text);

sub _my_system
{
    my $cmd = shift;

    print join(' ', @$cmd), "\n";
    if (system { $cmd->[0] } (@$cmd)) {
        die "<<@$cmd>> failed.";
    }
}

foreach my $cmd (
    [ "./bin/gen-docbook-make-helpers.pl" ],
    [ "./bin/gen-fortunes.pl" ],
    [ "./bin/gen-deps-mak.pl" ],
)
{
    _my_system($cmd);
}

=begin removed_duplicate_code

my $wml_deps = io->file("deps.mak");

foreach my $wml_obj (
    io->dir("t2")->filter(sub { $_->filename =~ qr/\.wml\z/ })->All_Files
)
{
    my $filename = $wml_obj->canonpath;
    my @deps =
        grep { $_ ne '../template.wml' }
    List::MoreUtils::uniq(
        map { /\A\s*#include (?:'([^']+)'|"([^"]+)"|<([^>]+)>)\s*\z/ ? ($1 || $2 || $3) : () }
        grep { /\A\s*#include/ } $wml_obj->chomp->getlines);

    foreach my $dep (@deps)
    {
        foreach my $dir (".", "lib")
        {
            my $full_dep = "$dir/$dep";
            if (-e $full_dep)
            {
                print "$filename: $full_dep\n";
            }
        }
    }
}

=end removed_duplicate_code

=cut

1;
