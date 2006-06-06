## WWW::YouTube::XML::API
##
package WWW::YouTube::XML::API;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2006.0606 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::XML::API::ISA = qw(Exporter);

   @WWW::YouTube::XML::API::EXPORT = qw(); ## export required

   @WWW::YouTube::XML::API::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require WWW::YouTube::Com; ## NOTE: I need WWW::YouTube secrets

require WWW::YouTube::HTML::API; ## NOTE: HTML/XML crossover

require WWW::YouTube::ML::API; ## NOTE: generic *ML

require Frontier::Client; ## XML::API::ua (User Agent)

##require XML::libXML;
require XML::Parser; ## XML::API::tree parser

require DBI; require XML::Dumper; ##require SQL::Statement;

require Data::Dumper; ## get rid of this

require IO::File;

##debug##require FindBin;
##debug##require Cwd;

require Date::Format;

$WWW::YouTube::XML::API::url = "$WWW::YouTube::HTML::API::url/api2_xmlrpc";

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
      ## Customizations follow this line ##
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

); ## this does the work with opts and optype_flag(s)

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::YouTube::XML::API::opts_type_args{'ido'},
                                $WWW::YouTube::XML::API::opts_type_args{'iknow'},
                                $WWW::YouTube::XML::API::opts_type_args{'iman'}
                        )
                      );

WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::XML::API::opts_type_args );

$WWW::YouTube::XML::API::numeric_max_try = $WWW::YouTube::ML::API::numeric_max_try;
$WWW::YouTube::XML::API::string_dbm_dir = $WWW::YouTube::ML::API::string_dbm_dir.'/xml';
$WWW::YouTube::XML::API::string_vlbt_want = $WWW::YouTube::ML::API::string_vlbt_want;
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
   die "opening: ${$filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ @{$request} ],[ $ima, qw(data) ] ) );

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
   die "opening: ${$filename}.xml: $!\n";

   $fh->print( ${$result} );

   $fh->close();

   ##
   ## .txt
   ##
   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${$filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ ${$result} ],[ $ima ] ) );

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
   die "opening: ${$filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ ${$tree} ],[ $ima ] ) );

   $fh->close();

} ## end sub WWW::YouTube::XML::API::tree_dumper

##
## WWW::YouTube::XML::API::video_dumper
##
sub WWW::YouTube::XML::API::video_dumper
{
   my $tree = shift;

   my $debug = 0; print "video top\n" if ( $debug );

   my %map = (); $map{'id'} = 4;

   my $i = 2;

   my $ima = 'video'; ## dumper

   my $filename = $WWW::YouTube::XML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   my $fh = IO::File->new();

   if ( ${$tree}->[1]->[1] ne 'video_list' )
   {
      printf( "??=%s\n", ${$tree}->[1]->[1] ) if ( $debug );

      print "video not\n" if ( $debug );

      return;

   } ## end if

   print "video mid\n" if ( $debug );

   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${$filename}.txt: $!\n";

   while ( defined( ${$tree}->[1]->[2]->[$i-1] ) )
   {
      if ( ! defined(
                $WWW::YouTube::XML::API::Featured{${$tree}->[1]->[2]->[$i]->[$map{'id'}]->[2]}
                    )
         )
      {
         ##
         ## ! defined = This may not be a Featured Video, so it is questionable
         ##

         $fh->print( Data::Dumper->Dump
              (
                 [ ${$tree}->[1]->[2]->[$i] ],
                 [ sprintf( "%s%04d", ${$tree}->[1]->[2]->[$i-1], $i/2 ) ]
              )    );

      } ## end if

      $i += 2;

   } ## end while

   $fh->close();

   print "video bye\n" if ( $debug );

} ## end sub WWW::YouTube::XML::API::video_dumper

##
## WWW::YouTube::XML::API::ua_central
##
sub WWW::YouTube::XML::API::ua_central
{
   my @request = @_; ## I'm gonna fill in dev_id, etc.

   my @rpc = ();

   my $debug = 0 && $WWW::YouTube::XML::API::flag_ua_dmp; ## follow along for a while

   my $ithink = \'little' if ( $debug ); ## debug needs something to think/link a little about

   ##
   ## Checks
   ##

   if ( ! defined( $WWW::YouTube::XML::API::ua ) )
   {
      $WWW::YouTube::XML::API::ua = Frontier::Client->new
                               (
                                  'url' => $WWW::YouTube::XML::API::url,
                                  'encoding' => 'utf-8',
                                  'debug' =>
                                  ($WWW::YouTube::XML::API::flag_ua_dmp)? 1:undef,
                               );

   } ## end if

   if ( $debug )
   {
      $rpc[ 0 ] = $request[ 0 ]; ## and, off we go.

      $rpc[ 1 ]{'dev_id'} = $WWW::YouTube::XML::API::ua->string( $WWW::YouTube::Com::dev_id );

   } ## end if

   ##debug##   $rpc[ 1 ]{'debug'} = $WWW::YouTube::XML::API::ua->string( ${$ithink} . ' xmlrpc return ' . $debug++ ) if ( $debug );

   print @request . "<-request\n" if ( $debug );

   print( $request[ 0 ] =~ m/^(youtube)[.](users|videos)[.](get|list)[_](.+)$/ ) if ( $debug );

   print "<- request match\n" if ( $debug );

   return ( @rpc ) if ( ( @request != 2 ) || ## wrong size or bogus youtube function
                        ! ( $request[ 0 ] =~ m/^(youtube)[.](users|videos)[.](get|list)[_](.+)$/ )
                      );

   my ( $ido, $iknow, $ineedto, @iam_doing ) = ( $1, $2, $3 . '_' . $4, ($debug)? () : @rpc );

   $ithink = \$iknow if ( $debug ); ## that what @iam_doing = @rpc in $debug, but they are normally empty here

   ##debug##   printf( STDERR "Look at me! I'm specially in need of atterntion: \$ineedto = %s\n", $ineedto ); exit;

   if ( $iknow eq 'users' )
   {
      ## #####################
      ## YouTube API Functions -- Users
      ## #####################

      ##
      ## Check
      ##

      @iam_doing = grep( /^$ineedto$/, (
                                          'get_profile',
                                          'list_favorite_videos',
                                          'list_friends'
                                       )
                       );

      ##debug##      $rpc[ 1 ]{'debug'} = $WWW::YouTube::XML::API::ua->string( ${$ithink} . ' xmlrpc return ' . $debug++ ) if ( $debug );

      return ( @rpc ) if ( @iam_doing != 1 ); ## @iam_doing only one thing at a time, thanks.

      ##
      ## All 3 youtube.users.* API functions need just the 'user' name
      ##

      ##debug##      $rpc[ 1 ]{'debug'} = $WWW::YouTube::XML::API::ua->string( ${$ithink} . ' xmlrpc return ' . $debug++ ) if ( $debug );

      return ( @rpc ) if ( ! defined( $request[ 1 ]{'user'} ) || ## need 'user'
                           ( $request[ 1 ]{'user'} =~ m/^\s*$/ ) ## and not a junked user
                         );

      ##
      ## Do
      ##

      $rpc[ 0 ] = $request[ 0 ]; ## OK, here we go.

      $rpc[ 1 ]{'dev_id'} = $WWW::YouTube::XML::API::ua->string( $WWW::YouTube::Com::dev_id );

      $rpc[ 1 ]{'user'} = $WWW::YouTube::XML::API::ua->string( $request[ 1 ]{'user'} );

      ##debug##      $rpc[ 1 ]{'debug'} = $WWW::YouTube::XML::API::ua->string( ${$ithink} . ' xmlrpc return ' . $debug++ ) if ( $debug );

      return ( @rpc ); ## that's it for YouTube API Functions -- Users

   }
   else
   {
      ## #####################
      ## YouTube API Functions -- Videos
      ## #####################

      ## OK, now I care which $ineedto do, because %iam_special(izing) now with Videos

      my %iam_special =
      (
         'get_details' => 'video_id',
         'list_by_tag' => 'tag', ## page_no, per_page coming soon
         'list_by_user' => 'user',
         'list_featured' => undef,

      );

      @iam_doing = grep( /^$ineedto$/, keys %iam_special ); ## query what @iam_doing because $ineedto

      ##debug##      $rpc[ 1 ]{'debug'} = $WWW::YouTube::XML::API::ua->string( ${$ithink} . ' xmlrpc return ' . $debug++ ) if ( $debug );

      return ( @rpc ) if ( @iam_doing != 1 ); ## @iam_doing only one thing at a time, thanks.

      if ( defined( $iam_special{$iam_doing[ 0 ]} ) )
      {
         my $so_iwant2makesurethat = $iam_special{$iam_doing[ 0 ]}; ## some important encoding here!

         ##debug##         $rpc[ 1 ]{'debug'} = $WWW::YouTube::XML::API::ua->string( ${$ithink} . ' xmlrpc return ' . $debug++ ) if ( $debug );

         return ( @rpc ) if ( ! defined( $request[ 1 ]{$so_iwant2makesurethat} ) || ## this is a must have
                              ( $request[ 1 ]{$so_iwant2makesurethat} =~ m/^\s*$/ ) ## it isn't junk
                            );

         $rpc[ 1 ]{$so_iwant2makesurethat} =
                   $WWW::YouTube::XML::API::ua->string( $request[ 1 ]{$so_iwant2makesurethat} );

         ##
         ## Optionals
         ##
         if ( $iam_doing[ 0 ] eq 'list_by_tag' )
         {
            ## (optional) page: the "page" of results you want to retrieve (e.g. 1, 2, 3)
            ## (optional) per_page: the number of results per page (default 20, maximum 100).

            if ( defined( $request[ 1 ]{'page'} ) &&
                 ( $request[ 1 ]{'page'} =~ m/^[1-9]\d*$/ )
               )
            {
               $rpc[ 1 ]{'page'} =
                         $WWW::YouTube::XML::API::ua->int( $request[ 1 ]{'page'} );

            } ## end if

            if ( defined( $request[ 1 ]{'per_page'} ) &&
                 ( $request[ 1 ]{'per_page'} =~ m/^[1-9]\d*$/ ) &&
                 ( $request[ 1 ]{'per_page'} <= 100 )
               )
            {
               $rpc[ 1 ]{'per_page'} =
                         $WWW::YouTube::XML::API::ua->int( $request[ 1 ]{'per_page'} );

            } ## end if

         } ## end if

      } ## end if

      ##
      ## Got rpc?
      ##

      $rpc[ 0 ] = $request[ 0 ]; ## and, off we go.

      $rpc[ 1 ]{'dev_id'} = $WWW::YouTube::XML::API::ua->string( $WWW::YouTube::Com::dev_id );

      ##debug##      $rpc[ 1 ]{'debug'} = $WWW::YouTube::XML::API::ua->string( ${$ithink} . ' xmlrpc return ' . $debug++ ) if ( $debug );

      return ( @rpc );

   } ## end if

} ## end sub WWW::YouTube::XML::API::ua_central

##
## WWW::YouTube::XML::API::ua_request
##
## returns a $tree not a $result (no need to delete XML tree like an HTML tree)
##
sub WWW::YouTube::XML::API::ua_request
{
   my @request = @_;

   @request = WWW::YouTube::XML::API::ua_central( @request );

   WWW::YouTube::XML::API::request_dumper( \@request ) if ( $WWW::YouTube::XML::API::flag_request_dmp );

   my $result = undef;

   if ( ! ( $result = $WWW::YouTube::XML::API::ua->call( @request ) ) )
   {
      ##debug##printf( STDERR "---- result (##debug##) ----\n%s\n", $result ); ## simulate Frontier::Client debug

   } ## end if

   WWW::YouTube::XML::API::result_dumper( \$result ) if ( $WWW::YouTube::XML::API::flag_result_dmp );

   my $tree = $WWW::YouTube::XML::API::parser->parse( $result, 'ErrorContext' => 3 );

   if ( $tree->[1]->[0]->{'status'} eq 'ok' )
   {
      WWW::YouTube::XML::API::tree_dumper( \$tree ) if ( $WWW::YouTube::XML::API::flag_tree_dmp );

      WWW::YouTube::XML::API::video_dumper( \$tree ) if ( $WWW::YouTube::XML::API::flag_video_dmp );

      ##
      ## HTML
      ##
      ##WWW::YouTube::HTML::video_dumper( \$tree ) if ( $WWW::YouTube::HTML::flag_video_dmp );

   }
   else
   {
      ##debug##printf( STDERR "---- result  ----\n%s\n", $result ); ## simulate Frontier::Client debug

   } ## end if

   return ( $tree, $result );

} ## end sub WWW::YouTube::XML::API::ua_request

##
## NOTE: Getopts hasn't set the options yet. (all flags = 0 right now)
##
## I've deferred the instantiation of this qw(ua) until needed.
## That occurs when creating the xmlrpc request types ( qw(ua->string), etc.).
## I fixed this problem with qw(ua_central) function.
##
$WWW::YouTube::XML::API::ua = undef; ## see NOTE above, goto qw(ua_central) function

$WWW::YouTube::XML::API::parser = XML::Parser->new( 'Style' => 'Tree' );

%WWW::YouTube::XML::API::action = (); ## pointers to general and specific api routines

%WWW::YouTube::XML::API::spec4rpc = (); ## NOTE result specs -- many XML::API::spec4rpc below

%WWW::YouTube::XML::API::used4rpc = (); ## NOTE results used -- many XML::API::used4rpc below

##
## Users API: request 'user'; result keys vary
##            =======         ======
##  XML::API::ugp   qw(user)  qq(user)     <-- See NOTE 2 below.
##  XML::API::ulfv  qw(user)  qw(video_id)
##  XML::API::ulf   qw(user)  qw(user)
##
## NOTE 1: See result specs in XML::API::spec4rpc and XML::API::used4rpc hashes.
##         All the spec4rpc result keys are listed in the XML::API::spec4rpc hash.
##         All the used4rpc result keys are listed in the XML::API::used4rpc hash.
##
##         Why?  Because most of the result params are useless for my purposes.
##               I just want the params that I have actually needed and qw(used4rpc).
##
## NOTE 2: For the XML::API::ugp qw(user) request:
##         $result{$request{'user'}}{$profile_param_tag} = $profile_param_value;
##
##         This works well because the XML::API::ugp is only requesting the profile
##         for the qw(user) specified, and not a multiple listing like others.
##

##
## YouTube API Functions -- Users
##
##    * youtube.users.get_profile
##
##      http://www.youtube.com/dev_api_ref?m=youtube.users.get_profile
##
##    * youtube.users.list_favorite_videos
##
##      http://www.youtube.com/dev_api_ref?m=youtube.users.list_favorite_videos
##
##    * youtube.users.list_friends
##
##      http://www.youtube.com/dev_api_ref?m=youtube.users.list_friends
##
##

my $api = 'any an all of them';

##
$api = 'ugp';
##

eval( '$WWW::YouTube::XML::API::'.$api.'_id = \'youtube.users.get_profile\';' );

eval( '%WWW::YouTube::XML::API::'.$api.' = ();' ); ## result_key='user'

$WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## user_profile
   'first_name' => 2,
   'last_name' => 4,
   'about_me' => 6,
   'age' => 8,
   'video_upload_count' => 10,
   'video_watch_count' => 12,
   'homepage' => 14,
   'hometown' => 16,
   'gender' => 18,
   'occupations' => 20,
   'companies' => 22,
   'city' => 24,
   'country' => 26,
   'books' => 28,
   'hobbies' => 30,
   'movies' => 32,
   'relationship' => 34,
   'friend_count' => 36,
   'favorite_video_count' => 38,
   'currently_on' => 40,

};

$WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## user_profile
#   'first_name' => 2,
#   'last_name' => 4,
#   'about_me' => 6,
   'age' => 8,
#   'video_upload_count' => 10,
#   'video_watch_count' => 12,
#   'homepage' => 14,
#   'hometown' => 16,
   'gender' => 18,
