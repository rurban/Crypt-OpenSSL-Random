package Crypt::OpenSSL::Random;

use strict;
use Carp;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD);

require Exporter;
require DynaLoader;
use AutoLoader;

@ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

@EXPORT_OK = qw( random_bytes random_pseudo_bytes random_seed
                 random_egd random_status );

$VERSION = '0.02';

bootstrap Crypt::OpenSSL::Random $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Crypt::OpenSSL::RSA - RSA encoding and decoding, using the openSSL libraries

Crypt::OpenSSL::Random - Routines for accessing the OpenSSL
pseudo-random number generator

=head1 SYNOPSIS

  use Crypt::OpenSSL::Random;

  

=head1 DESCRIPTION

Crypt::OpenSSL::Random provides the ability to seed and query the
OpenSSL library's pseudo-random number generator

=head2 EXPORT

None by default.

=head1 Static Methods

=item random_bytes

This function, returns a specified number of cryptographically strong
pseudo-random bytes from the PRNG.  If the PRNG has not been seeded
with enough randomness to ensure an unpredictable byte sequence, then
a false value is returned.

=item random_pseudo_bytes

This function, is similar to c<random_bytes>, but the resulting
sequence of bytes are not necessarily unpredictable.  They can be used
for non-cryptographic purposes and for certain purposes in
cryptographic protocols, but usually not for key generation etc.

=item random_seed

This function seeds the PRNG with a supplied string of bytes.  It
returns true if the PRNG has sufficient seeding.  Note: calling this
function with non-random bytes is of limited value at best!

=item random_egd

This function seeds the PRNG with data from the specified entropy
gathering daemon.  Returns the number of bytes read from the daemon on
succes, or -1 if not enough bytes were read, or if the connection to
the daemon failed.

=item random_status

This function returns true if the PRNG has sufficient seeding.


=head1 AUTHOR

Ian Robertson, iroberts@cpan.com

=head1 SEE ALSO

perl(1), rand(3), RAND_add(3), RAND_egd(3), RAND_bytes(3).

=cut
