##
## WWW::YouTube::HTML::API
##
package WWW::YouTube::HTML::API;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2006.0626 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::HTML::API::ISA = qw(Exporter);

   @WWW::YouTube::HTML::API::EXPORT = qw(); ## export required

   @WWW::YouTube::HTML::API::EXPORT_OK =
   (
   ); ## export ok on request

   $WWW::YouTube::HTML::API::url = 'http://www.youtube.com';

} ## end BEGIN

#use lib ( $ENV{'HOME'} );
#
#require WWW::YouTube::Com; ## NOTE: I need WWW::YouTube::Com secrets

require WWW::YouTube::XML::API; ## NOTE: HTML/XML crossover

require WWW::YouTube::ML::API; ## NOTE: generic *ML

require LWP::UserAgent; ## HTML::API::ua (User Agent)

require LWP::Simple; ## HTML::API::ua-like (Simple User Agent)

require HTTP::Cookies;

require HTTP::Request::Common; ## qw(POST); ## quick and easy POST edit

require HTML::TreeBuilder; ## HTML::API::tree parser

require DBI; require XML::Dumper; require SQL::Statement;

require Data::Dumper; ## get rid of this

require IO::File;

require Encode;

require FindBin;

require File::Basename;

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
      ## Customizations follow this line ##
      'xmltree_video',
   ],
   'opts_type_numeric' =>
   [
      @{$WWW::YouTube::ML::API::opts_type_args{'opts_type_numeric'}},
      ## Customizations follow this line ##
   ],
   'opts_type_string' =>
   [
      @{$WWW::YouTube::ML::API::opts_type_args{'opts_type_string'}},
      ## Customizations follow this line ##
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

$WWW::YouTube::HTML::API::string_dbm_dir =
   File::Basename::dirname( $WWW::YouTube::ML::API::string_dbm_dir ) . '/html';

$WWW::YouTube::HTML::API::string_vlbt_want = $WWW::YouTube::ML::API::string_vlbt_want;

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

$WWW::YouTube::HTML::API::lwp_ua_agent = undef;

##debug## printf( "fb=%s, ur=%s\n", $FindBin::Bin, $WWW::YouTube::Com::user );

$WWW::YouTube::HTML::API::request = undef;

## Optional Request Methods:
##   $request = HTTP::Request->new( 'GET' => $WWW::YouTube::HTML::API::url );
##   $request = HTTP::Request->new( 'POST' => $WWW::YouTube::HTML::API::url );
##   $request = HTTP::Request::Common::POST( $uri, \%form ); ## See login below

$WWW::YouTube::HTML::API::result = undef; ## HTTP::Response

##$WWW::YouTube::HTML::API::parser = HTML::TreeBuilder->new();

$WWW::YouTube::HTML::API::tree = HTML::TreeBuilder->new();            ## need one to work with
$WWW::YouTube::HTML::API::tree = $WWW::YouTube::HTML::API::tree->delete(); ## after each use to clean up

%WWW::YouTube::HTML::API::vlmr = (); ## youtube.videos.list_most_recent

##
##
##
sub get_started
{
   ##debug## print "getting started with login\n";

   $WWW::YouTube::HTML::API::cookie_file = File::Spec->catfile( $FindBin::Bin,
                                                'lwpcookies_' . $WWW::YouTube::Com::user . '.txt'
                                                              );

   ##debug## unlink( $WWW::YouTube::HTML::API::cookie_file );

   $WWW::YouTube::HTML::API::cookies =
      HTTP::Cookies->new( 'file' => $WWW::YouTube::HTML::API::cookie_file,
                          'autosave' => 1
                        );

   $WWW::YouTube::HTML::API::ua = LWP::UserAgent->new(
                                'cookie_jar' => $WWW::YouTube::HTML::API::cookies,
                                'protocols_allowed'   => [ 'http' ],
                                'protocols_forbidden' => [ 'https', 'ftp', 'mailto' ],
                                                     );

   $WWW::YouTube::HTML::API::lwp_ua_agent = $WWW::YouTube::HTML::API::ua->agent();

   if ( ! -f $WWW::YouTube::HTML::API::cookie_file )
   {
      ##debug##   print( "I'm looking for cookies: [".$WWW::YouTube::HTML::API::cookie_file."]\n" );

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

      my ( $itry, $max_try ) = ( 1, 5 ); ## how many retries exactly?

      ##debug##   my $save_agent = $WWW::YouTube::HTML::API::ua->agent('Mozilla/5.0');

      push( @{ $WWW::YouTube::HTML::API::ua->requests_redirectable }, 'POST' ); ## "HTTP 303 See Other"

      while ( $itry++ <= $max_try )
      {
         ##debug##      printf( STDERR "ua makes login request\n%s\n", $request->as_string() );

         $result = $WWW::YouTube::HTML::API::ua->get( $request_uri );

         sleep 5; ## I'm, like, a human?

         ##debug##print "something\n" if ( $result->is_error() );

         $result = $WWW::YouTube::HTML::API::ua->request( $request );
         #$result = $WWW::YouTube::HTML::API::ua->post( $request_uri, $request_form );

         ##debug##print "something else\n" if ( $result->is_error() );

         last if ( $result->is_success() );

         print( STDERR eval( $ua_info ) ) if ( $itry > $max_try );

      } ## end while

      ##debug##   $save_agent = $WWW::YouTube::HTML::API::ua->agent($save_agent);

      pop( @{ $WWW::YouTube::HTML::API::ua->requests_redirectable } );

      ##
      ## Simulating the Frontier::Client debug output style of XML::API::ua
      ##
      if ( $WWW::YouTube::HTML::API::flag_ua_dmp )
      {
         printf( STDERR "---- request ----\n%s\n", $request->as_string() );

         printf( STDERR "---- result  ----\n%s\n", $result->as_string() );

      } ## end if

      ##debug##   printf( STDERR "ua got bad login result\n%s\n", '' ) if ( $result->is_error() );

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
## WWW::YouTube::HTML::API::tree_dumper
##
sub WWW::YouTube::HTML::API::tree_dumper
{
   my $tree = shift;

   my $i = 2;

   my $ima = 'tree'; ## dumper

   my $filename = $WWW::YouTube::HTML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   ##debug##
   printf( STDERR "Look at me! I'm specially in need of attention: \$filename = %s\n", $filename ); return;

   my $fh = IO::File->new();

   my $request = HTML::Request->new(); ## to ask for video page

   my $result = undef;

   $request->method( 'GET' );

   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${$filename}.txt: $!\n";

   while ( defined( ${$tree}->[1]->[2]->[$i-1] ) )
   {
      if ( ! $WWW::YouTube::XML::API::vlf{${$tree}->[1]->[2]->[$i]->[4]->[2]} )
      {
         $request->uri( ${$tree}->[1]->[2]->[$i]->[24]->[2] );

         $result = WWW::YouTube::HTML::API::ask( $request );

         if ( $result->as_string() =~ m/class="error">(This video [^<]+)/ )
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. $1 );

         }
         elsif ( $result->as_string() =~
                 m/>(This video may contain content that is inappropriate [^<]+)/ )
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. 'adult content' );

         }
         else
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. 'viewable' );

         } ## end if

      } ## end if

      $i += 2;

   } ## end while

   $fh->close();

} ## end sub WWW::YouTube::HTML::API::tree_dumper

