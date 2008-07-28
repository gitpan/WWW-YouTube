##
## WWW::YouTube::XML::API
##
package WWW::YouTube::XML::API;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0728 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::XML::API::ISA = qw(Exporter);

   @WWW::YouTube::XML::API::EXPORT = qw(); ## export required

   @WWW::YouTube::XML::API::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require WWW::YouTube::GData;

require WWW::YouTube::ML::API; ## NOTE: generic *ML

require AppConfig::Std;

require URI;

require HTTP::Request;

require HTTP::Message;

require Data::Dumper;

require File::Spec;

require IO::File;

require Date::Format;

__PACKAGE__ =~ m/^(WWW::[^:]+)::([^:]+)(::([^:]+)){0,1}$/;

##debug##print( "API! $1::$2::$4\n" );

%WWW::YouTube::XML::API::opts_type_args =
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
     __PACKAGE__ ne join( '::', $WWW::YouTube::XML::API::opts_type_args{'ido'},
                                $WWW::YouTube::XML::API::opts_type_args{'iknow'},
                                $WWW::YouTube::XML::API::opts_type_args{'iman'}
                        )
                      );

WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::XML::API::opts_type_args );

$WWW::YouTube::XML::API::numeric_max_try = $WWW::YouTube::ML::API::numeric_max_try;

##debug##$WWW::YouTube::XML::API::numeric_max_try++;
##debug##printf( STDERR "WWW::YouTube::XML::API::numeric_max_try=%d\n", $WWW::YouTube::XML::API::numeric_max_try );
##debug##printf( STDERR "WWW::YouTube::ML::API::numeric_max_try=%d\n", $WWW::YouTube::ML::API::numeric_max_try );

WWW::YouTube::ML::API::register_all_opts( \%WWW::YouTube::XML::API::opts_type_args );

push( @WWW::YouTube::XML::API::EXPORT_OK,
      @{$WWW::YouTube::XML::API::opts_type_args{'export_ok'}} );

#foreach my $x ( keys %{$WWW::YouTube::XML::API::opts_type_args{'opts'}} )
#{
#   printf( "opts{%s}=%s\n", $x, $WWW::YouTube::XML::API::opts_type_args{'opts'}{$x} );
#} ## end foreach

#foreach my $x ( @{$WWW::YouTube::XML::API::opts_type_args{'export_ok'}} )
#{
#   printf( "ok=%s\n", $x );
#} ## end foreach

#foreach my $x ( @WWW::YouTube::XML::API::EXPORT_OK )
#{
#   printf( "OK=%s\n", $x );
#} ## end foreach

##
## NOTE: Getopts hasn't set the options yet. (all flags = 0 right now)
##

$WWW::YouTube::XML::API::url = 'http://gdata.youtube.com';

$WWW::YouTube::XML::API::config = AppConfig::Std->new();

$WWW::YouTube::XML::API::config_file = File::Spec->catfile( $ENV{'HOME'}, '.www_youtube_rc' );

$WWW::YouTube::XML::API::config->define( 'username', { EXPAND   => 0 } );
$WWW::YouTube::XML::API::config->define( 'password', { EXPAND   => 0 } );
$WWW::YouTube::XML::API::config->define( 'dev_key', { EXPAND   => 0 } );
$WWW::YouTube::XML::API::config->define( 'clnt_id', { EXPAND   => 0 } );

if ( ! -e $WWW::YouTube::XML::API::config_file )
{
   system( "echo 'username = ' > $WWW::YouTube::XML::API::config_file" );
   system( "echo 'password = ' >> $WWW::YouTube::XML::API::config_file" );
   system( "echo 'dev_key = ' >> $WWW::YouTube::XML::API::config_file" );
   system( "echo 'clnt_id = ' >> $WWW::YouTube::XML::API::config_file" );

} ## end if

if ( -e $WWW::YouTube::XML::API::config_file &&
     ( ( ( stat( $WWW::YouTube::XML::API::config_file ) )[2] & 36 ) != 0 )
   )
{
   die "Your config file $WWW::YouTube::XML::API::config_file is readable by others!\n";

} ## end if

