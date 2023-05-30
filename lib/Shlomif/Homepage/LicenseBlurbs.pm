# Copyright 2020 Shlomi Fish ( https://www.shlomifish.org/ )
# Author: Shlomi Fish ( https://www.shlomifish.org/ )
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package Shlomif::Homepage::LicenseBlurbs;

use strict;
use warnings;
use utf8;

use Moo;

has 'base_path'        => ( is => 'rw' );
has 'contact_url'      => ( is => 'ro', required => 1, );
has 'copyright_holder' => ( is => 'ro', required => 1, );

sub by_sa_british_blurb
{
    my ( $self, $args ) = @_;

    my $year    = $args->{year};
    my $version = $args->{version} // '3.0';

    return <<"EOF";
<p>
This document is Copyright by @{[$self->copyright_holder()]}, $year, and is available
under the
terms of <a rel="license"
href="http://creativecommons.org/licenses/by-sa/$version/">the Creative Commons
Attribution-ShareAlike License (CC-by-sa) $version Unported</a> (or at your option any
later version).
</p>

<p>
For securing additional rights, please contact
<a href="@{[$self->contact_url()]}">@{[$self->copyright_holder()]}</a>
and see <a href="http://www.shlomifish.org/meta/copyrights/">the
explicit requirements</a> that are being spelt from abiding by that licence.
</p>
EOF
}

sub by_sa_license_british
{
    my ( $self, $args ) = @_;

    my $head_tag = $args->{head_tag} // 'h3';

    return
qq#<section><header><$head_tag id="license">Copyright and Licence</$head_tag></header>#
        . $self->by_sa_british_blurb($args)
        . qq#</section>#;
}

sub by_british_blurb
{
    my ( $self, $args ) = @_;

    my $year    = $args->{year};
    my $url     = $args->{url}     // "https://www.shlomifish.org/";
    my $version = $args->{version} // '3.0';

    return <<"EOF";
<p><a rel="license" href="http://creativecommons.org/licenses/by/$version/"><img alt="Creative Commons License" class="bless" src="@{[$self->base_path]}images/somerights20.png"/></a></p>

<p>
This document is Copyright by <a href="$url">@{[$self->copyright_holder()]}</a>, $year, and is available
under the
terms of <a rel="license"
href="http://creativecommons.org/licenses/by/$version/">the Creative Commons
Attribution License (CC-by) $version Unported</a> (or at your option any
later version of that licence).
</p>

<p>
For securing additional rights, please contact
<a href="@{[$self->contact_url()]}">@{[$self->copyright_holder()]}</a>
and see <a href="http://www.shlomifish.org/meta/copyrights/">the
explicit requirements</a> that are being spelt from abiding by that licence.
</p>
EOF
}

sub by_hebrew_blurb
{
    my ( $self, $args ) = @_;

    my $year    = $args->{year};
    my $version = $args->{version} // '2.5';

    return <<"EOF";
<p><a rel="license" href="http://creativecommons.org/licenses/by/$version/deed.he"><img alt="Creative Commons License" class="bless" src="@{[$self->base_path]}images/somerights20.png"/></a></p>

<p>
זכויות היוצרים על מסמך זה שייכות לשלומי פיש, והוא נוצר בשנת ${year},
תחת תנאי
<a rel="license" href="http://creativecommons.org/licenses/by/$version/deed.he">הרישיון
ייחוס 2.5 לא מותאם של קריאייטיב קומונס Creative Commons)</a>
(או לשיקולכם כל גרסה מאוחרת יותר של אותו הרישיון.)
</p>

<p>
בשביל לרכוש זכויות נוספות, אנא צרו קשר עם
<a href="@{[$self->contact_url()]}">שלומי פיש</a>
ושימו לב
<a href="http://www.shlomifish.org/meta/copyrights/">לדרישות המפורשות</a>
שהוא דורש כדי לעמוד בתנאי הרישיון הזה.
</p>
EOF
}

sub by_nc_sa_british_blurb
{
    my ( $self, $args ) = @_;

    my $year    = $args->{year};
    my $version = $args->{version} // '3.0';

    return <<"EOF";
<p>
This document is Copyright by @{[$self->copyright_holder()]}, $year, and is made
available under the
terms of <a rel="license"
href="http://creativecommons.org/licenses/by-nc-sa/$version/">the Creative Commons
Attribution Noncommercial ShareAlike License (CC-by-nc-sa) $version Unported</a> (or at your
option any later version).
</p>

<p>
For securing additional rights, please contact
<a href="@{[$self->contact_url()]}">@{[$self->copyright_holder()]}</a>
and see <a href="http://www.shlomifish.org/meta/copyrights/">the
explicit requirements</a> that are being spelt from abiding by that licence.
</p>
EOF
}

1;

__END__