##
## WWW::YouTube::HTML::API::video_dumper
##
sub WWW::YouTube::HTML::API::video_dumper
{
   my $tree = shift;

   my $i = 2;

   my $ima = 'video'; ## dumper

   my $fh = IO::File->new();

   my $filename = $WWW::YouTube::HTML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   ##debug##
   printf( STDERR "Look at me! I'm specially in need of attention: \$filename = %s\n", $filename ); return;

   my $request = HTML::Request->new(); ## to ask for video page

   my $result = undef;

   $request->method( 'GET' );

   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${$filename}.txt: $!\n";

   while ( defined( ${$tree}->[1]->[2]->[$i-1] ) )
   {
      if ( ! $WWW::YouTube::XML::API::vlf{${$tree}->[1]->[2]->[$i]->[4]->[2]} )
      {
         $request->uri( ${$tree}->[1]->[2]->[$i]->[24]->[2] );

         $result = WWW::YouTube::HTML::API::ask( $request );

         if ( $result->as_string() =~ m/class="error">(This video [^<]+)/ )
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. $1 );

         }
         elsif ( $result->as_string() =~
                 m/>(This video may contain content that is inappropriate [^<]+)/ )
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. 'adult content' );

         }
         else
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. 'viewable' );

         } ## end if

      } ## end if

      $i += 2;

   } ## end while

   $fh->close();

} ## end sub WWW::YouTube::HTML::API::video_dumper

