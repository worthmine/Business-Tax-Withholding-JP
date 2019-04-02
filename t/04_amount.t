use strict;
use Test::More 0.98 tests => 26;

use lib 'lib';

use Business::Tax::Withholding::JP;
my $tax = Business::Tax::Withholding::JP->new( no_wh => 1 );

note "without withholding---";

$tax->price(10000);
is $tax->net(), 10000, "net";                                       # 1
is $tax->tax(), 800, "tax";                                         # 2
is $tax->full(), 10800, "full";                                     # 3
is $tax->withholding(), 0, "withholding";                           # 4
is $tax->total(), 10800, "total";                                   # 5

$tax->amount(0);
is $tax->tax(), 0, "tax with amount 0";                             # 6
is $tax->full(), 0, "full with amount 0";                           # 7
is $tax->withholding(), 0, "withholding amount 0";                  # 8
is $tax->total(), 0, "total with amount 0";                         # 9

$tax->amount(2);
is $tax->tax(), 1600, "tax with amount 2";                          #10
is $tax->full(), 21600, "full with amount 2";                       #11
is $tax->withholding(), 0, "withholding amount 2";                  #12
is $tax->total(), 21600, "total with amount 2";                     #13

my $tax = Business::Tax::Withholding::JP->new();

note "with withholding---";

$tax->price(10000);
is $tax->net(), 10000, "net";                                       #14
is $tax->tax(), 800, "tax";                                         #15
is $tax->full(), 10800, "full";                                     #16
is $tax->withholding(), 1021, "withholding";                        #17
is $tax->total(), 9779, "total";                                    #18

$tax->amount(0);
is $tax->tax(), 0, "tax with amount 0";                             #19
is $tax->full(), 0, "full with amount 0";                           #20
is $tax->withholding(), 0, "withholding amount 0";                  #21
is $tax->total(), 0, "total with amount 0";                         #22

$tax->amount(2);
is $tax->tax(), 1600, "tax with amount 2";                          #23
is $tax->full(), 21600, "full with amount 2";                       #24
is $tax->withholding(), 2042, "withholding amount 2";               #25
is $tax->total(), 19558, "total with amount 2";                     #26

done_testing;
