package MyNavLinks;

use strict;
use warnings;

use parent 'HTML::Latemp::NavLinks::GenHtml::ArrowImages';
sub get_image_base
{
    return "arrow-2-";
}

1;
