## WWW::YouTube::XML
##
package WWW::YouTube::XML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2006.0606 $ =~ /(\d+)\.(\d+)/);

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

#require File::Spec::Unix;

require File::Basename;

require Date::Format;

require String::Approx;

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

##
## WWW::YouTube::XML::vgd
##
sub WWW::YouTube::XML::vgd  ## NOTE: changing this to collect data for xml dump
{
   my $h = shift;

   ##
   ## XML: purpose
   ##

   my $iam = 'vgd';

   my $ihave = 'video_detail';

   my $video_id = $h->{'video_id'};

   my $vgd = undef; ## video_get_details

   my $try = 1; ## reset

   while ( $try++ <= $WWW::YouTube::XML::API::numeric_max_try )
   {
      $vgd = $WWW::YouTube::XML::API::action{$iam}->( { 'request' =>
                                                    {
                                                       'video_id' => $video_id,
                                                    }
                                               } );

      last if ( $vgd->{'ok'} );

      sleep $WWW::YouTube::ML::numeric_delay_sec; ## pacing requests

   } ## end while

   if ( $vgd->{'ok'} )
   {
      ##
      ## Process vgd page
      ##

      delete( $vgd->{'ok'} );

      $h->{$ihave}->{'tag'} = $h->{'video_list'}->{'tag'};

      while ( my ( $video_gd_tag, $video_gd_tag_val ) = each( %{$vgd->{$video_id}} ) )
      {
         ##debug##printf( STDERR "XML::$iam %s => %s\n", $video_gd_tag, $video_gd_tag_val );

         $h->{$ihave}->{$iam}{$video_id}{$video_gd_tag} = $video_gd_tag_val;

      } ## end while

      $h->{$ihave}->{'ok'} = 1;

      $h->{$ihave}->{$iam}->{$video_id}->{'tags'} =~ s/[\s]+/ /g;

      $h->{$ihave}->{$iam}->{$video_id}->{'title'} =~ s/[\s]+/ /g;

      $h->{$ihave}->{$iam}->{$video_id}->{'description'} =~ s/[\s]+/ /g;

      if ( defined( $h->{$ihave}->{'tag'} ) )
      {
         if ( ! defined( $h->{$ihave}->{$iam}->{$video_id}->{'author'} ) )
         {
            $h->{$ihave}->{$iam}->{$video_id}->{'author'} = '';

            $h->{'found_author'}->{$video_id} = 0; ## % certain

         }
         else
         {
            $h->{$ihave}->{$iam}->{$video_id}->{'author'} =~ s/[\s]+/ /g;

            if ( $h->{$ihave}->{$iam}->{$video_id}->{'author'} =~ m/$h->{$ihave}->{'tag'}/i )
            {
               $h->{'found_author'}->{$video_id} = 100; ## % certain

               $h->{$ihave}->{$iam}->{'author'}{
                  $h->{$ihave}->{$iam}->{$video_id}->{'author'}
                                                        }->{'videos'}{$video_id} = 1;
=cut
               ##debug##
               printf( "XML::${iam}_author=%s\tvideos=%d\n",
                       $h->{$ihave}->{$iam}->{$video_id}->{'author'},
                       0 + keys %{$h->{$ihave}->{$iam}->{'author'}{
                                     $h->{$ihave}->{$iam}->{$video_id}->{'author'}
                                                                  }->{'videos'}
                                 }
                     );
=cut
            }
            else
            {
               $h->{'found_author'}->{$video_id} = 0; ## % certain

            } ## end if

         } ## end if

      } ## end if

   }
   else
   {
      $h->{$ihave}->{'ok'} = 0; ## some vgd was bad

   } ## end if

   return ( $h );

} ## end sub WWW::YouTube::XML::vgd

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

   my $curr_page = $h->{'first_page'};

   my $item_cnt = 0;

   my $item_cnt_saved = $item_cnt;

   my $vlbt = undef; ## video_list_by_tag

   $h->{$ihave}->{'tag'} = $h->{'tag'};

   next_vlbt: ## goto label

   my $try = 1; ## reset

   while ( $try++ <= $WWW::YouTube::XML::API::numeric_max_try )
   {
      $vlbt = $WWW::YouTube::XML::API::action{$iam}->( { 'request' =>
                                                     {
                                                        'tag' => $h->{$ihave}->{'tag'},
                                                        'per_page' => $h->{'per_page'},
                                                        'page' => $curr_page,
                                                     }
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
         ##debug##printf( STDERR "XML::$iam %s => %s\n", $video_id_tag, $video_id_tag_val );

         $h->{$ihave}->{$iam}{$video_id_tag} = $video_id_tag_val;

         $item_cnt++; ## means something came back in this

      } ## end while

      if ( $item_cnt > $item_cnt_saved )
      {
         $curr_page++;

         goto next_vlbt if ( $curr_page <= $h->{'last_page'} );

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
=cut
            ##debug##
            printf( "XML::${iam}_author=%s\tvideos=%d\n",
                    $h->{$ihave}->{$iam}->{$video_id}->{'author'},
                    0 + keys %{$h->{$ihave}->{$iam}->{'author'}{
                                  $h->{$ihave}->{$iam}->{$video_id}->{'author'}
                                                               }->{'videos'}
                              }
                  );
=cut
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
            ##debug##printf( "XML::${iam}_tag=%s\n", $x );

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

 Options;

   TBD

=head1 OPTIONS

TBD

=head1 DESCRIPTION

   WWW::YouTube XML Layer.

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::HTML>> I<L<WWW::YouTube::XML::API>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut

