#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Getopt::Long qw/ GetOptions /;
use XML::Grammar::Screenplay::ToHTML ();

sub run
{
    my $output_fn;

    GetOptions( "output|o=s" => \$output_fn, );

    if ( !defined($output_fn) )
    {
        die "Output filename not specified! Use the -o|--output flag!";
    }

    my $output_text = XML::Grammar::Screenplay::ToHTML->new->translate_to_html(
        {
            source => { file => shift(@ARGV), },
            output => "string",
        }
    );
    $output_text =~ s/[ \t]+$//gms;

    open my $out, ">:encoding(UTF-8)", $output_fn;
    print {$out} $output_text;
    close($out);

    exit(0);
}

run;

__END__

=encoding UTF-8

=head1 NAME

XML::Grammar::Screenplay::App::ToHTML

=head1 VERSION

version v0.16.0

=head1 NAME

XML::Grammar::Screenplay::App::ToHTML - module implementing
a command line application to convert a Screenplay XML file to HTML

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
