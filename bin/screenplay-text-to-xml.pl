#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Getopt::Long qw/ GetOptions /;
use XML::Grammar::Screenplay::FromProto              ();
use XML::Grammar::Screenplay::FromProto::Parser::QnD ();

sub run
{
    my $output_fn;

    GetOptions( "output|o=s" => \$output_fn, );

    if ( !defined($output_fn) )
    {
        die "Output filename not specified! Use the -o|--output flag!";
    }

    my $converter = XML::Grammar::Screenplay::FromProto->new(
        {
            parser_class => "XML::Grammar::Screenplay::FromProto::Parser::QnD",
        }
    );

    my $xml = $converter->convert(
        {
            source => { file => shift(@ARGV), },
        },
    );

    open my $out, ">:encoding(UTF-8)", $output_fn;
    print {$out} $xml;
    close($out);

    exit(0);
}

run;

1;

__END__

=encoding UTF-8

=head1 NAME

XML::Grammar::Screenplay::App::FromProto

=head1 VERSION

version v0.16.0

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