##
## WWW::YouTube::HTML::API::xmltree_video_dumper
##
sub WWW::YouTube::HTML::API::xmltree_video_dumper
{
   my $tree = shift;

   my $i = 2;

   my $ima = 'xmltree_video';## dumper

   my $fh = IO::File->new();

   my $filename = $WWW::YouTube::HTML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   ##debug##
   printf( STDERR "Look at me! I'm specially in need of attention: \$filename = %s\n", $filename ); return;

   my $request = HTML::Request->new(); ## to ask for video page

   my $result = undef;

   $request->method( 'GET' );

   $fh->open( "+>${filename}.txt"
   ) || die "opening: ${$filename}.txt: $!\n";

   while ( defined( ${$tree}->[1]->[2]->[$i-1] ) )
   {
      if ( ! $WWW::YouTube::XML::::API::vlf{${$tree}->[1]->[2]->[$i]->[4]->[2]} )
      {
         $request->uri( ${$tree}->[1]->[2]->[$i]->[24]->[2] );

         $result = WWW::YouTube::HTML::API::ask( $request );

         if ( $result->as_string() =~ m/class="error">(This video [^<]+)/ )
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. $1 );

         }
         elsif ( $result->as_string() =~
                 m/>(This video may contain content that is inappropriate [^<]+)/ )
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. 'adult content' );

         }
         else
         {
            $fh->printf( "%s\n", ${$tree}->[1]->[2]->[$i]->[4]->[2] .':'. 'viewable' );

         } ## end if

      } ## end if

      $i += 2;

   } ## end while

   $fh->close();

} ## end sub WWW::YouTube::HTML::API::xmltree_video_dumper

