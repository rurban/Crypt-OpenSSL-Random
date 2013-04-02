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
   ($ExtUtils::MakeMaker::VERSION gt '6.46' ?
    ('LICENSE'     => 'perl',
     'META_MERGE'  =>
     {
      resources =>
      {
       homepage    => 'http://sourceforge.net/projects/perl-openssl/',
       repository  => 'http://perl-openssl.cvs.sourceforge.net/viewvc/perl-openssl/Crypt/OpenSSL/Random/',
       license     => 'http://dev.perl.org/licenses/',
       MailingList => 'perl-openssl-users@lists.sourceforge.net',
      },
     }
    ) : ()),
    SIGN => 1
);

package MY;
use Config;

sub top_targets {
  local $_ = shift->SUPER::top_targets(@_);
  s/\$\(FIRST_MAKEFILE\) blibdirs/\$(FIRST_MAKEFILE\) blibdirs README/;
  $_
}

sub depend {
  "
README : \$(VERSION_FROM)
	pod2text \$(VERSION_FROM) > README

release : dist
	git commit -a -m\"release \$(VERSION)\"
	git tag \$(VERSION)
	cpan-upload \$(DISTVNAME).tar\$(SUFFIX)
	git push
	git push --tags

gcov : \$(BASEEXT).c.gcov \$(BASEEXT).gcov cover_db/\$(BASEEXT)-xs.html

\$(BASEEXT).c.gcov \$(BASEEXT).xs.gcov : \$(BASEEXT).xs
	\$(MAKE) CCFLAGS=\"\$(CCFLAGS) -fprofile-arcs -ftest-coverage\" LDDLFLAGS=\"\$(LDDLFLAGS) -fprofile-arcs -ftest-coverage\"
	gcov \$(BASEEXT).c \$(BASEEXT).xs

cover_db/\$(BASEEXT)-xs.html : \$(BASEEXT).xs.gcov
	PERL5OPT=-MDevel::Cover make test
	-$^X -S gcov2perl \$(BASEEXT).c.gcov \$(BASEEXT).xs.gcov
	$^X -S cover

gprof :
	\$(MAKE) CCFLAGS=\"\$(CCFLAGS) -pg\" LDDLFLAGS=\"\$(LDDLFLAGS) -pg\"
"
}
