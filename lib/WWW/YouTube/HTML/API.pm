##
## WWW::YouTube::HTML::API
##
package WWW::YouTube::HTML::API;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0606 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::HTML::API::ISA = qw(Exporter);

   @WWW::YouTube::HTML::API::EXPORT = qw(); ## export required

   @WWW::YouTube::HTML::API::EXPORT_OK =
   (
   ); ## export ok on request

   $WWW::YouTube::HTML::API::url = 'http://www.youtube.com';

} ## end BEGIN

require WWW::YouTube::ML::API; ## NOTE: generic *ML

require LWP::UserAgent; ## HTML::API::ua (User Agent)

require LWP::Simple; ## HTML::API::ua-like (Simple User Agent)

require HTTP::Cookies;

require HTTP::Request::Common; ## qw(POST); ## quick and easy POST edit

require HTML::TreeBuilder; ## HTML::API::tree parser

require Data::Dumper;

require IO::File;

require Encode;

require FindBin;

require File::Basename;

require File::Spec;

__PACKAGE__ =~ m/^(WWW::[^:]+)::([^:]+)(::([^:]+)){0,1}$/g;

##debug##print( "API! $1::$2::$4\n" );

%WWW::YouTube::HTML::API::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $2,
   'iman'           => $4,
   'myp'            => __PACKAGE__,
   'opts'           => {},
   'opts_filename'  => {},
   'export_ok'      => [],
   'opts_type_flag' =>
   [
      @{$WWW::YouTube::ML::API::opts_type_args{'opts_type_flag'}},
   ],
   'opts_type_numeric' =>
   [
      @{$WWW::YouTube::ML::API::opts_type_args{'opts_type_numeric'}},
   ],
   'opts_type_string' =>
   [
      @{$WWW::YouTube::ML::API::opts_type_args{'opts_type_string'}},
   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::YouTube::HTML::API::opts_type_args{'ido'},
                                $WWW::YouTube::HTML::API::opts_type_args{'iknow'},
                                $WWW::YouTube::HTML::API::opts_type_args{'iman'}
                        )
                      );

WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::HTML::API::opts_type_args );

$WWW::YouTube::HTML::API::numeric_max_try = $WWW::YouTube::ML::API::numeric_max_try;

WWW::YouTube::ML::API::register_all_opts( \%WWW::YouTube::HTML::API::opts_type_args );

push( @WWW::YouTube::HTML::API::EXPORT_OK,
      @{$WWW::YouTube::HTML::API::opts_type_args{'export_ok'}} );

#foreach my $x ( keys %{$WWW::YouTube::HTML::API::opts_type_args{'opts'}} )
#{
#   printf( "opts{%s}=%s\n", $x, $WWW::YouTube::HTML::API::opts_type_args{'opts'}{$x} );
#} ## end foreach

#foreach my $x ( @{$WWW::YouTube::HTML::API::opts_type_args{'export_ok'}} )
#{
#   printf( "ok=%s\n", $x );
#} ## end foreach

#foreach my $x ( @WWW::YouTube::HTML::API::EXPORT_OK )
#{
#   printf( "OK=%s\n", $x );
#} ## end foreach

##
## NOTE: Getopts hasn't set the options yet. (all flags = 0 right now)
##

$WWW::YouTube::HTML::API::cookie_file = undef;

$WWW::YouTube::HTML::API::cookies = undef;

$WWW::YouTube::HTML::API::ua = undef;

$WWW::YouTube::HTML::API::request = undef;

$WWW::YouTube::HTML::API::result = undef; ## HTTP::Response

$WWW::YouTube::HTML::API::tree = HTML::TreeBuilder->new();            ## need one to work with
$WWW::YouTube::HTML::API::tree = $WWW::YouTube::HTML::API::tree->delete(); ## after each use to clean up

%WWW::YouTube::HTML::API::vlmr = (); ## youtube.videos.list_most_recent

END {

} ## end END

##
## get_started
##
sub get_started
{
   $WWW::YouTube::HTML::API::cookie_file = File::Spec->catfile( $FindBin::Bin,
                                                'lwpcookies_' . $WWW::YouTube::Com::user . '.txt'
                                                              );

   $WWW::YouTube::HTML::API::cookies =
      HTTP::Cookies->new( 'file' => $WWW::YouTube::HTML::API::cookie_file,
                          'autosave' => 1
                        );

   $WWW::YouTube::HTML::API::ua = LWP::UserAgent->new(
                                'cookie_jar' => $WWW::YouTube::HTML::API::cookies,
                                'protocols_allowed'   => [ 'http', 'https' ],
                                'protocols_forbidden' => [ 'ftp', 'mailto' ],
                                                     );

   if ( ! -f $WWW::YouTube::HTML::API::cookie_file )
   {
      my $ua_info = 'sprintf( "WWW::YouTube::HTML::API login failed: %s \$itry=%dof%d\n",
                              $result->status_line(), $itry-1, $max_try
                            )';

      my $request_uri = "$WWW::YouTube::HTML::API::url/login";

      my %request_form =
      (
         'current_form' => 'loginForm',
         'username' => $WWW::YouTube::Com::user,
         'password' => $WWW::YouTube::Com::pass,
         'action_login' => 'Log In',
      );

      my $request = HTTP::Request::Common::POST( $request_uri, \%request_form );

      my $result = undef;

      my ( $itry, $max_try ) = ( 1, $WWW::YouTube::HTML::API::numeric_max_try );

      push( @{ $WWW::YouTube::HTML::API::ua->requests_redirectable }, 'POST' ); ## "HTTP 303 See Other"

      while ( $itry++ <= $max_try )
      {
         $result = $WWW::YouTube::HTML::API::ua->get( $request_uri );

         sleep 5; ## I'm, like, a human?

         $result = $WWW::YouTube::HTML::API::ua->request( $request );

         last if ( $result->is_success() );

         print( STDERR eval( $ua_info ) ) if ( $itry > $max_try );

      } ## end while

      pop( @{ $WWW::YouTube::HTML::API::ua->requests_redirectable } );

      ##
      ## Simulating the Frontier::Client debug output style of XML::API::ua
      ##
      if ( $WWW::YouTube::HTML::API::flag_ua_dmp )
      {
         printf( STDERR "---- request ----\n%s\n", $request->as_string() );

         printf( STDERR "---- result  ----\n%s\n", $result->as_string() );

      } ## end if

   } ## end if

} ## end sub get_started

##
## WWW::YouTube::HTML::API::show_all_opts
##
sub WWW::YouTube::HTML::API::show_all_opts
{
   WWW::YouTube::ML::API::show_all_opts( \%WWW::YouTube::HTML::API::opts_type_args );

} ## end sub WWW::YouTube::HTML::API::show_all_opts

##
## WWW::YouTube::HTML::API::mirror
##
sub mirror
{
   my ( $uri, $localfile ) = @_;

   get_started() if ( ! defined( $WWW::YouTube::HTML::API::ua ) );

   $WWW::YouTube::HTML::API::ua->mirror( $uri, $localfile );

} ## end sub mirror

##
## WWW::YouTube::HTML::API::ua_request
##
## returns a parse $tree and the $result (delete your $tree when you're done with it!)
##
sub WWW::YouTube::HTML::API::ua_request
{
   my ( $request, $control ) = @_;

   my $result = undef;

   my $tree = undef;

   my $ua_info = 'sprintf( "WWW::YouTube::HTML::API::ua_request failed: %s \$itry=%dof%d\n",
                            $result->status_line(), $itry-1, $max_try
                         )';

   my ( $itry, $max_try ) = ( 1, $WWW::YouTube::HTML::API::numeric_max_try );

   get_started() if ( ! defined( $WWW::YouTube::HTML::API::ua ) );

   while ( $itry++ <= $max_try )
   {
      $result = $WWW::YouTube::HTML::API::ua->request( $request );

      last if ( $result->is_success() );

      print( STDERR eval( $ua_info ) ) if ( $itry > $max_try );

   } ## end while

   ##
   ## Simulating the Frontier::Client debug output style of XML::API::ua
   ##
   if ( $WWW::YouTube::HTML::API::flag_ua_dmp )
   {
      printf( STDERR "---- request ----\n%s\n", $request->as_string() );

      printf( STDERR "---- result  ----\n%s\n", $result->as_string() );

   } ## end if

   if ( $result->is_success() )
   {
      ##debug##      print( STDERR "ua_request got good result\n" );

      return ( $result ) if ( defined( $control->{'no_tree'} ) );

      $tree = HTML::TreeBuilder->new(); ## (delete your $tree when you're done with it!)

      $tree->parse( $result );

      $tree->eof();

      $tree->elementify(); ## NOTE: maybe I shouldn't do this all the time here?

      return ( $tree ) if ( defined( $control->{'no_result'} ) );

   }
   else
   {
      die eval( $ua_info );

   } ## end if

   return ( $tree, $result ); ## you get to pick one or keep both

} ## end sub WWW::YouTube::HTML::API::ua_request

1;
__END__ ## package WWW::YouTube::HTML::API

=head1 NAME

WWW::YouTube::HTML::API - How to Interface with YouTube using HTTP Protocol, CGI, returning HTML.

=head1 SYNOPSIS

=head1 OPTIONS

--html_api_* options:

opts_type_flag:

   --html_api_ua_dmp
   --html_api_request_dmp
   --html_api_result_dmp

opts_type_numeric:

   --html_api_max_try=number

opts_type_string:

   NONE

=head1 DESCRIPTION

HTML::API stands for HTML Application Programming Interface

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML::API>> I<L<WWW::YouTube::HTML>> I<L<WWW::YouTube::XML::API>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut

