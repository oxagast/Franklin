#!/usr/bin/perl
# Author: by oxagast
#
# Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
#                  ,   .
#   ,-             |   | o
#   |  ;-. ,-: ;-. | , | . ;-.
#   |- |   | | | | |<  | | | |
#   |  '   `-` ' ' ' ` ' ' ' '
#  -'
use Irssi;
use Data::Dumper;
use vars qw($VERSION %IRSSI);
$VERSION = "1.3";
%IRSSI = (
          authors     => 'oxagast',
          contact     => 'oxagast@oxasploits.com',
          name        => 'franklin_profiler',
          description => 'Franklin ChatGPT bot user profiler database',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'October, 21st 2023',
);

Irssi::signal_add_last('message public', 'record');

Irssi::settings_add_str("franklin_helper", "franklin_helper_admin", "");
my $owner = Irssi::settings_get_str('franklin_helper_admin');
our $summd = "./summarydb";

sub record {
  my ($server, $msg, $nick, $address, $channel) = @_;
  my $ln = $server->{nick};
  open(PROF, '<', "$summd/$nick") or die $!;
  my @ll = <>;
  close(PROF);
  chomp(@ll);
  if (scalar($ll) >= 10) {
  open(PROF, '>>', "$summd/$nick") or die $!;
  for $nline (1..scalar($ll)-1) {
    print PROF "$nline\n"
  }
  print PROF "$msg\n";
} else {
  print PROF "$msg\n";
}
  close(PROF);
}


