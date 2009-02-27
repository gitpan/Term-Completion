package Term::Completion::Path;

use strict;
use warnings;
use File::Spec;

our $VERSION = '0.90';

our @EXPORT_OK = qw(Complete);
use base qw(Term::Completion);

# ugly way to get the separator - an API for that would be nice
my $sep = File::Spec->catfile(qw(A B));
if($sep) {
  $sep =~ s/^A|B$//g;
} else {
  $sep = ($^O =~ /win/i ? "\\" : "/");
}

our %DEFAULTS = (
    sep => $sep
);

sub _get_defaults
{
  return(__PACKAGE__->SUPER::_get_defaults(), %DEFAULTS);
}

sub Complete
{
  my $prompt = shift;
  $prompt = '' unless defined $prompt;
  __PACKAGE__->new(prompt => $prompt)->complete;
}

sub get_choices
{
  my __PACKAGE__ $this = shift;
  map { (-d) ? "$_/" : $_ } glob("$_[0]*");
}

sub post_process
{
  my __PACKAGE__ $this = shift;
  my $return = $this->SUPER::post_process(shift);
  my $sep = $this->{sep};
  $return =~ s/\Q$sep\E$//;
  $return;
}

# TODO validate should have methods to check for file/dir/link

1;

