use strict;
use warnings;

use Test::More;

use lib 'lib';

use ApiDashboard::Asset;

my $source = ApiDashboard::Asset::source_text();
my $sha    = ApiDashboard::Asset::source_sha256();

like( $sha, qr/\A[a-f0-9]{64}\z/, 'dashboards/index has a stable SHA-256 digest' );
like( $source, qr/file => 'api-dashboard-bootstrap'/, 'api-dashboard bootstrap worker keeps the current DD flat ajax file name' );
like( $source, qr/file => 'api-dashboard-collections-save'/, 'api-dashboard save worker keeps the current DD flat ajax file name' );
like( $source, qr/file => 'api-dashboard-collections-delete'/, 'api-dashboard delete worker keeps the current DD flat ajax file name' );
like( $source, qr/file => 'api-dashboard-send-request'/, 'api-dashboard send worker keeps the current DD flat ajax file name' );

done_testing;
