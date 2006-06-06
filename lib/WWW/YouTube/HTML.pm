## package WWW::YouTube::HTML
##
package WWW::YouTube::HTML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2006.0606 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::HTML::ISA = qw(Exporter);

   @WWW::YouTube::HTML::EXPORT = qw(); ## export required

   @WWW::YouTube::HTML::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require WWW::YouTube::HTML::API;

#require File::Spec::Unix;

require File::Basename;

##require DBI; require XML::Dumper; ##require SQL::Statement;

require Date::Format;

require Text::Wrap;

%WWW::YouTube::HTML::opts =
(
   ##
   ## vlbt_opts
   ##

);

__PACKAGE__ =~ m/^(WWW::[^:]+)((::([^:]+)){1}(::([^:]+)){0,1}){0,1}$/g;

##debug##print( "HTML! $1::$4::$6\n" );

%WWW::YouTube::HTML::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $4,
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::YouTube::HTML::opts,
   'opts_filename'  => {},
   'export_ok'      => [],
   'urls' =>
   {
      ##
      ## vlbt_opts
      ##

   },
   'opts_type_flag' =>
   [
      ##
      ## vlbt_opts
      ##
      'auto_play',
      'disarm',
      'thumbnail',

   ],
   'opts_type_numeric' =>
   [
      ##
      ## vlbt_opts
      ##
      'columns',
      'rows',

   ],
   'opts_type_string' =>
   [
      ##
      ## vlbt_opts
      ##
      'body_bgcolor',
      'watch_size',
      'watch_size_window',

   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::YouTube::HTML::opts_type_args{'ido'},
                                $WWW::YouTube::HTML::opts_type_args{'iknow'},
                                #$WWW::YouTube::HTML::opts_type_args{'iman'}
                        )
                      );

WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::HTML::opts_type_args );

##
## vlbt_opts
##
$WWW::YouTube::HTML::flag_auto_play = 0; ## auto_play videos
$WWW::YouTube::HTML::flag_disarm = 0; ## are kids to view?
$WWW::YouTube::HTML::flag_thumbnail = 0; ## quick loading of thumbnail rather than video

$WWW::YouTube::HTML::string_body_bgcolor = 'Black';

$WWW::YouTube::HTML::numeric_rows = 2; ## rows in table
$WWW::YouTube::HTML::numeric_columns = 5; ## columns in table

$WWW::YouTube::HTML::string_watch_size = 'unconstrained'; ## object size

$WWW::YouTube::HTML::string_watch_size_window = 'large_window'; ## window size

##debug##WWW::YouTube::ML::API::show_all_opts( \%WWW::YouTube::HTML::opts_type_args );

WWW::YouTube::HTML::register_all_opts( \%WWW::YouTube::HTML::API::opts_type_args );

##debug##WWW::YouTube::HTML::show_all_opts( \%WWW::YouTube::HTML::opts_type_args );

push( @WWW::YouTube::HTML::EXPORT_OK,
      @{$WWW::YouTube::HTML::opts_type_args{'export_ok'}} );

END {

} ## end END

##
## WWW::YouTube::HTML::register_all_opts
##
sub WWW::YouTube::HTML::register_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::HTML::API::opts_type_args;

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      $WWW::YouTube::HTML::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      $WWW::YouTube::HTML::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::YouTube::HTML::register_all_opts

##
## WWW::YouTube::HTML::show_all_opts
##
sub WWW::YouTube::HTML::show_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::HTML::opts_type_args;

   WWW::YouTube::ML::API::show_all_opts( $opts_type_args );

} ## end sub WWW::YouTube::HTML::show_all_opts

##
## WWW::YouTube::HTML::mirror_this_please
##
sub WWW::YouTube::HTML::mirror_this_please
{
   my $share_amongst_us = shift;

   ##debug##   print STDERR "mirror_this_please\n";

   die "lock exists\n" if ( -e $share_amongst_us->{'our_lock'} );

   mkdir $share_amongst_us->{'our_dir'} if ( ! -e $share_amongst_us->{'our_dir'} );

   my $fh_lock = IO::File->new( "+>$share_amongst_us->{'our_lock'}" ) ||
   die "opening: $share_amongst_us->{'our_lock'} : $!\n";

   $fh_lock->close(); ## unlink some other time, somewhere else far-far away

   foreach my $uri ( sort keys %{$share_amongst_us->{'our_mirrors'}} )
   {
      my $localfile = $share_amongst_us->{'our_mirrors'}{$uri};

      ##debug##      print STDERR "mirroring to $localfile\n";

      $WWW::YouTube::HTML::API::ua->mirror( $uri, $localfile );

   } ## end while

} ## end sub WWW::YouTube::HTML::mirror_this_please

##
## WWW::YouTube::HTML::mirror_most_recent
##
sub WWW::YouTube::HTML::mirror_most_recent
{
   my $h = shift;

   ##debug##   print STDERR "mirror_most_recent\n";

   my $we_dont_blow_up_occasionally = 0;

   my $share_amongst_us = {};

   $share_amongst_us->{'our_dir'} =
            File::Basename::dirname( $FindBin::Bin ).'/mr_mirror/mr';

   $share_amongst_us->{'our_lock'} = $share_amongst_us->{'our_dir'}.'/.lock';

   $share_amongst_us->{'our_first'} = 1; ## 1

   $share_amongst_us->{'our_last'}  = 15; ## 15

   $share_amongst_us->{'our_mirrors'} = {};

   for ( my $i = $share_amongst_us->{'our_first'};
            $i <= $share_amongst_us->{'our_last'}; $i++ )
   {
      $share_amongst_us->{'our_mirrors'}{
                $WWW::YouTube::HTML::API::url.'/browse?s=mr&f=b&page='.$i.'&t=t'
                                        } =
                         sprintf( $share_amongst_us->{'our_dir'}."/%02d.html", $i );

   } ## end for

   while ( $we_dont_blow_up_occasionally )
   {
      sleep 600 if ( -e $share_amongst_us->{'our_lock'} );

   } ## end while

   if ( ! -e $share_amongst_us->{'our_dir'} )
   {
         WWW::YouTube::HTML::mirror_this_please( $share_amongst_us )

   } ## end if

   if ( defined( $h->{'share_with_parse'} ) )
   {
      return( $share_amongst_us );

   } ## end if

} ##end sub WWW::YouTube::HTML::mirror_most_recent

##
## WWW::YouTube::HTML::parse_mirror_most_recent
##
sub WWW::YouTube::HTML::parse_mirror_most_recent
{
   my $h = shift;

   ##debug##
   print STDERR "parse_mirror_most_recent\n";

   my $we_dont_blow_up_occasionally = 0;

   my $debug = ! $we_dont_blow_up_occasionally;

   my $given_more_work_to_do = defined( $h->{'my_recursion'} );

   my $found_more_work = 0;

   my $share_amongst_us = {};

   if ( ! $given_more_work_to_do )
   {
      $share_amongst_us = WWW::YouTube::HTML::mirror_most_recent( { 'share_with_parse' => 1 } );

   }
   else
   {
      $share_amongst_us = $h->{'my_recursion'};

   } ## end if

   my $mydir = File::Basename::dirname(
               File::Basename::dirname( $share_amongst_us->{'our_dir'} )
                                      ) . '/video';

   ##debug##print "$mydir\n"; sleep 30;

   my $mywrkdir = "$mydir/mr";

   my $fh_mylock = IO::File->new();

   my $mylock = "$mywrkdir/.lock";

   if ( -e $mywrkdir && ! -e $mylock && ! $given_more_work_to_do )
   {
      $found_more_work++;

      WWW::YouTube::HTML::parse_mirror_most_recent( { 'my_recursion' => $share_amongst_us }
                                             );

   }
   else
   {
      while ( $we_dont_blow_up_occasionally )
      {
         last if ( ! -e $mywrkdir );

         sleep 30;

      } ## end while

   } ## end if

   if ( ! $given_more_work_to_do ) ## by parser #1, then im parser #1
   {
      unlink( $share_amongst_us->{'our_lock'} );

      exit if ( -e $share_amongst_us->{'our_lock'}.'_no_parse' );

      rename( $share_amongst_us->{'our_dir'}, $mywrkdir ) ||
      die __PACKAGE__."renaming mr: $!\n";

   } ## end if

   $fh_mylock->open( "+>$mylock" ) ||
   die __PACKAGE__." opening: $mylock : $!\n";

   $fh_mylock->close(); ## unlinked toward the end

   ##
   ## MLDB_user
   ##

   my $MLDB_user = DBI->connect('DBI:DBM(RaiseError=1):mldbm="XML::Dumper":' );

   $MLDB_user->{'f_dir'} = $WWW::YouTube::ML::API::string_dbm_dir;

   my $MLDB_user_sql = '';

   if ( ! -f $WWW::YouTube::ML::API::string_dbm_dir.'/user.pag' )
   {
      my $MLDB_user_sql =
      'CREATE TABLE user '.
      '('.
         'user_id TEXT,'.
         'type TEXT,'.
         'first_name TEXT,'.
         'last_name TEXT,'.
         'about_me TEXT,'.
         'age TEXT,'.
         'video_upload_count TEXT,'.
         'video_watch_count TEXT,'.
         'homepage TEXT,'.
         'hometown TEXT,'.
         'gender TEXT,'.
         'occupations TEXT,'.
         'companies TEXT,'.
         'city TEXT,'.
         'country TEXT,'.
         'books TEXT,'.
         'hobbies TEXT,'.
         'movies TEXT,'.
         'relationship TEXT,'.
         'friend_count TEXT,'.
         'favorite_video_count TEXT,'.
         'currently_on TEXT,'.
      ')' .";\n";

      foreach my $sqln ( split( /;*\n+/, $MLDB_user_sql ) )
      {
         print $sqln ."\n";

         my $stln = $MLDB_user->prepare( $sqln );

         $stln->execute();

         $stln->dump_results() if $stln->{'NUM_OF_FIELDS'};

      } ## end foreach

   } ## end if

   #   $MLDB_user_sql =
   #      'CREATE TABLE user ( user_id TEXT, type TEXT )' .";\n"
   #      'INSERT INTO user VALUES (\'fbloggs\',\'trouble\')' .";\n".
   #      'INSERT INTO user VALUES (\'spatel\',\'unknown\')' .";\n".
   #      'INSERT INTO user VALUES (\'ermeyers\',\'cleared\')' .";\n".
   #      'DELETE FROM user WHERE user_id = \'ermeyers\'' .";\n".
   #      'UPDATE user SET type = \'trouble\' WHERE user_id = \'spatel\'' .";\n".
   #      'SELECT * FROM user' .";\n";

   ##
   ## MLDB_video
   ##

   my $MLDB_video = DBI->connect('DBI:DBM(RaiseError=1)mldbm="XML::Dumper":' );

my %MLDB_video_hash = ();
   $MLDB_video->{'f_dir'} = $WWW::YouTube::ML::API::string_dbm_dir;

   my $MLDB_video_sql = '';

   if ( ! -f $WWW::YouTube::ML::API::string_dbm_dir.'/video.pag' )
   {
      my $MLDB_video_sql = ##debug##'DROP TABLE video'. ";\n".
         'CREATE TABLE video '.
         '('.
            'status TEXT,'.
            'author TEXT,'.
            'video_id TEXT,'.
            'title TEXT,'.
            'rating_avg TEXT,'.
            'rating_count TEXT,'.
            'tags TEXT,'.
            'description TEXT,'.
            'update_time TEXT,'.
            'view_count TEXT,'.
            'upload_time TEXT,'.
            'length_seconds TEXT,'.
            'recording_date TEXT,'.
            'recording_location/ TEXT,'. ## stub?
            'recording_country/ TEXT,'. ## stub?
            'comment_count TEXT,'.
            'comment_list TEXT,'. ## 'comment'*
            'channel_list TEXT,'. ## 'channel'*
            'thumbnail_url TEXT,'.
            'watch_url TEXT,'.
         ')' .";\n";

      foreach my $sqln ( split( /;*\n+/, $MLDB_video_sql ) )
      {
         ##debug##print $sqln ."\n";

         my $stln = $MLDB_video->prepare( $sqln );

         $stln->execute();

         ##debug##$stln->dump_results() if $stln->{'NUM_OF_FIELDS'};

      } ## end foreach

   } ## end if

   #   $MLDB_video_sql =
   #      'CREATE TABLE video ( video_id TEXT, type TEXT )' .";\n"
   #      'INSERT INTO video VALUES (\'fbloggs\',\'trouble\')' .";\n".
   #      'INSERT INTO video VALUES (\'spatel\',\'unknown\')' .";\n".
   #      'INSERT INTO video VALUES (\'ermeyers\',\'cleared\')' .";\n".
   #      'DELETE FROM video WHERE video_id = \'ermeyers\'' .";\n".
   #      'UPDATE video SET type = \'trouble\' WHERE video_id = \'spatel\'' .";\n".
   #      'SELECT * FROM video' .";\n";

   ##
   ## Files
   ##
   my $fh_myhtml = IO::File->new(); my $myhtml = ''; ## local .html file

   my $fh_mydump = IO::File->new(); my $mydump = ''; ## each .html has a .txt dump of tree

   my $fh_myindx = IO::File->new(); my $myindx = "$mywrkdir/index.html";

   ## Optional Request Methods:
   ##   $request = HTTP::Request->new( 'GET' => $WWW::YouTube::HTML::API::url );
   ##   $request = HTTP::Request->new( 'POST' => $WWW::YouTube::HTML::API::url );
   ##   $request = HTTP::Request::Common::POST( $uri, \%form );

   my $html_request = HTTP::Request->new(); $html_request->method( 'GET' );

   my $html_result = undef;

   my $html_tree = undef;

   my $html_elem_class = undef;

   my $html_elem_href = undef;

   my $html_elem_src = undef;

   my $myxmldump = XML::Dumper->new();

   my $myxml = "$mywrkdir/video_list.xml.gz";

   my %video_list = ();

   my $video_id = '';

   my $i = 0;

   $fh_myindx->open( $myindx, '+>:encoding(utf8)' ) ||
   die "opening: $myindx : $!\n";

   foreach $myhtml ( sort values( %{$share_amongst_us->{'our_mirrors'}} ) )
   {
      $html_tree = HTML::TreeBuilder->new(); ## must do this, then delete below

      ##debug##printf( "%s => ? ##tree %s\n", $myhtml, ( defined( $html_tree ) )? 'exists':'problem' );
      ##debug## $html_tree->delete(); next;

      ##debug##      print( STDERR "opening $myhtml\n" );

      $myhtml = $mywrkdir.'/'.File::Basename::basename( $myhtml );

      ##debug##      print STDERR "$myhtml\n";

      $fh_myhtml->open( $myhtml, '<:encoding(utf8)' ) ||
      die( "opening: $myhtml: $!\n" );

      $html_tree->parse_file( $fh_myhtml );

      $fh_myhtml->close();

      $html_tree->elementify();

      foreach $html_elem_class ( $html_tree->look_down( 'class', 'moduleFeaturedThumb' ) )
      {
         ## thumbnail_url:
         foreach $html_elem_src ( $html_elem_class->look_down( 'src', qr/^http:/ ) )
         {
            $html_elem_src->attr( 'src' ) =~ m@/vi/([^/]+)/2[.]jpg$@;

            $video_id = $1;

            $video_list{$video_id} = {};

            $video_list{$video_id}{'thumbnail_url'} = $html_elem_src->attr( 'src' );

            ##
            ## record video in MLDB_video
            ##

            $MLDB_video_sql =
            'INSERT INTO video video_id VALUES \''.$video_id.'\' )';

            foreach my $sqln ( split( /;*\n+/, $MLDB_video_sql ) )
            {
               ##debug##print $sqln ."\n";

               my $stln = $MLDB_video->prepare( $sqln );

               $stln->execute();

               ##debug##$stln->dump_results() if $stln->{'NUM_OF_FIELDS'};

            } ## end foreach

         } ## end foreach

      } ## end foreach

      foreach $html_elem_class ( $html_tree->look_down( 'class', 'moduleFeaturedTitle' ) )
      {
         ## watch_url and title for video:
         foreach $html_elem_href ( $html_elem_class->look_down( 'href', qr/^http:/ ) )
         {
            $html_elem_href->attr( 'href' ) =~ m@[?]v[=]([^&]+)[&]@;

            $video_id = $1;

            $video_list{$video_id} = {};

            $video_list{$video_id}{'watch_url'} = $html_elem_href->attr( 'href' );

            $video_list{$video_id}{'title'} = $html_elem_href->address( '.0' );

            ##
            ## record video in MLDB_video
            ##

            $MLDB_video_sql =
            'UPDATE video SET watch_url = \''.$html_elem_href->attr( 'href' ).'\''.
            ' WHERE video_id = \''.$video_id.'\'' .";\n".
            'UPDATE video SET title = \''.$html_elem_href->address( '.0' ).'\''.
            ' WHERE video_id = \''.$video_id.'\'' .";\n";

            foreach my $sqln ( split( /;*\n+/, $MLDB_video_sql ) )
            {
               ##debug##print $sqln ."\n";

               my $stln = $MLDB_video->prepare( $sqln );

               $stln->execute();

               ##debug##$stln->dump_results() if $stln->{'NUM_OF_FIELDS'};

            } ## end foreach

            ##debug## printf( "%s\n", $video_id );

         } ## end foreach

      } ## end foreach

      foreach $html_elem_class ( $html_tree->look_down( 'class', 'moduleFeaturedDetails' ) )
      {
         foreach $html_elem_href ( $html_elem_class->look_down( 'href', qr@^/profile@ ) )
         {
            ##
            ## record user in MLDB_user
            ##

            $MLDB_user_sql =
               'INSERT INTO user user_id VALUES \''.$html_elem_href->address('.0').'\''.";\n";

            foreach my $sqln ( split( /;*\n+/, $MLDB_user_sql ) )
            {
               ##debug##print $sqln ."\n";

               my $stln = $MLDB_user->prepare( $sqln );

               $stln->execute();

               ##debug##$stln->dump_results() if $stln->{'NUM_OF_FIELDS'};

            } ## end foreach

         } ## end foreach

      } ## end foreach

      $html_tree = $html_tree->delete(); ## done with that parse

      ##debug## last;

   } ## end while

#=cut ## debug
   ##
   ## MLDB_user
   ##
   $MLDB_user_sql = 'SELECT * FROM user' .";\n";

   foreach my $sqln ( split( /;*\n+/, $MLDB_user_sql ) )
   {
      print $sqln ."\n";

      my $stln = $MLDB_user->prepare( $sqln );

      $stln->execute();

      ##$stln->dump_results() if $stln->{'NUM_OF_FIELDS'};

   } ## end foreach
#=cut

#=cut ## debug
   ##
   ## MLDB_video
   ##
   $MLDB_video_sql ='SELECT * FROM video' .";\n";

   foreach my $sqln ( split( /;*\n+/, $MLDB_video_sql ) )
   {
      print $sqln ."\n";

      my $stln = $MLDB_video->prepare( $sqln );

      $stln->execute();

      $stln->dump_results() if $stln->{'NUM_OF_FIELDS'};

   } ## end foreach
#=cut

   ##
   ## Process Data and Cache for now
   ##
   foreach $video_id ( keys %video_list )
   {
      my $fh_zlib = new IO::Zlib;

      my $html_data = undef;

      my $video_id_canon = $video_id; $video_id_canon =~ s/[-]/_dash_/g;

      my $mycache  = "$mydir/sm_video_cached/$video_id_canon.txt.gz";

      my $mycached = $mycache;

      my $mycerred = "$mydir/sm_video_cerred/$video_id_canon.txt.gz";
         $mycached = $mycerred if ( -e $mycerred ); ## C(lass) err(or)ed video

      my $myshowed = "$mydir/sm_video_showed/$video_id_canon.txt.gz";
         $mycached = $myshowed if ( -e $myshowed ); ## Showed video

      my $myvcried = "$mydir/sm_video_vcried/$video_id_canon.txt.gz";
         $mycached = $myvcried if ( -e $myvcried ); ## V(ideo) c(opy)ri(ght)

      my $myvetoed = "$mydir/sm_video_vetoed/$video_id_canon.txt.gz";
         $mycached = $myvetoed if ( -e $myvetoed ); ## Vetoed ## TOUse viol

      my $myvflged = "$mydir/sm_video_vflged/$video_id_canon.txt.gz";
         $mycached = $myvflged if ( -e $myvflged ); ## V(ideo) fl(ag)ged

      my $myvprned = "$mydir/sm_video_vprned/$video_id_canon.txt.gz";
         $mycached = $myvprned if ( -e $myvprned ); ## V(ideo) pr(u)ned

      my $myvprved = "$mydir/sm_video_vprved/$video_id_canon.txt.gz";
         $mycached = $myvprved if ( -e $myvprved ); ## V(ideo) pr(i)v(ledg)ed

      my $MLDB_record = 1;

      if ( ! -e $mycached )
      {
         $MLDB_record = 1; ## I haven't seen this stuff

         ##debug##print STDERR "making request for video\n";

         $html_request->uri( $video_list{$video_id}{'watch_url'} );

         if ( 1 )
         {
            ( $html_result ) = WWW::YouTube::HTML::API::ua_request_utf8( $html_request,
                                                                    { 'no_tree' => 1 }
                                                                  );

         }
         else
         {
            ( $html_tree,
              $html_result ) = WWW::YouTube::HTML::API::ua_request_utf8( $html_request );

              $html_tree->delete();

         } ## end if

         $html_data = $html_result->as_string();

         ##debug##my $mycached = "$mydir/lg_video_cached/$video_id_canon.html.gz";

         #if ( $fh_zlib->open( $mycached, 'wb9' ) )
         #{
         #   $fh_zlib->print( $html_data ); ## see /video_cached_lg
         #} ## end if

      }
      else
      {
         $MLDB_record = 1; ##0; ## I've seen this stuff

         ##debug##print STDERR "have video in cache\n";

         if ( $fh_zlib->open( $mycached, 'rb' ) )
         {
            $html_data = <$fh_zlib>;

         } ## end if

      } ## end if

      undef( $fh_zlib );

      $fh_zlib = IO::Zlib->new( $mycache, 'wb9' ) if ( ! -e $mycache  &&
                                                       ! -e $mycerred &&
                                                       ! -e $myshowed &&
                                                       ! -e $myvcried &&
                                                       ! -e $myvetoed &&
                                                       ! -e $myvflged &&
                                                       ! -e $myvprned &&
                                                       ! -e $myvprved &&
                                                       ! 0 && 1
                                                     );

      ##
      ## Must show video status this way until API has got some flagging param
      ##

      my @html_chunk = (); ## will I find a chunk?

      if ( ! defined ( $html_data ) ) {}
      elsif ( $html_data =~ m/(>(This .+? (inappropriate|flagged) [^<]*))/ )
      {
         @html_chunk = ( $1, $2, $3 );

         $mycached = $myvflged;

         $video_list{'not_showed'}{$video_id} = 'vflged' if ( $MLDB_record );

      }
      elsif ( $html_data =~ m/(class="error">([^<]*))/ )
      {
         @html_chunk = ( $1, $2, $2 );

         $video_list{'not_showed'}{$video_id} = 'cerred' if ( $MLDB_record );

         if    ( $html_chunk[1] =~ m/This .+? (terms of use violation)[.]/ )
         {
            $html_chunk[2] = $1;

            $mycached = $myvetoed;

            $video_list{'not_showed'}{$video_id} = 'vetoed' if ( $MLDB_record );

         }
         elsif ( $html_chunk[1] =~ m/This .+? (copyright infringement)[.]/ )
         {
            $html_chunk[2] = $1;

            $mycached = $myvcried;

            $video_list{'not_showed'}{$video_id} = 'vcried' if ( $MLDB_record );

         }
         elsif ( $html_chunk[1] =~ m/This .+? (removed by the user)[.]/ )
         {
            $html_chunk[2] = $1;

            $mycached = $myvprned;

            $video_list{'not_showed'}{$video_id} = 'vprned' if ( $MLDB_record );

         }
         elsif ( $html_chunk[1] =~ m/This .+? (private video)[.]/ )
         {
            $html_chunk[2] = $1;

            $mycached = $myvprved;

            $video_list{'not_showed'}{$video_id} = 'vprved' if ( $MLDB_record );

         } ## end if

      } ## end if

      if ( ! defined( $video_list{'not_showed'}{$video_id} ) )
      {
         $mycached = $myshowed;

      }
      else
      {
         ##debug##
         print 'found <' . $html_chunk[2] . ">\n" if ( ! -e $mycached );

         $fh_zlib->print( '<' . $html_chunk[2] . ">\n" ) if ( defined( $fh_zlib ) );

         $video_list{'seen_errors'}{$video_list{'not_showed'}{$video_id}} = $html_chunk[2] if ( $MLDB_record );

      } ## end if

      if ( defined( $fh_zlib ) )
      {
         undef( $fh_zlib );

         rename( $mycache, $mycached ) if ( -e $mycache );

      } ## end if

   } ## end foreach

   $i = 0;

   $fh_myindx->print( "<html><body><table border=1><tbody>\n" );

   foreach $video_id ( keys %video_list )
   {
      $fh_myindx->print( '<tr height="25%">' ) if ( $i++ % 4 == 0 );

      $fh_myindx->print( '<td width="25%" valign="top">' );

      if ( ! defined( $video_list{'not_showed'}{$video_id} ) )
      {
         $fh_myindx->print(
                     '<img src="'.$video_list{$video_id}{'thumbnail_url'}.'"><br>'.
                     WWW::YouTube::HTML::video_flagger_form(
                     {
                        'video_id' => $video_id
                     }
                                                 ).
                     '<a href="'.$video_list{$video_id}{'watch_url'}.'">'.
                     ' <font size=-2>'.$video_list{$video_id}{'title'}.'</font>'.
                     '</a><br>'."\n"

                          );

      }
      else
      {
         $fh_myindx->printf( "%s:<br>%s\n",
            $video_id,
            $video_list{'seen_errors'}{$video_list{'not_showed'}{$video_id}}
                           );

      } ## end if

      $fh_myindx->print( '</td>' );

      $fh_myindx->print( '</tr>' ) if ( $i % 4 == 0 );

   } ## end foreach

   $fh_myindx->print( "</tbody></table></body></html>\n" );

   $fh_myindx->close();

   $MLDB_video->disconnect();

   ##$myxmldump->dtd; ## In document

   ##$myxmldump->pl2xml( \%MLDB_video_hash, $myxml );

   $MLDB_user->disconnect();

   unlink( $mylock ); rename( $mywrkdir, $mywrkdir.Date::Format::time2str( "%Y%m%d%H%M%S", time ) );

} ##end sub WWW::YouTube::HTML::parse_mirror_most_recent

