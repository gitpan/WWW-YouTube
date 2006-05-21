#!/usr/bin/perl -w
##

use strict;

use warnings;

use Module::Build;

require ExtUtils::MakeMaker;

require Config;

require File::Spec;

require Date::Format;

require FindBin;

my $param =
{
   'NAME' => 'WWW-YouTube',
   'CPANID' => 'ERMEYERS',
   'AUTHOR' => 'Eric R. Meyers <ermeyers@adelphia.net>',
   'VERSION' => Date::Format::time2str( '%Y.%m%d', time() ),
   'LICENSE' => 'perl',
   'ABSTRACT' => 'Interface to bundle modules',

};

my $build = Module::Build->new
   (
      'dist_name' => $param->{'NAME'},
      'dist_author' => $param->{'AUTHOR'},
      'dist_version' => Date::Format::time2str( '%Y.%m%d', time() ),
      'license' => $param->{'LICENSE'},
      'dist_abstract' => $param->{'ABSTRACT'},
      'create_makefile_pl' => 'passthrough',
      'sign' => 1,
      'recursive_test_files' => 1,
      'build_requires' =>
      {
         'Test::More' => 0,
      },
      'requires' =>
      {
         'perl' => '5.6.1',
         'Encode' => 0,
         'FindBin' => 0,
         'HTTP::Cookies' => 0,
         'HTTP::Request::Common' => 0,
         'LWP::UserAgent' => 0,
         'LWP::Simple' => 0,
         'HTML::TreeBuilder' => 0,
         'Frontier::Client' => 0,
         'XML::Parser' => 0,
         'DBI' => 0,
         'XML::Dumper' => 0,
         'SQL::Statement' => 0,
         'Date::Format' => 0,
         'File::Basename' => 0,
         'IO::File' => 0,
         'IO::Zlib' => 0,
         'Term::ReadLine' => 0,
         'Text::Wrap' => 0,
         'String::Approx' => 0,
         'Data::Dumper' => 0,

      },
      'recommends' =>
      {
         'Test::Memory::Cycle' => 0,
         'Test::Pod' => 0,
         'Test::Taint' => 0,
         'Test::Warn' => 0,

      },
   );

unlink( "MANIFEST.bak" );

unlink( "$param->{'NAME'}-$param->{'VERSION'}.tar.gz" );

$build->create_build_script();

if ( -d "$FindBin::Bin/_bin" ) ## won't exist in distribution
{
   system( "$FindBin::Bin/_bin/create_www_youtube.plx $param->{'VERSION'}" );

   $build->dispatch( 'build' );
   $build->dispatch( 'test', 'verbose' => 1 );
   $build->dispatch( 'install' );

}
else
{
   locate_gpg();

   print "Now, please enter 'Build' to make all, 'Build test' to test, and 'Build install' to install.\n";

} ## end if

##
## can_run
##
sub can_run
{
   my $cmd = shift;

   my $_cmd = $cmd;

   return $cmd if ( -x $cmd or $cmd = MM->maybe_command( $cmd ) );

   foreach my $dir ( split( /$Config::Config{'path_sep'}/, $ENV{PATH} ), '.' )
   {
      my $abs = File::Spec->catfile( $dir, $_cmd );

      return ( $abs ) if ( -x $abs or $abs = MM->maybe_command( $abs ) );

   } ## end foreach

} ## end sub can_run

##
## locate_gpg
##
sub locate_gpg
{
   print "##\n## Thanks to Audrey Tang, for being the first person to send me an encrypted email.\n##\n";

   print "*** Looking for GnuPG (GNU Privacy Guard, a cryptographic signature tool)...\n";

   my $gpg = can_run( 'gpg' );

   my $has_gpg = ( $gpg and `gpg --version` =~ /GnuPG/ and defined `gpg --list-public-keys` );

   if ( $has_gpg )
   {
      print "GnuPG found ($gpg).\n";

      return ( 1 ) if grep { /^--installdeps/ } @ARGV;

      if ( ExtUtils::MakeMaker::prompt( "Import CPAN Author $param->{'CPANID'}'s public key into GnuPG?", 'n' ) =~ /^y/i )
      {
         print 'Importing public key into GnuPG keyring... ';

         system 'gpg', '--quiet', '--import', glob('public_keys/'.$param->{'CPANID'}.'*.pub');

         print "done.\n";

      } ## end if

      return ( 1 );

   } ## end if

   print 'GnugPG not found anywhere in your PATH, "eek," said Mr. Audrey Tang.'."\n";

   return;

} ## end sub locate_gpg

