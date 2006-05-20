#!/usr/bin/perl -w
##

##
## WWW::YouTube
##
package WWW::YouTube;

use strict;

use warnings;

use 5.005;

require Date::Format;

our $YYYY_MMDD = Date::Format::time2str( "%Y.%m%d", time() );

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION = sprintf("%d.%02d", "Revision: $YYYY_MMDD" =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::ISA = qw(Exporter);

   @WWW::YouTube::EXPORT = qw(); ## export required

   @WWW::YouTube::EXPORT_OK =
   (

   ); ## export ok on request

} ## end BEGIN

require WWW::YouTube::ML;

require File::Basename;

%WWW::YouTube::opts =
(
); ## General Public

__PACKAGE__ =~ m/^(WWW::[^:]+)((::([^:]+))(::([^:]+))){0,1}$/g;

##debug##print( "UT! $1::$4::$6\n" );

%WWW::YouTube::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => 'ut',
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::YouTube::opts,
   'opts_filename'  => {},
   'export_ok'      => [],
   'urls'           => {},
   'opts_type_flag' =>
   [
      'test_f',
   ],
   'opts_type_numeric' =>
   [
      'test_n',
   ],
   'opts_type_string' =>
   [
      'test_s',
   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::YouTube::opts_type_args{'ido'},
                                #$WWW::YouTube::ML::opts_type_args{'iknow'},
                                #$WWW::YouTube::ML::opts_type_args{'iman'}
                        )
                      );

WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::opts_type_args );

$WWW::YouTube::flag_test_f = 1;
$WWW::YouTube::numeric_test_n = 999;
$WWW::YouTube::string_test_s = 'this is a test';

##debug## WWW::YouTube::ML::API::show_all_opts( \%WWW::YouTube::opts_type_args );

WWW::YouTube::register_all_opts( \%WWW::YouTube::ML::opts_type_args );

#push( @WWW::YouTube::EXPORT_OK,
#      @{$WWW::YouTube::opts_type_args{'export_ok'}} );

END {

} ## end END

##
## WWW::YouTube::register_all_opts
##
sub WWW::YouTube::register_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::ML::opts_type_args;

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      $WWW::YouTube::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      $WWW::YouTube::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::YouTube::register_all_opts

##
## WWW::YouTube::ML::show_all_opts
##
sub WWW::YouTube::show_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::opts_type_args;

   WWW::YouTube::ML::show_all_opts( $opts_type_args );

} ## end sub WWW::YouTube::XML::show_all_opts

##
## WWW::YouTube::vlbt
##
sub WWW::YouTube::vlbt
{
   my $h = shift; ## not used yet

   my $iam = basename( $0 );

   die ( "\$0=$0\n" ) if ( ! defined( $iam ) || ( $iam eq '' ) );

   $iam =~ m/^([^_]+_([^.]+))[.]plx$/ || die "no basename match to start (iknow_iam.plx)\n";

   my ( $dflt_ml_tag, $dflt_ml_tag_subdir ) = ( $2, $1 ); ##debug##print $tag . "\n";exit;

   my $ml_tag = ( defined ( $WWW::YouTube::ML::string_tag ) )? $WWW::YouTube::ML::string_tag :
                                                          $dflt_ml_tag;

   my $ml_tag_subdir = ( defined ( $WWW::YouTube::ML::string_tag_subdir ) )? $WWW::YouTube::ML::string_tag_subdir :
                                                                        $dflt_ml_tag_subdir;

   WWW::YouTube::ML::vlbt( { 'tag' => $ml_tag, 'tag_subdir' => $ml_tag_subdir } );

} ## end sub WWW::YouTube::vlbt

1;
__END__ ## package WWW::YouTube

=head1 NAME

WWW::YouTube - YouTube Developer Interface

=head1 SYNOPSIS

 how to use your program
 program [options]

 Options;
# --help brief help message
# --man full documentation
=head1 OPTIONS

#=over 8
#
#=item B<--help>
#
#Print a brief help message and exits.
#
#=item B<--man>
#
#Prints the manual page and exits.
#
#=back

=head1 DESCRIPTION

long description of your program

=head1 SEE ALSO

need to know things before somebody uses your program

=head1 AUTHOR

Eric R. Meyers <ermeyers@adelphia.net>

=head1 LICENSE

perl

=head1 COPYRIGHT

Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut

