##
## WWW::YouTube::XML
##
package WWW::YouTube::XML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0623 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::XML::ISA = qw(Exporter);

   @WWW::YouTube::XML::EXPORT = qw(); ## export required

   @WWW::YouTube::XML::EXPORT_OK =
   (

   ); ## export ok on request

} ## end BEGIN

require WWW::YouTube::XML::API;

require IO::Zlib;

require File::Basename;

require Date::Format;

require String::Approx;

require XML::TreeBuilder; ## XML::Tree parser

require XML::Dumper;

%WWW::YouTube::XML::opts =
(
);

__PACKAGE__ =~ m/^(WWW::[^:]+)((::([^:]+)){1}(::([^:]+)){0,1}){0,1}$/g;

##debug##print( "XML! $1::$4::$6\n" );

%WWW::YouTube::XML::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $4,
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::YouTube::XML::opts,
   'opts_filename'  => {},
   'export_ok'      => [],
   'urls' =>
   {
   },
   'opts_type_flag' =>
   [
   ],
   'opts_type_numeric' =>
   [
   ],
   'opts_type_string' =>
   [
      'vlbt_want',
   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::YouTube::XML::opts_type_args{'ido'},
                                $WWW::YouTube::XML::opts_type_args{'iknow'},
                                #$WWW::YouTube::XML::opts_type_args{'iman'}
                        )
                      );

WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::XML::opts_type_args );

##debug##WWW::YouTube::ML::API::show_all_opts( \%WWW::YouTube::XML::opts_type_args );

$WWW::YouTube::XML::string_vlbt_want = 'all';

WWW::YouTube::XML::register_all_opts( \%WWW::YouTube::XML::API::opts_type_args );

#push( @WWW::YouTube::XML::EXPORT_OK,
#      @{$WWW::YouTube::XML::opts_type_args{'export_ok'}} );

END {

} ## end END

##
## WWW::YouTube::XML::register_all_opts
##
sub WWW::YouTube::XML::register_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::XML::API::opts_type_args;

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      $WWW::YouTube::XML::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      $WWW::YouTube::XML::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::YouTube::XML::register_all_opts

##
## WWW::YouTube::XML::show_all_opts
##
sub WWW::YouTube::XML::show_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::XML::opts_type_args;

   WWW::YouTube::ML::API::show_all_opts( $opts_type_args );

} ## end sub WWW::YouTube::XML::show_all_opts

#<feed xmlns='http://www.w3.org/2005/Atom'
#      xmlns:openSearch='http://a9.com/-/spec/opensearchrss/1.0/'
#      xmlns:gml='http://www.opengis.net/gml'
#      xmlns:georss='http://www.georss.org/georss'
#      xmlns:media='http://search.yahoo.com/mrss/'
#      xmlns:yt='http://gdata.youtube.com/schemas/2007'
#      xmlns:gd='http://schemas.google.com/g/2005'>

##
## See: http://code.google.com/apis/gdata/reference.html
##
## The Atom response feed and entries may also include any of the following Atom and GData elements
## (as well as others listed in the Atom specification):
##
#<link rel="http://schemas.google.com/g/2005#feed" type="application/atom+xml" href="..."/>
#      Specifies the URI where the complete Atom feed can be retrieved.
#
#<link rel="http://schemas.google.com/g/2005#post" type="application/atom+xml" href="..."/>
#      Specifies the Atom feed's PostURI (where new entries can be posted).
#
#<link rel="self" type="..." href="..."/>
#      Contains the URI of this resource.
#      The value of the type attribute depends on the requested format.
#      If no data changes in the interim, sending another GET to this URI returns the same response.
#
#<link rel="previous" type="application/atom+xml" href="..."/>
#      Specifies the URI of the previous chunk of this query result set, if it is chunked.
#
#<link rel="next" type="application/atom+xml" href="..."/>
#      Specifies the URI of the next chunk of this query result set, if it is chunked.
#
#<link rel="edit" type="application/atom+xml" href="..."/>
#      Specifies the Atom entry's EditURI (where you send an updated entry).

##
## WWW::YouTube::XML::demo
##
sub WWW::YouTube::XML::demo
{
   my $request = undef;

   my $result = undef;

   my $xml_tree = undef;

   foreach my $feed qw( top_rated top_favorites most_viewed most_recent most_discussed most_linked most_responded recently_featured watch_on_mobile )
   {
      print "##\n## /feeds/api/standardfeeds/$feed\n##\n";

      $request = WWW::YouTube::XML::API::standardfeeds( $feed );

      $result = WWW::YouTube::XML::API::ua_request( $request );

      if ( $result->is_success() )
      {
         $xml_tree = WWW::YouTube::XML::parse_result( $result );

         WWW::YouTube::XML::example_show_xml_links( $xml_tree );

         $xml_tree ->delete();

      }
      else
      {
         print $result->as_string() . "\nFAILURE\n";

      } ## end if

   } ## end foreach

   print "##\n## uploaded_by_userid\n##\n";

   $request = WWW::YouTube::XML::API::uploaded_by_userid( 'nikitia' );

   $result = WWW::YouTube::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      $xml_tree = WWW::YouTube::XML::parse_result( $result );

      WWW::YouTube::XML::example_show_xml_links( $xml_tree );

      $xml_tree ->delete();

   }
   else
   {
      print $result->as_string() . "\nFAILURE\n";

   } ## end if

   print "##\n## browse\n##\n";

   $request = WWW::YouTube::XML::API::browse( '/comedy/-Comedy' );

   $result = WWW::YouTube::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      $xml_tree = WWW::YouTube::XML::parse_result( $result );

      WWW::YouTube::XML::example_show_xml_links( $xml_tree );

      $xml_tree ->delete();

   }
   else
   {
      print $result->as_string() . "\nFAILURE\n";

   } ## end if

   print "##\n## search\n##\n";

   $request = WWW::YouTube::XML::API::search( 'vq' => 'funny+video', 'start-index' => 11, 'max-results' => 10 );

   $result = WWW::YouTube::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      $xml_tree = WWW::YouTube::XML::parse_result( $result );

      WWW::YouTube::XML::example_show_xml_links( $xml_tree );

      $xml_tree ->delete();

   }
   else
   {
      print $result->as_string() . "\nFAILURE\n";

   } ## end if

} ## end sub WWW::YouTube::XML::demo

##
## Parse result
##
sub WWW::YouTube::XML::parse_result
{
   my $result = shift;

   my $xml_tree = XML::TreeBuilder->new();

   $xml_tree->parse( $result->content() );

   $xml_tree->eof();

   return( $xml_tree );

} ## end sub WWW::YouTube::XML::parse_result

##
## Example show_xml_links
##
sub WWW::YouTube::XML::example_show_xml_links
{
   my $xml_tree = shift;

   if ( $xml_tree->{'_tag'} eq 'feed' )
   {
      WWW::YouTube::XML::API::tree_dumper( $xml_tree ) if ( $WWW::YouTube::XML::API::flag_tree_dmp );

      foreach my $xml_child ( $xml_tree->content_list() )
      {
         next if ( ! ( $xml_child->tag() eq 'link' ) );

         if ( $xml_child->attr( 'rel' ) eq 'http://schemas.google.com/g/2005#feed' )
         {
            ##debug##
            print "FEED::FEED " . $xml_child->attr( 'href' ) . "\n";

         }
         elsif ( $xml_child->attr( 'rel' ) eq 'alternate' )
         {
            ##debug##
            print "FEED::ALT  " . $xml_child->attr( 'href' ) . "\n";

         }
         elsif ( $xml_child->attr( 'rel' ) eq 'related' )
         {
            ##debug##
            print "FEED::REL  " . $xml_child->attr( 'href' ) . "\n";

         }
         elsif ( $xml_child->attr( 'rel' ) eq 'previous' )
         {
            ##debug##
            print "FEED::PREV " . $xml_child->attr( 'href' ) . "\n";

         }
         elsif ( $xml_child->attr( 'rel' ) eq 'self' )
         {
            ##debug##
            print "FEED::SELF " . $xml_child->attr( 'href' ) . "\n";

         }
         elsif ( $xml_child->attr( 'rel' ) eq 'next' )
         {
            ##debug##
            print "FEED::NEXT " . $xml_child->attr( 'href' ) . "\n";

         }
         else
         {
            ##debug##
            print "FEED::???  " . $xml_child->attr( 'rel' ) . "\n";

         } ## end if

      } ## end foreach

      foreach my $xml_entry ( $xml_tree->find_by_tag_name( 'entry' ) )
      {
         my $xml_title = $xml_entry->find_by_tag_name( 'title' );

         ##debug##
         printf( "title=%s\n", $xml_title->content()->[ 0 ] );

         foreach my $xml_link ( $xml_entry->find_by_tag_name( 'link' ) )
         {
            if ( $xml_link->attr( 'rel' ) eq 'alternate' )
            {
               ##debug##
               print "ALTERNATE " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'http://gdata.youtube.com/schemas/2007#video.complaints' )
            {
               ##debug##
               print "COMPLAINT " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'http://gdata.youtube.com/schemas/2007#video.ratings' )
            {
               ##debug##
               print "RATING    " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'http://gdata.youtube.com/schemas/2007#video.related' )
            {
               ##debug##
               print "RELATED   " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'http://gdata.youtube.com/schemas/2007#video.responses' )
            {
               ##debug##
               print "RESPONSES " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'self' )
            {
               ##debug##
               print "SELF      " . $xml_link->attr( 'href' ) . "\n";

            } ## end if

         } ## end foreach

      } ## end foreach

   } ## end if

} ## end sub WWW::YouTube::XML::example_show_xml_links

##
## Example rating
##
sub WWW::YouTube::XML::example_rating_by_videoid_rating
{
   my ( $videoid, $rating ) = @_;

   my $xml_tree = XML::Element->new( '~pi', text => 'xml version="1.0" encoding="UTF-8"' );

   my $entry = XML::Element->new( 'entry', 'xmlns' => "http://www.w3.org/2005/Atom",
                                           'xmlns:gd' => "http://schemas.google.com/g/2005" );

   my $gdrating = XML::Element->new( 'gd:rating', 'value' => $rating, 'min' => 1, 'max' => 5 );

   $entry->push_content( $gdrating );

   $xml_tree->push_content( $entry );

   my $request = WWW::YouTube::XML::API::rating_by_videoid( $videoid, $xml_tree );

   $xml_tree->delete();

   return( $request );

} ## end sub WWW::YouTube::XML::example_rating_by_videoid_rating

##
## Example comment
##
sub WWW::YouTube::XML::example_comment_by_videoid_comment
{
   my ( $videoid, $comment ) = @_;

   my $xml_tree = XML::Element->new( '~pi', text => 'xml version="1.0" encoding="UTF-8"' );

   my $entry = XML::Element->new( 'entry', 'xmlns' => "http://www.w3.org/2005/Atom" );

   my $content = XML::Element->new( 'content', 'type' => 'text' );

   $content->push_content( $comment );

   $entry->push_content( $content );

   $xml_tree->push_content( $entry );

   my $request = WWW::YouTube::XML::API::comment_by_videoid( $videoid, $xml_tree );

   $xml_tree->delete();

   return( $request );

} ## end sub WWW::YouTube::XML::example_comment_by_videoid_comment

##
## Example complaint
##
sub WWW::YouTube::XML::example_complaint_by_videoid_reason
{
   my ( $videoid, $reason ) = @_;

   my $xml_tree = XML::Element->new( '~pi', text => 'xml version="1.0" encoding="UTF-8"' );

   my $entry = XML::Element->new( 'entry', 'xmlns' => "http://www.w3.org/2005/Atom",
                                           'xmlns:yt' => "http://gdata.youtube.com/schemas/2007" );

   my $ytcontent = XML::Element->new( 'yt:content', 'type' => 'text' );

   my $category = XML::Element->new( 'category', 'scheme' => 'http://gdata.youtube.com/schemas/2007/complaint-reasons.cat',
                                                 'term' => $reason,
                                   );

   $ytcontent->push_content( "Please ignore this complaint. I'm testing a YouTube API and needed to issue a complaint to test the add complaint function." );

   $entry->push_content( $ytcontent );

   $entry->push_content( $category );

   $xml_tree->push_content( $entry );

   my $request = WWW::YouTube::XML::API::complaint_by_videoid( $videoid, $xml_tree );

   $xml_tree->delete();

   return( $request );

} ## end sub WWW::YouTube::XML::example_complaint_by_videoid_reason

##
## Example contact
##
sub WWW::YouTube::XML::example_contact_by_userid_videoid_description
{
   my ( $userid, $videoid, $description ) = @_;

   my $xml_tree = XML::Element->new( '~pi', text => 'xml version="1.0" encoding="UTF-8"' );

   my $entry = XML::Element->new( 'entry', 'xmlns' => "http://www.w3.org/2005/Atom",
                                           'xmlns:yt' => "http://gdata.youtube.com/schemas/2007" );

   my $id = XML::Element->new( 'id' );

   my $ytdescription = XML::Element->new( 'yt:description' );

   $ytdescription->push_content( $description );

   $id->push_content( $videoid );

   $entry->push_content( $id );

   $entry->push_content( $ytdescription );

   $xml_tree->push_content( $entry );

   my $request = WWW::YouTube::XML::API::contact_by_userid( $userid, $xml_tree );

   $xml_tree->delete();

   return( $request );

} ## end sub WWW::YouTube::XML::example_contact_by_userid_videoid_description

##
## Example favorite
##
sub WWW::YouTube::XML::example_favorite_by_userid_videoid
{
   my ( $userid, $videoid ) = @_;

   my $xml_tree = XML::Element->new( '~pi', text => 'xml version="1.0" encoding="UTF-8"' );

   my $entry = XML::Element->new( 'entry', 'xmlns' => "http://www.w3.org/2005/Atom" );

   my $id = XML::Element->new( 'id' );

   $id->push_content( $videoid );

   $entry->push_content( $id );

   $xml_tree->push_content( $entry );

   my $request = WWW::YouTube::XML::API::favorite_by_userid( $userid, $xml_tree );

   $xml_tree->delete();

   return( $request );

} ## end sub WWW::YouTube::XML::example_favorite_by_userid_videoid

##
## Example playlist
##
sub WWW::YouTube::XML::example_playlist_by_userid_title_description
{
   my ( $userid, $title_string, $description ) = @_;

   my $xml_tree = XML::Element->new( '~pi', text => 'xml version="1.0" encoding="UTF-8"' );

   my $entry = XML::Element->new( 'entry', 'xmlns' => "http://www.w3.org/2005/Atom",
                                           'xmlns:yt' => "http://gdata.youtube.com/schemas/2007" );

   my $title = XML::Element->new( 'title', 'type' => 'text' );

   my $ytdescription = XML::Element->new( 'yt:description' );

   $title->push_content( $title_string );

   $ytdescription->push_content( $description );

   $entry->push_content( $title );

   $entry->push_content( $ytdescription );

   $xml_tree->push_content( $entry );

   my $request = WWW::YouTube::XML::API::playlist_by_userid( $userid, $xml_tree );

   $xml_tree->delete();

   return( $request );

} ## end sub WWW::YouTube::XML::example_playlist_by_userid_title_description

##
## Example response
##
sub WWW::YouTube::XML::API::example_response_from_videoid_to_videoid
{
   my ( $videoid_from, $videoid_to ) = @_;

   my $xml_tree = XML::Element->new( '~pi', text => 'xml version="1.0" encoding="UTF-8"' );

   my $entry = XML::Element->new( 'entry', 'xmlns' => "http://www.w3.org/2005/Atom" );

   my $id = XML::Element->new( 'id' );

   $id->push_content( $videoid_from );

   $entry->push_content( $id );

   $xml_tree->push_content( $entry );

   my $request = WWW::YouTube::XML::API::response_by_videoid( $videoid_to, $xml_tree );

   $xml_tree->delete();

   return( $request );

} ## end sub WWW::YouTube::XML::API::example_response_from_videoid_to_videoid

##
## WWW::YouTube::XML::action_vlbt
##
%WWW::YouTube::XML::vlbt = ();

