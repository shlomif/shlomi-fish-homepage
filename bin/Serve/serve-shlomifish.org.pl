#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;

use ShlomifServe;

ShlomifServe::serve(
     'dir_to_serve' =>
        # File::Spec->rel2abs("../../dest/t2-homepage/"),
        "../../dest/t2-homepage/",
    );
