package Shlomif::Homepage::NavBlocks::Master_Tr;

use strict;
use warnings;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Title_Tr');

has 'css_class' => (is => 'ro', isa => 'Str', default => 'main_title');

1;