sub WWW::YouTube::XML::action_vlbt
{
   my $h = shift;

   my $tag = $h->{'tag'};

   $tag =~ s@ @+@g;

   %WWW::YouTube::XML::vlbt = ( 'ok' => 0 );

   my $start_index = ( $h->{'page'} - 1 ) * $h->{'per_page'} + 1;

   ##debug##printf( "start_index=%d\n", $start_index );

   my $request = WWW::YouTube::XML::API::search( 'vq' => $tag,
                                                 'max-results' => $h->{'per_page'},
                                                 'start-index' => $start_index );

   my $result = WWW::YouTube::XML::API::ua_request( $request );

   my $xml_tree = WWW::YouTube::XML::parse_result( $result );

   foreach my $xml_entry ( $xml_tree->find_by_tag_name( 'entry' ) )
   {
      $WWW::YouTube::XML::vlbt{'ok'} = 1;

      my $xml_id = $xml_entry->find_by_tag_name( 'id' );

      ##debug##printf( "id=%s\n", $xml_id->content()->[ 0 ] );

      $xml_id->content()->[ 0 ] =~ m@/videos/(.+)$@;

      my $video_id = $1;

      ##debug##printf( "video_id=%s\n", $video_id );

      my $xml_title = $xml_entry->find_by_tag_name( 'title' );

      ##debug##printf( "title=%s\n", $xml_title->content()->[ 0 ] );

      my $xml_content = $xml_entry->find_by_tag_name( 'content' );

      ##debug##printf( "content=%s\n", $xml_content->content()->[ 0 ] );

      my $xml_author = $xml_entry->find_by_tag_name( 'uri' );

      ##debug##printf( "author=%s\n", $xml_author->content()->[ 0 ] );

      $xml_author->content()->[ 0 ] =~ m@/users/(.+)$@;

      my $author = $1;

      ##debug##printf( "author=%s\n", $author );

      $WWW::YouTube::XML::vlbt{$video_id}->{'author'} = $author;

      $WWW::YouTube::XML::vlbt{$video_id}->{'title'} = $xml_title->content()->[ 0 ];

      $WWW::YouTube::XML::vlbt{$video_id}->{'description'} = $xml_content->content()->[ 0 ];

      $WWW::YouTube::XML::vlbt{$video_id}->{'tags'} = '';

      foreach my $xml_category ( $xml_entry->find_by_tag_name( 'category' ) )
      {
         next if ( ! defined( $xml_category->attr( 'term' ) ) );

         ##debug##printf( "term=%s\n", $xml_category->attr( 'term' ) );

         $WWW::YouTube::XML::vlbt{$video_id}->{'tags'} .= $xml_category->attr( 'term' ) . ' ';

      } ## end foreach

   } ## end foreach

   return ( \%WWW::YouTube::XML::vlbt );

} ## end sub WWW::YouTube::XML::action_vlbt

