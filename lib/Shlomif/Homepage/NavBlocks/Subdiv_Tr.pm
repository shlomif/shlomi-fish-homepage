package Shlomif::Homepage::NavBlocks::Subdiv_Tr;

use strict;
use warnings;

use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Title_Tr');

has 'css_class' => ( is => 'ro', isa => 'Str', default => 'subdiv' );

1;
