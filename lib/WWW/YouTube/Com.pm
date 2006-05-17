##
## WWW::YouTube::Com
##
package WWW::YouTube::Com;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
my $VERSION=sprintf("%d.%02d", q$Revision: 1.2 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::YouTube::Com::ISA = qw(Exporter);

   @WWW::YouTube::Com::EXPORT = qw(); ## export required

   @WWW::YouTube::Com::EXPORT_OK = qw(user pass dev_id); ## export ok on request

} ## end BEGIN

require WWW::YouTube;

$WWW::YouTube::Com::user = 'undef'; ## YouTube username

$WWW::YouTube::Com::pass = 'undef'; ## YouTube password

$WWW::YouTube::Com::dev_id = 'undef'; ## YouTube Developer ID

END {

} ## end END

1;
__END__

=head1 NAME

WWW::YouTube::Com - (plete) setup of WWW::YouTube with needed personal parameters

=head1 SYNOPSIS

 how to use your program
 program [options]

WWW::YouTube::Com is your private package of secrets for WWW::YouTube to function.
This perl package is for your secrets to be kept (but used) by WWW::YouTube.

 Options;
# --help brief help message
# --man full documentation
=head1 OPTIONS

#=over 8
#
#=item B<--help>
#
#Print a brief help message and exits.
#
#=item B<--man>
#
#Prints the manual page and exits.
#
#=back

=head1 DESCRIPTION

 long description of your program

=head1 SEE ALSO

 need to know things before somebody uses your program

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut
