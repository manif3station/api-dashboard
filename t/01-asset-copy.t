use strict;
use warnings;

use Test::More;

use lib 'lib';

use ApiDashboard::Asset;

my $source = ApiDashboard::Asset::source_text();
my $sha    = ApiDashboard::Asset::source_sha256();

like( $sha, qr/\A[a-f0-9]{64}\z/, 'dashboards/index has a stable SHA-256 digest' );
like( $source, qr/file => 'bootstrap'/, 'api-dashboard bootstrap worker uses the local skill ajax file name' );
like( $source, qr/file => 'collections-save'/, 'api-dashboard save worker uses the local skill ajax file name' );
like( $source, qr/file => 'collections-delete'/, 'api-dashboard delete worker uses the local skill ajax file name' );
like( $source, qr/file => 'send-request'/, 'api-dashboard send worker uses the local skill ajax file name' );

done_testing;
