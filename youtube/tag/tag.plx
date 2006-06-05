#!/usr/bin/perl -w
##

use strict;

use warnings;

#program version
##my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%02d", q$Revision: 1.4 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   ##debug## push( @ARGV, '--xml_ua_dmp' );
   ##debug## push( @ARGV, '--xml_request_dmp' );
   ##debug## push( @ARGV, '--xml_result_dmp' );
   ##debug## push( @ARGV, '--xml_tree_dmp' );
   ##debug## push( @ARGV, '--xml_video_dmp' );

   ##debug## push( @ARGV, '--html_ua_dmp' );
   ##debug## push( @ARGV, '--html_request_dmp' );
   ##debug## push( @ARGV, '--html_result_dmp' );
   ##debug## push( @ARGV, '--html_tree_dmp' );
   ##debug## push( @ARGV, '--html_video_dmp' );

   ##debug## push( @ARGV, '--html_disarm' );

   ##debug## push( @ARGV, '--html_auto_play' );

   ##debug## push( @ARGV, '--html_thumbnail' );

   ##debug## push( @ARGV, '--html_body_bgcolor=Cyan' );

   ##debug## push( @ARGV, '--html_columns=5' );

   ##debug## push( @ARGV, '--html_watch_size=small' );

   ##debug## push( @ARGV, '--html_watch_size=unconstrained' );

   ##debug## push( @ARGV, '--html_watch_size_window=large_window' );

   ##debug## push( @ARGV, '--html_vlbt_want=not_found_tagged' );

   ##debug## push( @ARGV, '--xml_vlbt_want=all' );

   ##debug## push( @ARGV, '--xml_vlbt_want=found_author' );

   ##debug## push( @ARGV, '--ml_vlbt_want=not_found_tagged' );

   ##debug## push( @ARGV, '--ml_first_page=1' );

   ##debug## push( @ARGV, '--ml_max_pages=1' );

   ##debug## push( @ARGV, '--ml_per_page=10' );

   ##debug## push( @ARGV, '--ml_delay_sec=3' );

   ##debug####problem## push( @ARGV, '--ml_tag=what are you doing' );

} ## end BEGIN

use lib ( ( $ENV{'HOME'} eq '/' )? '/var/www' : $ENV{'HOME'} );

use WWW::YouTube::Com;

use Getopt::Long;

use Pod::Usage;

use File::Basename;

##
## --disarm: for my kid to view tagged videos, but not able to flag them
##
my $man = 0;
my $help = 0;

my %opts =
(
   'man' => \$man,
   'help|?' => \$help,
   %WWW::YouTube::opts,

);

GetOptions( %opts ) || pod2usage( 2 );

pod2usage( 1 ) if ( $help );

pod2usage( '-exitstatus' => 0, '-verbose' => 2 ) if ( $man );

chdir( File::Basename::dirname( $0 ) ); ## this move is very critical

##debug## WWW::YouTube::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::ML::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::XML::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::XML::API::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::HTML::API::show_all_opts(); ##debug##exit;

my $something_someday = undef;

WWW::YouTube::vlbt( { 'tag' => $something_someday } ); ## this tag does work yet (not used)

END {

} ## end END

__END__

=head1 NAME

youtube/tag - short description of your program

=head1 SYNOPSIS

 how to use your program

=head1 DESCRIPTION

 long description of your program

=head1 SEE ALSO

 need to know things before somebody uses your program

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers E<lt>ermeyers@adelphia.netE<gt>

=cut
