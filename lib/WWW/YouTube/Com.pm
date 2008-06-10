##
## WWW::YouTube::Com
##
package WWW::YouTube::Com;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0610 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::Com::ISA = qw(Exporter);

   @WWW::YouTube::Com::EXPORT = qw(); ## export required

   @WWW::YouTube::Com::EXPORT_OK = qw(); ## export ok on request

} ## end BEGIN

$WWW::YouTube::Com::user = <?php print "'$argv[1]'";?>; ## YouTube username

$WWW::YouTube::Com::pass = <?php print "'$argv[2]'";?>; ## YouTube password

$WWW::YouTube::Com::dev_key = <?php print "'$argv[3]'";?>; ## YouTube Developer key

$WWW::YouTube::Com::clnt_id = <?php print "'$argv[4]'";?>; ## YouTube Client ID

END {

} ## end END

1;
__END__

=head1 NAME

WWW::YouTube::Com - Complete the setup of WWW::YouTube with needed personal parameters

=head1 SYNOPSIS

$ mkdir ~/WWW

$ mkdir ~/WWW/YouTube

/usr/bin/php $PERLLIB/WWW/YouTube/Com.pm B<user pass dev_key clnt_id> > ~/WWW/YouTube/Com.pm

-- NOTE: php ...

=head1 OPTIONS

 B<user pass dev_key clnt_id>

=head1 DESCRIPTION

B<WWW::YouTube::Com> is your private package of secrets for B<WWW::YouTube> to function.

This perl package is for your secrets to be kept at home (but used) by B<WWW::YouTube> applications.

=head1 SEE ALSO

I<L<WWW::YouTube>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut
