#!/usr/bin/perl
# Author: by oxagast
# Thanks: atg, dclaw, proge, CerebraNet, morb, bookworm, denzuko, RDNt, xibalba... and more...
#
# Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
#                  ,   .
#   ,-             |   | o
#   |  ;-. ,-: ;-. | , | . ;-.
#   |- |   | | | | |<  | | | |
#   |  '   `-` ' ' ' ` ' ' ' '
#  -'
use Proc::Simple;
use Irssi;
use vars qw($VERSION %IRSSI);
use Sanitize;
use LWP::UserAgent;
use URI;
use JSON;
use Digest::MD5 qw(md5_hex);
use Encode;
use Data::Dumper;
$VERSION = "2.10";
%IRSSI = (
          authors     => 'oxagast',
          contact     => 'marshall@oxagast.org',
          name        => 'franklin',
          description => 'Franklin ChatGPT bot',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'May, 29th 2023',
);

Irssi::signal_add_last('message public', 'chncll');
$SIG{ALRM} = \&timed_out;


eval {
    alarm(10);    
    reloadfrank($server);
    alarm(0);
};

sub chncll {
my ($server, $msg, $nick, $address, $channel) = @_;
 my $ln = $server->{nick};
if ($msg =~ /^$ln[:|,] reload/i) {
reloadfrank($server); 
}


sub reloadfrank {
  my ($server) = @_;
    $server->command("script" . "load" . "frankln.pl");
}
