#! /usr/bin/env perl
#
# Run spork - my way
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
#
use strict;
use warnings;
use 5.014;
use autodie;

use Spork::Shlomify           ();
use Path::Tiny                qw/ path /;
use XML::LibXML               ();
use XML::LibXML::XPathContext ();

local $SIG{__WARN__} = sub {
    my $w = shift;
    warn $w if $w !~ m{\A(?:Creating slides|Slideshow created!)};
    return;
};

Spork::Shlomify->new->load_hub->command->process(@ARGV);

sub fix_spork
{
    my @fns = @{ shift() };

    foreach my $fn (@fns)
    {
        my $fh = path($fn);

        $fh->edit_utf8(
            sub {
                s%<tt>%<code>%gms;
                s%</tt>%</code>%gms;

s%<a accesskey='\S+'\s+href="">([^<]+)</a>%<strong>$1</strong>%gms;
                return;
            }
        );

        $fh->edit_lines_utf8(
            sub {

                $_ = ''
                    if m%\Q<link rel="stylesheet" type="text/css" href=""/>\E%;
                s/[\t ]+(\n?)\z/$1/;
            }
        );
        my $p         = XML::LibXML->new;
        my $indiv_dom = $p->parse_file($fn);

        my $xpc = XML::LibXML::XPathContext->new($indiv_dom);
        my $ns  = "http://www.w3.org/1999/xhtml";
        $xpc->registerNs( 'xhtml', $ns );
        while (
            my @nodes = $xpc->findnodes(
"//xhtml:ul/xhtml:ul | //xhtml:ul/xhtml:ol | //xhtml:ol/xhtml:ul | //xhtml:ol/xhtml:ol"
            )
            )
        {
            foreach my $node ( $nodes[0] )
            {
                my $parent = $node->parentNode;
                my $copy   = $node->cloneNode(1);
                my $li     = XML::LibXML::Element->new('li');
                $li->setNamespace($ns);
                $li->appendChild($copy);
                $parent->replaceChild( $li, $node );
            }
        }
        $fh->spew_utf8( $indiv_dom->toString() );
    }

    system(
        qw#tidy -quiet -asxhtml --show-warnings no --tidy-mark no --write-back yes#,
        @fns
    );
    return;
}

fix_spork( [ glob("slides/*.html") ] );
