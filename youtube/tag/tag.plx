#!/usr/bin/perl -w
##

use strict;

use warnings;

#program version
##my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0610 $ =~ /(\d+)\.(\d+)/);

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

   ##debug## push( @ARGV, '--html_columns=3' );

   ##debug## push( @ARGV, '--html_watch_size=small' );

   ##debug## push( @ARGV, '--html_watch_size=unconstrained' );

   ##debug## push( @ARGV, '--html_watch_size_window=large_window' );

   ##debug## push( @ARGV, '--html_vlbt_want=not_found_tagged' );

   ##debug## push( @ARGV, '--xml_vlbt_want=all' );

   ##debug## push( @ARGV, '--xml_vlbt_want=found_author' );

   ##debug## push( @ARGV, '--ml_vlbt_want=not_found_tagged' );

   ##debug## push( @ARGV, '--ml_first_page=1' );

   ##debug## push( @ARGV, '--ml_max_pages=1' );

   ##debug## push( @ARGV, '--ml_per_page=3' );

   ##debug## push( @ARGV, '--ml_delay_sec=3' );

   ##debug####problem## push( @ARGV, '--canon_tag=what_nbsp_are_nbsp_you_nbsp_doing' );

   ##debug##
   push( @ARGV, '--yt_mozilla' );

} ## end BEGIN

use lib ( ( $ENV{'HOME'} eq '/' )? '/var/www' : $ENV{'HOME'} ); ## This also accomodates the Apache Setup

use WWW::YouTube;

use Getopt::Long;

use Pod::Usage;

##
## Options
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

##debug## WWW::YouTube::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::ML::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::XML::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::XML::API::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::HTML::show_all_opts(); ##debug##exit;
##debug## WWW::YouTube::HTML::API::show_all_opts(); ##debug##exit;

WWW::YouTube::vlbt( { '$0' => $0 } );

##debug##WWW::YouTube::show_all_opts();

END {

} ## end END

__END__

=head1 NAME

B<youtube/tag/tag.plx> - L<WWW::YouTube> ( B<vlbt> = youtube.videos.list_by_tag )

=head1 SYNOPSIS

=over

=item Example #1 A 'very nice girl'?

B<$ ~/youtube/tag/tag.plx> '--ml_tag=very nice girl' --html_disarm --html_thumbnail --ml_max_pages=1

B<$ ls> ~/youtube/tag/tag_very_nbsp_nice_nbsp_girl

=item Example #2 A 'very hot girl'?

B<$ ~/youtube/tag/tag.plx> '--ml_tag=very hot girl' --html_columns=3 --ml_per_page=6 --ml_max_pages=5

B<$ ls> ~/youtube/tag/tag_very_nbsp_hot_nbsp_girl

=item Example #3 A 'keeper' link to call-on 'very hot girl' in the future?

B<$ ln> -s ~/youtube/tag/tag.plx ~/youtube/tag/tag_very_nbsp_hot_nbsp_girl.plx

B<$ rm> -Rf ~/youtube/tag/tag_very_nbsp_hot_nbsp_girl

B<$ ~/youtube/tag/tag_very_nbsp_hot_nbsp_girl.plx> --ml_first_page=99 --html_columns=1 --ml_per_page=1 --ml_max_pages=1

B<$ ls> -1 ~/youtube/tag/tag_very_nbsp_hot_nbsp_girl

_P2P0001.html

P2P0001.html

video_list.xml.gz

B<$ man> XML::Dumper

B<$ zcat> ~/youtube/tag/tag_very_nbsp_hot_nbsp_girl/video_list.xml.gz B<| more>

=item Example #4 Update your 'keeper' list

B<$ for> x in tag_*.plx;do B<$x> --html_columns=3 --ml_per_page=6 --ml_max_pages=5;done

=item Options:

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

=over

=item To protect I<children>.

I developed this program to find and flag videos as I<inappropriate> material.

README at L<http://www.youtube.com/profile?user=ermeyers>.

I run by B<youtube/tag/tag.plx> I<armed> to flag videos.

=item With regard to the colored Video I<Tag> and Video I<Author> labels displayed, corresponding to the Video's tags or the Author's username at YouTube:

I<Green>  : Found, and your tag string matched Exactly.

I<Yellow> : Found, but your tag string matched in a Partial or a Fuzzy way.

I<Red>    : no match found.

There are options for this:

--ml_vlbt_want=[all|found_(tagged|author)|not_found_(tagged|author)] ## What's saved and displayed

--xml_api_vlbt_want=[all|found_(tagged|author)|not_found_(tagged|author)] ## What's saved

--html_api_vlbt_want=[all|found_(tagged|author)|not_found_(tagged|author)] ## What's displayed

=item So now, your ready for the B<tag> application: ( B<vlbt> = youtube.videos.list_by_tag )

=back

=head2 I<Let's setup to play videos by 'tag'>

=over

=item As your I<username>:

B<$ [ ! -d ~/youtube || ! -d ~/youtube/video ] && man WWW::YouTube>

B<$ mkdir> ~/youtube/images ## youtube application images directory

B<$ GET>

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2008.0610/youtube/images/ERMpowered.gif

E<gt> ~/youtube/images/ERMpowered.gif

B<$ chmod> a+r ~/youtube/images/ERMpowered.gif

B<$ mkdir> ~/youtube/tag ## tag application directory

B<$ GET>

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2008.0610/youtube/tag/tag.plx

E<gt> ~/youtube/tag/tag.plx

B<$ chmod> +x ~/youtube/tag/tag.plx

=back

=head2 TAG SETUP [1] for Mozilla Firefox Web Browser

=over

=item This Mozilla I<Firefox> setup is an EXPERIMENTAL setup:

This is a functional prototype, a work in progress, so please be flexible for a while.  Thanks.

=item Mozilla browsers, Mozilla Firefox included, have a -remote option.

I've created a I<mozilla_tag_agent.sh script> to utilize Mozilla's remote capability.

If you have a different but compatible Mozilla browser, than you're still ok, because there's a switch available for you to override the Mozilla browser setting to use your Mozilla browser program instead.  If something's wrong, then please email me to let me know what doesn't work for you.

=item As your I<root>:

B<# mkdir> /var/www/html/images ## web application images directory

B<# GET>

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2008.0610/youtube/images/ERMpowered.gif

E<gt> /var/www/html/images/ERMpowered.gif

B<# chmod> a+r /var/www/html/images/ERMpowered.gif

B<# mkdir> /var/www/cgi-bin/youtube

B<# mkdir> /var/www/cgi-bin/youtube/tag

B<# GET>

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2008.0610/youtube/tag/mozilla_tag.php

E<gt> /var/www/cgi-bin/youtube/tag/mozilla_tag.php

B<# chmod> a+x /var/www/cgi-bin/youtube/tag/mozilla_tag.php

B<# mkdir> /var/www/youtube

B<# mkdir> /var/www/youtube/tag ## ( mozilla_tag.php --> mozilla_tag_agent.sh ) control directory

B<# ln> -s ~username/youtube /var/www/html/youtube

=item As your I<username>:

B<$ GET>

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2008.0610/youtube/tag/mozilla_tag_agent.sh

E<gt> ~/youtube/tag/mozilla_tag_agent.sh

B<$ chmod> +x ~/youtube/tag/mozilla_tag_agent.sh

=item my default browser:

B<$ ~/youtube/tag/tag.plx> --yt_canon_tag=very_nbsp_hot_nbsp_girl --yt_mozilla

B<$ ~/youtube/tag/tag.plx> --yt_canon_tag=very_nbsp_hot_nbsp_girl --yt_mozilla --yt_mozilla_bin=/usr/bin/firefox

=item select your alternative browser:

B<$ ~/youtube/tag/tag.plx> --yt_canon_tag=very_nbsp_hot_nbsp_girl --yt_mozilla --yt_mozilla_bin=/usr/bin/mozilla

=item You should see something come up, after a short period of time, like your favorite web browser with a 'very hot girl' exposing herself somewhere in it.

=item The Mozilla tag agent script

Let's see what the I<mozilla_tag_agent.sh script> was created to do for you.

=item If you don't have Mozilla Firefox, then you'll need to edit the mozilla_tag_agent.sh script to set it up for your Mozilla browser.

Find the line with "./tag.plx $CMD"

Change it to "./tag.plx $CMD --yt_mozilla_bin=/usr/bin/mozilla"

Where "/usr/bin/mozilla" is the absolutely correct path to your specific Mozilla browser.

=item Before we start the agent, let's take a look to see what is going on in the background.

I'm going to use /usr/bin/firefox here, but you should use your Mozilla browser instead.

=item As your I<username>:

B<$ ( /usr/bin/firefox http://localhost/cgi-bin/youtube/tag/mozilla_tag.php 2E<gt>&1 ) E<gt> /dev/null &>

=item I assume that the /var/www/youtube/tag directory is still empty.

B<$ ls> -1 /var/www/youtube/tag

Yep, I think it's still unused.

=item Enter the Tag: I<very hot girl> please, then press the I<Enter> button.

=item Let's take a look at what happened, and why.

B<$ ls> -1 /var/www/youtube/tag

=item I</var/www/youtube/tag/B<tag.ctl>>

Contents of tag.ctl:

--yt_mozilla --yt_canon_tag=very_nbsp_hot_nbsp_girl --ml_vlbt_want=all --ml_delay_sec=1 --ml_first_page=1 --ml_max_pages=2 --ml_per_page=6 --html_columns=3 --html_watch_size=large_window

NOTE: The canonical tag form is I<_nbsp_> for I<spaces>, meaning "non-breaking" space, like &I<nbsp>; in html.

=item I</var/www/youtube/tag/B<tag_very_nbsp_hot_nbsp_girl>>

This is simply a touched null-file eventually to be renamed I<B<tag_very_nbsp_hot_nbsp_girl>.please_delete_me> to tell the I<mozilla_tag_agent.sh script> to remove the same named tag directory along with this tag directory control file.

=item Let's start your mozilla_tag_agent.sh script to process that pending tag request in tag.ctl.

B<$ ~/youtube/tag/mozilla_tag_agent.sh>

=item We're done with the command line, so just watch the agent do its work for now.

=back

=head2 TAG SETUP [2] for Apache httpd

=over

=item This I<Apache> setup is an EXPERIMENTAL setup (Considered a I<SECURITY RISK> by SELinux).

=item So there may come a user named I<apache> to play videos by 'tag' with you.

=item As your I<username>:

B<$ chmod> -R a+w ~/youtube/video

B<$ chmod> a+w ~/youtube/tag

=item As your I<root>:

B<# ln> -s ~username/WWW /var/www/WWW

B<# ln> -s ~username/youtube /var/www/html/youtube

=item As your I<username>:

B<$ GET>

http://search.cpan.org/src/ERMEYERS/WWW-YouTube-2008.0610/youtube/tag/apache_tag.php

E<gt> ~/youtube/tag/apache_tag.php

B<$ chmod> a+x ~/youtube/tag/apache_tag.php

B<$ GET> http://localhost/youtube/tag/tag.php ## DOES THIS WORK FOR YOU NOW?

=item I<About my SELinux>:

I currently have FC4 Linux, Apache 2.0, and I couldn't use perl, or CGI.pm or load mod_perl.so at all.

My SELinux didn't allow me to run perl CGI scripts under Apache's httpd.

My SELinux didn't allow me to load mod_perl.so into Apache's httpd in perl.conf.

My SELinux didn't allow me to use symbolic links under Apache's httpd directories.

My FC4 Linux 'Security Level Config' script is named /usr/bin/system-config-securitylevel.

I checked "Disable SELinux protection for httpd daemon," so that I could run perl CGI scripts.

I'm not happy with this SELinux configuation issue, since it's being considered an SELinux SECURITY RISK, so I developed TAG SETUP [1] for Mozilla Firefox Web Browser.  Now I'm very happy. ( #; >#)##

=back

=head1 SEE ALSO

What else is there to see, after seeing some 'very hot girl' on YouTube?

You asked...

I<L<WWW::YouTube>> I<L<WWW::YouTube::Com>> I<L<WWW::YouTube::ML>> I<L<WWW::YouTube::XML>> I<L<WWW::YouTube::HTML>>

=head1 AUTHOR

Copyright (C) 2006 Eric R. Meyers E<lt>ermeyers@adelphia.netE<gt>

=cut
