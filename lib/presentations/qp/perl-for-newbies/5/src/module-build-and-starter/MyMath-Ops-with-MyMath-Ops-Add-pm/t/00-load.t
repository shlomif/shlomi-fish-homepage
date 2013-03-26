#!perl -T

use Test::More tests => 5;

BEGIN {
    use_ok( 'MyMath::Ops' );
    use_ok( 'MyMath::Ops::Add' );
    use_ok( 'MyMath::Ops::Multiply' );
    use_ok( 'MyMath::Ops::Subtract' );
    use_ok( 'MyMath::Ops::Divide' );
}

diag( "Testing MyMath::Ops $MyMath::Ops::VERSION, Perl $], $^X" );
