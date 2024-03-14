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
$VERSION = "1.4";
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

sub chncll {
  my ($server, $msg, $nick, $address, $channel) = @_;
  my $ln = $server->{nick};
  # these commands can be used by anybody
  if ($msg =~ m/^$ln[:|,] reload/i) {
    $server->command("script unload franklin.pl");
    $server->command("script load franklin.pl");
  }

  # below this in this sub is for commands only by Franklin admin
    if ($msg =~ m/^$ln[:|,] pullcode/i) {
      if($nick == $owner) {
      system("cd /home/irc-bot/Franklin && git pull");
      }
    }
    if ($msg =~ m/^$ln[:|,] levelup/i) {
      if ($nick == $owner) {
      $server->command("op $channel $nick");
      }
    }
#    if ($msg =~ m/^$ln[:|,] reboot/i) {
#      if ($nick == $owner) {
#        system("sudo /sbin/reboot");
#      }
#   }
}
