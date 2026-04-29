use strict;
use warnings;

use Test::More;

use lib 'lib';

use ApiDashboard::Asset;

is(
    ApiDashboard::Asset::source_sha256(),
    '4fd3725ab8704c576ac74e31fe9788ba4f02a1c633690e2446012de28823188c',
    'dashboards/index stays an exact copy of the current DD api-dashboard source asset',
);

done_testing;
