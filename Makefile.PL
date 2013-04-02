use ExtUtils::MakeMaker;

use lib qw(inc);
use Devel::CheckLib;
my ($libdir, $incdir);
my $args = join(" ", @ARGV);
if ($args =~ /INCDIR[ =](\S+)/) {
  $incdir = $1;
}
if ($args =~ /LIBDIR[ =](\S+)/) {
  $libdir = $1;
}
if ($libdir or $incdir) {
  eval qq{assert_lib( lib => 'ssl', header => 'openssl/rand.h', libpath => $libdir, incpath => $incdir )};
} else {
  eval q{assert_lib( lib => 'ssl', header => 'openssl/rand.h' )};
}
if ($@) {
  warn "-lssl -lcrypto not found. Need to install the openssl devel packages.\n";
}

WriteMakefile(
  'NAME'	    => 'Crypt::OpenSSL::Random',
  'VERSION_FROM'    => 'Random.pm',
  'PREREQ_PM'	    => {},
  'LIBS'            => $libdir ? [ "-L$libdir -lssl -lcrypto" ] : [ "-lssl -lcrypto" ],
  'INC'             => $incdir ? "-I$incdir" : "",
);
