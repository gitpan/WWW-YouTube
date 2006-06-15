##
## WWW::YouTube
##
package WWW::YouTube;

use strict;

use warnings;

use 5.005;

require Date::Format;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION = sprintf("%d.%04d", "Revision: 2006.0615" =~ /(\d+)\.(\d+)/);

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
   'iknow'          => 'yt',
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::YouTube::opts,
   'opts_filename'  => {},
   'export_ok'      => [],
   'urls'           => {},
   'opts_type_flag' =>
   [
      'apache',
      'mozilla',
   ],
   'opts_type_numeric' =>
   [
      'test_n',
   ],
   'opts_type_string' =>
   [
      'canon_tag',
      'mozilla_bin',
   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::YouTube::opts_type_args{'ido'},
                                #$WWW::YouTube::ML::opts_type_args{'iknow'},
                                #$WWW::YouTube::ML::opts_type_args{'iman'}
                        )
                      );

WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::opts_type_args );

$WWW::YouTube::flag_apache = 0;
$WWW::YouTube::flag_mozilla = 0;
$WWW::YouTube::numeric_test_n = 999;
$WWW::YouTube::string_canon_tag = undef; ## _nbsp_
$WWW::YouTube::string_mozilla_bin = '/usr/bin/firefox';

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
   my $h = shift;

   my $iam = File::Basename::basename( $h->{'$0'} );

   die ( "\$0=$h->{'$0'}\n" ) if ( ! defined( $iam ) || ( $iam eq '' ) );

   chdir( $FindBin::Bin ); ## very critical move for subdirs named tag_*

   my $ml_tag = undef;

   my $ml_tag_subdir = undef;

   my $basename_match = 0;

   if ( defined( $WWW::YouTube::ML::string_tag ) )
   {
      $ml_tag = $WWW::YouTube::ML::string_tag;
   }
   elsif ( defined( $WWW::YouTube::string_canon_tag ) )
   {
      $ml_tag = $WWW::YouTube::string_canon_tag;

      $ml_tag =~ s/_nbsp_/ /g;

   }
   else
   {
      $basename_match++;

      $iam =~ m/^([^_]+_([^.]+))[.]plx$/ || die "no basename match to start (iknow_iam.plx)\n";

      ( $ml_tag, $ml_tag_subdir ) = ( $2, $1 ); ##debug##print $tag . "\n";exit;

      $ml_tag =~ s/_nbsp_/ /g;

   } ## end if

   if ( defined( $WWW::YouTube::string_canon_tag ) )
   {
      $ml_tag_subdir = $WWW::YouTube::string_canon_tag; ## external parties play tag with us

   }
   elsif ( defined ( $WWW::YouTube::ML::string_tag_subdir ) )
   {
      $ml_tag_subdir = $WWW::YouTube::ML::string_tag_subdir;

   } ## end if

   WWW::YouTube::ML::vlbt( { 'tag' => $ml_tag, 'tag_subdir' => $ml_tag_subdir } );

   if ( $WWW::YouTube::flag_mozilla )
   {
      my $url = sprintf( "file://%s/%s%s/%s%04d.html",
                         $FindBin::Bin,
                       ( $basename_match )? '' : 'tag_',
                         $ml_tag_subdir,
                       ( $WWW::YouTube::HTML::flag_disarm )? 'PNP' : 'P2P',
                         $WWW::YouTube::ML::numeric_first_page,
                       );

      system( $WWW::YouTube::string_mozilla_bin . ' -remote "ping()" 2>/dev/null' );

      if ( ! $? )
      {
         system( $WWW::YouTube::string_mozilla_bin . ' -remote "openurl('. $url . ',new-tab)"' );

      }
      else
      {
         system( '( ' . $WWW::YouTube::string_mozilla_bin . ' ' . $url . ' 2>&1 ) > /dev/null &' );

      } ## end if

   } ## end if

} ## end sub WWW::YouTube::vlbt

1;
__END__ ## package WWW::YouTube

=head1 NAME

