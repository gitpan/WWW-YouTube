##

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
our $VERSION = sprintf("%d.%04d", "Revision: 2006.0606" =~ /(\d+)\.(\d+)/);

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

   my $iam = File::Basename::basename( $0 );

   die ( "\$0=$0\n" ) if ( ! defined( $iam ) || ( $iam eq '' ) );

   my $ml_tag = undef;

   my $ml_tag_subdir = undef;

   my $dflt_ml_tag_subdir = undef;

   if ( defined( $WWW::YouTube::ML::string_tag ) )
   {
      $ml_tag = $WWW::YouTube::ML::string_tag;
   }
   else
   {
      $iam =~ m/^([^_]+_([^.]+))[.]plx$/ || die "no basename match to start (iknow_iam.plx)\n";

      ( $ml_tag, $ml_tag_subdir ) = ( $2, $1 ); ##debug##print $tag . "\n";exit;

   } ## end if

   if ( defined ( $WWW::YouTube::ML::string_tag_subdir ) )
   {
      $ml_tag_subdir = $WWW::YouTube::ML::string_tag_subdir

   } ## end if

   WWW::YouTube::ML::vlbt( { 'tag' => $ml_tag, 'tag_subdir' => $ml_tag_subdir } );

} ## end sub WWW::YouTube::vlbt

1;
__END__ ## package WWW::YouTube

=head1 NAME

WWW::YouTube - YouTube Developer Interface

=head1 SYNOPSIS

use lib ( $ENV{'HOME'} );

use WWW::YouTube::Com; ## SEE DESCRIPTION

 Options;

   TBD

=head1 OPTIONS

TBD

=head1 DESCRIPTION

B<WWW::YouTube> is the I<Public> YouTube Development Interface.

B<L<WWW::YouTube::Com>> is your I<Private> YouTube Development Interface.

We need your private user, pass and dev_id defined here.

To use this YouTube Developer Interface, you need to have a YouTube username and password, and you'll need to register with YouTube as a Developer in order to get a Developer ID for the YouTube XMLRPC API.

By the way, you need to go to YouTube at http://www.youtube.com to do your registering, and you must think up a really good excuse for wanting to become a registered YouTube Developer.  Something like helping me to develop programs to protect registered teenagers and the General Public, including children, from being exposed to too much adult content and other inappropriate material might work.

http://www.youtube.com/profile?user=ermeyers

Just because a YouTube video has been flagged as inappropriate material for the General Public, doesn't mean that you, as a registered adult, can't watch it.  Flagging keeps YouTube registered teenagers, and YouTube's unregistered viewing General Public, including children, from being able to view the contents of a video identified as an inappropriate video.

You'll need to educate yourself a little bit, and experiment with YouTube directly, before going Hog Wild with my YouTube applications, like I do, flagging video after video.  That's my purpose for this development project.

http://www.youtube.com
http://www.youtube.com/dev

-- So, now about your future YouTube development projects:

$ mkdir ~/WWW

$ mkdir ~/WWW/YouTube

/usr/bin/php $PERLLIB/WWW/YouTube/Com.pm B<user pass dev_id> > ~/WWW/YouTube/Com.pm

-- NOTE: php ...

-- Users/Videos data: XML-RPC Interface demo for this initial testing, training and development environment setup purpose.

$ mkdir ~/youtube

$ mkdir ~/youtube/video ## video application and data directory (We're not storing videos here)

$ GET

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2006.0606/youtube/video/video.plx

> ~/youtube/video/video.plx

$ chmod +x ~/youtube/video/video.plx

-- It's time for you to see this YouTube Developer API's page: http://www.youtube.com/dev

$ ~/youtube/video/video.plx

WWW::YouTube::XML::API::action{ugp_cache}:

Calling $WWW::YouTube::XML::API::action{ugp_call}

WWW::YouTube::XML::API::action{ulfv_cache}:

Calling $WWW::YouTube::XML::API::action{ulfv_call}

WWW::YouTube::XML::API::action{ulf_cache}:

Calling $WWW::YouTube::XML::API::action{ulf_call}

WWW::YouTube::XML::API::action{vlf_call}:

WWW::YouTube::XML::API::action{vgd_cache}:

Calling $WWW::YouTube::XML::API::action{vlf_call}

Calling $WWW::YouTube::XML::API::action{vgd_call}

WWW::YouTube::XML::API::action{vlbt_cache}:

Calling $WWW::YouTube::XML::API::action{vlbt_call}

WWW::YouTube::XML::API::action{vlbu_cache}:

Calling $WWW::YouTube::XML::API::action{vlbu_call}

