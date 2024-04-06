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

#use IO::Async::Timer::Periodic;
#use IO::Async::Loop;
use Proc::Simple;
$VERSION = "2.1";
%IRSSI = (
          authors     => 'oxagast',
          contact     => 'oxagast@oxasploits.com',
          name        => 'franklin_helper',
          description => 'Franklin LLM AI bot',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'Mar, 11th 2024',
);
Irssi::signal_add_last('message public', 'chncll');
Irssi::settings_add_str("franklin_helper", "franklin_admin", "");
my $owner = Irssi::settings_get_str('franklin_admin');
my $logf  = Irssi::settings_get_str('franklin_log');
sub resetworker {
  while (1) {
    sleep 900;
    system->command("script unload franklin.pl");                                                  # these make sure if something unexpected
    system->command("script load franklin.pl");                                                    # causes a lockup, it reloads automatically
  }
}
$resetloop = Proc::Simple->new();
$resetloop->start(\&resetworker);


sub chncll {
  my ($server, $msg, $nick, $address, $channel) = @_;
  my $ln = $server->{nick};

  # these commands can be used by anybody
  if ($msg =~ m/^$ln[:|,] reload/i) {
    $server->command("script unload franklin.pl");
    $server->command("script load franklin.pl");
  }
  if ($nick eq $owner) {                                                                           # these may only be used by botmaster
    if ($msg =~ m/^$ln[:|,] levelup/i) {
      $server->command("op $channel $nick");
    }
    if ($msg =~ m/^$ln[:|,] reboot/i) {
      system("sudo /sbin/reboot");
    }
  }
}
