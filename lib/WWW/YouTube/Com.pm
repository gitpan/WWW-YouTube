## WWW::YouTube::Com
##
package WWW::YouTube::Com;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2006.0606 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::Com::ISA = qw(Exporter);

   @WWW::YouTube::Com::EXPORT = qw(); ## export required

   @WWW::YouTube::Com::EXPORT_OK = qw(user pass dev_id); ## export ok on request

} ## end BEGIN

require WWW::YouTube;

$WWW::YouTube::Com::user = <?php print "'$argv[1]'";?>; ## YouTube username

$WWW::YouTube::Com::pass = <?php print "'$argv[2]'";?>; ## YouTube password

$WWW::YouTube::Com::dev_id = <?php print "'$argv[3]'";?>; ## YouTube Developer ID

END {

} ## end END

1;
__END__

=head1 NAME

WWW::YouTube::Com - Complete the setup of WWW::YouTube with needed personal parameters

=head1 SYNOPSIS

WWW::YouTube::Com is your private package of secrets for WWW::YouTube to function.

This perl package is for your secrets to be kept (but used) by WWW::YouTube applications.

 Options;

   NONE

=head1 OPTIONS

NONE

=head1 DESCRIPTION

 user pass dev_id from registering with http://www.youtube.com as a developer

=head1 SEE ALSO

I<L<WWW::YouTube>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut