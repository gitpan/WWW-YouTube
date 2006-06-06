## WWW::YouTube::ML
##
package WWW::YouTube::ML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2006.0606 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::ML::ISA = qw(Exporter);

   @WWW::YouTube::ML::EXPORT = qw(); ## export required

   @WWW::YouTube::ML::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require WWW::YouTube::XML;

require WWW::YouTube::HTML;

##bad##require Term::UI;

require Term::ReadLine;

%WWW::YouTube::ML::opts =
(
   ##
   ## vlbt_opts
   ##

); ## General Public

__PACKAGE__ =~ m/^(WWW::[^:]+)((::([^:]+)){1}(::([^:]+)){0,1}){0,1}$/g;

##debug##print( "ML! $1::$4::$6\n" );

%WWW::YouTube::ML::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $4,
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::YouTube::ML::opts,
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
   ],
   'opts_type_numeric' =>
   [
      'delay_sec',

      ##
      ## vlbt_opts
      ##
      'first_page',
      'max_pages',
      'last_page',
      'per_page'

   ],
   'opts_type_string' =>
   [
      ##
      ## vlbt_opts
      ##
      'tag',
      'vlbt_want',

   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::YouTube::ML::opts_type_args{'ido'},
                                $WWW::YouTube::ML::opts_type_args{'iknow'},
                                #$WWW::YouTube::ML::opts_type_args{'iman'}
                        )
                      );

##WWW::YouTube::ML::register_all_opts( \%WWW::YouTube::ML::API::opts_type_args );

WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::ML::opts_type_args );

$WWW::YouTube::ML::numeric_first_page = WWW::YouTube::ML::numeric_first_page(1); ## to download
$WWW::YouTube::ML::numeric_max_pages = WWW::YouTube::ML::numeric_max_pages(100); ## set limit
$WWW::YouTube::ML::numeric_per_page = WWW::YouTube::ML::numeric_per_page(20); ## set default
$WWW::YouTube::ML::numeric_last_page = WWW::YouTube::ML::numeric_last_page(1); ## calc at runtime using WWW::YouTube::ML:last_page()
$WWW::YouTube::ML::numeric_delay_sec = WWW::YouTube::ML::numeric_delay_sec(); ## pacing

$WWW::YouTube::ML::string_tag = undef;

##$WWW::YouTube::ML::string_vlbt_want = 'all';##$WWW::YouTube::ML::API::string_vlbt_want;

##debug##WWW::YouTube::ML::API::show_all_opts( \%WWW::YouTube::ML::opts_type_args );

WWW::YouTube::ML::register_all_opts( \%WWW::YouTube::XML::opts_type_args );

WWW::YouTube::ML::register_all_opts( \%WWW::YouTube::HTML::opts_type_args );

push( @WWW::YouTube::ML::EXPORT_OK,
      @{$WWW::YouTube::ML::opts_type_args{'export_ok'}} );

END {

} ## end END

##
## WWW::YouTube::ML::register_all_opts
##
sub WWW::YouTube::ML::register_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::ML::API::opts_type_args;

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      $WWW::YouTube::ML::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      $WWW::YouTube::ML::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::YouTube::ML::register_all_opts

##
## WWW::YouTube::ML::show_all_opts
##
sub WWW::YouTube::ML::show_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::ML::opts_type_args;

   WWW::YouTube::ML::API::show_all_opts( $opts_type_args );

} ## end sub WWW::YouTube::ML::show_all_opts

##$WWW::YouTube::ML::numeric_first_page = WWW::YouTube::ML::numeric_first_page(); ## to download
##
## WWW::YouTube::ML::numeric_first_page
##
sub WWW::YouTube::ML::numeric_first_page
{
   my $set = shift;

   $WWW::YouTube::ML::numeric_first_page = $set if ( defined( $set ) );

   if ( ! defined( $WWW::YouTube::ML::numeric_first_page ) )
   {
      $WWW::YouTube::ML::numeric_first_page = 1;

   } ## end if

   return ( $WWW::YouTube::ML::numeric_first_page );

} ## end sub WWW::YouTube::ML::numeric_first_page

##
## WWW::YouTube::ML::numeric_max_pages
##
sub WWW::YouTube::ML::numeric_max_pages
{
   my $set = shift;

   $WWW::YouTube::ML::numeric_max_pages = $set if ( defined( $set ) );

   if ( ! defined( $WWW::YouTube::ML::numeric_max_pages ) )
   {
      if ( defined( $WWW::YouTube::ML::numeric_last_page ) )
      {
         $WWW::YouTube::ML::numeric_max_pages = +1 + $WWW::YouTube::ML::numeric_last_page -
                                                $WWW::YouTube::ML::numeric_first_page;

      }
      else
      {
         $WWW::YouTube::ML::numeric_max_pages = 1;

      } ## end if

   } ## end if

   WWW::YouTube::ML::numeric_first_page() if ( ! defined( $WWW::YouTube::ML::numeric_first_page ) );

   WWW::YouTube::ML::numeric_last_page() if ( ! defined( $WWW::YouTube::ML::numeric_last_page ) );

   return ( $WWW::YouTube::ML::numeric_max_pages );

} ## end sub WWW::YouTube::ML::numeric_max_pages

