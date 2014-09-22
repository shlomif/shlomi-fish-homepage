package Shlomif::Homepage::FortuneCollections::Record;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

has [qw(
    about_blurb
    desc
    id
    meta_desc
    page_title
    text
    title
)] => (is => 'ro', isa => 'Str', required => 1);

sub nav_record
{
    my ($self) = @_;

    return
    {
        text => scalar($self->text()),
        url => sprintf(
            "humour/fortunes/%s.html",
            scalar($self->id())
        ),
        title => scalar($self->title()),
    };
}

package Shlomif::Homepage::FortuneCollections;

use strict;
use warnings;

use 5.014;

use utf8;

use Carp;
use Data::Dumper;
use List::Util qw(max);

use YAML::XS (qw(LoadFile DumpFile));
use JSON::MaybeXS (qw(encode_json));

use IO::All;

use Shlomif::WrapAsUtf8 (qw(_print_utf8));

sub _init_fortune
{
    my ($class, $rec) = @_;

    return Shlomif::Homepage::FortuneCollections::Record->new($rec);
}

my $yaml_data_fn = $INC{'Shlomif/Homepage/FortuneCollections.pm'} =~ s#/[^/]+\z#/fortunes-meta-data.yml#r;
my $orig_fortunes_records = LoadFile($yaml_data_fn)->{'shlomif_fortunes_collections'}->{'fortunes'};

# DumpFile('./foo.yml', { shlomif_fortunes_collections => { fortunes => \@orig_fortunes_records, }, }, );

my @forts =
(
    map { __PACKAGE__->_init_fortune($_) } @$orig_fortunes_records,
);

sub get_fortune_records
{
    my ($class) = @_;

    return \@forts;
}

sub sorted_fortunes
{
    my ($class) = @_;

    return
    [
        sort { $a->id() cmp $b->id() }
        @{$class->get_fortune_records()}
    ];
}

sub nav_data
{
    my ($class) = @_;

    return [ map { $_->nav_record() } @{$class->sorted_fortunes()} ] ;
}

sub print_single_fortune_record_toc_entry
{
    my ($class, $r) = @_;

    my $id = $r->id;
    my $desc = $r->desc;

    _print_utf8( <<"EOF" );
<li>
<p>
<a href="$id.html"><b>$id</b></a>
(<a href="$id.xml">XML</a>, <a href="$id">Plaintext</a>) -
$desc
</p>
</li>
EOF

    return;
}

sub get_single_fortune_record_all_in_one_page_entry
{
    my ($class, $r) = @_;

    my $id = $r->id;
    my $title = $r->title;

    return <<"EOF";
<h2 id="$id">$title</h2>
<div class="fortunes_list">
(((((include "fortunes/xhtmls/$id.xhtml-for-input")))))
</div>
EOF
}

sub print_fortune_records_toc
{
    my ($class) = @_;

    foreach my $r (@{$class->get_fortune_records()})
    {
        $class->print_single_fortune_record_toc_entry($r);
    }

    return;
}

sub get_fortune_all_in_one_page_html_wml
{
    my ($class) = @_;

    my $ret = <<"EOF";
#include '../template.wml'

<latemp_subject "Shlomi Fish Fortunes Collections - All in One Page" />
<latemp_meta_desc "Shlomi Fish Fortunes Collections - All in One Page" />

<div class="page_toc">
<h2 id="toc">Table of Contents</h2>
<ul>
EOF

    foreach my $r (@{$class->get_fortune_records()})
    {

        my $id = $r->id();
        my $title = $r->title();

        $ret .= <<"FOO_EOF" ;
<li><a href="#$id">$title</a><br />
(((((include "fortunes/xhtmls/$id.toc-xhtml")))))
</li>
FOO_EOF

    }

    $ret .= "</ul>\n";
    $ret .= "</div>\n";

    foreach my $r (@{$class->get_fortune_records()})
    {
        $ret .= $class->get_single_fortune_record_all_in_one_page_entry($r);
    }

    return $ret;
}

my $deps_mtime_max = max(
    map { io->file($_)->mtime() }
    __FILE__ , $yaml_data_fn
);

sub _print_if_update_needed
{
    my ($class, $path, $contents_promise) = @_;

    my $fh = io->file($path);

    if ( (! $fh->exists()) ||  ($deps_mtime_max > $fh->mtime()) )
    {
        $fh->utf8->print(
            $contents_promise->(),
        );
    }

    return;
}

sub write_fortune_all_in_one_page_to_file
{
    my ($class, $filename) = @_;

    $class->_print_if_update_needed($filename,
        sub {
            return $class->get_fortune_all_in_one_page_html_wml();
        },
    );

    return;
}

sub get_single_fortune_page_html_wml
{
    my ($class, $r) = @_;

    my $id = $r->id();
    my $title = $r->title();

    return <<"EOF";
#include '../template.wml'

<latemp_subject "@{[$r->page_title()]}" />
<latemp_meta_desc "@{[$r->meta_desc()]}" />

<h2*>About</h2*>

@{[$r->about_blurb()]}

<h3>Table of Contents</h3>

(((((include "fortunes/xhtmls/$id.toc-xhtml")))))

<h2 id="fortunes-list">The Fortunes Themselves</h2>
<div class="fortunes_list">
(((((include "fortunes/xhtmls/$id.xhtml-for-input")))))
</div>
EOF
}

sub print_all_fortunes_html_wmls
{
    my ($class) = @_;


    foreach my $r (@{Shlomif::Homepage::FortuneCollections->sorted_fortunes() })
    {
        my $path = "t2/humour/fortunes/@{[$r->id()]}.html.wml";
        $class->_print_if_update_needed(
            $path,
            sub {
                return $class->get_single_fortune_page_html_wml($r);
            },
        );
    }
}

sub write_epub_json
{
    my ($class, $fn) = @_;

    io()->file($fn)->print
    (
        encode_json
        (
            +{
                filename => $fn,
                title => "Quotes / Fortunes Cookies by Shlomi Fish",
                authors =>
                [
                    {
                        name => "Shlomi Fish",
                        sort => "Fish, Shlomi",
                    }
                ],
                cover => "shlomif-fortunes.jpg",
                rights => "CC-by-sa",
                publisher => 'http://www.shlomifish.org/',
                language => 'en',
                subjects => ['Humor',],
                identifier =>
                {
                    scheme => 'URL',
                    value => q#http://www.shlomifish.org/humour/fortunes/#,
                },
                contents =>
                [
                    {
                        type => 'toc',
                        source => 'toc.html',
                    },
                    (
                        map
                        {
                            +{ type => 'text', source => ($_->id().".xhtml"), }
                        }
                        @{$class->get_fortune_records()},
                    ),
                ],
                toc =>
                {
                    depth => 2,
                    parse => ['text'],
                    generate =>
                    {
                        title => 'Index',
                    },
                },
            }
        )
    );
}

1;