##
## WWW::YouTube::XML::vlbt
##
sub WWW::YouTube::XML::vlbt  ## NOTE: changing this to collect data for xml dump
{
   my $h = shift;

   ##
   ## XML: purpose
   ##

   my $iam = 'vlbt';

   my $ihave = 'video_list';

   my $xml_curr_page = $h->{'first_page'}; ## first call

   my $xml_full_need = ( $h->{'last_page'} - $h->{'first_page'} + 1 ) * $h->{'per_page'}; ## to meet need

   my $xml_per_page = $h->{'per_page'}; ## items per call

   my $xml_last_page = $h->{'last_page'}; ## last call

   ##
   ## Okay, here we go
   ##

   my $item_cnt = 0;

   my $item_cnt_saved = $item_cnt;

   my $vlbt = undef; ## video_list_by_tag

   $h->{$ihave}->{'tag'} = $h->{'tag'};

   next_vlbt: ## goto label

   my $try = 1; ## reset

   ##debug##   print "WWW::YouTube::XML getting page=$xml_curr_page\n";

   while ( $try++ <= $WWW::YouTube::XML::API::numeric_max_try )
   {
      $vlbt = WWW::YouTube::XML::action_vlbt( {
                                                 'tag' => $h->{$ihave}->{'tag'},
                                                 'per_page' => $xml_per_page,
                                                 'page' => $xml_curr_page,
                                            } );

      last if ( $vlbt->{'ok'} );

      sleep $WWW::YouTube::ML::numeric_delay_sec; ## pacing requests

   } ## end while

   if ( $vlbt->{'ok'} )
   {
      ##
      ## Process vlbt page
      ##

      delete( $vlbt->{'ok'} );

      $item_cnt_saved = $item_cnt;

      while ( my ( $video_id_tag, $video_id_tag_val ) = each( %{$vlbt} ) )
      {
         next if ( defined( $h->{$ihave}->{$iam}{$video_id_tag} ) ); ## something new came back

         ##debug##printf( STDERR "XML::$iam %s => %s\n", $video_id_tag, $video_id_tag_val );

         $h->{$ihave}->{$iam}{$video_id_tag} = $video_id_tag_val;

         $item_cnt++ 

      } ## end while

      if ( $item_cnt > $item_cnt_saved )
      {
         $xml_curr_page++;

         goto next_vlbt if ( $xml_curr_page <= $xml_last_page );

      } ## end if

   }
   else
   {
      $h->{$ihave}->{'ok'} = 0; ## some vlbt was bad

   } ## end if

   foreach my $video_id ( keys %{$h->{$ihave}->{$iam}} )
   {
      $h->{$ihave}->{'tag'} =~ s/[\s]+/ /g;

      $h->{$ihave}->{$iam}->{$video_id}->{'tags'} =~ s/[\s]+/ /g;

      $h->{$ihave}->{$iam}->{$video_id}->{'title'} =~ s/[\s]+/ /g;

      ##debug##printf( "title=%s\n", $h->{$ihave}->{$iam}->{$video_id}->{'title'} );

      $h->{$ihave}->{$iam}->{$video_id}->{'description'} =~ s/[\s]+/ /g;

      $h->{'found_author'}->{$video_id} = 0; ## % certain

      if ( ! defined( $h->{$ihave}->{$iam}->{$video_id}->{'author'} ) )
      {
         $h->{$ihave}->{$iam}->{$video_id}->{'author'} = '';

         $h->{'found_author'}->{$video_id} = 0; ## % certain

      }
      else
      {
         $h->{$ihave}->{$iam}->{$video_id}->{'author'} =~ s/[\s]+/ /g;

         ##debug##printf( "XML::${iam}_author=%s\n", $h->{$ihave}->{$iam}->{$video_id}->{'author'} );

         if ( $h->{$ihave}->{$iam}->{$video_id}->{'author'} =~ m/$h->{$ihave}->{'tag'}/i )
         {
            $h->{'found_author'}->{$video_id} = 100; ## % certain

            $h->{$ihave}->{$iam}->{'author'}{
               $h->{$ihave}->{$iam}->{$video_id}->{'author'}
                                                    }->{'videos'}{$video_id} = 1;

         }
         else
         {
            $h->{'found_author'}->{$video_id} = 0; ## % certain

         } ## end if

      } ## end if

      $h->{'found_tagged'}->{$video_id} = 0; ## % certain

      foreach my $x ( split( /[\s:]+/, $h->{$ihave}->{$iam}->{$video_id}->{'tags'} ) )
      {
         ##debug##printf( "XML::${iam}_anytag=%s\n", $x );

         if ( String::Approx::amatch( $x, qw(i), $h->{$ihave}->{'tag'} ) )
         {
            ##debug## printf( "XML::${iam}_tag=%s\n", $x );

            next if ( $x eq '*' || $x eq '+' );

            if ( ( $h->{$ihave}->{'tag'} =~ m/$x/i ) &&
                 ( length( $x ) >= int ( length( $h->{$ihave}->{'tag'} ) / 2 ) )
               )
            {
               if ( $x =~ m/$h->{$ihave}->{'tag'}/i )
               {
                  ##debug##printf( "XML::${iam}_tag=%s full match\n", $x );

                  $h->{'found_tagged'}->{$video_id} = 100; ## % certain

                  last;

               }
               elsif ( $h->{'found_tagged'}->{$video_id} < 50 )
               {
                  ##debug##printf( "XML::${iam}_tag=%s fuzzy match\n", $x );

                  $h->{'found_tagged'}->{$video_id} = 50; ## % certain

               } ## end if

            }
            elsif ( ! defined( $h->{'found_tagged'}->{$video_id} ) )
            {
               ##debug##printf( "XML::${iam}_tag=%s fuzzy mismatch\n", $x )

               $h->{'found_tagged'}->{$video_id} = 0; ## % certain

            } ## end if

         } ## end if

      } ## end foreach

   } ## end foreach

   return ( $h );

} ## end sub WWW::YouTube::XML::vlbt

1;
__END__ ## package WWW::YouTube::XML

=head1 NAME

WWW::YouTube::XML - General Extensible Markup Language capabilities go in here.

=head1 SYNOPSIS

=head1 OPTIONS

--xml_* options:

opts_type_flag:

   NONE

opts_type_numeric:

   NONE

opts_type_string:

   --xml_vlbt_want=string

=head1 DESCRIPTION

   WWW::YouTube XML Layer.

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::HTML>> I<L<WWW::YouTube::XML::API>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut

