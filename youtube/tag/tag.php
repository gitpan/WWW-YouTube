<?php

/***************************************************************************
 *   Copyright (C) 2006 by Eric R. Meyers   *
 *   ermeyers@adelphia.net   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<style type="text/css">
/* <![CDATA[ */
a:link { text-decoration: underline; color: #0000ff; }
a:visited { text-decoration: underline; color: #ff00ff; }
a:hover { text-decoration: none; color: #ff7f1f; }
a:active { text-decoration: none; color: #00ff00; }
body {
   color: #3f3f3f;
   background-color: #f3f3f3;
   margin-left: 1cm;
   margin-right: 1cm;
}
/* ]]> */
</style>
<?php

$AUTHOR = 'Eric R. Meyers <ermeyers@adelphia.net>';

print '<meta name="author" content="'.$AUTHOR.'">' ."\n";

$LICENSE = 'GPL';

print '<meta name="copyright" content="'.$LICENSE.'">' ."\n";

$VH = $_SERVER['SERVER_NAME'];

print '<base href="http://' . $VH . '/">' ."\n";

$IAM = $_SERVER['SCRIPT_NAME'];

$SCRIPT = $VH . $IAM;

$namelist = array( 'youtube' => 'YouTube' );

$actionlist = array( 'vlbt' => 'videos.list_by_tag' );

$match_found = 0;

if ( isset( $_GET['interface_name'] ) )
{
   $interface_name = $_GET['interface_name'];

}
else
{
   $interface_name = $namelist['youtube'];

} ## end if

print '<meta name="description" content="WWW::'.$interface_name.'::Com User Interface">' ."\n";

print '<meta name="keywords" content="WWW::'.$interface_name.'::Com, User, Interface, Control">' ."\n";

print '<title>Interface to WWW::' . $interface_name . '::Com</title>' ."\n";

##$Period = 15; #sec

#if ( 0 && $submitted_value != 'Pause' )
#{
#   print '<meta http-equiv="refresh" content="' . $Period .
#         ';url=http://' . $SCRIPT .'?interface_action=?????&interface_name=' . $interface_name . '">' ."\n";
#
#} ## end if

print '</head>' ."\n";

print '<body>' ."\n";

if ( isset( $_GET['interface_action'] ) )
{
   $interface_action = $_GET['interface_action'];

}
else
{
   $interface_action = $actionlist['vlbt'];

} ## end if

if ( isset( $_GET['sstr'] ) )
{
   $sstr_value = preg_replace( '/[`]/', '', $_GET['sstr'] );
 
}
else
{
   $sstr_value = '';

} ## end if

if ( isset( $_GET['submission'] ) )
{
   $submitted_value = $_GET['submission'];

}
else
{
   $submitted_value = 'Enter';

} ## end if

$vlbt_wnt = 'found';
$vlbt_dly = 1; ## I'll calc this
$vlbt_1st = 1;
$vlbt_max = 2;
$vlbt_per = 6;
$vlbt_col = 3;
$vlbt_siz = 'large_window';
$vlbt_flg = '';

$vlbt_type = '';

if ( isset( $_GET['submission'] ) && ! isset( $_GET['arm'] ) )
{
   $arm_value = 0;

   $vlbt_type = 'PNP'; ## for kids

   $arm_cbox = '<input type="checkbox" name="arm" value="1">';

   $vlbt_flg .= ' --html_disarm';

}
else
{
   $arm_value = 1;

   $vlbt_type = 'P2P'; ## for adults

   $arm_cbox = '<input type="checkbox" name="arm" value="1" checked>';

} ## end if

if ( isset( $_GET['method'] ) )
{
   $method_value = $_GET['method'];

   if ( $method_value == 'stdmethod' )
   {
      $stdmethod_rbtn = '<input type="radio" name="method" value="stdmethod" checked>';
      $auto_play_rbtn = '<input type="radio" name="method" value="auto_play">';
      $thumbnail_rbtn = '<input type="radio" name="method" value="thumbnail">';

   }
   else
   {
      $vlbt_flg .= ' --html_' . $_GET['method'];

      if ( $method_value == 'auto_play' )
      {
         $stdmethod_rbtn = '<input type="radio" name="method" value="stdmethod">';
         $auto_play_rbtn = '<input type="radio" name="method" value="auto_play" checked>';
         $thumbnail_rbtn = '<input type="radio" name="method" value="thumbnail">';

      }
      elseif ( $method_value == 'thumbnail' )
      {
         $stdmethod_rbtn = '<input type="radio" name="method" value="stdmethod">';
         $auto_play_rbtn = '<input type="radio" name="method" value="auto_play">';
         $thumbnail_rbtn = '<input type="radio" name="method" value="thumbnail" checked>';

      } ## end if

   } ## end if

}
else
{
   $stdmethod_rbtn = '<input type="radio" name="method" value="stdmethod" checked>';
   $auto_play_rbtn = '<input type="radio" name="method" value="auto_play">';
   $thumbnail_rbtn = '<input type="radio" name="method" value="thumbnail">';

} ## end if

if ( isset( $_GET['want'] ) )
{
   $vlbt_wnt = $_GET['want'];

   if ( $vlbt_wnt == 'all' )
   {
      $want_all_rbtn = '<input type="radio" name="want" value="all" checked>';
      $want_fnd_rbtn = '<input type="radio" name="want" value="found">';
      $want_nfd_rbtn = '<input type="radio" name="want" value="not_found">';

   }
   else
   {
      if ( $vlbt_wnt == 'found' )
      {
         $want_all_rbtn = '<input type="radio" name="want" value="all">';
         $want_fnd_rbtn = '<input type="radio" name="want" value="found" checked>';
         $want_nfd_rbtn = '<input type="radio" name="want" value="not_found">';

      }
      elseif ( $vlbt_wnt == 'not_found' )
      {
         $want_all_rbtn = '<input type="radio" name="want" value="all">';
         $want_fnd_rbtn = '<input type="radio" name="want" value="found">';
         $want_nfd_rbtn = '<input type="radio" name="want" value="not_found" checked>';

      } ## end if

   } ## end if

}
else
{
   $vlbt_wnt = 'all';

   $want_all_rbtn = '<input type="radio" name="want" value="all" checked>';
   $want_fnd_rbtn = '<input type="radio" name="want" value="found">';
   $want_nfd_rbtn = '<input type="radio" name="want" value="not_found">';

} ## end if

if ( isset( $_GET['1st'] ) )
{
   $vlbt_1st = $_GET['1st'];

} ## end if

if ( isset( $_GET['max'] ) )
{
   $vlbt_max = $_GET['max'];

} ## end if

if ( isset( $_GET['per'] ) )
{
   $vlbt_per = $_GET['per'];

} ## end if

if ( isset( $_GET['col'] ) )
{
   $vlbt_col = $_GET['col'];

} ## end if

foreach ( $namelist as $n )
{
   if ( $interface_name == $n )
   {
      $match_found++;

   } ## end if

} ## end foreach

print '<form enctype="application/x-www-form-urlencoded" action="' . $IAM . '">' ."\n";

print '<table width="100%" border="1">'. "\n";

print '<caption><a target="_blank" href="http://www.youtube.com/profile?user=ermeyers">WWW::'.$interface_name.'::Com</a></caption>' ."\n";

print '<thead>' ."\n";

print '<tr>' ."\n";

print '<th align="center">' ."\n";

print '<a target="Heaven" href="http://www.biblegateway.com/passage/?search=Matt%203:12&version=31">' ."\n";

print '<font size=+1><strong>Matthew 3:12</strong></font>' ."\n";

print '</a>' ."\n";

print '</th>' ."\n";

print '<th align="left" bgcolor="white" colspan=2>' ."\n";

print '<font size=-1><em>&quot;His winnowing fork is in his hand, and he will clear his threshing floor, gathering his wheat into the barn and burning up the chaff with unquenchable fire.&quot; -- NIV</em></font>' ."\n";

print '</th>' ."\n";

print '</tr>' ."\n";

print '<tr>'. "\n";

print '</thead>' ."\n";

print '<tbody>' ."\n";

print '<tr>'. "\n";

print '<td width="50%"><font size=-1>'. "\n";

print '<ul><li><strong><em>P</em></strong> : Pornography or Obscenity</li>' ."\n";
print '<li><strong><em>I</em></strong> : Illegal Acts</li>' ."\n";
print '<li><strong><em>G</em></strong> : Graphic Violence</li>' ."\n";
print '<li><strong><em>R</em></strong> : Racially or Ethnically Offensive Content</li></ul>' ."\n";

print '</font></td>'. "\n";

print '<td width=20%><font size=-1>'. "\n";

print '<ul><li><strong><em>S</em></strong> : Submit</li></ul>' ."\n";

print '</td></font>'. "\n";

print '<td align="center">'. "\n";

print '<a target="_blank" href="http://users.adelphia.net/~ermeyers">' . $AUTHOR .
      '<br>'.
      '<img src="/youtube/tag/images/ERMpowered.gif"></a>' .
      '<br>' .
      '<strong><em><font size=-1>to protect children</font></em></strong>'. "\n";

print '</td>'. "\n";

print '</tr>'. "\n";

print '<tr>' ."\n";

print '<td align="center" colspan=3>'. "\n";

print $arm_cbox . '<em>PARENT</em>: If you&apos;re logging into ' . $interface_name . ' to flag videos, like me, then use my armed interface.' ."\n";

print '</td>'. "\n";

print '</tr>'. "\n";

print '<tr>'. "\n";

print '<td>'. "\n";

if ( 1 )
{
   print '<INPUT type="text" name="interface_name" value="' . $namelist['youtube'] . '" readonly disabled>' ."\n";

}
else
{
   print '<select name="interface_name">' ."\n";

   foreach ( $namelist as $n )
   {
      print '<option value="' . $n . '">' . $n . '</option>' . "\n";

   } ## end foreach

   print '</select>' ."\n";

} ## end if

if ( 1 )
{
   print '<INPUT type="text" name="interface_action" value="' . $actionlist['vlbt'] . '" readonly disabled>' ."\n";

}
else
{
   print '<select NAME="interface_action">' . "\n";

   foreach ( $actionlist as $a )
   {
      print '<option value="' . $a . '">' . $a . '</option>' . "\n";

   } ## end foreach

   print '</select>' ."\n";

} ## end if

print '<br>' ."\n";

print '<strong><em>Tag:</em></strong><input type="text" name="sstr" value="'. $sstr_value .'" size="25" maxlength="100" alt="Tag or User to search for on '. $interface_name . '" src="/icons/world1.gif">' ."\n";

print '<input type="submit" name="submission" value="Enter">' ."\n";

print '<td align="center">'. "\n";

print '<a href="' . $IAM . '">Refresh</a>' ."\n";

print '<br>' ."\n";

print '<input type="reset" value="Reset">' ."\n";

print '</td>'. "\n";

print '<td align="center" bgcolor="white">'. "\n";

print '<font size=-1>&quot;Keep it <em>FUN, CLEAN and REAL!&quot;</em></font>' ."\n";

print '<br>' ."\n";

print '<font size=-1><em>Please help to protect <strong>all</strong> <font color="green">children</font>, by flagging <strong>all</strong> <font color="red">adult content</font> as <font color="blue">inappropriate material</font>.</em></font>' ."\n";

print '</td>'. "\n";

print '</tr>'. "\n";

print '<tr>'. "\n";

print '<td>'. "\n";

print '<strong><em>First Page:</em></strong> <select NAME="1st">' . "\n";

for ( $i = 1; $i <= 100; $i++ )
{
   if ( $i == $vlbt_1st )
   {
      print '<option value="' . $i . '" selected>' . $i . '</option>' . "\n";

   }
   else
   {
      print '<option value="' . $i . '">' . $i . '</option>' . "\n";

   } ## end if

} ## end foreach

print '</select>' ."\n";

print '<strong><em>Pages:</em></strong> <select NAME="max">' . "\n";

for ( $i = 1; $i <= 100; $i++ )
{
   if ( $i == $vlbt_max )
   {
      print '<option value="' . $i . '" selected>' . $i . '</option>' . "\n";

   }
   else
   {
      print '<option value="' . $i . '">' . $i . '</option>' . "\n";

   } ## end if

} ## end foreach

print '</select>' ."\n";

print '</td>'. "\n";

print '<td>'. "\n";

print '<strong><em>Per Page:</em></strong> <select NAME="per">' . "\n";

for ( $i = 1; $i <= 100; $i++ )
{
   if ( $i == $vlbt_per )
   {
      print '<option value="' . $i . '" selected>' . $i . '</option>' . "\n";

   }
   else
   {
      print '<option value="' . $i . '">' . $i . '</option>' . "\n";

   } ## end if

} ## end foreach

print '</select>' ."\n";

print '</td>'. "\n";

print '<td>'. "\n";

print '<strong><em>Columns:</em></strong> <select NAME="col">' . "\n";

for ( $i = 1; $i <= 5; $i++ )
{
   if ( $i == $vlbt_col )
   {
      print '<option value="' . $i . '" selected>' . $i . '</option>' . "\n";

   }
   else
   {
      print '<option value="' . $i . '">' . $i . '</option>' . "\n";

   } ## end if

} ## end foreach

print '</select>' ."\n";

print '</td>'. "\n";

print '</tr>'. "\n";

print '<tr>'. "\n";

print '<td colspan=1>'. "\n";

print '<a target="view_results" href="/youtube/tag/"><strong><em>View results:</em></strong></a>' ."\n";

if ( $interface_action == $actionlist['vlbt'] )
{
   $sstr_canon = preg_replace( '/\s+/', '_nbsp_', $sstr_value );

   print '<a target="' . $sstr_canon . '"' .
         ' href="/youtube/tag/tag_' . $sstr_canon . '/' . $vlbt_type . '0001.html">' . $sstr_value .
         '</a>' ."\n";

}
elseif ( $interface_action == $actionlist['vlbu'] )
{
   #print shell_exec( '/sbin/ifdown ' . $interface_name . ' 2>&1' );

} ## end if

if ( isset( $_GET{'canon'} ) )
{
   remove_directory( '/var/www/html/youtube/tag/tag_'.$_GET{'canon'} );

} ## end if

list_tag_results( '/var/www/html/youtube/tag', 0 );

print '</td>'. "\n";

print '<td colspan=2>'. "\n";

print '<strong><em>Remove results:</em></strong>' ."\n";

if ( ( $interface_action == $actionlist['vlbt'] ) &&
     ( $submitted_value == 'Enter' ) &&
     ( $sstr_value != '' )
   )
{
   #print '<pre>' ."\n";

   print shell_exec( 'umask 0000;/var/www/html/youtube/tag/tag.plx' .
                     ' \'--ml_tag=' . $sstr_value . '\' ' .
                     ' --ml_vlbt_want=' . $vlbt_wnt .
                     ' --ml_delay_sec=' . $vlbt_dly .
                     ' --ml_first_page=' . $vlbt_1st .
                     ' --ml_max_pages=' . $vlbt_max .
                     ' --ml_per_page=' . $vlbt_per .
                     ' --html_columns=' . $vlbt_col .
                     ' --html_watch_size=' . $vlbt_siz .
                     $vlbt_flg .
                     ' 2>&1'
                   );

   #print '</pre>' ."\n";

}
elseif ( $interface_action == $actionlist['vlbu'] )
{
   #print shell_exec( '/sbin/ifdown ' . $interface_name . ' 2>&1' );

} ## end if

list_tag_results( '/var/www/html/youtube/tag', 1 );

print '</td>'. "\n";

print '</tr>'. "\n";

print '<tr>'. "\n";

print '<td colspan=3>'. "\n";

print '<strong><em>Display method:</em></strong>' ."\n";

print '<br>' ."\n";

print $stdmethod_rbtn . 'STANDARD Display method: This will load slowly.' ."\n";

##print '<br>' ."\n";
##
##print $auto_play_rbtn . 'AUTO-PLAY Display method: This will load more slowly, and makes a mess of the audio.' ."\n";

print '<br>' ."\n";

print $thumbnail_rbtn . 'THUMBNAIL Display method: This will load quickly.' ."\n";

print '</td>'. "\n";

print '</tr>'. "\n";

print '<tr>'. "\n";

print '<td colspan=3>'. "\n";

print '<strong><em>Display:</em></strong>' ."\n";

print '<br>' ."\n";

print $want_all_rbtn . '<em>ALL</em>: This will display all videos returned.' ."\n";

print '<br>' ."\n";

print $want_fnd_rbtn . '<em>FOUND</em>: This will display all videos found to match the tags you&apos;ve entered.' ."\n";

print '<br>' ."\n";

print $want_nfd_rbtn . '<em>NOT_FOUND</em>: This will display all videos not found to match the tags you&apos;ve entered.' ."\n";

print '</td>'. "\n";

print '</tr>'. "\n";

print '</tbody>' ."\n";

print '</table>'. "\n";

print '</form>' ."\n";

function list_tag_results( $dir, $rmdir_flag )
{
   $IAM = $_SERVER['SCRIPT_NAME'];

   $dir_contents = scandir( $dir );

   foreach ( $dir_contents as $tag_item )
   {
      if ( ! preg_match( '/^tag_/', $tag_item ) ) { continue; };

      $item_canon = preg_replace( '/^tag_/', '', $tag_item );

      $item = preg_replace( '/_nbsp_/', ' ', $item_canon );

      if ( ! $rmdir_flag )
      {
         print '<a target="' . $item_canon . '" href="/youtube/tag/' . $tag_item . '/">' . $item . '</a>' ."\n";

      }
      else
      {
         print '<a href="' . $IAM . '?canon=' . $item_canon . '">' . $item . '</a>' ."\n";

      } ## end if

   } ## end foreach

} ## end function

function remove_directory( $dir )
{
   $dir_contents = scandir( $dir );

   foreach ( $dir_contents as $item )
   {
      if ( ( $item == '.' ) || ( $item == '..' ) ) { continue; };

      ##debug##print $dir . '/' . $item ."\n";

      if ( is_dir( $dir . '/' . $item ) )
      {
         ##debug##print 'call is ' . $dir . '/' . $item ."\n";

         remove_directory( $dir . '/' . $item );

      }
      elseif ( file_exists( $dir . '/' . $item ) )
      {
         unlink( $dir . '/' . $item );

      } ## end if

   } ## end foreach

   rmdir( $dir );

} ## end function

?>
<!--

-->
</body>
</html>
