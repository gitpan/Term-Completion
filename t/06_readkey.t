#!/perl

use strict;

my %test_arg;
BEGIN {
  %test_arg = ( tests => 3 );
  eval { require Term::ReadKey };
  if($@) {
    %test_arg = (skip_all => 'Term::ReadKey is required for testing Term::Completion qw(:POSIX)');
  }
}
use Test::More %test_arg;

use_ok('Term::Completion' => qw(:readkey));

my $tc = Term::Completion->new();

ok(eval { $tc->set_raw_tty; $tc->reset_tty; 1; } && !$@, "ReadKey tty methods work OK");

ok(eval { $tc->get_term_size; 1; } && !$@, "ReadKey tty method works OK");

