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
our $VERSION = sprintf("%d.%04d", "Revision: 2006.0626" =~ /(\d+)\.(\d+)/);

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

##debug##print( "YT! $1::$4::$6\n" );

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

B<WWW::YouTube> is the I<Public> YouTube Development Interface (YTDI).

B<L<WWW::YouTube::Com>> is your I<Private> YouTube Developer's Interface.

We need your private B<user, pass and dev_id> defined here.

To use the YouTube Development Interface (YTDI) through your own YouTube Developer's Interface, you need to have a YouTube username and password, and you'll need to register with YouTube as a Developer in order to get a Developer ID for the YouTube Developer's API at L<http://www.youtube.com/dev>.

WWW::YouTube: "Keep it FUN, CLEAN and REAL," -- "to protect children."

I've been through the Lion's den over this very good visual-invention of mine, in the comp.lang.perl.modules news forum, but like Daniel did a very long time ago, I came out of the Lion's den completely unscathed, because the roaring lions, like John Bokma, had no teeth.  I know that most of you out there will be using WWW::YouTube to suit your own private video purposes, solving your own problems and satisfying your own needs, but there will be some of you out there who might also choose to help me to protect innocent children, developing teenagers and the general public from inappropriate adult content in the public domain, by occasionally using the youtube/tag/tag.plx application that will always be included as an integral part of this distribution.  Either way, for or against my central theme and the original purpose for the development of WWW::YouTube, this central tag application should always be analyzed as the current example of what can be engineered and developed for the public good, fully embracing the open-source philosophy, and fully respecting the First Amendment Rights of adults, while simply trying to protect innocent children from too many visual attacks from thoughtless individuals.  Opportunity knocks, because the technological door is being opened for all of us to explore what can be done.  The Good application has already won over the Bad application, because an instant success cannot be turned into something that is doomed to fail, John.

The youtube/video/video.plx application, also provided with this distribution, runs a simple demo, and is intended to help you to get started.

This is a functional prototype, a work in progress, so please be flexible for a while.  Thanks.

More to come, I promise.

=head1 SEE ALSO

I<L<WWW::YouTube::Com>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::XML>> I<L<WWW::YouTube::HTML>>

=head1 AUTHOR

Copyright (C) 2006 Eric R. Meyers E<lt>ermeyers@adelphia.netE<gt>

=head1 LICENSE

perl

=cut

