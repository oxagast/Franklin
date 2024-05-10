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
Irssi::signal_add_last('message public', 'catchmsg');
my $sdbloc = "/home/franklin/Franklin/fprofiles/";


sub buildjson {
  my ($nick, $create_date, $change_date, $totmsgs, $msg, $queries_per_day, $messages_per_day, $average_line_length, @lastm, @rndm) = @_;
  ($sec, $min, $hour, $day, $mon, $year_1900, $wday, $yday, $isdst) = localtime;
  if (($hour == 0) && ($min == 0)) {
    $nh{'qpd'}  = $nh{'qpd'} / 2;
    $nh{'mnpd'} = $nh{'mnpd'} / 2;
    $nh{'mspd'} = $nh{'msd'} / 2;
  }
  if ($msg =~ m/^Franklin[:|,] /) {
    $nh{'qpd'} = ($queries_per_day + 1);
  }
  $nh{'mspd'} = ($messages_per_day + 1);
  $nh{'lll'}  = ($average_line_length + length($msg)) / 2;
  $hn{'tot'}  = $totmsgs + 1;

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
                        queries_per_day        => $nh{'qpd'},
                        messages_per_day       => $nh{'mspd'},
                        average_message_length => $nh{'lll'},
                        operator               => false,
                        (
                         messages => {
                                      last   => [@lastm],
                                      random => [@rndm]
                         }
                        )
              }
             )
  );
  return create_json(\%summdb);
}

# this could maybe work like ...
# have all nicks in one json string, oxagast => { ... }, billybob => { ... }, lisab => { ... }, ......
# then copy parts that dont need changing, only pull, edit, and reinsert pieces of json that are
# altered when that user speaks in channels, then written back to file.
sub catchmsg {
  my ($server, $msg, $nick, $address, $channel) = @_;
  my $injson = "";
  if (!-e "$sdbloc/$nick") {
    $newjsonout = buildjson($nick, strftime("%m%d%Y", localtime), strftime("%m%d%Y", localtime), 0, 0, 0, 0, 0, 0);
    open(SDBN, '>', "$sdbloc/$nick");
    print SDBN $newjsonout;
    close(SDBN);
    $injson = $newjsonout;
  }
  if (-e "$sdbloc/$nick") {
    open(SDBI, '<', "$sdbloc/$nick");
    $injson = <SDBI>;
    close(SDBI);
  }
  $lmn{$nick}             = \@lm;
  $rmn{$nick}             = \@rm;
  $dstruct                = parse_json($injson);
  $queries_per_day        = $dstruct->{$nick}->{queries_per_day};
  $messages_per_day       = $dstruct->{$nick}->{messages_per_day};
  $create_date            = $dstruct->{$nick}->{create_date};
  $change_date            = $dstruct->{$nick}->{change_date};
  $average_message_length = $dstruct->{$nick}->{average_message_length};
  $oper                   = $dstruct->{$nick}->{operator};

  for $m (0 .. scalar($dstruct->{$nick}->{messages}->{last}[$m])) {
    @lm[$m] = $dstruct->{$nick}->{messages}->{last}[$m];
  }
  if (scalar(@lm) >= 6) {
    shift(@lm);
  }
  push(@lm, $msg);
  for $r (0 .. 6) {
    @rm[$r] = $dstruct->{$nick}->{messages}->{random}[$r];
  }
  if (scalar(@rm) >= 6) {
    shift(@rm);
  }
  if (int(rand(20)) == 0) {
    push(@rm, $msg);
  }
  my $create_date;
  if (-e "$sdbloc/$nick") {
    $create_date = strftime("%m%d%Y", localtime);
  }
  my $change_date = strftime("%m%d%Y", localtime);
  $sdbjson = buildjson($nick, $create_date, $change_date, $totmsgs, $msg, $queries_per_day, $messages_per_day, $average_message_length, @lm, @rm);
  open(SDBO, '>', "$sdbloc/$nick");
  print SDBO $sdbjson;
  close(SDBO);
  Irssi::print $sdbjson;
}
