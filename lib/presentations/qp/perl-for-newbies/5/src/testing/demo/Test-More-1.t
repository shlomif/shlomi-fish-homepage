#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;

use Add2 (qw(add));

# TEST
is (add(0, 0),
    0,
    "0+0 == 0",
);

# TEST
is (add(2, 2),
    4,
    "2+2 == 4",
);

# TEST
is (add(4, 20),
    24,
    "4+20 == 24",
);

# TEST
is (add(20, 4),
    24,
    "20+4 == 24",
);

# TEST
is (add(-2, 8),
    6,
    "(-2)+8 == 6",
);

# TEST
is (add(4, 3.5),
    7.5,
    "4+3.5 == 7.5",
);

# TEST
is (add(3.5, 3.5),
    7,
    "3.5+3.5 == 7"
);