#   'occupations' => 20,
#   'companies' => 22,
#   'city' => 24,
#   'country' => 26,
#   'books' => 28,
#   'hobbies' => 30,
#   'movies' => 32,
#   'relationship' => 34,
   'friend_count' => 36,
   'favorite_video_count' => 38,
#   'currently_on' => 40,

};

$WWW::YouTube::XML::API::action{$api.'_call_check'} = sub
{
   my $request = shift;

   my $iam = 'ugp';

   my $id = 'user';

   return( defined( $request->{$id} ) );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_hash_load'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'ugp'; ##debug##print "${iam}_hash_load\n";

   my $imap = 'map';

   my $id = 'user';

   my $iown = 'spec';

   eval( '%WWW::YouTube::XML::API::'.$iam.' = ();' ); ## clear hash

   my $i = 2;

   my $j = 0;

   if ( defined( $result->{'tree'}->[1]->[$i]->[$j] ) )
   {
      my $j = 2;

      while ( defined ( $result->{'tree'}->[1]->[$i]->[$j-1] ) )
      {
         my $param = $result->{'tree'}->[1]->[$i]->[$j-1];

         my $value = ( defined( $result->{'tree'}->[1]->[$i]->[$j]->[2] ) )?
                                $result->{'tree'}->[1]->[$i]->[$j]->[2] : 'undef';

         $result->{$iown}->{$param} = $j;

         $result->{$imap}->{$param} = $result->{$iown}->{$param};

         eval( '$WWW::YouTube::XML::API::'.$iam.'{$request->{$id}}{$param} = $value;' );

         $j += 2;

      } ## end while

      $i += 2;

   } ## end if

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_load'} = sub
{
   my $request = shift;

   my $iam = 'ugp'; ##debug##print "${iam}_cache_load\n";

   my $id = 'user';

   my $result =
   {
      'ok'   => 0,
      'tree' => undef,
      'map'  => undef,
      'spec' => undef,

   };

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      ##debug##print "${iam}_cache_load call_check ok\n";

      my $id_wrk_dir = '../video/' . $iam . '_cache';

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      return( $result ) if ( ! -f $myxml );

      $myxmldump->dtd(); ## It's in document

      $result->{'tree'} = $myxmldump->xml2pl( $myxml );

      if ( defined( $result->{'tree'} ) )
      {
         ##debug##print "${iam}_cache_load result tree ok\n";

         $result->{'map'}  = $WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$iam.'_id' )};

         $result->{'spec'} = $WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$iam.'_id' )};

         $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

         $result->{'ok'} = 1;

      }
      else
      {
         printf( "something wrong with tree\n" );

      } ## end if

   } ## end if

   return( $result );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_save'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'ugp'; ##debug##print "${iam}_cache_save\n";

   my $id = 'user';

   $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      mkdir ( $id_wrk_dir ) if ( ! -d $id_wrk_dir );

      ##debug##printf( "%s_save\n", $id_wrk_dir );

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      $myxmldump->dtd; ## In document

      $myxmldump->pl2xml( $result->{'tree'}, $myxml );

   } ## end if

   return( defined( $request->{$id} ) );

}; ## end sub

##
$api = 'ulfv';
##

eval( '$WWW::YouTube::XML::API::'.$api.'_id = \'youtube.users.list_favorite_videos\';' );

eval( '%WWW::YouTube::XML::API::'.$api.' = ();' ); ## result_key='video_id'

$WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_details
   'author' => 2,
   'id' => 4, ## In my used4rpc: 'video_id' => 4,
   'title' => 6,
   'rating_avg' => 8,
   'rating_count' => 10,
   'tags' => 12,
   'description' => 14,
   'update_time' => 16,
   'view_count' => 18,
   'upload_time' => 20,
   'length_seconds' => 22,
   'recording_date' => 24,
   'recording_location/' => 26, ## stub?
   'recording_country/' => 28, ## stub?
   'comment_list' => 30, ## 'comment'*
   'channel_list' => 32, ## 'channel'*
   'thumbnail_url' => 34,

};

$WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_details
#   'author' => 2,
   'video_id' => 4, ## In my spec4rpc: 'id' => 4,
   'title' => 6,
#   'rating_avg' => 8,
#   'rating_count' => 10,
   'tags' => 12,
   'description' => 14,
#   'update_time' => 16,
#   'view_count' => 18,
#   'upload_time' => 20,
#   'length_seconds' => 22,
#   'recording_date' => 24,
#   'recording_location/' => 26, ## stub?
#   'recording_country/' => 28, ## stub?
#   'comment_list' => 30, ## 'comment'*
#   'channel_list' => 32, ## 'channel'*
#   'thumbnail_url' => 34,

};

$WWW::YouTube::XML::API::action{$api.'_call_check'} = sub
{
   my $request = shift;

   my $iam = 'ulfv';

   my $id = 'user';

   return( defined( $request->{$id} ) );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_hash_load'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'ulfv';

   my $iown = 'spec';

   my $imap = 'map';

   my $id = 'video_id';

   ##$result->{$iown}->{$id} = $result->{$iown}->{'id'}; ## name change

   eval( '%WWW::YouTube::XML::API::'.$iam.' = ();' );

   my $i = 2;

   while ( defined( $result->{'tree'}->[1]->[2]->[$i] ) )
   {
      my $j = 2;

      my $h = {};

      while ( defined ( $result->{'tree'}->[1]->[2]->[$i]->[$j-1] ) )
      {
         my $param = $result->{'tree'}->[1]->[2]->[$i]->[$j-1];

         my $value = ( defined( $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] ) )?
                                $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] : 'undef';

         $result->{$iown}->{$param} = $j;

         if ( $param eq 'id' )
         {
            if ( defined( $result->{$imap}->{$id} ) )
            {
               $result->{$imap}->{$id} = $result->{$iown}->{$param};

               $h->{$id} = $value;

            } ## end if

         }
         elsif ( $param eq 'url' )
         {
            my $url = 'watch_url';

            $result->{$imap}->{$url} = $result->{$iown}->{$param};

            $h->{$url} = $value;

         }
         else
         {
            $result->{$imap}->{$param} = $result->{$iown}->{$param};

            $h->{$param} = $value;

         } ## end if

         $j += 2;

      } ## end while

      while ( my ( $param, $value ) = each( %{$h} ) )
      {
         $WWW::YouTube::XML::API::ulfv{
            $result->{'tree'}->[1]->[2]->[$i]->[$result->{$imap}->{$id}]->[2]
                                 }{$param} = $value;

      } ## end while


      $i += 2;

   } ## end while

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_load'} = sub
{
   my $request = shift;

   my $iam = 'ulfv';

   my $id = 'user';

   my $result =
   {
      'ok'   => 0,
      'tree' => undef,
      'map'  => undef,
      'spec' => undef,

   };

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      return( $result ) if ( ! -f $myxml );

      ##$myxmldump->dtd; ## It's in document

      $result->{'tree'} = $myxmldump->xml2pl( $myxml );

      if ( defined( $result->{'tree'} ) )
      {
         $result->{'ok'} = 1;

         $result->{'map'}  = $WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$iam.'_id' )};
         $result->{'spec'} = $WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$iam.'_id' )};

         $WWW::YouTube::XML::API::action{$iam.'load_hash'}->( $request, $result );

      } ## end if

   } ## end if

   return( $result );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_save'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'ulfv';

   my $id = 'user';

   $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      mkdir ( $id_wrk_dir ) if ( ! -d $id_wrk_dir );

      ##debug##printf( "%s_save\n", $id_wrk_dir );

      my $id_tag = $request->{$id};

      my $myxmldump = XML::Dumper->new();

      $myxmldump->dtd; ## In document

      $id = 'video_id';

      foreach my $video_id ( keys %{eval( '\%WWW::YouTube::XML::API::'.$iam )} )
      {
         my $id_canon = $video_id; $id_canon =~ s/[-]/_dash_/g;

         my $myxml = "$id_wrk_dir/$id_canon.xml.gz"; ## video

         $myxmldump->pl2xml( $result->{'tree'}, $myxml );

         $id_tag =~ s/[\s]+/_nbsp_/g;

         my $id_tag_dir = "$id_wrk_dir/$id_tag";

         mkdir ( $id_tag_dir ) if ( ! -d $id_tag_dir );

         symlink( "../$id_canon.xml.gz", "$id_tag_dir/$id_canon.xml.gz" ); ## just link tag to the video

      } ## end foreach

   } ## end if

   return( defined( $request->{$id} ) );

}; ## end sub

