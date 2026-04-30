use strict;
use warnings;

use Test::More;

use lib 'lib';

use ApiDashboard::Asset;

my $page = ApiDashboard::Asset::parse_bookmark();

is( $page->{title}, 'API Dashboard', 'bookmark keeps the DD API dashboard title' );
is( $page->{bookmark}, 'api-dashboard', 'bookmark keeps the original bookmark id' );
like( $page->{html}, qr/>Collections</, 'HTML keeps the collections section' );
like( $page->{html}, qr/>Workspace</, 'HTML keeps the workspace section' );
like( $page->{html}, qr/Import Postman Collection/, 'HTML keeps the Postman import control' );
like( $page->{html}, qr/Export Postman Collection/, 'HTML keeps the Postman export control' );
like( $page->{html}, qr/Request Token Values/, 'HTML keeps the token field section' );
like( $page->{html}, qr/id="api-response-preview"/, 'HTML keeps the response preview container' );
like( $page->{html}, qr/data-api-token-input/, 'HTML keeps token input tagging' );
like( $page->{html}, qr/api-collection-tab/, 'HTML keeps collection tab markup' );
is( scalar @{ $page->{ajax_blocks} }, 4, 'bookmark keeps all four saved Ajax workers' );
is_deeply(
    [ map { $_->{file} } @{ $page->{ajax_blocks} } ],
    [
        'bootstrap',
        'collections-save',
        'collections-delete',
        'send-request',
    ],
    'bookmark keeps the expected saved Ajax worker file names',
);

done_testing;
