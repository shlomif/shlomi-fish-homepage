#!/usr/bin/env perl

use strict;
use warnings;
use lib './lib';
use HTML::Latemp::GenDepsTT2 ();

HTML::Latemp::GenDepsTT2->new(
    {
        src_dir => 'src',
        src_var => '$(SRC_DEST)',
    }
)->run;
