package Term::Completion::Multi;

use strict;
use warnings;
use File::Spec;

our $VERSION = '0.90';

our @EXPORT_OK = qw(Complete);
use base qw(Term::Completion);

our %DEFAULTS = (
    delim => ' '
);

sub _get_defaults
{
  return(__PACKAGE__->SUPER::_get_defaults(), %DEFAULTS, delim => $DEFAULTS{delim});
}

sub Complete
{
  my ($prompt,@choices) = @_;
  $prompt = '' unless defined $prompt;
  __PACKAGE__->new(prompt => $prompt, choices => \@choices)->complete;
}

sub get_choices
{
  my __PACKAGE__ $this = shift;
  my $in = shift;
  my $delim = $this->{delim};
  my $prefix = '';
  # remove all up to and including last separator
  ($in =~ s/^(.*[$delim]+)//) && ($prefix = $1);
  #... and use that to match the choices
  map { $prefix.$_ } grep(/^\Q$in/,@{$this->{choices}});
}

sub show_choices
{
  my __PACKAGE__ $this = shift;
  my $return = shift;
  # start new line - cursor was on input line
  $this->{out}->print($this->{eol});
  my $delim = $this->{delim};
  $return =~ s/^.*[$delim]//; # delete everything up to last delimiter
  $this->_show_choices($this->get_choices($return));
}

sub post_process
{
  my __PACKAGE__ $this = shift;
  my $return = $this->SUPER::post_process(shift);
  my $delim = $this->{delim};
  $return =~ s/^[$delim]+|[$delim]+$//g;
  $return;
}

sub validate
{
  my __PACKAGE__ $this = shift;
  my $return = shift;
  unless($this->{validate}) {
    return $return;
  }
  my $ok = 1;
  my $delim = $this->{delim};
  foreach my $val (split(/[$delim]+/, $return)) {
    my $return = $this->SUPER::validate($val);
    unless(defined $return) {
      $ok = 0;
      last;
    }
  }
  return unless $ok;
  return $return;
}

1;

__END__


