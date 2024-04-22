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
use Proc::Simple;

$userfile = "1.0.0";
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

  buildjson();

sub buildjson {

@lastm = ("blah", "hello yes i am oxagst", "your mine franklin");
@rndm = ("archery lol", "i wanna shoot spunk", "or not");


  # the json should look something like the below after generation
  ## {"versions":{"userfile":"1.0.0","franklin":"4.0.0"},"nick":"oxagast","create_date":
  ## "04182024","change_date":"04192024","total_messages":55,"queries_per_day":12,"menti
  ## ons_per_day":3,"messages_per_day":2,"average_message_length":77,"operator":true,"me
  ## ssages":{"last":["hello how are you","oh yeah im fine","yeah my name is oxagast, wh
  ## ats yours"],"random":["blah","no i like girls toes","Franklin: tell me about nyc"]},
  ## "checksum":"B2CCA97A"}
  $nick = "oxagast";
  %summdb = (( versions => { selfver => $userfile, frankver => $franklinver }),
              ($nick => {create_date => "04182024", change_date => "04192024",
              total_messages => $totmsgs, queries_per_day => 4, mentions_per_day => 5,
              messages_per_day => 18, average_message_length => 78, operator => false,
              (messages => {last => [ $lastm[0], $lastm[1], $lastm[2] ],
              random => [ $rndm[0], $rndm[1], $rndm[2] ]})}));

    $json_nick = create_json (\%summdb);
    Irssi::print $json_nick;
}

# this could maybe work like ...
# have all nicks in one json string, oxagast => { ... }, billybob => { ... }, lisab => { ... }, ......
# then copy parts that dont need changing, only pull, edit, and reinsert pieces of json that are
# altered when that user speaks in channels, then written back to file.



#sub catchmsg {
#   ($server, $msg, $nick, $address, $channel) = @_;
#   $totmsgs++;
  #open(SDB, '>', "$sdbloc/$nick");
  #  print SDB $collected;
  #close(SDB);
  #}