##
$api = 'ulf'; ## ulf
##

eval( '$WWW::YouTube::XML::API::'.$api.'_id = \'youtube.users.list_friends\';' );

eval( '%WWW::YouTube::XML::API::'.$api.' = ();' ); ## result_key='user'

$WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## friend_list friend
   'user' => 2,
   'video_upload_count' => 4,
   'favorite_count' => 6,
   'friend_count' => 8,

};

$WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## friend_list friend
   'user' => 2,
   'video_upload_count' => 4,
   'favorite_count' => 6,
   'friend_count' => 8,

};

$WWW::YouTube::XML::API::action{$api.'_call_check'} = sub
{
   my $request = shift;

   my $iam = 'ulf';

   my $id = 'user';

   return( defined( $request->{$id} ) );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_hash_load'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'ulf';

   my $imap = 'map';

   my $id = 'user';

   my $iown = 'spec';

   eval( "%WWW::YouTube::XML::API::${iam} = ();" );

   my $i = 2;

   while ( defined( $result->{'tree'}->[1]->[2]->[$i] ) )
   {
      my $j = 2;

      while ( defined ( $result->{'tree'}->[1]->[2]->[$i]->[$j-1] ) )
      {
         my $param = $result->{'tree'}->[1]->[2]->[$i]->[$j-1];

         my $value = ( defined( $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] ) )?
                                $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] : 'undef';

         $result->{$iown}->{$param} = $j;

         $result->{$imap}->{$param} = $result->{$iown}->{$param};

         if ( $param ne $id )
         {
            eval( '$WWW::YouTube::XML::API::'.${iam}.'{
                   $result->{\'tree\'}->[1]->[2]->[$i]->[$result->{$imap}->{$id}]->[2]
                                                 }{$param} = $value;'
                );

         } ## end if

         $j += 2;

      } ## end while

      $i += 2;

   } ## end while

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_load'} = sub
{
   my $request = shift;

   my $iam = 'ulf';

   my $id = 'user';

   my $result =
   {
      'ok'   => 0,
      'tree' => undef,
      'map'  => undef,
      'spec' => undef,

   };

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      return( $result ) if ( ! -f $myxml );

      ##$myxmldump->dtd; ## It's in document

      $result->{'tree'} = $myxmldump->xml2pl( $myxml );

      if ( defined( $result->{'tree'} ) )
      {
         $result->{'ok'} = 1;

         $result->{'map'}  = $WWW::YouTube::XML::API::used4rpc{eval('$WWW::YouTube::XML::API::'.$iam.'_id')};
         $result->{'spec'} = $WWW::YouTube::XML::API::spec4rpc{eval('$WWW::YouTube::XML::API::'.$iam.'_id')};

         $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

      } ## end if

   } ## end if

   return( $result );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_save'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'ulf';

   my $id = 'user';

   $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      mkdir ( $id_wrk_dir ) if ( ! -d $id_wrk_dir );

      ##debug##printf( "%s_save\n", $id_wrk_dir );

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      $myxmldump->dtd; ## In document

      $id = 'user';

      foreach my $friend ( keys %{eval( '\%WWW::YouTube::XML::API::'.$iam )} )
      {
         my $id_canon = $friend; $id_canon =~ s/[-]/_dash_/g;

         my $myxml = "$id_wrk_dir/$id_canon.xml.gz"; ## video

         $myxmldump->pl2xml( $result->{'tree'}, $myxml );

         $id_tag =~ s/[\s]+/_nbsp_/g;

         my $id_tag_dir = "$id_wrk_dir/$id_tag";

         mkdir ( $id_tag_dir ) if ( ! -d $id_tag_dir );

         symlink( "../$id_canon.xml.gz", "$id_tag_dir/$id_canon.xml.gz" ); ## just link tag to the video

      } ## end foreach

   } ## end if

   return( defined( $request->{$id} ) );

}; ## end sub

##
## YouTube API Functions -- Videos
##
##    * youtube.videos.get_details
##
##      http://www.youtube.com/dev_api_ref?m=youtube.videos.get_details
##
##    * youtube.videos.list_by_tag (now with paging)
##
##      http://www.youtube.com/dev_api_ref?m=youtube.videos.list_by_tag
##
##    * youtube.videos.list_by_user
##
##      http://www.youtube.com/dev_api_ref?m=youtube.videos.list_by_user
##
##    * youtube.videos.list_featured
##
##      http://www.youtube.com/dev_api_ref?m=youtube.videos.list_featured
##

##
## Videos API: request keys vary; and, qw(My) result key is always 'video_id'
##             =======                     ======
##   XML::API::vgd  qw(video_id)           qq(video_id) <-- See NOTE 2 below.
##   XML::API::vlbt qw(tag page per_page)  qw(video_id)
##   XML::API::vlbu qw(user)               qw(video_id)
##   XML::API::vlf  qw()                   qw(video_id)
##
## NOTE 1: See result specs in XML::API::spec4rpc and XML::API::used4rpc hashes.
##         All the spec4rpc result keys are listed in the XML::API::spec4rpc hash.
##         All the used4rpc result keys are listed in the XML::API::used4rpc hash.
##
##         Why?  Because most of the result params are useless for my purposes.
##               I just want the params that I have actually needed and qw(used4rpc).
##
## NOTE: For the XML::API::vgd qw(video_id) request:
##       $result{$request{'video_id'}}{$detail_param} = $detail_value;
##
##       This works well because the XML::API::vgd is only requesting the details
##       for the qw(video_id) specified, and not a multiple listing like others.
##

##
$api = 'vgd';
##

eval( '$WWW::YouTube::XML::API::'.$api.'_id = \'youtube.videos.get_details\';' );

eval( '%WWW::YouTube::XML::API::'.$api.' = ();' ); ## result_key='video_id'

$WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_details
   'author' => 2,
   'title' => 4,
   'rating_avg' => 6,
   'rating_count' => 8,
   'tags' => 10,
   'description' => 12,
   'update_time' => 14,
   'view_count' => 16,
   'upload_time' => 18,
   'length_seconds' => 20,
   'recording_date' => 22,
   'recording_location/' => 24, ## a stub? I don't know.
   'recording_country/' => 26, ## a stub? I don't know.
   'comment_list' => 28, ## 'comment'*
   'channel_list' => 30, ## 'channel'*
   'thumbnail_url' => 32,

};

$WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_details
   'author' => 2,
   'title' => 4,
#   'rating_avg' => 6,
#   'rating_count' => 8,
   'tags' => 10,
   'description' => 12,
#   'update_time' => 14,
#   'view_count' => 16,
#   'upload_time' => 18,
   'length_seconds' => 20,
#   'recording_date' => 22,
#   'recording_location/' => 24, ## stub?
#   'recording_country/' => 26, ## stub?
#   'comment_list' => 28, ## 'comment'*
#   'channel_list' => 30, ## 'channel'*
   'thumbnail_url' => 32, ## This is a unique key, but I used $request{'video_id'}.

};

$WWW::YouTube::XML::API::action{$api.'_call_check'} = sub
{
   my $request = shift;

   my $iam = 'vgd';

   my $id = 'video_id';

   return( defined( $request->{$id} ) );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_hash_load'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'vgd';

   my $imap = 'map';

   my $id = 'video_id';

   my $iown = 'spec';

   ##debug##$request->{'video_id'} = 'somevideo_id' if ( ! defined( $request->{'video_id'} ) );
   ##debug##foreach my $x ( sort keys %{$request} ) { printf( "vgd request tag=%s val=%s\n", $x, $request->{$x} ); } ## end foreach

   eval( '%WWW::YouTube::XML::API::'.$iam.' = ();' );

   my $i = 2;

   my $j = 0;

   if ( defined( $result->{'tree'}->[1]->[$i]->[$j] ) )
   {
      my $j = 2;

      while ( defined ( $result->{'tree'}->[1]->[$i]->[$j-1] ) )
      {
         my $param = $result->{'tree'}->[1]->[$i]->[$j-1];

         my $value = ( defined( $result->{'tree'}->[1]->[$i]->[$j]->[2] ) )?
                                $result->{'tree'}->[1]->[$i]->[$j]->[2] : 'undef';

         $result->{$iown}->{$param} = $j;

         $result->{$imap}->{$param} = $result->{$iown}->{$param};

         eval( '$WWW::YouTube::XML::API::'.$iam.'{$request->{$id}}{$param} = $value;' );

         $j += 2;

      } ## end while

      $i += 2;

   } ## end if

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_load'} = sub
{
   my $request = shift;

   my $iam = 'vgd';

   my $id = 'video_id';

   my $result =
   {
      'ok'   => 0,
      'tree' => undef,
      'map'  => undef,
      'spec' => undef,

   };

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      return( $result ) if ( ! -f $myxml );

      ##$myxmldump->dtd; ## It's in document

      $result->{'tree'} = $myxmldump->xml2pl( $myxml );

      if ( defined( $result->{'tree'} ) )
      {
         $result->{'ok'} = 1;

         $result->{'map'}  = eval( '$WWW::YouTube::XML::API::used4rpc{$WWW::YouTube::XML::API::'.$iam.'_id}' );
         $result->{'spec'} = eval( '$WWW::YouTube::XML::API::spec4rpc{$WWW::YouTube::XML::API::'.$iam.'_id}' );

         $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

      }
      else
      {
         printf( "something wrong with tree\n" );

      } ## end if

   } ## end if

   return( $result );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_save'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'vgd';

   my $id = 'video_id';

   ##debug##$request->{'video_id'} = 'somevideo_id' if ( ! defined( $request->{'video_id'} ) );
   ##debug##foreach my $x ( sort keys %{$request} ) { printf( "vgd request tag=%s val=%s\n", $x, $request->{$x} ); } ## end foreach

   $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      mkdir ( $id_wrk_dir ) if ( ! -d $id_wrk_dir );

      ##debug##printf( "%s_save\n", $id_wrk_dir );

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      $myxmldump->dtd; ## In document

      $myxmldump->pl2xml( $result->{'tree'}, $myxml );

   } ## end if

   return( defined( $request->{$id} ) );

}; ## end sub

##
$api = 'vlbt';
##

eval( '$WWW::YouTube::XML::API::'.$api.'_id = \'youtube.videos.list_by_tag\';' );

eval( '%WWW::YouTube::XML::API::'.$api.' = ();' ); ## result_key='video_id'

$WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_list video
   'author' => 2,
   'id' => 4, ## In my used4rpc: 'video_id' => 4,
   'title' => 6,
   'length_seconds' => 8,
   'rating_avg' => 10,
   'rating_count' => 12,
   'description' => 14,
   'view_count' => 16,
   'upload_time' => 18,
   'comment_count' => 20,
   'tags' => 22,
   'url' => 24,
   'thumbnail_url' => 26,

}; ## same as user

$WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_list video
   'author' => 2,
   'video_id' => 4, ## In my spec4rpc: 'id' => 4,
   'title' => 6,
   'length_seconds' => 8,
#   'rating_avg' => 10,
#   'rating_count' => 12,
   'description' => 14,
#   'view_count' => 16,
#   'upload_time' => 18,
#   'comment_count' => 20,
   'tags' => 22,
   'watch_url' => 24,
   'thumbnail_url' => 26,

};

$WWW::YouTube::XML::API::action{$api.'_call_check'} = sub
{
   my $request = shift;

   my $iam = 'vlbt';

   my $id = 'tag';

   return( defined( $request->{$id} ) );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_hash_load'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'vlbt';

   my $imap = 'map';

   my $id = 'video_id';

   my $iown = 'spec';

   eval( '%WWW::YouTube::XML::API::'.$iam.' = ();' );

   my $i = 2;

   while ( defined( $result->{'tree'}->[1]->[2]->[$i] ) )
   {
      my $j = 2;

      my $h = {};

      while ( defined ( $result->{'tree'}->[1]->[2]->[$i]->[$j-1] ) )
      {
         my $param = $result->{'tree'}->[1]->[2]->[$i]->[$j-1];

         my $value = ( defined( $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] ) )?
                                $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] : 'undef';

         $result->{$iown}->{$param} = $j;

         if ( $param eq 'id' )
         {
            if ( defined( $result->{$imap}->{$id} ) )
            {
               $result->{$imap}->{$id} = $result->{$iown}->{$param};

               ##$h->{$id} = $value;

            } ## end if

         }
         elsif ( $param eq 'url' )
         {
            my $url = 'watch_url';

            $result->{$imap}->{$url} = $result->{$iown}->{$param};

            $h->{$url} = $value;

         }
         else
         {
            $result->{$imap}->{$param} = $result->{$iown}->{$param};

            $h->{$param} = $value;

         } ## end if

         $j += 2;

      } ## end while

      while ( my ( $param, $value ) = each( %{$h} ) )
      {
         eval( '$WWW::YouTube::XML::API::'.$iam.'{
                $result->{\'tree\'}->[1]->[2]->[$i]->[$result->{$imap}->{$id}]->[2]
                                            }{$param} = $value;' );

      } ## end while


      $i += 2;

   } ## end while

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_load'} = sub
{
   my $request = shift;

   my $iam = 'vlbt';

   my $id = 'tag';

   my $result =
   {
      'ok'   => 0,
      'tree' => undef,
      'map'  => undef,
      'spec' => undef,

   };

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      return( $result ) if ( ! -f $myxml );

      ##$myxmldump->dtd; ## It's in document

      $result->{'tree'} = $myxmldump->xml2pl( $myxml );

      if ( defined( $result->{'tree'} ) )
      {
         $result->{'ok'} = 1;

         $result->{'map'}  = eval( '$WWW::YouTube::XML::API::used4rpc{$WWW::YouTube::XML::API::'.$iam.'_id}' );
         $result->{'spec'} = eval( '$WWW::YouTube::XML::API::spec4rpc{$WWW::YouTube::XML::API::'.$iam.'_id}' );

         $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

      }
      else
      {
         printf( "something wrong with tree\n" );

      } ## end if

   } ## end if

   return( $result );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_save'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'vlbt';

   my $id = 'tag';

   $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      ##debug##print $FindBin::Bin ."\n";
      ##debug##print Cwd::cwd() ."\n";

      my $id_wrk_dir = '../video/' . $iam . '_cache';

      mkdir ( $id_wrk_dir ) if ( ! -d $id_wrk_dir );

      ##debug##printf( "%s_save\n", $id_wrk_dir );

      my $id_tag = $request->{$id};

      my $myxmldump = XML::Dumper->new();

      $myxmldump->dtd; ## In document

      $id = 'video_id';

      foreach my $video_id ( keys %{eval( '\%WWW::YouTube::XML::API::'.$iam )} )
      {
         my $id_canon = $video_id; $id_canon =~ s/[-]/_dash_/g;

         my $myxml = "$id_wrk_dir/$id_canon.xml.gz"; ## video

         $myxmldump->pl2xml( $result->{'tree'}, $myxml );

         $id_tag =~ s/[\s]+/_nbsp_/g;

         my $id_tag_dir = "$id_wrk_dir/$id_tag";

         if ( ! -d $id_tag_dir )
         {
            mkdir ( $id_tag_dir );

            ##chmod( 0777, $myxml );

         } ## end if

         symlink( "../$id_canon.xml.gz", "$id_tag_dir/$id_canon.xml.gz" ); ## just link tag to the video

      } ## end foreach

   } ## end if

   return( defined( $request->{$id} ) );

   ##
   ## NOTE:
   ##

   ## ut_response <= $tree[0]
   ## @video_list      <= $tree[1]
   ## $video_list[0]->{'status'} <= $video_list_atributes{'status'},
   ## $video_list[1]             <= 'video_list'
   ## $video_list[2]             <= @list_by_tag
   ##

   ##
   ## @video_list   <= $tree[1]
   ## @list_by_tag  <= $video_list[2]
   ## %list_by_tag_attributes <= $list_by_tag[$i-2] qw(that is why for($i=2;;$i+=2))
   ## 'video'                 <= $list_by_tag[$i-1] qw(is this <video> defined?)
   ##

   ##
   ## @video_list  <= $tree[1]
   ## @list_by_tag <= $video_list[2]
   ##
   ## %list_by_tag_attributes <= $list_by_tag[$i-2] qw(that is why for($i=2;;$i+=2))
   ## 'video'                 <= $list_by_tag[$i-1] qw(is this <video> defined?)
   ## @video_by_tag           <= $list_by_tag[$i]   qw(we have a map for this spec)
   ##

   ##
   ## Ok, where's that map, when you need it?
   ##
   ## %video_attributes <= $list_by_tag[$i-2]
   ## 'video'           <= $list_by_tag[$i-1]
   ## @video            <= $list_by_tag[$i]
   ##
   ## %param_attributes <= $video[$n-2]   \
   ## 'param'           <= $video[$n-1]   | check this with XML::API::flag_tree_dmp
   ## $param            <= $video[$n]     /
   ##

}; ## end sub

