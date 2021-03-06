##
## package WWW::YouTube::HTML
##
package WWW::YouTube::HTML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0728 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::HTML::ISA = qw(Exporter);

   @WWW::YouTube::HTML::EXPORT = qw(); ## export required

   @WWW::YouTube::HTML::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require WWW::YouTube::HTML::API;

require File::Spec;

require File::Basename;

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
   },
   'opts_type_flag' =>
   [
      'auto_play',
      'disarm',
      'thumbnail',

   ],
   'opts_type_numeric' =>
   [
      'columns',
      'rows',

   ],
   'opts_type_string' =>
   [
      'vlbt_want',
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
$WWW::YouTube::HTML::numeric_columns = 3; ## columns in table

$WWW::YouTube::HTML::string_vlbt_want = 'all';

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
## WWW::YouTube::HTML::video_intel
##
my $mydir = File::Spec->catfile( File::Basename::dirname( $FindBin::Bin ), 'video' );

foreach my $x ( qw(cached cerred showed vcried vetoed vflged vprned vprved) )
{
   if ( ! -d File::Spec->catfile( $mydir, "sm_video_$x" ) )
   {
      mkdir File::Spec->catfile( $mydir, "sm_video_$x" );

   } ## end if

} ## end foreach
##
sub WWW::YouTube::HTML::video_intel
{
   my $h = shift;

   ##debug##   print STDERR "video_intel\n";

   my $html_request = HTTP::Request->new(); $html_request->method( 'GET' );

   my $html_result = undef;

   my $html_tree = undef;

   ##
   ## Cache Maintenance
   ##

   opendir( DH, File::Spec->catfile( $mydir, 'sm_video_showed' ) ) ||
   die( 'opening '. File::Spec->catfile( $mydir, 'sm_video_showed' ) . ": $!\n" );

   my @flist = map { "$mydir/sm_video_showed/$_" } grep { /[.]txt$/ } readdir( DH );

   closedir( DH );

   foreach my $x ( @flist )
   {
      ##debug## printf( "flist x=%s\n", $x );

      unlink( $x ) if ( -M $x > 0.5/24 ); ## = 30 mins, (0.125 days old is 3 hours)

   } ## end foreach

   ##
   ## Process and Cache data
   ##
   foreach my $video_id ( keys %{$h->{'video_list'}} )
   {
      my $fh_zlib = new IO::Zlib;

      my $html_data = undef;

      my $video_id_canon = $video_id; $video_id_canon =~ s/[-]/_dash_/g;

      my $mycache  = File::Spec->catfile( $mydir, 'sm_video_cached', $video_id_canon . '.txt.gz' );

      my $mycerred = File::Spec->catfile( $mydir, 'sm_video_cerred', $video_id_canon . '.txt.gz' );

      my $myshowed = File::Spec->catfile( $mydir, 'sm_video_showed', $video_id_canon . '.txt.gz' );

      my $myvcried = File::Spec->catfile( $mydir, 'sm_video_vcried', $video_id_canon . '.txt.gz' );

      my $myvetoed = File::Spec->catfile( $mydir, 'sm_video_vetoed', $video_id_canon . '.txt.gz' );

      my $myvflged = File::Spec->catfile( $mydir, 'sm_video_vflged', $video_id_canon . '.txt.gz' );

      my $myvprned = File::Spec->catfile( $mydir, 'sm_video_vprned', $video_id_canon . '.txt.gz' );

      my $myvprved = File::Spec->catfile( $mydir, 'sm_video_vprved', $video_id_canon . '.txt.gz' );

      my $mycached = $mycache;

      if ( -e $mycerred ) ## C(lass) err(or)ed video
      {
         unlink( $mycerred ); ## reprocess always

      }
      elsif ( -e $myshowed ) ## Showed video
      {
         if ( -M $myshowed > 0.5/24 )
         {
            unlink( $myshowed ); ## retained in cache for a very short period of time, otherwise review again

         }
         else
         {
            $h->{'status'}->{$video_id} = 'shown';

            next;

         } ## end if

      }
      elsif ( -e $myvcried ) ## V(ideo) c(opy)ri(ght)
      {
         $h->{'status'}->{$video_id} = 'vcried';

         next;

      }
      elsif ( -e $myvetoed ) ## Vetoed ## TOUse viol
      {
         $h->{'status'}->{$video_id} = 'vetoed';

         next;

      }
      elsif ( -e $myvflged ) ## V(ideo) fl(ag)ged
      {
         $h->{'status'}->{$video_id} = 'vflged';

         next;

      }
      elsif ( -e $myvprned ) ## V(ideo) pr(u)ned
      {
         $h->{'status'}->{$video_id} = 'vprned';

         next;

      }
      elsif ( -e $myvprved ) ## V(ideo) pr(i)v(ledg)ed
      {
         $h->{'status'}->{$video_id} = 'vprved';

         next;

      } ## end if

      ##debug## print STDERR "making watch request for video: video_id=$video_id\n";

      $html_request->uri( $WWW::YouTube::HTML::API::url . '/watch?v=' . $video_id );

      WWW::YouTube::HTML::API::get_started() if ( ! defined( $WWW::YouTube::HTML::API::ua ) );

      my $parse_head = $WWW::YouTube::HTML::API::ua->parse_head();

      $WWW::YouTube::HTML::API::ua->parse_head( 0 );

      $html_result = WWW::YouTube::HTML::API::ua_request( $html_request, { 'no_tree' => 1 } );

      $WWW::YouTube::HTML::API::ua->parse_head( $parse_head );

      $html_data = $html_result->as_string();

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

      if ( ! defined ( $html_data ) )
      {
         ##debug##print "html_data not defined\n";

      }
      elsif ( $html_data =~ m/(>(This .+? (inappropriate|flagged) [^<]*))/ )
      {
         @html_chunk = ( $1, $2, $3 );

         $mycached = $myvflged;

         $h->{'not_shown'}->{$video_id} = 'vflged';

      }
      elsif ( $html_data =~ m/(class="error">([^<]*))/ )
      {
         @html_chunk = ( $1, $2, $2 );

         $h->{'not_shown'}->{$video_id} = 'cerred';

         if    ( $html_chunk[1] =~ m/This .+? (terms of use violation)[.]/ )
         {
            $html_chunk[2] = $1;

            $mycached = $myvetoed;

            $h->{'not_shown'}->{$video_id} = 'vetoed';

         }
         elsif ( $html_chunk[1] =~ m/This .+? (copyright infringement)[.]/ )
         {
            $html_chunk[2] = $1;

            $mycached = $myvcried;

            $h->{'not_shown'}->{$video_id} = 'vcried';

         }
         elsif ( $html_chunk[1] =~ m/This .+? (removed by the user)[.]/ )
         {
            $html_chunk[2] = $1;

            $mycached = $myvprned;

            $h->{'not_shown'}->{$video_id} = 'vprned';

         }
         elsif ( $html_chunk[1] =~ m/This .+? (private video)[.]/ )
         {
            $html_chunk[2] = $1;

            $mycached = $myvprved;

            $h->{'not_shown'}->{$video_id} = 'vprved';

         } ## end if

      } ## end if

      if ( ! defined( $h->{'not_shown'}{$video_id} ) )
      {
         $mycached = $myshowed;

         $h->{'status'}{$video_id} = 'shown';

      }
      else
      {
         $h->{'status'}{$video_id} = $h->{'not_shown'}{$video_id};

         ##debug##
         print 'found <' . $html_chunk[2] . ">\n" if ( ! -e $mycached );

         $fh_zlib->print( '<' . $html_chunk[2] . ">\n" ) if ( defined( $fh_zlib ) );

         $h->{'see_errors'}->{$h->{'not_shown'}->{$video_id}} = $html_chunk[2];

      } ## end if

      if ( defined( $fh_zlib ) )
      {
         undef( $fh_zlib );

         rename( $mycache, $mycached ) if ( -e $mycache );

      } ## end if

   } ## end foreach

} ##end sub WWW::YouTube::HTML::video_intel

##
## WWW::YouTube::HTML::vlbt
##
sub WWW::YouTube::HTML::vlbt  ## NOTE: changing to collect data for xml dump, then html
{
   my $h = shift;

#=cut
#   (
#     $h->{'tag'},
#     $h->{'wrkdir'},
#     $h->{'first_page'},
#     $h->{'last_page'},
#     $h->{'per_page'},
#     $h->{'video_list'},
#     $h->{'xmlfile'},
#     $h->{'xmldumper'},
#   );
#=cut

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

   ##
   ## Watch and Gather intelligence
   ##

   my $intel = { 'video_list' => $h->{$ihave}->{$iam} };

   WWW::YouTube::HTML::video_intel( $intel );

   my @video_id = keys %{$h->{$ihave}->{$iam}}; ## video IDs returned XML::vlbt

#   ##
#   ## Get rid of stuff we don't want to see (vlbt has no author, need vgd video_detail to get author)
#   ##
#   for( my $i = 0; $i <= $#video_id; $i++ )
#   {
#      if ( ! $h->{'found_author'}->{$video_id[$i]} ) ## && ( $h->{'video_list'}->{'just'} eq 'found_author' ) )
#      {
#         $h->{'video_id'} = $video_id[$i];
#
#         $h = WWW::YouTube::XML::vgd( $h );
#
#         ##debug##die ( "WWW::YouTube::XML::vgd call\n" ) if ( ! $h->{'video_detail'}{'ok'} );
#
#         delete( $h->{'video_id'} );
#
#         $h->{$ihave}->{$iam}{$video_id[$i]}->{'author'} = $h->{'video_detail'}->{'vgd'}{$video_id[$i]}->{'author'}
#
#      } ## end if
#
#      if ( (   $h->{'found_tagged'}->{$video_id[$i]} && ( $h->{'video_list'}->{'just'} eq 'not_found_tagged'   ) ) ||
#           ( ! $h->{'found_tagged'}->{$video_id[$i]} && ( $h->{'video_list'}->{'just'} eq 'found_tagged'       ) ) ||
#           (   $h->{'found_author'}->{$video_id[$i]} && ( $h->{'video_list'}->{'just'} eq 'not_found_author' ) ) ||
#           ( ! $h->{'found_author'}->{$video_id[$i]} && ( $h->{'video_list'}->{'just'} eq 'found_author'     ) )
#         )
#      {
#         splice( @video_id, $i--, 1 ); ## remove item at $i
#
#      } ## end if
#
#   } ## end foreach

   my $mypage_cnt_saved = $h->{'last_page'} - $h->{'first_page'} + 1;

   my $mypage_cnt = 0; ## number of pages process so far

   my $myitem_cnt_saved = $#video_id + 1; ## number of videos returned XML::vlbt

   ##debug##printf( "[0]number of relevant videos returned=%d\n", $myitem_cnt_saved );

   my $myitem_cnt = 0; ## number of videos returned XML::vlbt and processed so far

   foreach $video_id ( @video_id )
   {
      my $author = $h->{$ihave}->{$iam}{$video_id}->{'author'};

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

         ##debug##$h->{'found_author'}->{$video_id} = 0; ## reset

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

            if ( ! $WWW::YouTube::HTML::flag_disarm && ( $intel->{'status'}->{$video_id} eq 'shown' ) )
            {
               $midframe .= WWW::YouTube::HTML::video_flagger_form( { 'video_id' => $video_id } );

            } ## end if

            ##debug##print Data::Dumper::Dumper( $h->{'found_tagged'}->{$video_id} );

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
                       '  <td align="center">' ."\n".
                       '   <font size=-1 color='.'white'.'><strong>'.$intel->{'status'}->{$video_id}.'</strong></font>' ."\n".
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

         ##debug## printf( "[1]number of videos processed=%d of %d\n", $myitem_cnt, $myitem_cnt_saved );

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
          '[P](Pornography or Obscenity) '.
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

=head1 OPTIONS

--html_* options:

opts_type_flag:

   --html_auto_play
   --html_disarm
   --html_thumbnail

opts_type_numeric:

   --html_columns=number
   --html_rows=number

opts_type_string:

   --html_vlbt_want=string
   --html_body_bgcolor=string
   --html_watch_size=string
   --html_watch_size_window=string

=head1 DESCRIPTION

   WWW::YouTube HTML Layer.

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::HTML::API>> I<L<WWW::YouTube::XML>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut
