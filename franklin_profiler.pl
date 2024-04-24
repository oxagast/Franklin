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
use utf8;
use JSON::Create 'create_json';
use JSON::Parse ':all';
use Proc::Simple;
use POSIX qw(strftime);
$userfile    = "1.0.0";
$franklinver = "4.0.0";
%IRSSI = (
          authors     => 'oxagast',
          contact     => 'oxagast@oxasploits.com',
          name        => 'franklin_helper',
          description => 'Franklin LLM AI bot',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'Mar, 11th 2024',
);
my $sdbloc = "/home/franklin/Franklin/summarydb";
Irssi::signal_add_last('message public', 'catchmsg');


sub buildjson {
  my ($nick, $create_date, $change_date, $totmsgs, $msg) = @_;
  push(@lastm, $msg);
  @rndm = ("", "", "");

  # the json should look something like the below after generation
  ## {"versions":{"userfile":"1.0.0","franklin":"4.0.0"},"nick":"oxagast","create_date":
  ## "04182024","change_date":"04192024","total_messages":55,"queries_per_day":12,"menti
  ## ons_per_day":3,"messages_per_day":2,"average_message_length":77,"operator":true,"me
  ## ssages":{"last":["hello how are you","oh yeah im fine","yeah my name is oxagast, wh
  ## ats yours"],"random":["blah","no i like girls toes","Franklin: tell me about nyc"]},
  ## "checksum":"B2CCA97A"}
  %summdb = (
             (versions => {selfver => $userfile, frankver => $franklinver}),
             (
              $nick => {
                        create_date            => "$create_date",
                        change_date            => "$change_date",
                        total_messages         => $totmsgs,
                        queries_per_day        => 0,
                        mentions_per_day       => 0,
                        messages_per_day       => 0,
                        average_message_length => 0,
                        operator               => false,
                        (
                         messages => {
                                      last   => [$lastm[0], $lastm[1], $lastm[2]],
                                      random => [$rndm[0],  $rndm[1],  $rndm[2]]
                         }
                        )
              }
             )
  );
  $json_nick = create_json(\%summdb);
  Irssi::print $json_nick;
  return $json_nick;
}

# this could maybe work like ...
# have all nicks in one json string, oxagast => { ... }, billybob => { ... }, lisab => { ... }, ......
# then copy parts that dont need changing, only pull, edit, and reinsert pieces of json that are
# altered when that user speaks in channels, then written back to file.
sub catchmsg {
  my ($server, $msg, $nick, $address, $channel) = @_;
  if (-e "$sdbloc/$nick") {
    open(SDB, '<', "$sdbloc/$nick");
    $injson = <SDB>;
    close(SDB);
  }
  $dstruct                = parse_json($injson);
  $mentions_per_day       = $dstruct->{oxagast}->{mentions_per_day};
  $queries_per_day        = $dstruct->{oxagast}->{queries_per_day};
  $messages_per_day       = $dstruct->{oxagast}->{messages_per_day};
  $create_date            = $dstruct->{oxagast}->{create_date};
  $change_date            = $dstruct->{oxagast}->{change_date};
  $average_message_length = $dstruct->{oxagast}->{average_message_length};
  $oper                   = $dstruct->{oxagast}->{operator};
  Irssi::print "$mentions_per_day $queries_per_day $messages_per_day $create_date $change_date $average_message_length $oper";
  my $create_date;

  if (-e "$sdbloc/$nick") {
    $create_date = strftime("%m%d%Y", localtime);
  }
  my $change_date = strftime("%m%d%Y", localtime);
  $sdbjson = buildjson($nick, $create_date, $change_date, $totmsgs, $msg);
  open(SDB, '>', "$sdbloc/$nick");
  print SDB $sdbjson;
  close(SDB);
}
