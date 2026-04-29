use strict;
use warnings FATAL => 'all';

use File::Spec;
use File::Temp qw(tempdir tempfile);
use Test::More;

use lib 'lib';

use ApiDashboard::Asset;

my $node_bin     = _find_command('node');
my $chromium_bin = _find_command(qw(chromium chromium-browser google-chrome google-chrome-stable));

plan skip_all => 'Playwright smoke test requires node and Chromium on PATH'
  if !$node_bin || !$chromium_bin || !$ENV{NODE_PATH};

my $tmp = tempdir( CLEANUP => 1, TMPDIR => 1 );
my $html_path = File::Spec->catfile( $tmp, 'api-dashboard.html' );
open my $html_fh, '>', $html_path or die "Unable to write $html_path: $!";
print {$html_fh} ApiDashboard::Asset::static_html();
close $html_fh or die "Unable to close $html_path: $!";

my ( $script_fh, $script_path ) = tempfile( 'api-dashboard-playwright-XXXXXX', SUFFIX => '.js', TMPDIR => 1 );
print {$script_fh} <<'JS';
const { chromium } = require('playwright-core');

async function main() {
  const browser = await chromium.launch({
    executablePath: process.env.CHROMIUM_BIN,
    headless: true
  });
  const page = await browser.newPage();
  page.on('pageerror', () => {});
  await page.goto(process.env.API_DASHBOARD_URL, { waitUntil: 'domcontentloaded' });
  const title = await page.title();
  const shellTabs = await page.locator('[data-api-shell-tab]').allTextContents();
  const responseTabs = await page.locator('[data-api-response-tab]').allTextContents();
  const hasNewTab = await page.locator('#api-new-tab').count();
  const hasTokenShell = await page.locator('#api-token-shell').count();
  const hasPreview = await page.locator('#api-response-preview').count();
  const hasAuthKind = await page.locator('#api-auth-kind').count();
  console.log(JSON.stringify({
    title,
    shellTabs,
    responseTabs,
    hasNewTab,
    hasTokenShell,
    hasPreview,
    hasAuthKind
  }));
  await browser.close();
}

main().catch((error) => {
  console.error(String(error && error.stack || error));
  process.exit(1);
});
JS
close $script_fh or die "Unable to close $script_path: $!";

my $cmd = join q{ },
  'NODE_PATH="' . $ENV{NODE_PATH} . '"',
  'CHROMIUM_BIN="' . $chromium_bin . '"',
  'API_DASHBOARD_URL="file://' . $html_path . '"',
  $node_bin,
  $script_path;
my $output = qx{$cmd 2>&1};
my $exit = $? >> 8;
is( $exit, 0, "Playwright smoke flow exits cleanly\n$output" );
my $payload = _json_decode($output);

is( $payload->{title}, 'API Dashboard', 'Playwright sees the API dashboard document title' );
is_deeply(
    $payload->{shellTabs},
    [ 'Collections', 'Workspace' ],
    'Playwright sees the two main API dashboard sections',
);
is_deeply(
    $payload->{responseTabs},
    [ 'Request Details', 'Response Body', 'Response Headers' ],
    'Playwright sees the response detail tabs',
);
is( $payload->{hasNewTab}, 1, 'Playwright sees the new tab button' );
is( $payload->{hasTokenShell}, 1, 'Playwright sees the token values shell' );
is( $payload->{hasPreview}, 1, 'Playwright sees the response preview container' );
is( $payload->{hasAuthKind}, 1, 'Playwright sees the credential type selector' );

done_testing;

sub _find_command {
    for my $name (@_) {
        for my $dir ( split /:/, $ENV{PATH} || q{} ) {
            my $path = File::Spec->catfile( $dir, $name );
            return $path if -x $path;
        }
    }
    return;
}

sub _json_decode {
    my ($text) = @_;
    require JSON::PP;
    return JSON::PP::decode_json($text);
}