##
## WWW::YouTube::ML::numeric_per_page
##
sub WWW::YouTube::ML::numeric_per_page
{
   my $set = shift;

   my $max_per_page = 100; ## youtube limit

   my $mod_per_page = $max_per_page + 1;

   $WWW::YouTube::ML::numeric_per_page = $set % $mod_per_page if ( defined( $set ) );

   if ( ! defined( $WWW::YouTube::ML::numeric_per_page ) )
   {
      if ( defined( $WWW::YouTube::ML::numeric_max_pages ) )
      {
         $WWW::YouTube::ML::numeric_per_page = $WWW::YouTube::ML::numeric_max_pages % $mod_per_page;

      } ## end if

   } ## end if

   WWW::YouTube::ML::numeric_delay_sec();

   return ( $WWW::YouTube::ML::numeric_per_page );

} ## end sub WWW::YouTube::ML::numeric_per_page

##$WWW::YouTube::ML::numeric_last_page = WWW::YouTube::ML::numeric_last_page(); ## calc at runtime using WWW::YouTube::ML:last_page()
##
## WWW::YouTube::ML::numeric_last_page
##
sub WWW::YouTube::ML::numeric_last_page
{
   my $set = shift;

   if ( defined( $set ) )
   {
      $WWW::YouTube::ML::numeric_last_page = $set;

   }
   else
   {

   ##if ( ! defined( $WWW::YouTube::ML::numeric_last_page ) )
   ##{
      if ( defined( $WWW::YouTube::ML::numeric_max_pages ) )
      {
         $WWW::YouTube::ML::numeric_last_page = -1 + $WWW::YouTube::ML::numeric_first_page +
                                                $WWW::YouTube::ML::numeric_max_pages;
      }
      else
      {
         $WWW::YouTube::ML::numeric_last_page = $WWW::YouTube::ML::numeric_first_page;

      } ## end if

   } ## end if

   WWW::YouTube::ML::numeric_max_pages() if ( ! defined( $WWW::YouTube::ML::numeric_max_pages ) );

   return ( $WWW::YouTube::ML::numeric_last_page );

} ## end sub WWW::YouTube::ML::numeric_last_page

##$WWW::YouTube::ML::numeric_delay_sec = WWW::YouTube::ML::numeric_delay_sec(); ## pacing
##
## WWW::YouTube::ML::numeric_delay_sec
##
sub WWW::YouTube::ML::numeric_delay_sec
{
   my $set = shift;

   $WWW::YouTube::ML::numeric_delay_sec = $set if ( defined( $set ) );

   if ( ! defined( $WWW::YouTube::ML::numeric_delay_sec ) )
   {
      if ( defined( $WWW::YouTube::ML::numeric_per_page ) )
      {
         $WWW::YouTube::ML::numeric_delay_sec = floor( +0.5 * $WWW::YouTube::ML::numeric_per_page );

      }
      else
      {
         $WWW::YouTube::ML::numeric_delay_sec = 0;

      } ## end if

   } ## end if

   return ( $WWW::YouTube::ML::numeric_delay_sec );

} ## end sub WWW::YouTube::ML::numeric_delay_sec

##
## WWW::YouTube::ML::vlbt
##
sub WWW::YouTube::ML::vlbt
{
   my $h = shift;

   ##
   ## ML: so I can make XML curr_page calls right and set HTML curr_page, etc.
   ##

   if ( $WWW::YouTube::ML::API::string_vlbt_want ne 'all' )
   {
      $WWW::YouTube::XML::API::string_vlbt_want = $WWW::YouTube::ML::API::string_vlbt_want;

      $WWW::YouTube::HTML::API::string_vlbt_want = $WWW::YouTube::ML::API::string_vlbt_want;

   }
   elsif ( $WWW::YouTube::XML::API::string_vlbt_want eq $WWW::YouTube::HTML::API::string_vlbt_want )
   {
      $WWW::YouTube::ML::API::string_vlbt_want = $WWW::YouTube::XML::API::string_vlbt_want;

      $WWW::YouTube::ML::API::string_vlbt_want = $WWW::YouTube::HTML::API::string_vlbt_want;

   } # end if

   (
     $h->{'tag'},
     $h->{'first_page'},
     $h->{'last_page'},
     $h->{'per_page'},
     $h->{'video_list'},
   ) =
   (
      ( defined( $WWW::YouTube::ML::string_tag ) )?
           $WWW::YouTube::ML::string_tag : $h->{'tag'},

      WWW::YouTube::ML::numeric_first_page( $h->{'first_page'} ),

      WWW::YouTube::ML::numeric_last_page( $h->{'last_page'} ),

      WWW::YouTube::ML::numeric_per_page( $h->{'per_page'} ),

      ( defined( $h->{'video_list'} ) )?
           $h->{'video_list'} : {
                                   'ok' => 1,
                                   'action' => 'vlbt',
                                   'vlbt' => {},
                                   'just' => 'all',
                                },

   );

   $h->{'tag_canon'} = $h->{'tag'};

   $h->{'tag_canon'} =~ s/\s+/_nbsp_/g;

   if ( ! defined( $h->{'wrkdir'} ) )
   {
      $h->{'wrkdir'} = $FindBin::Bin.'/tag_'.$h->{'tag_canon'};

   } ## end if

   ##debug##WWW::YouTube::ML::show_all_opts();

   ##
   ## ML: purpose
   ##

   $h->{'video_list'}->{'tag'} = $h->{'tag'};

   if ( ( $WWW::YouTube::HTML::API::string_vlbt_want ne 'none' ) ||
        ( $WWW::YouTube::HTML::API::string_vlbt_want ne 'none' )
      )
   {
      $h = WWW::YouTube::XML::vlbt( $h ); ## does just='all' marking found_tagged=boolean;

   }
   else
   {
      print( "Expediting call with nothing to do!\n" );

   } ## end if

   if ( $WWW::YouTube::HTML::API::string_vlbt_want ne 'none' )
   {
      mkdir( $h->{'wrkdir'} ) if ( ! -e $h->{'wrkdir'} ); ## if needed

      $h->{'video_list'}->{'just'} = $WWW::YouTube::HTML::API::string_vlbt_want;

      $h = WWW::YouTube::HTML::vlbt( $h );

   } ## end if

   if ( $WWW::YouTube::XML::API::string_vlbt_want ne 'none' )
   {
      mkdir $h->{'wrkdir'} if ( ! -e $h->{'wrkdir'} ); ## if needed

      my $myxmldumper = XML::Dumper->new();

      my $myxml = "$h->{'wrkdir'}/video_list.xml.gz";

      $h->{'video_list'}->{'just'} = $WWW::YouTube::XML::API::string_vlbt_want;

      if ( $WWW::YouTube::XML::API::string_vlbt_want ne 'all' )
      {
         ##
         ## Cull
         ##
         foreach my $video_id ( keys %{$h->{'video_list'}->{'vlbt'}} )
         {
            if ( ! $h->{'found_tagged'}->{$video_id} && ( $h->{'video_list'}->{'just'} eq 'found_tagged' ) )
            {
               delete( $h->{'video_list'}->{'vlbt'}->{$video_id} );

            }
            elsif ( $h->{'found_tagged'}->{$video_id} && ( $h->{'video_list'}->{'just'} eq 'not_found_tagged' ) )
            {
               delete( $h->{'video_list'}->{'vlbt'}->{$video_id} );

            }
            elsif ( ! $h->{'found_author'}->{$video_id} && ( $h->{'video_list'}->{'just'} eq 'found_author' ) )
            {
               delete( $h->{'video_list'}->{'vlbt'}->{$video_id} );

            }
            elsif ( $h->{'found_author'}->{$video_id} && ( $h->{'video_list'}->{'just'} eq 'not_found_author' ) )
            {
               delete( $h->{'video_list'}->{'vlbt'}->{$video_id} );

            } ## end if

            delete( $h->{'found_tagged'}->{$video_id} );

            delete( $h->{'found_author'}->{$video_id} );

         } ## end foreach

         delete( $h->{'found_tagged'} );

         delete( $h->{'found_author'} );

      } ## end if

      $myxmldumper->dtd; ## In-document DTD

      $myxmldumper->pl2xml( $h, $myxml );

   } ## end if

} ## end sub WWW::YouTube::ML::vlbt

=cut
   if ( ! defined( $h->{'tag'} ) )
   {
      my $term = Term::ReadLine->new('vlbt');

      $h->{'tag'} = $term->get_reply(
                           'prompt' => 'What tag do you want?',
                           'default' => $h->{'tag_dir'},
                                    );

   } ## end if
=cut

1;
__END__ ## package WWW::YouTube::ML

=head1 NAME

WWW::YouTube::ML - WWW::YouTube Markup Language, an Abstraction

=head1 SYNOPSIS

 Options;

   TBD

=head1 OPTIONS

TBD

=head1 DESCRIPTION

ML just stands for Markup Language, in a Abstract way, for HTML, XML, SGML or YAML or whatever gets included as ML capabilities. 

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML::API>> I<L<WWW::YouTube::HTML>> I<L<WWW::YouTube::XML>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut
