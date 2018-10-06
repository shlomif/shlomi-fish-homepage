#!/usr/bin/env perl

use strict;
use warnings;

s%
<quadpres_code_block> [\s\n]*
<quadpres_include_colorized_file \s+ filename="([^"]+)" \s* /\s*> [\s\n]*
</quadpres_code_block>
%<quadpres_code_file filename="$1" />%gmsx;