##
$api = 'vlbu';
##

eval( '$WWW::YouTube::XML::API::'.$api.'_id = \'youtube.videos.list_by_user\';' );

eval( '%WWW::YouTube::XML::API::'.$api.' = ();' ); ## result_key='video_id'

$WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_list video
   'author' => 2,
   'id' => 4, ## In my used4rpc: 'video_id' => 4,
   'title' => 6,
   'length_seconds' => 8,
   'rating_avg' => 10,
   'rating_count' => 12,
   'description' => 14,
   'view_count' => 16,
   'upload_time' => 18,
   'comment_count' => 20,
   'tags' => 22,
   'url' => 24,
   'thumbnail_url' => 26,

};

$WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_list video
   'author' => 2,
   'video_id' => 4, ## In my spec4rpc: 'id' => 4,
   'title' => 6,
   'length_seconds' => 8,
#   'rating_avg' => 10,
#   'rating_count' => 12,
   'description' => 14,
#   'view_count' => 16,
#   'upload_time' => 18,
#   'comment_count' => 20,
   'tags' => 22,
   'watch_url' => 24,
   'thumbnail_url' => 26,

};

$WWW::YouTube::XML::API::action{$api.'_call_check'} = sub
{
   my $request = shift;

   my $iam = 'vlbu';

   my $id = 'user';

   return( defined( $request->{$id} ) );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_hash_load'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'vlbu';

   my $imap = 'map';

   my $id = 'video_id';

   my $iown = 'spec';

   eval( '%WWW::YouTube::XML::API::'.$iam.' = ();' );

   my $i = 2;

   while ( defined( $result->{'tree'}->[1]->[2]->[$i] ) )
   {
      my $j = 2;

      my $h = {};

      while ( defined ( $result->{'tree'}->[1]->[2]->[$i]->[$j-1] ) )
      {
         my $param = $result->{'tree'}->[1]->[2]->[$i]->[$j-1];

         my $value = ( defined( $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] ) )?
                                $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] : 'undef';

         $result->{$iown}->{$param} = $j;

         if ( $param eq 'id' )
         {
            if ( defined( $result->{$imap}->{$id} ) )
            {
               $result->{$imap}->{$id} = $result->{$iown}->{$param};

               $h->{$id} = $value;

            } ## end if

         }
         elsif ( $param eq 'url' )
         {
            my $url = 'watch_url';

            $result->{$imap}->{$url} = $result->{$iown}->{$param};

            $h->{$url} = $value;

         }
         else
         {
            $result->{$imap}->{$param} = $result->{$iown}->{$param};

            $h->{$param} = $value;

         } ## end if

         $j += 2;

      } ## end while

      while ( my ( $param, $value ) = each( %{$h} ) )
      {
         eval( '$WWW::YouTube::XML::API::.'.$iam.'{
                $result->{\'tree\'}->[1]->[2]->[$i]->[$result->{$imap}->{$id}]->[2]
                                            }{$param} = $value;'
             );

      } ## end while


      $i += 2;

   } ## end while

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_load'} = sub
{
   my $request = shift;

   my $iam = 'vlbu';

   my $id = 'user';

   my $result =
   {
      'ok'   => 0,
      'tree' => undef,
      'map'  => undef,
      'spec' => undef,

   };

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      my $id_tag = $request->{$id};

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      return( $result ) if ( ! -f $myxml );

      ##$myxmldump->dtd; ## It's in document

      $result->{'tree'} = $myxmldump->xml2pl( $myxml );

      if ( defined( $result->{'tree'} ) )
      {
         $result->{'ok'} = 1;

         $result->{'map'}  = eval( '$WWW::YouTube::XML::API::used4rpc{$WWW::YouTube::XML::API::'.$iam.'_id}' );
         $result->{'spec'} = eval( '$WWW::YouTube::XML::API::spec4rpc{$WWW::YouTube::XML::API::'.$iam.'_id}' );

         $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

      }
      else
      {
         printf( "something wrong with tree\n" );

      } ## end if

   } ## end if

   return( $result );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_save'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'vlbu';

   my $id = 'user';

   $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      mkdir ( $id_wrk_dir ) if ( ! -d $id_wrk_dir );

      ##debug##printf( "%s_save\n", $id_wrk_dir );

      my $id_tag = $request->{$id};

      my $myxmldump = XML::Dumper->new();

      $myxmldump->dtd; ## In document

      $id = 'video_id';

      foreach my $video_id ( keys %{eval( '\%WWW::YouTube::XML::API::'.$iam )} )
      {
         my $id_canon = $video_id; $id_canon =~ s/[-]/_dash_/g;

         my $myxml = "$id_wrk_dir/$id_canon.xml.gz"; ## video

         $myxmldump->pl2xml( $result->{'tree'}, $myxml );

         $id_tag =~ s/[\s]+/_nbsp_/g;

         my $id_tag_dir = "$id_wrk_dir/$id_tag";

         mkdir ( $id_tag_dir ) if ( ! -d $id_tag_dir );

         symlink( "../$id_canon.xml.gz", "$id_tag_dir/$id_canon.xml.gz" ); ## just link tag to the video

      } ## end foreach

   } ## end if

   return( defined( $request->{$id} ) );

}; ## end sub

##
$api = 'vlf';
##

eval( '$WWW::YouTube::XML::API::'.$api.'_id = \'youtube.videos.list_featured\';' );

eval( '%WWW::YouTube::XML::API::'.$api.' = ();' ); ## result_key='video_id'

$WWW::YouTube::XML::API::spec4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_list video
   'author' => 2,
   'id' => 4, ## In my used4rpc: 'video_id' => 4,
   'title' => 6,
   'length_seconds' => 8,
   'rating_avg' => 10,
   'rating_count' => 12,
   'description' => 14,
   'view_count' => 16,
   'upload_time' => 18,
   'comment_count' => 20,
   'tags' => 22,
   'url' => 24,
   'thumbnail_url' => 26,

};

$WWW::YouTube::XML::API::used4rpc{eval( '$WWW::YouTube::XML::API::'.$api.'_id' )} =
{ ## video_list video
   'author' => 2,
   'video_id' => 4, ## In my spec4rpc: 'id' => 4,
   'title' => 6,
   'length_seconds' => 8,
#   'rating_avg' => 10,
#   'rating_count' => 12,
   'description' => 14,
#   'view_count' => 16,
#   'upload_time' => 18,
#   'comment_count' => 20,
   'tags' => 22,
   'watch_url' => 24,
   'thumbnail_url' => 26,

};

