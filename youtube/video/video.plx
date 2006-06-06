#!/usr/bin/perl -w
##

use strict;

use warnings;

#program version
##my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%02d", q$Revision: 1.4 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   ##debug## push( @ARGV, '--user=RediRoc' );

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

} ## end BEGIN

use lib ( "$ENV{'HOME'}" );

use WWW::YouTube::Com;

use Getopt::Long;

use Pod::Usage;

my $man = 0;
my $help = 0;
my $user = 'ermeyers';## user to lookup

##debug##
%WWW::YouTube::opts = %WWW::YouTube::opts; ## dummy
my %opts =
(
   'man' => \$man,
   'help|?' => \$help,
   'user=s' => \$user,
   %WWW::YouTube::opts,

);

##debug##WWW::YouTube::show_all_opts(); exit;

GetOptions( %opts ) || pod2usage(2);

pod2usage(1) if ( $help );

pod2usage( '-exitstatus' => 0, '-verbose' => 2 ) if ( $man );

##debug## WWW::YouTube::show_all_opts();
##debug## WWW::YouTube::ML::show_all_opts();
##debug## WWW::YouTube::ML::API::show_all_opts();
##debug## WWW::YouTube::XML::show_all_opts();
##debug## WWW::YouTube::XML::API::show_all_opts();
##debug## WWW::YouTube::HTML::show_all_opts();
##debug## WWW::YouTube::HTML::API::show_all_opts();

##debug##
WWW::YouTube::XML::API::demo( { 'request' => { 'user' => $user } } );

END {

} ## end END

__END__

=head1 NAME

youtube_video - short description of your program

=head1 SYNOPSIS

 how to use your program
 program [options]

 Options;
 --help brief help message
 --man full documentation
=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

 long description of your program

=head1 SEE ALSO

 need to know things before somebody uses your program

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers E<lt>ermeyers@adelphia.netE<gt>

=cut
