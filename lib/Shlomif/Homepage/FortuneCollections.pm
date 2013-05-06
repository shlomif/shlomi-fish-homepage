package Shlomif::Homepage::FortuneCollections::Record;

use strict;
use warnings;

use utf8;

use base 'Class::Accessor';

my @req_fields = (qw(
    about_blurb
    desc
    id
    meta_desc
    page_title
    text
    title
));

__PACKAGE__->mk_accessors(@req_fields);

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

use YAML::XS (qw(LoadFile DumpFile));

use Shlomif::WrapAsUtf8 (qw(_wrap_as_utf8));

sub _init_fortune
{
    my $rec = shift;

    foreach my $req_field (@req_fields)
    {
        if (!exists($rec->{$req_field}))
        {
            Carp::confess("Field $req_field does not exist in record for "
                . Dumper($rec) . "!");
        }
    }

    return Shlomif::Homepage::FortuneCollections::Record->new($rec);
}

my $yaml_data_fn = $INC{'Shlomif/Homepage/FortuneCollections.pm'} =~ s#/[^/]+\z#/fortunes-meta-data.yml#r;
my $orig_fortunes_records = LoadFile($yaml_data_fn)->{'shlomif_fortunes_collections'}->{'fortunes'};

# DumpFile('./foo.yml', { shlomif_fortunes_collections => { fortunes => \@orig_fortunes_records, }, }, );

my @forts =
(
    map { _init_fortune($_) } @$orig_fortunes_records,
);

sub get_fortune_records
{
    return \@forts;
}

sub sorted_fortunes
{
    return
    [
        sort { $a->id() cmp $b->id() }
        @{get_fortune_records()}
    ];
}

sub nav_data
{
    return [ map { $_->nav_record() } @{sorted_fortunes()} ] ;
}

sub print_single_fortune_record_toc_entry
{
    my ($class, $r) = @_;

    my $id = $r->id;
    my $desc = $r->desc;

    _wrap_as_utf8(
        sub
        {
            print <<"EOF";
<li>
<p>
<a href="$id.html"><b>$id</b></a>
(<a href="$id.xml">XML</a>, <a href="$id">Plaintext</a>) -
$desc
</p>
</li>
EOF
        },
    );

    return;
}

sub print_single_fortune_record_all_in_one_page_entry
{
    my ($class, $r) = @_;

    my $id = $r->id;
    my $desc = $r->desc;
    my $text = $r->text;
    my $title = $r->title;

    print <<"EOF";
<h2 id="$id">$title</h2>
<div class="fortunes_list">
#include "fortunes/xhtmls/$id.xhtml-for-input"
</div>
EOF

    return;
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

sub print_fortune_all_in_one_page
{
    my ($class) = @_;

    print <<"EOF";
#include '../template.wml'
#include "render_fortunes_pages.wml"

<latemp_subject "Shlomi Fish Fortunes Collections - All in One Page" />
<latemp_meta_desc "Shlomi Fish Fortunes Collections - All in One Page" />

<toc_div head_tag="h2" />

EOF

    foreach my $r (@{$class->get_fortune_records()})
    {
        $class->print_single_fortune_record_all_in_one_page_entry($r);
    }

    return;
}

1;

