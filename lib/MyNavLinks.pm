package MyNavLinks;

use strict;
use warnings;

use parent 'HTML::Latemp::NavLinks::GenHtml::ArrowImages';

sub get_image_base
{
    return "arrow-2-";
}

sub _get_nav_buttons_html
{
    my $self = shift;

    my (%args) = (@_);

    my $with_accesskey = $args{'with_accesskey'};

    my $root = $self->root();

    my $template = Template->new(
        {
            'POST_CHOMP' => 1,
        }
    );

    my $vars = {
        'buttons' => scalar(
            $args{sorted}
            ? [ sort { $a->{dir} cmp $b->{dir} } @{ $self->_get_buttons() } ]
            : $self->_get_buttons()
        ),
        'root'           => $root,
        'with_accesskey' => $with_accesskey,
        'image_base'     => $self->get_image_base(),
        ext              => $self->_ext(),
    };

    my $nav_links_template = $args{nav_links_template} // <<'EOF';
[% USE HTML %]
[% FOREACH b = buttons %]
[% SET key = b.dir.substr(0, 1) %]
<li>
[% IF b.exists %]
<a href="[% HTML.escape(b.link_obj.direct_url()) %]" title="[% b.title %] (Alt+[% key FILTER upper %])"
[% IF with_accesskey %]
accesskey="[% key %]"
[% END %]
>[% END %]<img src="[% root %]/images/[% image_base %][% b.button %][% UNLESS b.exists %]-disabled[% END %][% ext %]"
alt="[% b.title %]" class="bless" />[% IF b.exists %]</a>
[% END %]
</li>
[% END %]
EOF

    my $nav_buttons_html = "";

    $template->process( \$nav_links_template, $vars, \$nav_buttons_html );
    return $nav_buttons_html;
}

1;
