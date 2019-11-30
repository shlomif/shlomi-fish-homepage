#!/usr/bin/env perl

use strict;
use warnings;

use ShlomifServe ();

ShlomifServe->new->serve(
    {
        'dir_to_serve' => "../../dest/t2-homepage/",
    },
);
