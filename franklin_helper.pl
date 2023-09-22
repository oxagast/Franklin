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
use vars qw($VERSION %IRSSI);
$VERSION = "1.1";
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

sub chncll {
my ($server, $msg, $nick, $address, $channel) = @_;
 my $ln = $server->{nick};
 if ($msg =~ /^$ln[:|,] reload/i) {
  reloadfrank($server); 
}
}

sub reloadfrank {
  my ($server) = @_;
    $server->command("script unload franklin.pl");
    $server->command("script load franklin.pl");
}