B<WWW::YouTube> - YouTube Development Interface (YTDI)

=head1 SYNOPSIS

B<use lib ( $ENV{'HOME'} );>

B<use WWW::YouTube::Com;> ## SEE DESCRIPTION

Options (--yt_* options);

=head1 OPTIONS

--yt_* options:

opts_type_flag:

   --yt_apache
   --yt_mozilla

opts_type_numeric:

   NONE

opts_type_string:

   --yt_canon_tag=string
   --yt_mozilla_bin=string

=head1 DESCRIPTION

B<WWW::YouTube> is the I<Public> I<YouTube Development Interface> (YTDI).

B<L<WWW::YouTube::Com>> is your I<Private> YouTube Developer's Interface.

We need your private B<user, pass and dev_id> defined here.

To use the YouTube Development Interface (YTDI) through your own YouTube Developer's Interface, you need to have a YouTube username and password, and you'll need to register with YouTube as a Developer in order to get a Developer ID for the YouTube Developer's API at L<http://www.youtube.com/dev>.

By the way, you need to go directly to YouTube at L<http://www.youtube.com> to do your registering, and you must think up a really good excuse for your desire to become a registered YouTube Developer.

DON'T use something like helping me to develop programs to protect the registered teenagers and the General Public, including children, from being exposed to too much adult content and other inappropriate material.  It might not work to well, since on 06/14/2006, YouTube BLACKLISTED me for cleaning up the "hot babes," "foot fettish" and "bondage tickling" videos I found on YouTube.

README at L<http://www.youtube.com/profile?user=ermeyers>, if you can.  It has been 24 hours, and the YouTube Administrators still haven't told me why my account has been disabled.  YouTube, what is my "Terms of Use" offense to you?  I'll keep trying to get an answer, because as long as this guy L<http://www.youtube.com/watch?v=8uByGrzLLTs> or this girl L<http://www.youtube.com/watch?v=Bjtd9kmiyMI> are still YouTube "Gold Club" members, or the "Head" YouTube Administrators doing their daily "Self Worship" routine, things need to be corrected and all Children, Teenagers and the General Public, need to be protected continually with "Extreme Prejudice."

Luke 9:5, "If people do not welcome you, shake the dust off your feet when you leave their town, as a testimony against them." --NIV

Luke 10:11, "Even the dust of your town that sticks to our feet we wipe off against you. Yet be sure of this: The kingdom of God is near." --NIV

Now, just because a public video on YouTube has been flagged as inappropriate material for the General Public, doesn't mean that a registered adult can't watch it.  Flagging keeps YouTube registered teenagers, and YouTube's unregistered General Public viewers, including children, from being able to view the contents of a public video identified as an inappropriate video, viewable by registered adults only, if they I<explicitly> choose to be viewing the public videos flagged as "inappropriate material," during their I<current> login session.

You'll need to I<educate> yourself and I<experiment> with YouTube I<directly>, before going hog-wild with my WWW::YouTube applications, like I did, flagging videos.  "To protect children," that's my central theme and purpose for this B<EXPERIMENTAL> I<YouTube Development Interface> (YTDI) project, called B<WWW::YouTube>.

What happens with the YTDI really depends on Who, What, When, Where and Which action it's activated.

And Why, and How?  What I<actually> happens, Why or How it I<happened>, really matters in this world we live in, doesn't it?

Matthew 3:12, "His winnowing fork is in his hand, and he will clear his threshing floor, gathering his wheat into the barn and burning up the chaff with unquenchable fire." -- NIV

README AGAIN at L<http://www.youtube.com/profile?user=ermeyers>, if you can.

WWW::YouTube: "Keep it FUN, CLEAN and REAL," -- "to protect children!"

=head1 SEE ALSO

I<L<WWW::YouTube::Com>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::XML>> I<L<WWW::YouTube::HTML>>

=head1 AUTHOR

Copyright (C) 2006 Eric R. Meyers E<lt>ermeyers@adelphia.netE<gt>

=head1 LICENSE

perl

=cut

