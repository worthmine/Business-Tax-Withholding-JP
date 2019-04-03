use strict;
use Test::More 0.98 tests => 11;

use lib 'lib';

use Business::Tax::Withholding::JP;
my $calc = Business::Tax::Withholding::JP->new( no_wh => 1 );

$calc->price(10000);
is $calc->net(), 10000, "net";                                      # 1
is $calc->tax(), 800, "tax";                                        # 2
is $calc->full(), 10800, "full";                                    # 3
is $calc->withholding(), 0, "withholding";                          # 4
is $calc->subtotal(), 10800, "subtotal";                            # 5

$calc->price(1000000);
is $calc->withholding(), 0, "withholding with 1,000,000";           # 6
is $calc->subtotal(), 1080000, "subtotal with 1,000,000";           # 7

$calc->price(1111111);
is $calc->tax(), 88888, "tax with 1,111,111";                       # 8
is $calc->full(), 1199999, "full with 1,111,111";                   # 9
is $calc->withholding(), 0, "withholding with 1,111,111";           #10
is $calc->subtotal(), 1199999, "subtotal with 1,111,111";           #11

done_testing;