$WWW::YouTube::XML::API::action{$api.'_call_check'} = sub
{
   my $request = shift;

   my $iam = 'vlf';

   my $id = '';

   return( 1 );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_hash_load'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'vlf';

   my $imap = 'map';

   my $id = 'video_id';

   my $iown = 'spec';

   ##$result->{$iown}->{$id} = $result->{$iown}->{'id'}; ## name change

   $result->{$iown}->{'watch_url'} = $result->{$iown}->{'url'}; ## name change

   eval( "%WWW::YouTube::XML::API::$iam = ();" );

   my $i = 2;

   while ( defined( $result->{'tree'}->[1]->[2]->[$i] ) )
   {
      my $j = 2;

      my $h = {};

      while ( defined ( $result->{'tree'}->[1]->[2]->[$i]->[$j-1] ) )
      {
         my $param = $result->{'tree'}->[1]->[2]->[$i]->[$j-1];

         my $value = ( defined( $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] ) )?
                                $result->{'tree'}->[1]->[2]->[$i]->[$j]->[2] : 'undef';

         $result->{$iown}->{$param} = $j;

         if ( $param eq 'id' )
         {
            if ( defined( $result->{$imap}->{$id} ) )
            {
               $result->{$imap}->{$id} = $result->{$iown}->{$param};

               $h->{$id} = $value;

            } ## end if

         }
         elsif ( $param eq 'url' )
         {
            my $url = 'watch_url';

            $result->{$imap}->{$url} = $result->{$iown}->{$param};

            $h->{$url} = $value;

         }
         else
         {
            $result->{$imap}->{$param} = $result->{$iown}->{$param};

            $h->{$param} = $value;

         } ## end if

         $j += 2;

      } ## end while

      while ( my ( $param, $value ) = each( %{$h} ) )
      {
         eval( '$WWW::YouTube::XML::API::'.$iam.'{
                $result->{\'tree\'}->[1]->[2]->[$i]->[$result->{$imap}->{$id}]->[2]
                                            }{$param} = $value;'
             );

      } ## end while

      $i += 2;

   } ## end while

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_load'} = sub
{
   my $request = shift;

   my $iam = 'vlf';

   my $id = Date::Format::time2str( '%Y%m%d%H%M%S', time );

   my $result =
   {
      'ok'   => 0,
      'tree' => undef,
      'map'  => undef,
      'spec' => undef,

   };

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      my $id_tag = ( defined( $request->{$id} ) )? $request->{$id} : $id; ## I DON'T KNOW YET (DIR?DATETIME?)

      my $id_canon = $id_tag; $id_canon =~ s/[-]/_dash_/g;

      my $myxmldump = XML::Dumper->new();

      my $myxml = "$id_wrk_dir/$id_canon.xml.gz";

      return( $result ) if ( ! -f $myxml );

      ##$myxmldump->dtd; ## It's in document

      $result->{'tree'} = $myxmldump->xml2pl( $myxml );

      if ( defined( $result->{'tree'} ) )
      {
         $result->{'ok'} = 1;

         $result->{'map'}  = eval( '$WWW::YouTube::XML::API::used4rpc{$WWW::YouTube::XML::API::'.$iam.'_id}' );
         $result->{'spec'} = eval( '$WWW::YouTube::XML::API::spec4rpc{$WWW::YouTube::XML::API::'.$iam.'_id}' );

         $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

      }
      else
      {
         printf( "something wrong with tree\n" );

      } ## end if

   } ## end if

   return( $result );

}; ## end sub

$WWW::YouTube::XML::API::action{$api.'_cache_save'} = sub
{
   my ( $request, $result ) = @_;

   my $iam = 'vlf';

   my $imap = 'map';

   my $id = 'video_id';

   $WWW::YouTube::XML::API::action{$iam.'_hash_load'}->( $request, $result );

   if ( $WWW::YouTube::XML::API::action{$iam.'_call_check'}->( $request ) )
   {
      my $id_wrk_dir = '../video/' . $iam . '_cache';

      mkdir ( $id_wrk_dir ) if ( ! -d $id_wrk_dir );

      ##debug##printf( "%s_save\n", $id_wrk_dir );

      my $id_tag = Date::Format::time2str( '%Y%m%d%H%M%S', time );

      my $myxmldump = XML::Dumper->new();

      $myxmldump->dtd; ## In document

      my $i = 2;

      while ( defined( $result->{'tree'}->[1]->[2]->[$i] ) )
      {
         my $video_tree = $result->{'tree'}->[1]->[2]->[$i];

         my $video_id = $video_tree->[$result->{$imap}->{$id}]->[2];

         my $id_canon = $video_id; $id_canon =~ s/[-]/_dash_/g;

         my $myxml = "$id_wrk_dir/$id_canon.xml.gz"; ## video

         $myxmldump->pl2xml( $video_tree, $myxml );

         $id_tag =~ s/[\s]+/_nbsp_/g;

         my $id_tag_dir = "$id_wrk_dir/$id_tag";

         mkdir ( $id_tag_dir ) if ( ! -d $id_tag_dir );

         symlink( "../$id_canon.xml.gz", "$id_tag_dir/$id_canon.xml.gz" ); ## just link tag to the video

         $i += 2;

      } ## end while

   } ## end if

   return( defined( $request->{$id} ) );

}; ## end sub

undef( $api ); ## I served my many purposes

##
## %WWW::YouTube::XML::API::action ## generation of API actions
##
foreach $api qw(ugp ulfv ulf vgd vlbt vlbu vlf )
{
   $WWW::YouTube::XML::API::action{$api.'_call'} = sub
   {
      my $request = shift;

      my $iam_doing = eval( '$WWW::YouTube::XML::API::'.$api.'_id' );

      ##debug##printf( "Executing \$WWW::YouTube::XML::API::action\{'${api}_call'\} caller=%s\n", join( ':', caller() ) );

      my $result =
      {
         'ok'   => 0,
         'xml'  => '',
         'tree' => [],
         'map'  => $WWW::YouTube::XML::API::used4rpc{$iam_doing},
         'spec' => $WWW::YouTube::XML::API::spec4rpc{$iam_doing},

      };

      ## I'm doing primary checking here

      if ( ! defined( $request ) )
      {
         $request = {};
      }
      else
      {
         $request = $request->{'request'} if ( defined( $request->{'request'} ) );

      } ## end if

      if ( $WWW::YouTube::XML::API::action{$api.'_call_check'}->( $request ) )
      {
         ##debug##printf( "[2]Passed \$WWW::YouTube::XML::API::action\{'${api}_call_check'\}\n" );

         ( $result->{'tree'},
           $result->{'xml'} ) = WWW::YouTube::XML::API::ua_request( $iam_doing, $request );

      } ## end if

      if ( $result->{'tree'}->[1]->[0]->{'status'} eq 'ok' )
      {
         $result->{'ok'}++;

         $WWW::YouTube::XML::API::action{$api.'_cache_save'}->( $request, $result );

         delete( $result->{'spec'} ); ## tainted info

      }
      else
      {
         printf( STDERR 'Failed $WWW::YouTube::XML::API::action{'.$api.'_call}'."\n" );

      } ## end if

      return ( $result );

   }; ## end sub

   $WWW::YouTube::XML::API::action{$api} = sub
   {
      my $request = shift;

      $request = $request->{'request'} if ( defined( $request->{'request'} ) );

      ##debug##printf( "Executing \$WWW::YouTube::XML::API::action\{'${api}'\} caller=%s\n", join( ':', caller() ) );

      ## Leave all checking to the real worker

      my $result = $WWW::YouTube::XML::API::action{$api.'_call'}->( $request );

      my $api_hash = { 'ok' => 0 };

      if ( $result->{'ok'} )
      {
         eval( '$WWW::YouTube::XML::API::'.$api.'{\'ok\'} = 1; '.
               '$api_hash = \\%WWW::YouTube::XML::API::'.$api.';'
             );

      } ## end if

      return ( $api_hash );

   }; ## end sub

   $WWW::YouTube::XML::API::action{$api.'_show_hash'} = sub
   {
      my $mycmd = '
      my $h = shift;

      if ( ! defined( $h->{\'filehand\'} ) )
      {
         $h->{\'filehand\'} = \*STDOUT;

      } ##end if

      ##
      ## show hash
      ##
      foreach my $x ( sort keys %WWW::YouTube::XML::API::'.$api.' )
      {
         foreach my $y ( sort keys %{$WWW::YouTube::XML::API::'.$api.'{$x}} )
         {
            ##debug##print( "not defined x=$x\n" ) if ( ! defined( $x ) );

            ##debug##print( "not defined y=$y\n" ) if ( ! defined( $y ) );

            ##debug##print( "not defined api=$WWW::YouTube::XML::API::'.$api.'{$x}{$y}\n" ) if ( ! defined( $WWW::YouTube::XML::API::'.$api.'{$x}{$y} ) );

            $h->{\'filehand\'}->printf( "'.$api.'{%s}{%s}=%s\n",
                                        $x,
                                        $y,
                                        $WWW::YouTube::XML::API::'.$api.'{$x}{$y}
                                      );

         } ## end foreach

      } ## end foreach

      ';

      ##debug## print $mycmd;

      eval $mycmd;

   }; ## end sub

   $WWW::YouTube::XML::API::action{$api.'_show'} = sub
   {
      my $h = shift;

      my $result =
      {
         'ok' => 0,
         'tree' => [],
         'map'  => {},

      };

      ##debug##printf( "Executing \$WWW::YouTube::XML::API::action::\{'${api}_show'\} caller=%s\n", join( ':', caller() ) );

      ## Leave all checking to the real worker

      $result = $WWW::YouTube::XML::API::action{$api.'_call'}->( $h->{'request'} );

      if ( $result->{'ok'} )
      {
         ##debug## printf( "Calling \$WWW::YouTube::XML::API::action\{'${api}_show_hash'\}\n" );

      } ## end if

      $WWW::YouTube::XML::API::action{$api.'_show_hash'}->( $h );

      return ( $result );

   }; ## end sub

   $WWW::YouTube::XML::API::action{$api.'_cache'} = sub
   {
      my $request = shift;

      my $result =
      {
         'ok' => 0,
         'tree' => [],
         'map'  => {},

      };

      ##debug##printf( "Executing \$WWW::YouTube::XML::API::action::\{'${api}_show_cache'\} caller=%s\n", join( ':', caller() ) );

      ## Leave all checking to the real worker

      $request = $request->{'request'} if ( defined( $request->{'request'} ) );

      $result = $WWW::YouTube::XML::API::action{$api.'_cache_load'}->( $request );

      if ( ! $result->{'ok'} )
      {
         ##debug##
         printf( 'Calling $WWW::YouTube::XML::API::action{'.$api.'_call}'."\n" );

         $result = $WWW::YouTube::XML::API::action{$api.'_call'}->( $request );

      } ## end if

      return ( $result );

   }; ## end sub

   $WWW::YouTube::XML::API::action{$api.'_show_cache'} = sub
   {
      my $h = shift;

      my $result =
      {
         'ok' => 0,
         'tree' => [],
         'map'  => {},

      };

      ##debug##printf( "Executing \$WWW::YouTube::XML::API::action::\{'${api}_show_cache'\} caller=%s\n", join( ':', caller() ) );

      ## Leave all checking to the real worker

      $result = $WWW::YouTube::XML::API::action{$api.'_cache'}->( $h->{'request'} );

      if ( $result->{'ok'} )
      {
         ##debug## printf( "Calling \$WWW::YouTube::XML::API::action\{'${api}_show_hash'\}\n" );

      } ## end if

      $WWW::YouTube::XML::API::action{$api.'_show_hash'}->( $h );

      return ( $result );

   }; ## end sub

} ## end foreach

undef( $api ); ## I served my many purposes, again

##
## WWW::YouTube::XML::API::demo
##
sub WWW::YouTube::XML::API::demo
{
   my $request = shift || { 'request' => { 'user' => $WWW::YouTube::Com::user } };

   $request = $request->{'request'} if ( defined( $request->{'request'} ) );

   my $iam_doing = '';

   my $result =
   {
     'ok'   => 0,
     'tree' => [],
     'map'  => {},
     'xml'  => '',

   };

   ##
   ## Users
   ##

   ##
   $iam_doing = 'ugp_cache'; ## demo now
   ##

   print __PACKAGE__ . "::action{$iam_doing}:\n";

   $result = ${WWW::YouTube::XML::API::action{$iam_doing}}->( { 'request' => $request } );

   print __PACKAGE__ . "::action{$iam_doing} error\n" if ( ! $result->{'ok'} );

   $request->{'user'} = 'EEntertainmentTV'; ## Found a user who's got favorites, until I do,
                                            ## and I don't have any friends yet either.
                                            ## That's OK, I'm still a special person!

   ##
   $iam_doing = 'ulfv_cache'; ## demo now
   ##

   print __PACKAGE__ . "::action{$iam_doing}:\n";

   $result = $WWW::YouTube::XML::API::action{$iam_doing}->( { 'request' => $request } );

   print __PACKAGE__ . "::action{$iam_doing} error\n" if ( ! $result->{'ok'} );

   ##
   $iam_doing = 'ulf_cache'; ## demo now
   ##

   print __PACKAGE__ . "::action{$iam_doing}:\n";

   $result = $WWW::YouTube::XML::API::action{$iam_doing}->( { 'request' => $request } );

   print __PACKAGE__ . "::action{$iam_doing} error\n" if ( ! $result->{'ok'} );

   ##
   ## Videos
   ##

   ##
   $iam_doing = 'vlf_call'; ## demo now
   ##

   print __PACKAGE__ . "::action{$iam_doing}:\n";

   $result = $WWW::YouTube::XML::API::action{$iam_doing}->(); ## need a video_id to vgd

   print __PACKAGE__ . "::action{$iam_doing} error\n" if ( ! $result->{'ok'} );

   ##
   $iam_doing = 'vgd_cache'; ## demo now
   ##

   print __PACKAGE__ . "::action{$iam_doing}:\n";

   my $hal = $WWW::YouTube::XML::API::action{'vlf_cache'}();

   my $val = $hal->{'tree'}->[1]->[2]->[2]->[$hal->{'map'}->{'video_id'}]->[2];

   ##debug## printf( "%s\n", $val );

   $result = $WWW::YouTube::XML::API::action{$iam_doing}->(
                                              { 'request' => { 'video_id' => $val } }
                                                          );

   print __PACKAGE__ . "::action{$iam_doing} error\n" if ( ! $result->{'ok'} );

   ##
   $iam_doing = 'vlbt_cache'; ## demo now
   ##

   print __PACKAGE__ . "::action{$iam_doing}:\n";

   $result = $WWW::YouTube::XML::API::action{$iam_doing}->(
      { 'request' => { 'tag' => $request->{'user'},
                       'page' => 1,
                       'per_page' => 25
                     },
      }                                              );

   print __PACKAGE__ . "::action{$iam_doing} error\n" if ( ! $result->{'ok'} );

   ##
   $iam_doing = 'vlbu_cache'; ## demo now
   ##

   print __PACKAGE__ . "::action{$iam_doing}:\n";

   $result = $WWW::YouTube::XML::API::action{$iam_doing}->( { 'request' => $request } );

   print __PACKAGE__ . "::action{$iam_doing} error\n" if ( ! $result->{'ok'} );

   ##
   $iam_doing = 'vlf_cache'; ## demo now
   ##

   print __PACKAGE__ . "::action{$iam_doing}:\n";

   $WWW::YouTube::XML::API::action{$iam_doing}->();


} ## end sub WWW::YouTube::XML::API::demo

1;
__END__ ## package WWW::YouTube::XML::API

=head1 NAME

WWW::YouTube::XML::API - How to Interface with YouTube using HTTP Protocol and XMLRPC API.

=head1 SYNOPSIS

 Options;

   TBD

=head1 OPTIONS

TBD

=head1 DESCRIPTION

XML::API stands for XML Application Programming Interface

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML::API>> I<L<WWW::YouTube::HTML::API>> I<L<WWW::YouTube::XML>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut

