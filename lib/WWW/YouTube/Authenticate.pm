package WWW::YouTube::Authenticate;

use warnings;
use strict;

=head1 NAME

WWW::YouTube::Authenticate - Login handler for Google services

=head1 VERSION

Version 0.01

=cut

#our $VERSION = '0.01';
#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0610 $ =~ /(\d+)\.(\d+)/);

=head1 SYNOPSIS

WWW::YouTube::Authenticate handles the login procedures for Google services.

This module is a base class for WWW::YouTube::GData.  Unless you want to write
your own GData module, or equivalent, you're not going to be using this module.

=cut

use Carp;

use base qw( Class::Accessor Class::ErrorHandler );

__PACKAGE__->mk_accessors(qw(

  Email Passwd source _auth

));

=head1 FUNCTIONS

=head2 accountType (required)

Valid values are B<HOSTED>, B<GOOGLE> or B<HOSTED_OR_GOOGLE>.

Defaults to B<HOSTED_OR_GOOGLE>.

=cut

sub _valid_accountType { qw( HOSTED GOOGLE HOSTED_OR_GOOGLE ) }

sub _default_accountType { 'HOSTED_OR_GOOGLE' }

sub accountType {

  my $self = shift;

  return $self->SUPER::get( 'accountType' )
    unless @_;

  my $type = uc shift;

  my @valid = _valid_accountType;

  return $self->error( "Invalid accountType: $type" )
    unless grep { $type eq $_ } @valid;

  $self->SUPER::set( 'accountType', $type );

}

=head2 Email (required)

Email address used as the login for the requested service.

=head2 Passwd (required)

Password used for the Email login for the requested service.

=head2 service (required)

Must be a valid service code, but only carps when it doesn't recognize a code
to allow for new services to be added.

Check the documentation for the service you're writing code for.  Also,
L<http://code.google.com/support/bin/answer.py?answer=62712&topic=10433>
has a list of service codes.

Currently known codes are as follows:

  Service                       Code
  ----------------------------  -------
  YouTube data API	        youtube
  Default Service               youtube

Defaults to B<xapi>.

=cut

sub _valid_service { qw( youtube ) }

sub _default_service { 'youtube' }

sub service {

  my $self = shift;

  return $self->SUPER::get( 'service' )
    unless @_;

  my $code = lc shift;

  my @known = _valid_service;

  $self->error( "Unknown service code: $code" )
    unless grep { $code eq $_ } @known;

  $self->SUPER::set( 'service', $code );

}

#=head2 logintoken (optional)
#
#Not implemented at this time.
#
#=head2 logincaptcha (optional)
#
#Not implemented at this time.

=head2 login

Login to the google services page.

=cut

sub login {

  my $self = shift;

  my @required = qw( accountType Email Passwd service source );

  no warnings 'uninitialized';

  my $missing = join ', ', grep { $self->$_ eq '' } @required;

  return $self->error( "Missing required fields: $missing" )
    if $missing;

  use warnings 'uninitialized';

  my %params = map { ( $_ , $self->$_ ) } @required;

  no warnings 'uninitialized';

  my $r = $self->_ua->post( 'https://www.google.com/youtube/accounts/ClientLogin', \%params );

  if ( $r->code == 403 ) {

    my ( $error ) = $r->content =~ m!Error=(.+)(\s+|$)!i;

    return $self->error( "Invalid login: $error (" . _error_code( $error ) . ')' );

  } elsif ( $r->code == 200 ) {

    my ( $auth ) = $r->content =~ m!Auth=(.+)(\s+|$)!i;

    croak 'PANIC: Got a valid response from Google, but can\'t find Auth string'
      if $auth eq '';

    $self->_auth( $auth );

  } else {

    # If we get here then something's up with Google's website
    # http://code.google.com/apis/accounts/AuthForInstalledApps.html#Response
    # or else with our connection.

    croak 'PANIC: Got unexpected response (' . $r->code . ')';

  }
}

=head1 PRIVATE FUNCTIONS

=head2 _error_code

Takes an error code returned from Google and returns the explanatory text found at
L<http://code.google.com/apis/accounts/AuthForInstalledApps.html#Errors>.

=cut

{ my %codes = (

    'BadAuthentication'  => 'The login request used a username or password that is not recognized.',

    'NotVerified'        => 'The account email address has not been verified. The user will need to '
                         .  'access their Google account directly to resolve the issue before logging '
			 .  'in using a non-Google application.',

    'TermsNotAgreed'     => 'The user has not agreed to terms. The user will need to access their '
                         .  'Google account directly to resolve the issue before logging in using a '
			 .  'non-Google application.',

    'CaptchaRequired'    => 'A CAPTCHA is required. (A response with this error code will also contain '
                         .  'an image URL and a CAPTCHA token.)',

    'Unknown'            => 'The error is unknown or unspecified; the request contained invalid input '
                         .  'or was malformed.',

    'AccountDeleted'     => 'The user account has been deleted.',

    'AccountDisabled'    => 'The user account has been disabled.',

    'ServiceDisabled'    => 'The user\'s access to the specified service has been disabled. (The user '
                         .  'account may still be valid.)',

    'ServiceUnavailable' => 'The service is not available; try again later.',

  );

  sub _error_code { return exists $codes{ $_[1] } ? $codes{ $_[1] } : $codes{ 'Unknown' } }

  sub _codes { %codes } # This is for testing

}


=head1 AUTHOR

Eric R. Meyers, C<< <Eric.R.Meyers@gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-net-google-gdata at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-YouTube-Authenticate>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::YouTube::Authenticate

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-YouTube-Authenticate>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-YouTube-GData>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-YouTube-GData>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-YouTube-GData>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008 Eric R. Meyers <Eric.R.Meyers@gmail.com>, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WWW::YouTube::Authenticate