##
## WWW::YouTube::HTML::vlbt
##
sub WWW::YouTube::HTML::vlbt  ## NOTE: changing to collect data for xml dump, then html
{
   my $h = shift;

=cut
   (
     $h->{'tag'},
     $h->{'wrkdir'},
     $h->{'first_page'},
     $h->{'last_page'},
     $h->{'per_page'},
     $h->{'video_list'},
     $h->{'xmlfile'},
     $h->{'xmldumper'},
   );
=cut

   ##
   ## HTML
   ##

   my $iam = 'vlbt';

   my $ihave = 'video_list';

   my $video_id = undef;

   my $mypurpose = ( $WWW::YouTube::HTML::flag_disarm )? 'PNP' : 'P2P';

   my $myprivate = "$h->{'wrkdir'}/_$mypurpose";

   my $myprotected = "$h->{'wrkdir'}/$mypurpose";

   unlink < $myprivate*.html >;

   unlink < $myprotected*.html >;

   my %certainty =
   (
        0 => 'Red',
       50 => 'Yellow',
      100 => 'Green',

   );

   my $fh_myhtml = IO::File->new();

   my $myhtml = undef;

   my $midframe = ''; ## accumulation string

   my $curr_page = $h->{'first_page'};

   my ( $prev_page, $next_page ) = ( $curr_page - 1, $curr_page + 1 );

   my @video_id = keys %{$h->{$ihave}->{$iam}}; ## video IDs returned XML::vlbt

   my $mypage_cnt_saved = $h->{'last_page'} - $h->{'first_page'} + 1;

   my $mypage_cnt = 0; ## number of pages process so far

   for( my $i = 0; $i <= $#video_id; $i++ )
   {
      if ( (   $h->{'found_tagged'}->{$video_id[$i]} &&
           (   $h->{'video_list'}->{'just'} eq 'not_found'   ) ) ||
           ( ! $h->{'found_tagged'}->{$video_id[$i]} &&
           (   $h->{'video_list'}->{'just'} eq 'found'       ) )
         )
      {
         splice( @video_id, $i--, 1 ); ## remove item at $i

      } ## end if

   } ## end foreach

   my $myitem_cnt_saved = $#video_id + 1; ## number of videos returned XML::vlbt

   ##debug##printf( "[0]number of relevant videos returned=%d\n", $myitem_cnt_saved );

   my $myitem_cnt = 0; ## number of videos returned XML::vlbt and processed so far

   foreach $video_id ( @video_id )
   {
      if ( (   $h->{'found_tagged'}->{$video_id} && ( $h->{'video_list'}->{'just'} eq 'not_found_tagged' ) ) ||
           ( ! $h->{'found_tagged'}->{$video_id} && ( $h->{'video_list'}->{'just'} eq 'found_tagged'     ) ) ||
           (   $h->{'found_author'}->{$video_id} && ( $h->{'video_list'}->{'just'} eq 'not_found_author' ) ) ||
           ( ! $h->{'found_author'}->{$video_id} && ( $h->{'video_list'}->{'just'} eq 'found_author'     ) )
         )
      {
         ##
         ## This block excludes videos from the pages created
         ##

         $myitem_cnt_saved--;

         ##debug##printf( "[1]number of videos returned=%d\n", $myitem_cnt_saved );

      }
      else
      {
         ##debug##printf( "[2]number of videos returned=%d\n", $myitem_cnt_saved );

         ##
         ## This block includes videos in the pages created
         ##

         $myitem_cnt++;

         my $vlbt_ref = $h->{$ihave}->{$iam}{$video_id}; ## for brevity

         ##
         ## Start a page
         ##
         if ( ( $myitem_cnt % $h->{'per_page'} ) == 1 )
         {
            ##last if ( $mypage_cnt > $mypage_cnt_saved );

            ##
            ## Start page accumulation string
            ##
            $midframe = '';

            ##
            ## Start <head>
            ##
            my $head_meta_java = '<META HTTP-EQUIV="Content-Script-Type" CONTENT="text/javascript">';

            my ( $width, $height ) = WWW::YouTube::HTML::src_size( $WWW::YouTube::HTML::string_watch_size );

            my ( $width_w, $height_w ) = WWW::YouTube::HTML::src_size( $WWW::YouTube::HTML::string_watch_size_window );

            my $head_movie_java = '<script type="text/javascript" language="javascript">' ."\n".
               '// <!-- Start Hide' . "\n".
               'function showMovie( video_id ) {' ."\n".
               'window.open("javascript:\'\\' ."\n".
                           ##' document.writeln(\"\\' ."\n".
                             '<object width=\\\\\''.$width.'\\\\\' height=\\\\\''.$height.'\\\\\'>\\' ."\n".
                             '<param name=\\\\\'movie\\\\\'\\' ."\n".
                             ' value=\\\\\''.$WWW::YouTube::HTML::API::url.'/v/'.'"+video_id+"\\\\\'>\\' ."\n".
                             '</param>\\' ."\n".
                             '<embed type=\\\\\'application/x-shockwave-flash\\\\\'\\' ."\n".
                             '       src=\\\\\''.$WWW::YouTube::HTML::API::url.'/v/'.'"+video_id+"\\\\\'\\' ."\n".
                             '       width=\\\\\''.$width.'\\\\\' height=\\\\\''.$height.'\\\\\'>\\' ."\n".
                             '</embed>\\' ."\n".
                             '</object>\\' ."\n".
                           ##                  '\");\\' ."\n".
                                       '\'\\' ."\n".
                           '",' ."\n".
                           ' "P2PorPNP",' ."\n".
                           ' "'.' width='.$width_w.', height='.$height_w.', status, resizable'.' "' ."\n".
                          ');' ."\n".
               '} // End Hide -->' ."\n".
               '</script>' ."\n";

            my $head_meta_css =
               '<STYLE TYPE="text/css">' ."\n".
               '  H1 { font-size: x-large; color: red }' ."\n".
               '  H2 { font-size: large; color: blue }' ."\n".
               '  L1 { font-size: small; color: blue }' ."\n".
               '  L2 { font-size: x-small; color: black }' ."\n".
               '</STYLE>' ."\n";

            my $head_base_url_youtube = '<base href="'.$WWW::YouTube::HTML::API::url.'">';

            my $head_rss = '<!-- RSS Autodiscovery -->' ."\n".
		           '<link rel="alternate" type="application/rss+xml" title="RSS"' ."\n".
                           ' href="file:///home/ermeyers/kdevelop_dflt/atom_experimentation/myatom.xml" />' ."\n";

            my $head_meta_list = '';

            $head_meta_list .= $head_movie_java;

            $head_meta_list .= $head_base_url_youtube;

            $head_meta_list .= $head_rss;

            ##
            ## Put <head> and Start <body>
            ##
            my $head_and_bodystart = '<head>'.$head_meta_list.'</head>'."\n".
                                     '<body bgcolor="'.$WWW::YouTube::HTML::string_body_bgcolor.'">'; ## default

            ##FYI##my $link_tables='';

            if ( $WWW::YouTube::HTML::flag_auto_play )
            {
               $head_and_bodystart = WWW::YouTube::HTML::FlashObject_head_and_bodystart();

            }
            else
            {
               ##FYI##$link_tables=WWW::YouTube::HTML::link_tables(...) was originally called here

            } ## end if

            ##
            ## Put <head> and <body>_start to Start <table> and <tbody> (<thead>/<tfoot> was by link_tables)
            ##
            $midframe .=
                       '<html>'.
                       $head_and_bodystart.
                       '<table border=1>'.
                       ##FYI##$link_tables.
                       '<tbody>'."\n";

         } ## end if

         ##
         ## Implement <tbody>
         ##
         if ( ( ( $myitem_cnt - 1 ) % $WWW::YouTube::HTML::numeric_columns ) == 0 ) ## next row
         {
            $midframe .=
                       '<tr height="25%">';

         } ## end if

         if ( (   $h->{'found_tagged'}->{$video_id} && ( $h->{'video_list'}->{'just'} ne 'not_found_tagged' ) ) ||
              ( ! $h->{'found_tagged'}->{$video_id} && ( $h->{'video_list'}->{'just'} ne 'found_tagged'     ) ) ||
              (   $h->{'found_author'}->{$video_id} && ( $h->{'video_list'}->{'just'} ne 'not_found_author' ) ) ||
              ( ! $h->{'found_author'}->{$video_id} && ( $h->{'video_list'}->{'just'} ne 'found_author'     ) )
            )
         {
            $midframe .=
                       '<td width="20%" valign="top">';

            my $myhtml = sprintf( "file://${myprivate}%04d.html", $curr_page );

            my $author = $vlbt_ref->{'author'};

            if ( ! $h->{'found_author'}->{$video_id} )
            {
               $h->{'video_id'} = $video_id;

               $h = WWW::YouTube::XML::vgd( $h );

               die ( "WWW::YouTube::XML::vgd call\n" ) if ( ! $h->{'video_detail'}{'ok'} );

               delete( $h->{'video_id'} );

               my $vgd_ref = $h->{'video_detail'}->{'vgd'}{$video_id}; ## for brevity

               $author = $vgd_ref->{'author'};

            } ## end if

            $midframe .=
                       '<table>' ."\n".
                       ' <tr valign="bottom">' ."\n".
                       '  <td>' ."\n";

            if ( $WWW::YouTube::HTML::flag_thumbnail )
            {
               $midframe .=
                          '   <a href="'.$myhtml.'" alt="'.$video_id.'"' ."\n".
                          '      onClick="showMovie(\''.$video_id.'\');">' ."\n".
                          '    <img src="'.$vlbt_ref->{'thumbnail_url'}.'">' ."\n".
                          '   </a>' ."\n";

            }
            else
            {
               $midframe .=
                  WWW::YouTube::HTML::embed_video( {
                     'auto_play_setup' => $WWW::YouTube::HTML::flag_auto_play,
                     'auto_play' => $WWW::YouTube::HTML::flag_auto_play,
                     'size'      => 'small',
                     'video_id'  => $video_id,
                                            } );

            } ## end if

            $midframe .=
                       '  </td>' ."\n".
                       '  <td>' ."\n".
                       '   <a href="'.$myhtml.'" onClick="showMovie(\''.$video_id.'\');">' ."\n".
                       '    <font size=-2>&lt;&lt;</font>' ."\n".
                       '   </a>' ."\n".
                       '  </td>' ."\n".
                       ' </tr>' ."\n".
                       '</table>' ."\n";

            $midframe .=
                       '<table>' ."\n".
                       ' <tr valign="center">' ."\n".
                       '  <td>' ."\n";

            if ( ! $WWW::YouTube::HTML::flag_disarm )
            {
               $midframe .= WWW::YouTube::HTML::video_flagger_form( { 'video_id' => $video_id } );

            } ## end if

            my $color_tagged = $certainty{$h->{'found_tagged'}->{$video_id}};

            my $color_author = $certainty{$h->{'found_author'}->{$video_id}};

            $midframe .=
                       '  </td>' ."\n".
                       '  <td align="center">' ."\n".
                       '   <font size=-1 color='.$color_tagged.'><strong>Tag</strong></font>' ."\n".
                       '  </td>' ."\n".
                       '  <td align="center">' ."\n".
                       '   <a href="/profile?user='.$author.'">' ."\n".
                       '   <font size=-1 color='.$color_author.'><strong>Author</strong></font>' ."\n".
                       '   </a>' ."\n".
                       '  </td>' ."\n".
                       ' </tr>' ."\n".
                       '</table>' ."\n";

            $midframe .= WWW::YouTube::HTML::tags_title_description_form( { 'video_ref' => $vlbt_ref } );

         } ## end if

         $midframe .= '</td>' ."\n";

         if ( $myitem_cnt == $myitem_cnt_saved )
         {
            my $myitem_cnt = $myitem_cnt_saved;

            while ( $myitem_cnt++ % $WWW::YouTube::HTML::numeric_columns )
            {
               $midframe .=
                          '<td width="20%" valign="top">empty<td>' ."\n";

            } ## end while


         } ## end if

         if ( ( ( $myitem_cnt % $WWW::YouTube::HTML::numeric_columns ) == 0 ) ||
              ( $myitem_cnt == $myitem_cnt_saved )
            )
         {
            $midframe .= '</tr>';

         } ## end if

         ##debug##printf( "[1]number of videos processed=%d of %d\n", $myitem_cnt, $myitem_cnt_saved );

         ##
         ## Complete <tbody>, etc.
         ##
         if ( ( ( $myitem_cnt % $h->{'per_page'} ) == 0 ) || ( $myitem_cnt == $myitem_cnt_saved )
            )
         {
            $midframe .= '</tbody></table></body></html>' . "\n";

            $myhtml = sprintf( "${myprivate}%04d.html", $curr_page );

            $fh_myhtml->open( $myhtml, '+>:encoding(utf8)' ) ||
            die ( "opening $myhtml: $!\n" );

            $fh_myhtml->print( $midframe );

            $fh_myhtml->close();

            $myhtml = sprintf( "${myprotected}%04d.html", $curr_page );

            $fh_myhtml->open( $myhtml, '+>:encoding(utf8)' ) ||
            die ( "opening $myhtml: $!\n" );

            $fh_myhtml->print( WWW::YouTube::HTML::frame( {
                                                       'wrkdir' => $h->{'wrkdir'},
                                                       'purpose' => $mypurpose,
                                                       'curr_page' => $curr_page
                                                   } )
                             );

            $fh_myhtml->close();

            $mypage_cnt++;

            $prev_page++; $curr_page++; $next_page++;

         } ## end if

      } ## end if

   } ## end foreach

   return ( $h );

} ## end sub WWW::YouTube::HTML::vlbt

##
## WWW::YouTube::HTML::link_pages
##
sub WWW::YouTube::HTML::link_pages
{
   my $h = shift;

   return
   (
      sprintf ( '<a href="'.$h->{'href'}.'%04d.html">Prev</a>'.
                '&nbsp;'.
                '<a href="'.$h->{'href'}.'%04d.html">Next</a>',
                $h->{'prev_page'},
                $h->{'next_page'},
              )
   );

} ## end sub WWW::YouTube::HTML::link_pages

##
## WWW::YouTube::HTML::link_tables
##
sub WWW::YouTube::HTML::link_tables
{
   my $h = shift;

   my $bgcolor = ( defined( $h->{'bgcolor'} ) )? $h->{'bgcolor'} : 'lightGray';

   my ( $mult_lhs, $mult_rhs ) = ( int( $h->{'columns'} / 2 ) - 1 + ( $h->{'columns'} % 2 ),
                                   int( $h->{'columns'} / 2  )
                                 );

   my $link_pages = WWW::YouTube::HTML::link_pages( { 'href'      => $h->{'href'},
                                                 'prev_page' => $h->{'prev_page'},
                                                 'next_page' => $h->{'next_page'}
                                             } );

   my $caption = ( defined( $h->{'caption'} ) )? '<caption>' . $h->{'caption'} . '</caption>' : '';
   return
   (
      ##
      ## table caption
      ##
      $caption .

      ##
      ## table header
      ##
      '<thead align="center" bgcolor="'.$bgcolor.'"><tr>'.
      ' <th>&nbsp;</th>' x $mult_lhs.
      ' <th align="center">'.$link_pages.'</th>'.
      ' <th>&nbsp;</th>' x $mult_rhs.
      '</tr></thead>'.

      ##
      ## table footer
      ##
      '<tfoot align="center" bgcolor="'.$bgcolor.'"><tr>'.
      ' <td>&nbsp;</td>' x $mult_lhs.
      ' <td align="center">'.$link_pages.'</td>' .
      ' <td>&nbsp;</td>' x $mult_rhs.
      '</tr></tfoot>'.
      "\n"

   ); ## end return

} ## end sub WWW::YouTube::HTML::link_tables
#=cut
#            my $link_tables = WWW::YouTube::HTML::link_tables(
#                              {
#                                 ##'caption' => $iam,
#                                 'href' => "file://$myprivate",
#                                 'prev_page' => $prev_page,
#                                 'next_page' => $next_page,
#                                 'columns' => $WWW::YouTube::HTML::numeric_columns,
#                              }                         );
#=cut

##
## WWW::YouTube::HTML::src_size
##
sub WWW::YouTube::HTML::src_size
{
   my $size = shift;

   $size = 'standard' if ( ! defined( $size ) );

   my %src_size =
   (
      'standard' => { 'width' => 425, 'height' => 350 }, ## youtube
      'unconstrained' => { 'width' => '100%', 'height' => '100%' },
      'unconstrained_window' => { 'width' => '50%', 'height' => '50%' },
      'unspecified' => { 'width' => '', 'height' => '' },
      'unspecified_window' => { 'width' => '', 'height' => '' },
   );

   my %src_mult =
   (
      'small'    => 1/2.5,
      'medium'   => 1, 'standard' => 1,
      'large'    => 1.9,
   );

   foreach my $set_size ( 'small', 'standard', 'medium', 'large' )
   {
      $src_size{"${set_size}"}{'width'}  = int( $src_mult{$set_size} * $src_size{'standard'}{'width'} );
      $src_size{"${set_size}"}{'height'} = int( $src_mult{$set_size} * $src_size{'standard'}{'height'} );

      $src_size{"${set_size}_window"}{'width'}  = $src_size{${set_size}}{'width'}  + 18;
      $src_size{"${set_size}_window"}{'height'} = $src_size{${set_size}}{'height'} + 20;

   } ## end foreach

   return( reverse sort values %{$src_size{$size}} ); ## ensure ( width, height)

} ## end sub WWW::YouTube::HTML::src_size

##
## WWW::YouTube::HTML::FlashObject_head_and_body_start
##
sub WWW::YouTube::HTML::FlashObject_head_and_bodystart
{
   ##
   ## for onMouseOver/onMouseOout ?
   ##
   my $head_meta_javascript = '<META HTTP-EQUIV="Content-Script-Type" CONTENT="text/javascript">' ."\n";

   my $head_rss = '<!-- RSS Autodiscovery -->' ."\n".
                  '<link rel="alternate" type="application/rss+xml" title="RSS"' ."\n".
                  ' href="file:///home/ermeyers/kdevelop_dflt/atom_experimentation/myatom.xml" />' ."\n";

   my $head_meta_list = '';

   $head_meta_list .= $head_meta_javascript;

   $head_meta_list .= $head_rss;

   ##
   ## This is needed to automatically watch videos with body onLoad
   ##
   ## FlashObject() Won't do an absolute url; so set base href in head
   ##

   my $head_base_url_youtube = '<base href="'.$WWW::YouTube::HTML::API::url.'">';

   my $head_local_javascript_performOnLoadFunctions =
      '<script type="text/javascript" language="javascript">' ."\n".
      'var onLoadFunctionList = new Array();' ."\n".
      'function performOnLoadFunctions()' ."\n".
      '{' ."\n".
      '   for (var i in onLoadFunctionList)' ."\n".
      '   {' ."\n".
      '      onLoadFunctionList[i]();' ."\n".
      '   }' ."\n".
      '}' ."\n".
      '</script>';

   my $head_remote_javascript_flashobject =
#      '<script type="text/javascript" src="/flashobject.js"></script>';
      '<script type="text/javascript" src="/swfobject.js"></script>';

   return
   (
      '<head>' ."\n".
      $head_meta_list ."".
      $head_base_url_youtube ."\n".
      $head_local_javascript_performOnLoadFunctions ."\n".
      $head_remote_javascript_flashobject ."\n".
      '</head>' ."\n".
      '<body onLoad="performOnLoadFunctions();" bgcolor="'.$WWW::YouTube::HTML::string_body_bgcolor.'">' ."\n"

   );

} ## end sub WWW::YouTube::HTML::FlashObject_head_and_body_start

##
## WWW::YouTube::HTML::frame
##
sub WWW::YouTube::HTML::frame
{
   my $h = shift;

   my $prev_page = sprintf( "$h->{'purpose'}%04d.html", $h->{'curr_page'} - 1 );

   my $private = sprintf( "_$h->{'purpose'}%04d.html", $h->{'curr_page'} ); ## '_' private

   my $curr_page = sprintf( "$h->{'purpose'}%04d.html", $h->{'curr_page'} );

   my $next_page = sprintf( "$h->{'purpose'}%04d.html", $h->{'curr_page'} + 1 );

   return
   (
      '
      <head>
      <title>header-body-footer</title>
      <base href="'.$h->{'wrkdir'}.'/">

      <script type="text/javascript" language="javascript"> <!--src="remote/youtube_frames_setBgColors.js"-->

      <!-- Start Hide

      function setBgColorsIn( from_frame_number, to_frame_number, bgColor )
      {

         for ( var i = from_frame_number; i <= to_frame_number; i++ )
         {
            frames[i].document.bgColor = bgColor;

         } // end for

      } // end function setBgColorsIn

      // End Hide-->

      </script>

      <script type="text/javascript" language="javascript"> <!--src="remote/youtube_frames_linkPages.js"-->

      <!-- Start Hide

      function linkPagesIn( frame_number )
      {

         var prev_page_url = \''.$prev_page.'\';
         var curr_page_url = \''.$curr_page.'\';
         var next_page_url = \''.$next_page.'\';

         var linkPagesString =
                \'<html>\' +
                \'<head>\' +
                \'</head>\' +
                \'<body bgcolor="lightGray">\' +
                \'<center>\' +
                \'<a target="_top" href="\' + prev_page_url + \'">Prev</a>\' +
                \'&nbsp;&nbsp;&nbsp;\' +
                \'<a target="_top" href="\' + curr_page_url + \'">Refresh</a>\' +
                \'&nbsp;&nbsp;&nbsp;\' +
                \'<a target="_top" href="\' + next_page_url + \'">Next</a>\' +
                \'</center>\' +
                \'</body>\' +
                \'</html>\';

         frames[frame_number].document.writeln(linkPagesString);

      } // end function linkPagesIn

      // End Hide-->

      </script>

      <script type="text/javascript" language="javascript">

      <!-- Start Hide

      function performOnLoadFunctions()
      {
         setBgColorsIn(0,0,\'lightGray\');

         linkPagesIn(0);

         window.open("'.$private.'","mybody","status, toolbar");

         setBgColorsIn(2,2,\'lightGray\');

         linkPagesIn(2);

      } // end function performOnLoadFunctions

      // End Hide-->

      </script>

      </head>

      <frameset rows="4%,92%,4%" onLoad="performOnLoadFunctions();" src="javascript:\'\'">
         <frameset cols="*">
            <frame name="header" marginwidth="1" marginheight="1">
         </frameset>
         <frame name="mybody">
         <frameset cols="*">
            <frame name="footer" marginwidth="1" marginheight="1">
         </frameset>
      </frameset>
      '
   );
} ## end sub WWW::YouTube::HTML::frame

##
## WWW::YouTube::HTML::embed_video
##
sub WWW::YouTube::HTML::embed_video
{
   my $h = shift;

   my ( $width, $height ) = WWW::YouTube::HTML::src_size( $h->{'size'} );

   my $manual_play = 'v/';

   my $method = $manual_play;

   if ( defined( $h->{'auto_play'} ) )
   {
      $method = ( $h->{'auto_play'} )? 'player2.swf?video_id=' : $manual_play;

   } ## end if

   if ( $method eq $manual_play )
   {
      return
      (
         '<object width="'.$width.'" height="'.$height.'">' ."\n".
         ' <param name="movie" value="/'.$method.$h->{'video_id'}.'">' ."\n".
         ' </param>' ."\n".
         ' <embed type="application/x-shockwave-flash" src="/'.$method.$h->{'video_id'}.'" ' ."\n".
         '        width="'.$width.'" height="'.$height.'"' ."\n".
         ' >' ."\n".
         ' </embed>' ."\n".
         '</object>' ."\n"
##.         '<br>' ."\n"
      );

   }
   else
   {
      die ( "you need to setup autoplay\n" ) if ( ! defined( $h->{'auto_play_setup'} ) );

      return ## NOTE: must call FlashObject_head_and_body_start as auto_play_setup
      (
         '<div style="text-align: center; padding-bottom: 8px;">' ."\n".
         ' <div id="flashcontent">' ."\n".
         '  <div style="padding: 20px; font-size:14px; font-weight: bold; color: #ffffff">' ."\n".
         '     Hello, you either have JavaScript turned off' ."\n".
         '     or an old version of the Macromedia Flash Player,' ."\n".
         '     <a href="http://www.macromedia.com/go/getflashplayer/">click here</a>' ."\n".
         '     to get the latest flash player.' ."\n".
         '  </div>' ."\n".
         ' </div>' ."\n".
         '</div>' ."\n".
         '<script type="text/javascript">' ."\n".
         '// <![CDATA[' ."\n".
##         'var fo = new FlashObject(' ."\n".
         'var fo = new SWFObject(' ."\n".
         '                         "/'.$method.$h->{'video_id'}.'&l=ermeyers&t=ermeyers&s=ermeyers",' ."\n".
         '                         "movie_player",' ."\n".
         '                         "'.$width.'", "'.$height.'", 7, "#FFFFFF"' ."\n".
         '                      );' ."\n".
         'fo.write("flashcontent");' ."\n".
         '// ]]>' ."\n".
         '</script>' ## NOTE: this requires <base href=""> set to youtube in head

      );

   } ## end if

} ## end sub WWW::YouTube::HTML::embed_video

##
## WWW::YouTube::HTML::tags_title_description_form
##
sub WWW::YouTube::HTML::tags_title_description_form
{
   my $h = shift;

   my $tags = $h->{'video_ref'}->{'tags'};

   my $title = $h->{'video_ref'}->{'title'};

   my $descr = $h->{'video_ref'}->{'description'};

   $tags =~ s/[:\s]+/ /g;

   $title =~ s/[:\s]+/ /g;

   $descr =~ s/[:\s]+/ /g;

   $tags = '_TAGS__: ' . $tags;

   $title = '_TITLE_: ' . $title;

   $descr = '_DESCR_: ' . $descr;

   my @tags = split( /[\s\n]/, $tags );

   my @title = split( /[\s\n]/, $title );

   my @descr = split( /[\s\n]/, $descr );

   my $cols = 25;

   $Text::Wrap::columns = $cols;
   ##debug##   printf( "tags=[\n1234567890123456789012345\n%s]\n", Text::Wrap::wrap( '', '', @tags ) );
   ##debug##   printf( "title=[\n1234567890123456789012345\n%s]\n", Text::Wrap::wrap( '', '', @title ) );
   ##debug##   printf( "descr=[\n1234567890123456789012345\n%s]\n", Text::Wrap::wrap( '', '', @descr ) );

   return
   (
      sprintf( '<form>' ."\n".
               '<textarea name="tags"  rows=1 cols='.sprintf("%d",$cols).' readonly>%s</textarea><br />' ."\n".
               '<textarea name="title" rows=1 cols='.sprintf("%d",$cols).' readonly>%s</textarea><br />' ."\n".
               '<textarea name="descr" rows=1 cols='.sprintf("%d",$cols).' readonly>%s</textarea><br />' ."\n".
               '</form>' ."\n",
               Text::Wrap::wrap( '', '', @tags ),
               Text::Wrap::wrap( '', '', @title ),
               Text::Wrap::wrap( '', '', @descr ),
            )

   );

} ## end sub WWW::YouTube::HTML::tags_title_description_form

##
## WWW::YouTube::HTML::video_flagger_form
##
sub WWW::YouTube::HTML::video_flagger_form
{
   my $h = shift;

   ##
   ## for onMouseOver/onMouseOout ?
   ##
   ##my $head_meta_javascript = '<META HTTP-EQUIV="Content-Script-Type" CONTENT="text/javascript">';
   ##
   ##my $head_meta_list = '';

   return
   (
#      '<form method="get"' ."\n".
#      ' action="'.$WWW::YouTube::HTML::API::url.'/flag_video?v='.$h->{'video_id'}.'&flag=I">' ."\n".
      '<form method="post" action="watch_ajax" name="flagvideo">' ."\n".
      ' <input type="hidden" name="action_flag_video" value="1">' ."\n".
      ' <input type="hidden" name="video_id" value="' . $h->{'video_id'} . '">' ."\n".
      ' <select name="reason">' ."\n".
      '  <option value="">?</option>' ."\n".
      '  <option value="P">P</option>' ."\n".
      '  <option value="I">I</option>' ."\n".
      '  <option value="G">G</option>' ."\n".
      '  <option value="R">R</option>' ."\n".
      ' </select>' ."\n".
      ' <input type="submit" name="submit" value="S"' ."\n".
      '  onMouseOver=\'window.status="'.
          '[P](Pornography or Obsenity) '.
          '[I](Illegal Acts) '.
          '[G](Graphic Violence) '.
          '[R](Racially or Ethnically Offensive Content)'.
          '";\'' ."\n".
      '  onMouseOut=\'window.status="";\'' ."\n".
      ' >' ."\n".
      '</form>' ."\n"
   );

} ## end sub WWW::YouTube::HTML::video_flagger_form

1;
__END__ ## package WWW::YouTube::HTML

=head1 NAME

WWW::YouTube::HTML - General Hyper-Text Markup Language capabilities go in here.

=head1 SYNOPSIS

 Options;

   TBD

=head1 OPTIONS

TBD

=head1 DESCRIPTION

   WWW::YouTube HTML Layer.

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::HTML::API>> I<L<WWW::YouTube::XML>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut

