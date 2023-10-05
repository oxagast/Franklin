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
          contact     => 'marshall@oxagast.org',
          name        => 'franklin_helper',
          description => 'Franklin ChatGPT bot',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'May, 29th 2023',
);

Irssi::signal_add_last('message public', 'chncll');

Irssi::settings_add_str("franklin_helper", "franklin_helper_admin", "");
my $owner = Irssi::settings_get_str('franklin_helper_admin');


sub chncll {
  my ($server, $msg, $nick, $address, $channel) = @_;
  my $ln = $server->{nick};

  # these commands can be used by anybody
  if ($msg =~ m/^$ln[:|,] reload/i) {
    $server->command("script unload franklin.pl");
    $server->command("script load franklin.pl");
  }

  # below this in this sub is for commands only by Franklin admin
  if ($nick == $owner) {
    if ($msg =~ m/^$ln[:|,] pullcode/i) {
      system("cd /home/irc-bot/Franklin && git pull");
    }
    if ($msg =~ m/^$ln[:|,] join (#\w+)\s?.*/i) {
      $server->command("JOIN $1");
    }
    if ($msg =~ m/^$ln[:|,] part (#\w+)\s?.*/i) {
      $server->command("PART $1");

    }
  }
}