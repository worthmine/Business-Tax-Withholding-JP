use strict;
use Test::More 0.98 tests => 26;

use lib 'lib';

use Business::Tax::Withholding::JP;
my $calc = Business::Tax::Withholding::JP->new( no_wh => 1 );

note "without withholding---";

$calc->price(10000);
is $calc->net(), 10000, "net";                                      # 1
is $calc->tax(), 800, "tax";                                        # 2
is $calc->full(), 10800, "full";                                    # 3
is $calc->withholding(), 0, "withholding";                          # 4
is $calc->total(), 10800, "total";                                  # 5

$calc->amount(0);
is $calc->tax(), 0, "tax with amount 0";                            # 6
is $calc->full(), 0, "full with amount 0";                          # 7
is $calc->withholding(), 0, "withholding amount 0";                 # 8
is $calc->total(), 0, "total with amount 0";                        # 9

$calc->amount(2);
is $calc->tax(), 1600, "tax with amount 2";                         #10
is $calc->full(), 21600, "full with amount 2";                      #11
is $calc->withholding(), 0, "withholding amount 2";                 #12
is $calc->total(), 21600, "total with amount 2";                    #13

my $calc = Business::Tax::Withholding::JP->new();

note "with withholding---";

$calc->price(10000);
is $calc->net(), 10000, "net";                                      #14
is $calc->tax(), 800, "tax";                                        #15
is $calc->full(), 10800, "full";                                    #16
is $calc->withholding(), 1021, "withholding";                       #17
is $calc->total(), 9779, "total";                                   #18

$calc->amount(0);
is $calc->tax(), 0, "tax with amount 0";                            #19
is $calc->full(), 0, "full with amount 0";                          #20
is $calc->withholding(), 0, "withholding amount 0";                 #21
is $calc->total(), 0, "total with amount 0";                        #22

$calc->amount(2);
is $calc->tax(), 1600, "tax with amount 2";                         #23
is $calc->full(), 21600, "full with amount 2";                      #24
is $calc->withholding(), 2042, "withholding amount 2";              #25
is $calc->total(), 19558, "total with amount 2";                    #26

done_testing;
