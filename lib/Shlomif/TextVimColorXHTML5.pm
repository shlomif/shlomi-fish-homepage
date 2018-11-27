# vim: set ts=2 sts=2 sw=2 expandtab smarttab:
#
# This file is part of Text-VimColor
#
# This software is copyright (c) 2002-2006 by Geoff Richards.
#
# This software is copyright (c) 2011 by Randy Stauner.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use warnings;
use strict;

package Shlomif::TextVimColorXHTML5;

use IO::File;
use File::Copy qw( copy );
use File::ShareDir ();
use File::Temp qw( tempfile );
use Path::Class qw( file );
use Carp;
use IPC::Open3 ();    # core
use Symbol     ();    # core

use parent 'Text::VimColor';

# for backward compatibility
our $SHARED = File::ShareDir::dist_dir('Text-VimColor');

our $VIM_COMMAND  = 'vim';
our @VIM_OPTIONS  = ( qw( -RXZ -i NONE -u NONE -N -n ), "+set nomodeline" );
our $NAMESPACE_ID = 'http://ns.laxan.com/text-vimcolor/1';

our %VIM_LET = (
    perl_include_pod => 1,
    'b:is_bash'      => 1,
);

our %ANSI_COLORS = (
    Comment    => 'blue',
    Constant   => 'red',
    Identifier => 'cyan',
    Statement  => 'yellow',
    PreProc    => 'magenta',
    Type       => 'green',
    Special    => 'bright_magenta',
    Underlined => 'underline',
    Ignore     => 'bright_white',
    Error      => 'on_red',
    Todo       => 'on_cyan',
);

# These extra syntax group are available but linked to the groups above by
# default in vim. They'll get their own highlighting if the user unlinks them.
our %SYNTAX_LINKS;

$SYNTAX_LINKS{$_} = 'Constant' for qw( String Character Number Boolean Float );

$SYNTAX_LINKS{$_} = 'Identifier' for qw( Function );

$SYNTAX_LINKS{$_} = 'Statement'
    for qw( Conditional Repeat Label Operator Keyword Exception );

$SYNTAX_LINKS{$_} = 'PreProc' for qw( Include Define Macro PreCondit );

$SYNTAX_LINKS{$_} = 'Type' for qw( StorageClass Structure Typedef );

$SYNTAX_LINKS{$_} = 'Special'
    for qw( Tag SpecialChar Delimiter SpecialComment Debug );

# Copy ansi color for main group to all subgroups.
$ANSI_COLORS{$_} = $ANSI_COLORS{ $SYNTAX_LINKS{$_} } for keys %SYNTAX_LINKS;

# Build a lookup table to determine if a syntax exists.
our %SYNTAX_TYPE = map { ( $_ => 1 ) }

    # Re-use ansi color hash.
    keys %ANSI_COLORS;

# Set to true to print the command line used to run Vim.
our $DEBUG = $ENV{TEXT_VIMCOLOR_DEBUG};

sub _xml_escape
{
    return Text::VimColor::_xml_escape(@_);
}

# Return a string consisting of the start of an XHTML file, with a stylesheet
# either included inline or referenced with a <link>.
sub _html_header
{
    my ($self) = @_;

    my $input_filename = $self->input_filename;
    my $title =
          defined $self->{html_title} ? _xml_escape( $self->{html_title} )
        : defined $input_filename     ? _xml_escape($input_filename)
        :                               '[untitled]';

    my $stylesheet;
    if ( $self->{html_inline_stylesheet} )
    {
        $stylesheet = "<style>\n";
        if ( $self->{html_stylesheet} )
        {
            $stylesheet .= _xml_escape( $self->{html_stylesheet} );
        }
        else
        {
            my $file = $self->{html_stylesheet_file};
            $file = $self->dist_file('light.css')
                unless defined $file;
            unless ( ref $file )
            {
                $file = IO::File->new( $file, 'r' )
                    or croak "error reading stylesheet '$file': $!";
            }
            local $/;
            $stylesheet .= _xml_escape(<$file>);
        }
        $stylesheet .= "</style>\n";
    }
    else
    {
        $stylesheet =
            "<link rel=\"stylesheet\" type=\"text/css\" href=\""
            . _xml_escape( $self->{html_stylesheet_url}
                || "file://${\ file($self->dist_file('light.css'))->as_foreign('Unix') }"
            ) . "\" />\n";
    }

    my $head = $self->{xhtml5}
        ? <<"EOF"
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
EOF
        : <<"EOF";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN\"
   http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
EOF

    my $meta = $self->{xhtml5} ? qq{<meta charset="utf-8"/>} : '';
    return
          $head
        . " <head>\n"
        . "  <title>$title</title>\n"
        . $meta . "\n"
        . "  $stylesheet"
        . " </head>\n"
        . " <body>\n\n" . "<pre>";
}
1;

__END__