WWW::YouTube::XML::API::action{vlf_cache}:

Calling $WWW::YouTube::XML::API::action{vlf_call}

-- What else just happened?

$ ls -1 ~/youtube/video

lwpcookies_username.txt ## your YouTube username cookies

ugp_cache ## ugp = youtube.users.get_profile

ulf_cache ## ulf = youtube.users.list_friends

ulfv_cache ## ulfv = youtube.users.list_favorite_videos

vgd_cache ## vgd = youtube.videos.get_details

video.plx

vlbt_cache ## vlbt = youtube.videos.list_by_tag

vlbu_cache ## vlbu = youtube.videos.list_by_user

vlf_cache ## vlf = youtube.videos.list_featured

-- Look at my YouTube profile returned from the ugp_call and stored in the ugp_cache

$ zcat ~/youtube/video/ugp_cache/ermeyers.xml.gz | more

$ man XML::Dumper

-- OK?

-- And, so now, your ready for my 'tag' application: ( vlbt = youtube.videos.list_by_tag )

-- Let's setup to play videos by 'tag'

-- As your username:

$ mkdir ~/youtube/tag ## tag application directory

-- There will come a very helpful user named apache to play videos by 'tag' with you!

-- NOTE: SELinux causes problems running perl under Apache [ email me, if need be ]

$ chmod -R a+w ~/youtube/video

$ chmod a+w ~/youtube/tag

-- As your root:

# ln -s ~username/youtube /var/www/youtube

# ln -s ~username/WWW /var/www/WWW

# ln -s ~username/youtube /var/www/html/youtube

-- As your username:

$ GET

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2006.0606/youtube/tag/images/ERMpowered.gif

> ~/youtube/tag/images/ERMpowered.gif

$ chmod a+r ~/youtube/tag/images/ERMpowered.gif

$ GET

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2006.0606/youtube/tag/tag.php

> ~/youtube/tag/tag.php

$ chmod a+x ~/youtube/tag/tag.php

$ GET

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2006.0606/youtube/tag/tag.plx

> ~/youtube/tag/tag.plx

$ chmod a+x ~/youtube/tag/tag.plx

$ GET http://localhost/youtube/tag/tag.php ## DOES IT WORK FOR YOU NOW?

-- Security Level Config: /usr/bin/system-config-securitylevel.

-- Try checking "Disable SELinux protection for httpd daemon," so that you can run perl scripts under Apache.

-- Currently I have FC4 Linux, Apache 2.0, and I couldn't do Perl CGI.pm or load mod_perl at all. :(

-- NOTE: ~/youtube/tag/tag.plx works from the command line too, but it's not as much fun that way.

$ ~/youtube/tag/tag.plx '--ml_tag=very nice girl' --html_disarm --html_thumbnail --ml_max_pages=1

$ ls ~/youtube/tag/tag_very_nbsp_nice_nbsp_girl

$ ~/youtube/tag/tag.plx '--ml_tag=very hot girl' --html_columns=3 --ml_per_page=6 --ml_max_pages=5

$ ls ~/youtube/tag/tag_very_nbsp_hot_nbsp_girl

Matthew 3:12, "His winnowing fork is in his hand, and he will clear his threshing floor, gathering his wheat into the barn and burning up the chaff with unquenchable fire." -- NIV

--I've got I<children>, and I developed this program to flag videos as I<inappropriate> material. I run by tag to flag junk videos.

  * P : Pornography or Obscenity
  * I : Illegal Acts
  * G : Graphic Violence
  * R : Racially or Ethnically Offensive Content

  * S : Submit to YouTube

I'd like your help with this protective flagging effort, on occasion.  Thanks.

With regard to the colored Video "Tag" and Video "Author" labels displayed, corresponding to the Video's tags or the Author's username at YouTube:

  * Green  : Found, and your tag string matched Exactly.
  * Yellow : Found, but your tag string matched in a Partial or a Fuzzy way.
  * Red    : no match found.

I have tag display options for this:

  --ml_want=[all|found|not_found] ## What's saved and displayed

  --xml_want=[all|found|not_found] ## What's saved

  --html_want=[all|found|not_found] ## What's displayed

=head1 SEE ALSO

What else is there to see, after seeing some '--ml_tag=very hot girl' on YouTube?  You asked...

I<L<WWW::YouTube::Com>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::XML>> I<L<WWW::YouTube::HTML>> 

=head1 AUTHOR

Eric R. Meyers <ermeyers@adelphia.net>

=head1 LICENSE

perl

=head1 COPYRIGHT

Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut

