#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Latemp::GenMakeHelpers;
use File::Find::Object::Rule;
use IO::All;
use File::Which qw(which);

use List::MoreUtils;

{
    foreach my $cmd (qw(
        asciidoc
        docmake
        inkscape
        jing
        xsltproc
        ))
    {
        if (!defined(scalar(which($cmd))))
        {
            die "Cannot find '$cmd' in path. Please install it.";
        }
    }
}

{
    my %required_modules =
    (
        'CGI' => 0,
        'CGI::Minimal' => 0,
        'Carp' => 0,
        'Cwd' => 0,
        'DBD::SQLite' => 0,
        'DBI' => 0,
        'Data::Dumper' => 0,
        'DateTime' => 0,
        'Encode' => 0,
        'Exporter' => 0,
        'Fcntl' => 0,
        'File::Basename' => 0,
        'File::Copy' => 0,
        'File::Find' => 0,
        'File::Find::Object' => 0,
        'File::Find::Object::Rule' => 0,
        'File::Path' => 0,
        'File::Spec' => 0,
        'File::Spec::Functions' => 0,
        'File::Which' => 0,
        'Getopt::Long' => 0,
        'HTML::Latemp::GenMakeHelpers' => 0,
        'HTML::Parser' => '3.00',
        'HTML::Tidy' => 0,
        'HTML::TreeBuilder::LibXML' => 0,
        'HTML::Widgets::NavMenu' => 0,
        'HTML::Widgets::NavMenu::ToJSON' => 0,
        'HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML' => 0,
        'IO::All' => 0,
        'IO::Handle' => 0,
        'Imager' => 0,
        'JSON' => 0,
        'LWP::Simple' => 0,
        'List::MoreUtils' => 0,
        'List::Util' => 0,
        'MIME::Types' => 0,
        'Math::Trig' => 0,
        'Module::Build' => 0,
        'Moose' => 0,
        'POSIX' => 0,
        'Parallel::ForkManager' => 0,
        'SVG' => 0,
        'String::ShellQuote' => 0,
        'Template' => 0,
        'Template::Preprocessor::TTML' => 0,
        'Template::Preprocessor::TTML::CmdLineProc' => 0,
        'Term::ReadPassword' => 0,
        'Test::Count' => 0,
        'Test::Count::Filter' => 0,
        'Test::More' => 0,
        'Text::Hunspell' => 0,
        'Text::VimColor' => 0,
        'XML::Feed' => 0,
        'XML::Grammar::Fortune' => 0,
        'XML::Grammar::Fiction::App::ToDocBook' => 0,
        'XML::Grammar::Fiction::App::FromProto' => 0,
        'XML::Grammar::Screenplay::App::FromProto' => 0,
        'XML::Grammar::Screenplay::App::ToHTML' => 0,
        'XML::Grammar::Fortune::ToText' => 0,
        'XML::Grammar::ProductsSyndication' => 0,
        'XML::LibXML' => 0,
        'XML::LibXML::Reader' => 0,
        'XML::LibXML::XPathContext' => 0,
        'XML::LibXSLT' => 0,
        'XML::Parser' => 0,
        'XML::Writer' => 0,
        'XML::Writer' => 0,
        'autodie' => 0,
        'base' => 0,
        'constant' => 0,
        'lib' => 0,
        'parent' => 0,
        'strict' => 0,
        'utf8' => 0,
        'vars' => 0,
        'warnings' => 0,
    );

    my @not_found;

    foreach my $m (sort { $a cmp $b } keys(%required_modules))
    {
        my $v = $required_modules{$m};
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
