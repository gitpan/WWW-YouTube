## WWW::YouTube::ML::API
##
package WWW::YouTube::ML::API; ## All Markup Language API

use strict;

use warnings;

#program version
##my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2006.0606 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::ML::API::ISA = qw(Exporter);

   @WWW::YouTube::ML::API::EXPORT = qw(); ## export required

   @WWW::YouTube::ML::API::EXPORT_OK =
   (

   ); ## export ok on request

} ## end BEGIN

__PACKAGE__ =~ m/^(WWW::[^:]+)::([^:]+)(::([^:]+)){0,1}$/;

##debug## print( "API! $1::$2::$4\n" );

##debug## exit;

require DBI; require XML::Dumper; ##require SQL::Statement;

%WWW::YouTube::ML::API::opts =
(
);

%WWW::YouTube::ML::API::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $2,
   'iman'           => $4,
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::YouTube::ML::API::opts,
   'urls'           => {},
   'opts_filename'  => {},
   'export_ok'      => [],
   'opts_type_flag' =>
   [
      ##
      ## @{$WWW::YouTube::ML::API::opts_type_args{'opts_type_flag'}},
      ##
      'ua_dmp',
      'request_dmp',
      'result_dmp',
      'tree_dmp',
      'video_dmp',
      ## Customizations follow this line ##
   ],
   'opts_type_numeric' =>
   [
      'max_try'
      ## Customizations follow this line ##

   ],
   'opts_type_string' =>
   [
      'dbm_dir',
      'vlbt_want',
      ## Customizations follow this line ##
   ],

); ## this does the work with opts and optype_flag(s)

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::YouTube::ML::API::opts_type_args{'ido'},
                                $WWW::YouTube::ML::API::opts_type_args{'iknow'},
                                $WWW::YouTube::ML::API::opts_type_args{'iman'}
                        )
                      );

##debug####don't##WWW::YouTube::ML::API::create_opts_types( \%WWW::YouTube::ML::API::opts_type_args );

$WWW::YouTube::ML::API::numeric_max_try = 5;
$WWW::YouTube::ML::API::string_dbm_dir = "$ENV{'HOME'}/youtube/video/dbm/ml";
$WWW::YouTube::ML::API::string_vlbt_want = 'all';

##debug####don't##WWW::YouTube::ML::register_all_opts( \%WWW::YouTube::ML::API::opts_type_args );

##don't##push( @WWW::YouTube::ML::API::EXPORT_OK,
##don't##      @{$WWW::YouTube::ML::API::opts_type_args{'export_ok'}} );

#foreach my $x ( keys %{$WWW::YouTube::ML::API::opts_type_args{'opts'}} )
#{
#   printf( "opts{%s}=%s\n", $x, $WWW::YouTube::ML::API::opts_type_args{'opts'}{$x} );
#} ## end foreach

#foreach my $x ( @{$WWW::YouTube::ML::API::opts_type_args{'export_ok'}} )
#{
#   printf( "ok=%s\n", $x );
#} ## end foreach

#foreach my $x ( @WWW::YouTube::ML::API::EXPORT_OK )
#{
#   printf( "OK=%s\n", $x );
#} ## end foreach

##
## NOTE: Getopts hasn't set the options yet. (all flags = 0 right now)
##

END {

} ## end END

##
## WWW::YouTube::ML::API::create_opts_types
##
sub WWW::YouTube::ML::API::create_opts_types
{
   my $opts_type_args = shift || \%WWW::YouTube::ML::API::opts_type_args;

   return if ( $opts_type_args->{'myp'} eq __PACKAGE__ );

   my $Bin_dir = $FindBin::Bin;

   ##
   ## opts_type_flag: has filename and %d and init=0
   ##
   foreach my $opt_type ( @{$opts_type_args->{'opts_type_flag'}} )
   {
      my $opt_myp = $opts_type_args->{'myp'};

      my $opt_tag = "flag_$opt_type"; ## flag_x

      my $opt_ml_tag = lc( $opts_type_args->{'iknow'} ) . '_' . $opt_type; ## ml_x

      my $opt_url = "${opt_myp}::${opt_tag}"; ## __PACKAGE__::flag_x

      $opts_type_args->{'urls'}{$opt_ml_tag} = $opt_url;

      ##
      ## specifying filenames without filename suffix
      ##
      $opts_type_args->{'opts_filename'}{$opt_type} =  ## path/youtube_ml_x
                        $Bin_dir. '/' . lc( $opts_type_args->{'ido'} ) . '_' . $opt_ml_tag;

      push( @{$opts_type_args->{'export_ok'}}, $opt_tag );

      my $mycmd =
      "\n".
      '$'.$opt_url.' = 0;' ."\n".
      "\n".
      '$opts_type_args->{\'opts\'}{"'.$opt_ml_tag.'"} = \\$'.$opt_url.';' ."\n".
      "\n".
      '##' ."\n".
      '## '.$opt_url.'_prn' ."\n".
      '##' . "\n" .
      'sub '.$opt_url.'_prn' ."\n".
      '{' ."\n".
      '   printf( "'.$opt_url.'=%d\\n", $'.$opt_url.' );' ."\n".
      "\n".
      '} ## end sub '.$opt_url.'_prn' ."\n".
      "\n";

      ##debug## print( $mycmd );

      eval $mycmd || print $mycmd;

      ##debug##      eval $opt_url.'_prn();';

   } ## end foreach

   ##
   ## opts_type_numeric: has no filename and %d and =i and init=0
   ##
   foreach my $opt_type ( @{$opts_type_args->{'opts_type_numeric'}} )
   {
      my $opt_myp = $opts_type_args->{'myp'};

      my $opt_tag = "numeric_$opt_type"; ## numeric_x

      my $opt_ml_tag = lc( $opts_type_args->{'iknow'} ) . '_' . $opt_type; ## ml_x

      my $opt_url = "${opt_myp}::${opt_tag}"; ## __PACKAGE__::numeric_x

      $opts_type_args->{'urls'}{$opt_ml_tag} = $opt_url;

      push( @{$opts_type_args->{'export_ok'}}, $opt_tag );

      my $mycmd =
      "\n".
      '$'.$opt_url.' = 0;' ."\n".
      "\n".
      '$opts_type_args->{\'opts\'}{"'.$opt_ml_tag.'=i"} = \\$'.$opt_url.';' ."\n".
      "\n".
      '##' ."\n".
      '## '.$opt_url.'_prn' ."\n".
      '##' . "\n" .
      'sub '.$opt_url.'_prn' ."\n".
      '{' ."\n".
      '   printf( "'.$opt_url.'=%d\\n", $'.$opt_url.' );' ."\n".
      "\n".
      '} ## end sub '.$opt_url.'_prn' ."\n".
      "\n";

      ##debug## print( $mycmd );

      eval $mycmd || print $mycmd;

      ##debug##      eval $opt_url.'_prn();';

   } ## end foreach

   ##
   ## opts_type_string: has no filename and %s and =s and init=undef
   ##
   foreach my $opt_type ( @{$opts_type_args->{'opts_type_string'}} )
   {
      my $opt_myp = $opts_type_args->{'myp'};

      my $opt_tag = "string_$opt_type"; ## string_x

      my $opt_ml_tag = lc( $opts_type_args->{'iknow'} ) . '_' . $opt_type; ## ml_x

      my $opt_url = "${opt_myp}::${opt_tag}"; ## __PACKAGE__::string_x

      $opts_type_args->{'urls'}{$opt_ml_tag} = $opt_url;

      push( @{$opts_type_args->{'export_ok'}}, $opt_tag );

      my $mycmd =
      "\n".
      '$'.$opt_url.' = undef;' ."\n".
      "\n".
      '$opts_type_args->{\'opts\'}{"'.$opt_ml_tag.'=s"} = \\$'.$opt_url.';' ."\n".
      "\n".
      '##' ."\n".
      '## '.$opt_url.'_prn' ."\n".
      '##' . "\n" .
      'sub '.$opt_url.'_prn' ."\n".
      '{' ."\n".
      '   if ( defined( $'.$opt_url.' ) )' ."\n".
      '   {'. "\n".
      '      printf( "'.$opt_url.'=%s\\n", $'.$opt_url.' );' ."\n".
      "\n".
      '   }' ."\n".
      '   else' ."\n".
      '   {' ."\n".
      '      print ( "'.$opt_url.'=undef\n" );' ."\n".
      "\n".
      '   } ## end if' ."\n".
      "\n".
      '} ## end sub '.$opt_url.'_prn' ."\n".
      "\n";

      ##debug## print( $mycmd );

      eval $mycmd || print $mycmd;

      ##debug##      eval $opt_url.'_prn();';

   } ## end foreach

} ## end sub WWW::YouTube::ML::API::create_opts_types

##
## WWW::YouTube::ML::API::register_all_opts
##
sub WWW::YouTube::ML::API::register_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::ML::API::opts_type_args;

   return if ( $opts_type_args->{'myp'} eq __PACKAGE__ );

   ##my $myp = $opts_type_args->{'myp'};

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      ##
      ## used for Getopts
      ##
      ##eval ( '$'.$myp.'::opts_type_args{\'opts\'}{'.$opt_tag.'} = '.$opt_val . ';' );
      $WWW::YouTube::ML::API::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      ##
      ## used for ML::API
      ##
      ##eval ( '$'.$myp.'::opts_type_args{\'urls\'}{'.$opt_tag.'} = '.$opts_type_args->{'urls'}{$opt_tag}.';' );
      $WWW::YouTube::ML::API::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::YouTube::ML::API::register_all_opts

##
## WWW::YouTube::ML::API::opts_type_flag_prn
##
sub WWW::YouTube::ML::API::opts_type_flag_prn
{
   my $opts_type_args = shift || \%WWW::YouTube::ML::API::opts_type_args;

   ##debug##   print "$opts_type\n";

   foreach my $opt_tag ( sort @{$opts_type_args->{'opt_type_flag'}} )
   {
      printf( "opt_tag=%s\n", $opt_tag );

      printf( "opt_tag_url=%s\n", $opts_type_args->{'urls'}{$opt_tag} );

      $opt_tag =~ s/[=][is]$//;

      eval $opts_type_args->{'urls'}{$opt_tag} . '_prn();';

   } ## end foreach

} ## end sub WWW::YouTube::ML::API::opts_type_flag_prn

##
## WWW::YouTube::ML::API::show_all_opts
##
sub WWW::YouTube::ML::API::show_all_opts
{
   my $opts_type_args = shift || \%WWW::YouTube::ML::API::opts_type_args;

   ##debug##print caller() . " is caller\n";

   foreach my $opt_tag ( sort keys %{$opts_type_args->{'urls'}} )
   {
      eval $opts_type_args->{'urls'}{$opt_tag} . '_prn();';

   } ## end foreach

} ## end sub WWW::YouTube::ML::API::show_all_opts

1;
__END__ ## package WWW::YouTube::ML::API

=head1 NAME

WWW::YouTube::ML::API - How to Interface with YouTube in general.

=head1 SYNOPSIS

 Options;

   TBD

=head1 OPTIONS

TBD

=head1 DESCRIPTION

ML::API stands for Generic Markup Language -- Application Programming Interface

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::HTML::API>> I<L<WWW::YouTube::XML::API>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut
