#!/usr/bin/perl -w
##

use strict;

use warnings;

#program version
##my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0728 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   ##debug## push( @ARGV, '--xml_ua_dmp' );
   ##debug## push( @ARGV, '--xml_request_dmp' );
   ##debug## push( @ARGV, '--xml_result_dmp' );

   ##debug## push( @ARGV, '--html_ua_dmp' );
   ##debug## push( @ARGV, '--html_request_dmp' );
   ##debug## push( @ARGV, '--html_result_dmp' );

} ## end BEGIN

use lib ( "$ENV{'HOME'}" );

use WWW::YouTube;

use Getopt::Long;

use Pod::Usage;

my $man = 0;
my $help = 0;

my %opts =
(
   'man' => \$man,
   'help|?' => \$help,
   %WWW::YouTube::opts,

);

##debug##WWW::YouTube::show_all_opts(); exit;

GetOptions( %opts ) || pod2usage( 2 );

pod2usage( 1 ) if ( $help );

pod2usage( '-exitstatus' => 0, '-verbose' => 2 ) if ( $man );

##debug## WWW::YouTube::show_all_opts();
##debug## WWW::YouTube::ML::show_all_opts();
##debug## WWW::YouTube::ML::API::show_all_opts();
##debug## WWW::YouTube::XML::show_all_opts();
##debug## WWW::YouTube::XML::API::show_all_opts();
##debug## WWW::YouTube::HTML::show_all_opts();
##debug## WWW::YouTube::HTML::API::show_all_opts();

WWW::YouTube::XML::demo();

END {

} ## end END

__END__

=head1 NAME

B<youtube/video/video.plx> - YouTube Developers Interface, XML-RPC API demo.

=head1 SYNOPSIS

=over

=item It's time for you to see the YouTube Developer API's page: L<http://www.youtube.com/dev>

B<$ mkdir> ~/youtube

B<$ mkdir> ~/youtube/video ## video application and data directory (We're not storing videos here)

B<$ GET>

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2008.0728/youtube/video/video.plx

> ~/youtube/video/video.plx

B<$ chmod> +x ~/youtube/video/video.plx

B<$ ~/youtube/video/video.plx>

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

=item What else just happened?

B<$ ls> -1 ~/youtube/video

lwpcookies_username.txt ## your YouTube username cookies

ugp_cache ## ugp = youtube.users.get_profile

ulf_cache ## ulf = youtube.users.list_friends

ulfv_cache ## ulfv = youtube.users.list_favorite_videos

vgd_cache ## vgd = youtube.videos.get_details

video.plx

vlbt_cache ## vlbt = youtube.videos.list_by_tag

vlbu_cache ## vlbu = youtube.videos.list_by_user

vlf_cache ## vlf = youtube.videos.list_featured

=item Look at my YouTube profile returned from the ugp_call and stored in the ugp_cache:

B<$ man> XML::Dumper

B<$ zcat> ~/youtube/video/ugp_cache/ermeyers.xml.gz | B<more>

=item Options;

--help|? brief help message

--man full documentation

=back

=head1 OPTIONS

=over

=item B<--help|?>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

Users/Videos data:

YouTube XML-RPC API demo for initial testing, training and your own WWW::YouTube Development Environment setup purpose.

=head1 SEE ALSO

I<L<WWW::YouTube>> I<L<WWW::YouTube::Com>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::XML>> I<L<WWW::YouTube::HTML>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers E<lt>ermeyers@adelphia.netE<gt>

=cut
