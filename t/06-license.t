use strict;
use warnings;

use File::Spec;
use Test::More;

my $root = File::Spec->rel2abs(
    File::Spec->catdir( File::Spec->curdir() )
);

my $license = File::Spec->catfile( $root, 'LICENSE' );
ok( -f $license, 'LICENSE exists' );
ok( -s $license, 'LICENSE is not empty' );

open my $license_fh, '<', $license or die "Unable to read $license: $!";
local $/;
my $license_text = <$license_fh>;
close $license_fh or die "Unable to close $license: $!";

like( $license_text, qr/\AMIT License/m, 'LICENSE keeps the MIT heading' );
like( $license_text, qr/Permission is hereby granted, free of charge/m, 'LICENSE keeps the MIT grant text' );
like( $license_text, qr/THE SOFTWARE IS PROVIDED "AS IS"/m, 'LICENSE keeps the MIT warranty disclaimer' );

my $readme = File::Spec->catfile( $root, 'README.md' );
open my $readme_fh, '<', $readme or die "Unable to read $readme: $!";
my $readme_text = <$readme_fh>;
close $readme_fh or die "Unable to close $readme: $!";

like( $readme_text, qr/^## License$/m, 'README has a License section' );
like( $readme_text, qr/released under the MIT License/i, 'README mentions the MIT license' );
like( $readme_text, qr/\[LICENSE\]\(LICENSE\)/, 'README links to LICENSE' );

done_testing;
