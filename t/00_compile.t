use strict;
use Test::More 0.98;

use lib 'lib';

use_ok qw(Business::Tax::Withholding::JP);
my $tax = new_ok('Business::Tax::Withholding::JP', [ price => 10000 ]);

is $tax->net(), 10000, "net";
is $tax->tax(), 800, "tax";
is $tax->full(), 10800, "full";
is $tax->withholding(), 1021, "withholding";
is $tax->total(), 9779, "total";

$tax->price(1000000);
is $tax->withholding(), 102100, "withholding with 1,000,000";
is $tax->total(), 977900, "total with 1,000,000";

$tax->price(2000000);
is $tax->withholding(), 306300, "withholding with 2,000,000";
is $tax->total(), 1853700, "total with 2,000,000";

$tax->price(3000000);
is $tax->withholding(), 510500, "withholding with 3,000,000";
is $tax->total(), 2729500, "total with 3,000,000";

done_testing;