if ( -f $WWW::YouTube::XML::API::config_file )
{
   $WWW::YouTube::XML::API::config->file( $WWW::YouTube::XML::API::config_file )
   || die "reading $WWW::YouTube::XML::API::config_file\n";

} ## end if

##debug##printf( "username='%s'\n", $WWW::YouTube::XML::API::config->username() );
##debug##printf( "password='%s'\n", $WWW::YouTube::XML::API::config->password() );
##debug##printf( "dev_key='%s'\n", $WWW::YouTube::XML::API::config->dev_key() );
##debug##printf( "clnt_id='%s'\n", $WWW::YouTube::XML::API::config->clnt_id() );

$WWW::YouTube::XML::API::gdi = WWW::YouTube::GData->new(
                                  'Email'  => $WWW::YouTube::XML::API::config->username(),
                                  'Passwd' => $WWW::YouTube::XML::API::config->password(),
                                                       );

$WWW::YouTube::XML::API::gdi->login() || die "login failed: ".$WWW::YouTube::XML::API::gdi->errstr()."\n";

$WWW::YouTube::XML::API::ua = $WWW::YouTube::XML::API::gdi->_ua();

$WWW::YouTube::XML::API::ua->default_headers->push_header( 'X-GData-Key' => 'key=' . $WWW::YouTube::XML::API::config->dev_key() );

$WWW::YouTube::XML::API::ua->default_headers->push_header( 'X-GData-Client' => $WWW::YouTube::XML::API::config->clnt_id() );

##debug##print $WWW::YouTube::XML::API::ua->default_header( 'Authorization' ) . "\n";
##debug##print $WWW::YouTube::XML::API::ua->default_header( 'X-GData-Key' ) . "\n";
##debug##print $WWW::YouTube::XML::API::ua->default_header( 'X-GData-Client' ) . "\n";

END {

} ## end END

##
## WWW::YouTube::XML::API::show_all_opts
##
sub WWW::YouTube::XML::API::show_all_opts
{
   WWW::YouTube::ML::API::show_all_opts( \%WWW::YouTube::XML::API::opts_type_args );

} ## end sub WWW::YouTube::XML::API::show_all_opts

##
## WWW::YouTube::XML::API::request_dumper
##
sub WWW::YouTube::XML::API::request_dumper
{
   my $request = shift;

   my $ima = 'request'; ## dumper

   my $filename = $WWW::YouTube::XML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   my $fh = IO::File->new();

   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ $request ], [ $ima ] ) );

   $fh->close();

} ## end sub WWW::YouTube::XML::API::request_dumper

##
## WWW::YouTube::XML::API::result_dumper
##
sub WWW::YouTube::XML::API::result_dumper
{
   my $result = shift;

   my $ima = 'result'; ## dumper

   my $filename = $WWW::YouTube::XML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   my $fh = IO::File->new();

   ##
   ## .xml
   ##
   $fh->open( "+>${filename}.xml" ) ||
   die "opening: ${filename}.xml: $!\n";

   $fh->print( $result->content() );

   $fh->close();

   ##
   ## .txt
   ##
   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ $result ], [ $ima ] ) );

   $fh->close();

} ## end sub WWW::YouTube::XML::API::result_dumper

##
## WWW::YouTube::XML::API::tree_dumper
##
sub WWW::YouTube::XML::API::tree_dumper
{
   my $tree = shift;

   my $ima = 'tree'; ## dumper

   my $filename = $WWW::YouTube::XML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   my $fh = IO::File->new();

   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ $tree ], [ $ima ] ) );

   $fh->close();

} ## end sub WWW::YouTube::XML::API::tree_dumper

