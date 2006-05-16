#!/usr/bin/perl -Tw

use Test::More tests => 8;

use_ok( 'Bundle::Modules' );
use_ok( 'Bundle::Modules::Unstable' );
use_ok( 'Bundle::Modules::CPAN' );
use_ok( 'Bundle::Modules::CPAN::Unstable' );
use_ok( 'Bundle::Modules::Acme::Everything' );
use_ok( 'Bundle::Modules::Acme::Everything::Unstable' );
use_ok( 'Bundle::Modules::Acme::Everything::Unique' );
use_ok( 'Bundle::Modules::Acme::Everything::Unique::Unstable' );

diag( "Testing Bundle::Modules-$Bundle::Modules::VERSION" );