##
## WWW::YouTube::HTML::API::ua_request_utf8
##
## returns a parse $tree and the $result (delete your $tree when you're done with it!)
##
sub WWW::YouTube::HTML::API::ua_request_utf8
{
   my ( $request, $control ) = @_;

   my $ua_info = 'sprintf( "WWW::YouTube::HTML::API::ua_request_utf8 failed: ? \$itry=%dof%d\n",
                            $itry-1, $max_try
                         )';

   my $result = undef;

   my $tree = undef;

   my ( $itry, $max_try ) = ( 1, 5 ); ## how many retries exactly?

   die( "ua_request_utf8 method error\n" ) if ( $request->method() ne 'GET' );

   get_started() if ( ! defined( $WWW::YouTube::HTML::API::ua ) );

   while ( $itry++ <= $max_try )
   {
      ##debug##      print( STDERR "ua_request_utf8 makes request\n" );
      ##debug##      printf( STDERR "ua_request_utf8 %s\n", $request->uri() );

      ##BAD## $result = $WWW::YouTube::HTML::API::ua->mirror( $request, $content_file );

      $result = LWP::Simple::get( $request->uri() );

      last if ( defined( $result ) );

      print( STDERR eval( $ua_info ) ) if ( $itry > $max_try );

   } ## end while

   ##
   ## Simulating the Frontier::Client debug output style of XML::API::ua
   ##
   if ( $WWW::YouTube::HTML::API::flag_ua_dmp )
   {
      printf( STDERR "---- request ----\n%s\n", $request->as_string() );

   } ## end if

   if ( defined( $result ) )
   {
      ##debug##      print( STDERR "ua_request_utf8 got good result\n" );

      if ( 1 )
      {
         Encode::from_to( $result, 'utf8', 'Unicode' ); ## Solved! Keep adding problem chars!
         $result =~ s/[\xC2]/utf8(xC2)/g;               ##
         $result =~ s/[\xC3]/utf8(xC3)/g;               ##

         $result = HTTP::Response->parse( $result );

      }
      else
      {
         ##
         ## At least with what's here in this block, you'll see problem chars
         ##
         Encode::from_to( $result, 'utf8', 'Unicode' ); ## Solved! Keep adding problem chars!
         $result =~ s/[\xC2]/utf8(xC2)/g;               ##
         $result =~ s/[\xC3]/utf8(xC3)/g;               ##

         my $content_file = 'utf8content.html';

         my $fh_content = IO::File->new( $content_file, '+>:encoding(utf8)' );

         $fh_content->print( $result );

         undef( $fh_content );

         $fh_content = IO::File->new( $content_file, '<:encoding(utf8)' );

         my $save_slash = $/; undef( $/ );

         $result = <$fh_content>;

         $/ = $save_slash;

         undef( $fh_content );

         $result = HTTP::Response->parse( $result );

      } ## end if

      if ( $WWW::YouTube::HTML::API::flag_ua_dmp )
      {
         printf( STDERR "---- result  ----\n%s\n", $result->as_string() );

      } ## end if

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

   ##
   ## XML::API::ask does if ( $tree->[1]->[0]->{status} eq 'ok' )
   ## HTML::API::ask does something even more useful:
   ##
   if ( 1 )
   {
      WWW::YouTube::HTML::API::tree_dumper( $tree ) if ( $WWW::YouTube::HTML::API::flag_tree_dmp );

      WWW::YouTube::HTML::API::video_dumper( $tree ) if ( $WWW::YouTube::HTML::API::flag_video_dmp );

   } ## end if

   return ( $tree, $result ); ## you get to pick one or keep both

} ## end sub WWW::YouTube::HTML::API::ua_request_utf8

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

   my ( $itry, $max_try ) = ( 1, 5 ); ## how many retries exactly?

   get_started() if ( ! defined( $WWW::YouTube::HTML::API::ua ) );

   while ( $itry++ <= $max_try )
   {
      ##debug##      print( STDERR "ua_request makes request\n" );

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

   ##
   ## XML::API::ask does if ( $tree->[1]->[0]->{status} eq 'ok' )
   ## HTML::API::ask does something even more useful:
   ##
   if ( 1 )
   {
      WWW::YouTube::HTML::API::tree_dumper( $tree ) if ( $WWW::YouTube::HTML::API::flag_tree_dmp );

      WWW::YouTube::HTML::API::video_dumper( $tree ) if ( $WWW::YouTube::HTML::API::flag_video_dmp );

   } ## end if

   return ( $tree, $result ); ## you get to pick one or keep both

} ## end sub WWW::YouTube::HTML::API::ua_request

END {

} ## end END

1;
__END__ ## package WWW::YouTube::HTML::API

=head1 NAME

WWW::YouTube::HTML::API - How to Interface with YouTube using HTTP Protocol, CGI, returning HTML.

=head1 SYNOPSIS

Options (--html_api_* options);

=head1 OPTIONS

--html_api_* options:

opts_type_flag:

   --html_api_ua_dmp
   --html_api_request_dmp
   --html_api_result_dmp
   --html_api_tree_dmp
   --html_api_video_dmp

opts_type_numeric:

   --html_api_max_try=number

opts_type_string:

   --html_api_dbm_dir=string
   --html_api_vlbt_want=string

=head1 DESCRIPTION

HTML::API stands for HTML Application Programming Interface

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML::API>> I<L<WWW::YouTube::HTML>> I<L<WWW::YouTube::XML::API>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers E<lt>ermeyers@adelphia.netE<gt>

=cut

