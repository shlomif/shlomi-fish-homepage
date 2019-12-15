package Shlomif::Homepage::LicenseBlurbs;

use strict;
use warnings;
use utf8;

use Moo;

has 'base_path' => ( is => 'rw' );

sub by_sa_british_blurb
{
    my ( $self, $args ) = @_;

    my $year = $args->{year};

    return <<"EOF";
<p>
This document is Copyright by Shlomi Fish, $year, and is available
under the
terms of <a rel="license"
href="http://creativecommons.org/licenses/by-sa/3.0/">the Creative Commons
Attribution-ShareAlike License 3.0 Unported</a> (or at your option any
later version).
</p>

<p>
For securing additional rights, please contact
<a href="http://www.shlomifish.org/me/contact-me/">Shlomi Fish</a>
and see <a href="http://www.shlomifish.org/meta/copyrights/">the
explicit requirements</a> that are being spelt from abiding by that licence.
</p>
EOF
}

sub by_sa_license_british
{
    my ( $self, $args ) = @_;

    my $head_tag = $args->{head_tag} // 'h3';

    return qq#<$head_tag id="license">Copyright and Licence</$head_tag>#
        . $self->by_sa_british_blurb($args);
}

sub by_british_blurb
{
    my ( $self, $args ) = @_;

    my $year = $args->{year};

    return <<"EOF";
<p><a rel="license" href="http://creativecommons.org/licenses/by/3.0/"><img alt="Creative Commons License" class="bless" src="@{[$self->base_path]}images/somerights20.png"/></a></p>

<p>
This document is Copyright by Shlomi Fish, $year, and is available
under the
terms of <a rel="license"
href="http://creativecommons.org/licenses/by/3.0/">the Creative Commons
Attribution License 3.0 Unported</a> (or at your option any
later version of that licence).
</p>

<p>
For securing additional rights, please contact
<a href="http://www.shlomifish.org/me/contact-me/">Shlomi Fish</a>
and see <a href="http://www.shlomifish.org/meta/copyrights/">the
explicit requirements</a> that are being spelt from abiding by that licence.
</p>
EOF
}

sub by_hebrew_blurb
{
    my ( $self, $args ) = @_;

    my $year = $args->{year};

    return <<"EOF";
<p><a rel="license" href="http://creativecommons.org/licenses/by/2.5/deed.he"><img alt="Creative Commons License" class="bless" src="@{[$self->base_path]}images/somerights20.png"/></a></p>

<p>
זכויות היוצרים על מסמך זה שייכות לשלומי פיש, והוא נוצר בשנת ${year},
תחת תנאי
<a rel="license" href="http://creativecommons.org/licenses/by/2.5/deed.he">הרישיון
ייחוס 2.5 לא מותאם של קריאייטיב קומונס Creative Commons)</a>
(או לשיקולכם כל גרסה מאוחרת יותר של אותו הרישיון.)
</p>

<p>
בשביל לרכוש זכויות נוספות, אנא צרו קשר עם
<a href="http://www.shlomifish.org/me/contact-me/">שלומי פיש</a>
ושימו לב
<a href="http://www.shlomifish.org/meta/copyrights/">לדרישות המפורשות</a>
שהוא דורש כדי לעמוד בתנאי הרישיון הזה.
</p>
EOF
}

sub by_nc_sa_british_blurb
{
    my ( $self, $args ) = @_;

    my $year = $args->{year};

    return <<"EOF";
<p>
This document is Copyright by Shlomi Fish, $year, and is made
available under the
terms of <a rel="license"
href="http://creativecommons.org/licenses/by-nc-sa/3.0/">the Creative Commons
Attribution Noncommercial ShareAlike License 3.0 Unported</a> (or at your
option any later version).
</p>

<p>
For securing additional rights, please contact
<a href="http://www.shlomifish.org/me/contact-me/">Shlomi Fish</a>
and see <a href="http://www.shlomifish.org/meta/copyrights/">the
explicit requirements</a> that are being spelt from abiding by that licence.
</p>
EOF
}

1;

__END__
# # Below is stub documentation for your module. You'd better edit it!