#!/usr/bin/perl -w
##

use strict;

use warnings;

use 5.005;

use inc::Module::Install;

require Date::Format;

require File::Spec;

require FindBin; chdir( $FindBin::Bin );

##require Getopt::Long;

##Getopt::Long::GetOptions();

my @tests = glob File::Spec->catfile( 't', '*.pl.t' );

push( @tests, glob File::Spec->catfile( 't', 'use_me', '*.pl.t' ) );

my %params =
(
   'NAME' => 'WWW-YouTube',

);

##requires( 'perl' => '5.005' );

name( $params{'NAME'} );

##fixme##
license( 'perl' );

my $TIME = time(); version( Date::Format::time2str( '%Y.%m%d', $TIME ) ); system( "$FindBin::Bin/bin/create_www_youtube.plx $TIME" ); ## sync

all_from( 'lib/WWW/YouTube.pm' );

my @missing;

my @nice = qw( Test::Pod Test::Memory::Cycle Test::Warn Test::Taint );

foreach my $nice ( @nice )
{
    eval "require $nice";

    push( @missing, $nice ) if $@;

} ## end foreach

if ( @missing )
{
    @missing = map { "\t$_\n" } @missing;

    print <<"EOT";

$params{'NAME'} likes to have a lot of test modules for some of its tests.
The following are modules that would be nice to have, but not required.

@missing

EOT

} ## end if

locate_gpg();

feature( 'Shell.pm', '-default' => 0, recommendsi( qw( Shell ) ) ) unless can_run( 'sh' );

##auto_install( 'prerequisites_policy' => 'follow' );

build_requires( 'Test::More' => 0.34 );

auto_include_deps();

sign();

WriteAll();

##
## Thanks Audrey Tang
##
END {

   print "##\n## Thanks to Mr. Audrey Tang, for being the first person to send me an encrypted email.\n##\n";

   my $make = eval { require Config; $Config::Config{'make'} } || 'make';

   print "Now, please enter 'Build' to make all, 'Build test' to test, and 'Build install' to install.\n";

} ## end END

##
## locate_gpg
##
sub locate_gpg
{
   print "*** Looking for GnuPG (GNU Privacy Guard, a cryptographic signature tool)...\n";

   my $gpg = can_run( 'gpg' );

   my $has_gpg = ( $gpg and `gpg --version` =~ /GnuPG/ and defined `gpg --list-public-keys` );

   if ( $has_gpg )
   {
      print "GnuPG found ($gpg).\n";

      return ( 1 ) if grep { /^--installdeps/ } @ARGV;

      if ( 1 || prompt( "Import PAUSE and author keys to GnuPG?", 'y' ) =~ /^y/i )
      {
         print 'Importing... ';

         system 'gpg', '--quiet', '--import', glob('public_keys/*.pub');

         print "done.\n";

      } ## end if

      return ( 1 );

   } ## end if

   print "GnugPG not found anywhere in your PATH, \"eek,\" (said Audrey Tang).\n";

   return;

} ## end sub

__END__
