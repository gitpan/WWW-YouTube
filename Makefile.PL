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

requires( 'perl' => '5.005' );

requires( qw(
) );

my $param =
{
   'NAME' => 'WWW-YouTube',
   'CPANID' => 'ERMEYERS',
   'AUTHOR' => 'Eric R. Meyers <ermeyers@adelphia.net>',
   'VERSION' => Date::Format::time2str( '%Y.%m%d', time() ),
   'LICENSE' => 'perl',
   'ABSTRACT' => 'Interface to www.youtube.com',

};

name( $param->{'NAME'} );
author( $param->{'AUTHOR'} );
version( $param->{'VERSION'} );
license( $param->{'LICENSE'} );
abstract( $param->{'ABSTRACT'} );

all_from( 'lib/WWW/YouTube.pm' );

system( "$FindBin::Bin/_bin/create_www_youtube.plx $param->{'VERSION'}" );

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

$param->{'NAME'}-$param->{'VERSION'} likes to have a lot of test modules for some of its tests.

The following are modules that would be nice to have, but are not required:

@missing

EOT

} ## end if

locate_gpg();

feature( 'Shell.pm', '-default' => 0, recommends( qw( Shell ) ) ) unless can_run( 'sh' );

auto_install( 'prerequisites_policy' => 'follow' );

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

      if ( prompt( "Import CPAN Author $param->{'CPANID'}'s public key to GnuPG?", 'n' ) =~ /^y/i )
      {
         print 'Importing public key to GnuPG ... ';

         system 'gpg', '--quiet', '--import', glob('public_keys/'.$param->{'CPANID'}.'*.pub');

         print "done.\n";

      } ## end if

      return ( 1 );

   } ## end if

   print 'GnugPG not found anywhere in your PATH, "eek," said Mr. Audrey Tang.'."\n";

   return;

} ## end sub

__END__