##
## WWW::YouTube::XML::API::ua_request
##
sub WWW::YouTube::XML::API::ua_request
{
   my $request = shift;

   WWW::YouTube::XML::API::request_dumper( $request ) if ( $WWW::YouTube::XML::API::flag_request_dmp );

   my $result = $WWW::YouTube::XML::API::ua->request( $request );

   if ( ! $result->is_success() )
   {
      printf( STDERR "Failed: %s\n", $result->status_line() );

   }
   else
   {
      WWW::YouTube::XML::API::result_dumper( $result ) if ( $WWW::YouTube::XML::API::flag_result_dmp );

   } ## end if

   return ( $result );

} ## end sub WWW::YouTube::XML::API::ua_request

##
## Retrieving Most Recent videos, etc.
## GET http://gdata.youtube.com/feeds/api/standardfeeds/most_recent
##
sub WWW::YouTube::XML::API::standardfeeds
{
   my $api = shift;

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/standardfeeds/$api" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::standardfeeds

##
## Retrieving user's contacts by userid
## GET http://gdata.youtube.com/feeds/api/users/userID/contacts
##
sub WWW::YouTube::XML::API::contacts_by_userid
{
   my $userid = shift || 'default';

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}/contacts" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::contacts_by_userid

##
## Retrieving user's favorite videos by userid
## GET http://gdata.youtube.com/feeds/api/users/userID/favorites
##
sub WWW::YouTube::XML::API::favorites_by_userid
{
   my $userid = shift || 'default';

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}/favorites" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::favorites_by_userid

##
## Retrieving user's playlists by userid
## GET http://gdata.youtube.com/feeds/api/users/userID/playlists
##
sub WWW::YouTube::XML::API::playlists_by_userid
{
   my $userid = shift || 'default';

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}/playlists" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::playlists_by_userid

##
## Retrieving user's profile by userid
## GET http://gdata.youtube.com/feeds/api/users/userID
##
sub WWW::YouTube::XML::API::profile_by_userid
{
   my $userid = shift || 'default';

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::profile_by_userid

##
## Retrieving user's subscriptions by userid
## GET http://gdata.youtube.com/feeds/api/users/userID/subscriptions
##
sub WWW::YouTube::XML::API::subscriptions_by_userid
{
   my $userid = shift || 'default';

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}/subscriptions" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::subscriptions_by_userid

##
## Retrieving user's uploaded videos by userid
## GET http://gdata.youtube.com/feeds/api/users/userID/uploads
##
sub WWW::YouTube::XML::API::uploaded_by_userid
{
   my $userid = shift || 'default';

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}/uploads" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::uploaded_by_userid

##
## Retrieving user's uploaded video entry by userid and videoid
## GET http://gdata.youtube.com/feeds/api/users/userID/uploads/videoID
##
sub WWW::YouTube::XML::API::get_uploaded_by_userid_videoid
{
   my ( $userid, $videoid ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}/uploads/${videoid}" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::get_uploaded_by_userid_videoid

##
## Updating user's uploaded video entry by userid and videoid
## PUT http://gdata.youtube.com/feeds/api/users/userID/uploads/videoID
##
sub WWW::YouTube::XML::API::put_uploaded_by_userid_videoid
{
   my ( $userid, $videoid, $entry ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'PUT' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}/uploads/${videoid}" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   $request->content( $entry->as_xml() );

   return( $request );

} ## end sub WWW::YouTube::XML::API::put_uploaded_by_userid_videoid

##
## Removing user's uploaded videos by userid and videoid
## DELETE http://gdata.youtube.com/feeds/api/users/userID/uploads/videoID
##
sub WWW::YouTube::XML::API::remove_uploaded_by_userid_videoid
{
   my ( $userid, $videoid ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'DELETE' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/users/${userid}/uploads/${videoid}" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   return( $request );

} ## end sub WWW::YouTube::XML::API::remove_uploaded_by_userid_videoid

##
## WWW::YouTube::XML::API::upload_by_userid_filename
##
sub WWW::YouTube::XML::API::upload_by_userid_filename
{
   my ( $userid, $filename, $xml_tree ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'POST' );
   $request->uri( "/feeds/api/users/${userid}/uploads" );
   $request->protocol( 'HTTP/1.1' );

   $request->header( 'Host' => 'uploads.gdata.youtube.com' );
   $request->header( 'Slug' => $filename );
   $request->header( 'Connection' => 'close' );

   $request->content_type( 'multipart/related; boundary="<boundary_string>"' );

   $request->add_part( HTTP::Message->new( ['Content-Type' => 'application/atom+xml; charset=UTF-8'],
                                           $xml_tree->as_XML()
                                         )
                     );

   return( $request );

} ## end sub WWW::YouTube::XML::API::upload_by_userid_filename

##
## Browsing with categories and keywords
## GET http://gdata.youtube.com/feeds/api/videos/-/categories_or_keywords
##
sub WWW::YouTube::XML::API::browse
{
   my $query = shift;

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   if ( ! ( $query =~ m@^[/]@ ) )
   {
      $query = '/' . $query;

   } ## end if

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/videos/-$query" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::browse

##
## Searching for videos
## GET http://gdata.youtube.com/feeds/api/videos?query_parameters
##
sub WWW::YouTube::XML::API::search
{
   my @query = @_;

   my $request = HTTP::Request->new();

   my $uri = URI->new( $WWW::YouTube::XML::API::url . '/feeds/api/videos' );

   $uri->query_form( @query );

   $request->method( 'GET' );

   $request->uri( $uri );

   return( $request );

} ## end sub WWW::YouTube::XML::API::search

##
## Retrieving a video's comments by videoid
## GET http://gdata.youtube.com/feeds/api/videos/videoID/comments
##
sub WWW::YouTube::XML::API::comments_by_videoid
{
   my $videoid = shift;

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/videos/${videoid}/comments" );

   return( $request );

} ## end sub WWW::YouTube::XML::API::comments_by_videoid

##
## Creating a comment
##
## POST http://gdata.youtube.com/feeds/api/videos/videoID/comments
##
sub WWW::YouTube::XML::API::comment_by_videoid
{
   my ( $videoid, $xml_tree ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'POST' );

   $request->uri( $WWW::Youtube::XML::API::url . "/feeds/api/videos/${videoid}/comments" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   $request->content( $xml_tree->as_XML() );

   return( $request );

} ## end sub WWW::YouTube::XML::API::comment_by_videoid

##
## Creating a video response
##
## POST http://gdata.youtube.com/feeds/api/videos/videoID/responses
##
sub WWW::YouTube::XML::API::response_by_videoid
{
   my ( $videoid, $xml_tree ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'POST' );

   $request->uri( $WWW::YouTube::XML::API::url . "/feeds/api/${videoid}/responses" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   $request->content( $xml_tree->as_XML() );

   return( $request );

} ## end sub WWW::YouTube::XML::API::response_by_videoid

1;
__END__ ## package WWW::YouTube::XML::API

=head1 NAME

WWW::YouTube::XML::API - How to Interface with YouTube using HTTP Protocol and GData XML Atom API.

http://code.google.com/apis/youtube/developers_guide_protocol.html

=head1 SYNOPSIS

use WWW::YouTube;

=item ## Standard feeds

foreach my $feed qw( top_rated top_favorites most_viewed most_recent most_discussed most_linked most_responded recently_featured watch_on_mobile )
{
   print "##\n## /feeds/api/standardfeeds/$feed\n##\n";

   $request = WWW::YouTube::XML::API::standardfeeds( $feed );

   $result = WWW::YouTube::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      $xml_tree = WWW::YouTube::XML::parse_result( $result );

      WWW::YouTube::XML::example_show_xml_links( $xml_tree );

      $xml_tree->delete();

   }
   else
   {
      print $result->as_string() . "\nFAILURE\n";

   } ## end if

} ## end foreach

=item ## Uploaded by user

my $request = WWW::YouTube::XML::API::uploaded_by_userid( $userid );

my $result = WWW::YouTube::XML::API::ua_request( $request );

if ( $result->is_success() )
{
   my $xml_tree = XML::TreeBuilder->new();

   $xml_tree->parse( $result->content() );

   $xml_tree->eof();

   # do something here, then

   $xml_tree->delete();

} ## end if

=head1 OPTIONS

=item --xml_ua_dmp

user agent transaction dump

=item --xml_request_dmp

transaction request dump

=item --xml_result_dmp

transaction result dump

=head1 DESCRIPTION

XML::API stands for XML Application Programming Interface

See:	http://code.youtube.com
	http://code.google.com/apis/youtube
	http://code.google.com/apis/youtube/developers_guide_protocol.html


=head2	Demo

=over

WWW::YouTube::XML::demo()

=back

=head2 Retrieving and searching for videos

=over

1. Standard video feeds

=over

foreach my $feed qw( top_rated top_favorites most_viewed most_recent most_discussed most_linked most_responded recently_featured watch_on_mobile )
{
   print "##\n## /feeds/api/standardfeeds/$feed\n##\n";

   $request = WWW::YouTube::XML::API::standardfeeds( $feed );

   $result = WWW::YouTube::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      $xml_tree = WWW::YouTube::XML::parse_result( $result );

      WWW::YouTube::XML::example_show_xml_links( $xml_tree );

      $xml_tree->delete();

   }
   else
   {
      print $result->as_string() . "\nFAILURE\n";

   } ## end if

} ## end foreach

NOTE: This also works. WWW::YouTube::XML::API::standardfeeds( 'US/top_rated?time=today' );

=back

2. Videos uploaded by a specific user

=over

$request = WWW::YouTube::XML::API::uploaded_by_userid([ $userid ]);

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

3. Related videos

=over

Follow a link with rel="http://gdata.youtube.com/schemas/2007#video.related".

=back

4. Browsing with categories and keywords

=over

$request = WWW::YouTube::XML::API::browse( $categories_or_keywords );

$result = WWW::YouTube::XML::API::ua_request( $request );

See: http://code.google.com/apis/youtube/developers_guide_protocol.html#Browsing_with_Categories_and_Keywords

=back

5. Searching for videos

=over

$request = WWW::YouTube::XML::API::search( 'vq' => 'funny+video', 'max-results' => 10 );

$result = WWW::YouTube::XML::API::ua_request( $request );

See: http://code.google.com/apis/youtube/developers_guide_protocol.html#Searching_for_Videos

=back

=back

=head2 Uploading videos

=over

$request = WWW::YouTube::XML::API::upload_by_userid_filename( $userid, $filename, $xml_tree );

## ADD FILE PART ## See WWW::YouTube::XML::example_upload

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=head2 Updating and deleting videos

=over

1. Updating a video entry

=over

$request = WWW::YouTube::XML::API::get_uploaded_by_userid_videoid( $userid, $videoid );

$result = WWW::YouTube::XML::API::ua_request( $request );

$xml_tree = WWW::YouTube::XML::parse_result( $result );

## Edit the Entry, then put the update

$request = WWW::YouTube::XML::API::put_uploaded_by_userid_videoid( $userid, $videoid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Deleting a video

=over

$request = WWW::YouTube::XML::API::remove_uploaded_by_userid_videoid( $userid, $videoid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

=head2 Using community features

=over

1. Adding a rating

=over

$request = WWW::YouTube::XML::API::rating_by_videoid( $videoid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Comments

=over

1. Retrieving comments for a video

=over

$request = WWW::YouTube::XML::API::comments_by_videoid( $videoid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Adding a comment in response to a video

=over

$request = WWW::YouTube::XML::API::comment_by_videoid( $videoid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

3. Video responses

=over

1. Retrieving a list of video responses

=over

$request = WWW::YouTube::XML::API::responses_by_videoid( $videoid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Adding a video response

=over

$request = WWW::YouTube::XML::API::response_by_videoid( $videoid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

3. Deleting a video response

=over

$request = WWW::YouTube::XML::API::remove_response_by_videoid_responseid( $videoid, $responseid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

4. Adding a complaint

=over

$request = WWW::YouTube::XML::API::complaint_by_videoid( $videoid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back


5. Sharing videos with other users

=over

$request = WWW::YouTube::XML::API::contact_by_userid( $userid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

=head2 Saving and collecting videos

=over

1. Favorite videos

=over

1. Retrieving a user's favorite videos

=over

$request = WWW::YouTube::XML::API::favorites_by_userid([ $userid ]);

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Adding a favorite video

=over

$request = WWW::YouTube::XML::API::favorite_by_userid( $userid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

3. Deleting a favorite video

=over

$request = WWW::YouTube::XML::API::remove_favorite_by_userid_videoid( $userid, $videoid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

2. Playlists

=over

1. Retrieving a user's playlists

=over

$request = WWW::YouTube::XML::API::playlists_by_userid([ $userid ]);

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Retrieving a single playlist

=over

Follow a gd:feedLink with rel="http://gdata.youtube.com/schemas/2007#playlist".

=back

3. Adding a playlist

=over

$request = WWW::YouTube::XML::API::playlist_by_userid( $userid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

4. Updating a playlist

=over

$request = WWW::YouTube::XML::API::get_playlist_by_userid_playlistid( $userid, $playlistid );

$result = WWW::YouTube::XML::API::ua_request( $request );

$xml_tree = WWW::YouTube::XML::parse_result( $result );

## Edit the Entry, then put the update

$request = WWW::YouTube::XML::API::put_playlist_by_userid_playlistid( $userid, $playlistid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=over

1. Adding a video to a playlist

=over

$request = WWW::YouTube::XML::API::add_to_playlist_by_playlistid( $playlistid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Editing video information in a playlist

=over

$request = WWW::YouTube::XML::API::get_entry_by_playlistid_entryid( $playlistid, $entryid );

$result = WWW::YouTube::XML::API::ua_request( $request );

$xml_tree = WWW::YouTube::XML::parse_result( $result );

## Edit the Entry, then put the update

$request = WWW::YouTube::XML::API::put_entry_by_playlistid_entryid( $playlistid, $entryid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

3. Removing a video from a playlist

=over

$request = WWW::YouTube::XML::API::remove_entry_by_playlistid_entryid( $playlistid, $entryid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

5. Deleting a playlist

=over

$request = WWW::YouTube::XML::API::remove_playlist_by_userid_playlistid( $userid, $playlistid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

3. Subscriptions

=over

1. Retrieving a user's subscriptions

=over

$request = WWW::YouTube::XML::API::subscriptions_by_userid([ $userid ]);

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Adding a subscription

=over

$request = WWW::YouTube::XML::API::subscribe_by_userid( $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

3. Deleting a subscription

=over

$request = WWW::YouTube::XML::API::remove_subscription_by_userid_subscriptionid( $userid, $subscriptionid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

=back

=head2 Enabling user interaction

=over

1. User profiles

=over

1. Retrieving a user's profile

=over

$request = WWW::YouTube::XML::API::profile_by_userid([ $userid ]);

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

2. Contacts

=over

1. Retrieving a user's contacts

=over

$request = WWW::YouTube::XML::API::contacts_by_userid([ $userid ]);

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

2. Adding a contact

=over

$request = WWW::YouTube::XML::API::add_contact_by_userid( $userid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

3. Updating a contact

=over

$request = WWW::YouTube::XML::API::get_contact_by_userid_contactid( $userid, $contactid );

$result = WWW::YouTube::XML::API::ua_request( $request );

$xml_tree = WWW::YouTube::XML::parse_result( $result );

# Edit the Entry, then put the update

$request = WWW::YouTube::XML::API::put_contact_by_userid_contactid( $userid, $contactid, $xml_tree );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

4. Deleting a contact

=over

$request = WWW::YouTube::XML::API::remove_contact_by_userid_contactid( $userid, $contactid );

$result = WWW::YouTube::XML::API::ua_request( $request );

=back

=back

=back

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML::API>> I<L<WWW::YouTube::HTML::API>> I<L<WWW::YouTube::XML>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut

