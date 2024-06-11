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
$userfile    = "1.3.1";
$franklinver = "4.5.0";
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
my $sdbloc = "/home/franklin/Franklin/fprofiles/";                                                 # this is the location of the dbase dir


sub buildjson {
  my ($nick, $hostn, $oper, $create_date, $change_date, $totmsgs, $msg, $queries, $day, $average_line_length, @lastm) = @_;
  push(@lastm, $msg);
  if (scalar(@lastm) > 8) {
    shift(@lastm);                                                                                 # this stuff makes it so that there i
  } 
  if (scalar(@rndm) > 8) {
    shift(@rndm);
  }

  # maximum of x items in the 'last' array
  ($sec, $min, $hour, $day, $mon, $year_1900, $wday, $yday, $isdst) = localtime;
  my ($qpd, $mnpd, $msd, $mspd);
  if ($change_date != strftime("%m-%d-%Y", localtime)) {
    $day++;
  }
  if ($msg =~ m/^Franklin[:|,] /) {
    $queries++;
    $qpd = $queries / $day;                                                                        # franklin was called, we know it was a query
  }
  my $alll = ($average_line_length + length($msg)) / 2;                                            # calcs avg line len
  my $totm = $totmsgs + 1;
  $mspd = $totmsgs + 1  / $day;                                                                        # this is reset every morning at midnight
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
     $nick => {                                                                                    # all this gets rewritten back in json after modificaions
      create_date            => "$create_date",
      change_date            => "$change_date",
      total_messages         => "$totm",
      queries                => "$queries",
      queries_per_day        => "$qpd",
      messages_per_day       => "$mspd",
      average_message_length => "$alll",
      day                    => "$day",
      hostname               => "$hostn",
      operator               => $oper,
      (
       messages => {
                    last   => [@lastm],
                    random => [@rndm]
       }
      )
     }
    )
  );
  return create_json(\%summdb);                                                                    # return the json hash
}

#my $cmn = $server->channel_find($channel)->nick_find($server->{nick});
# this could maybe work like ...
# have all nicks in one json string, oxagast => { ... }, billybob => { ... }, lisab => { ... }, ......
# then copy parts that dont need changing, only pull, edit, and reinsert pieces of json that are
# altered when that user speaks in channels, then written back to file.
sub catchmsg {
  my ($server, $msg, $nick, $address, $channel) = @_;
  my $injson = "";
  if (!-f "$sdbloc/$nick.json") {                                                                       # checks if the user is already in the database ad creates it if not
    @init       = ();                                                                              # so that the random comes in blanked out
#  my ($nick, $hostn, $oper, $create_date, $change_date, $totmsgs, $msg, $queries, $day, $average_line_length, @lastm, $rndmm) = @_;
    $newjsonout = buildjson($nick, "localhost", 0, strftime("%m-%d-%Y", localtime), strftime("%m-%d-%Y", localtime), 1, "", 0, 1, 1, $msg);    # the final $msg is needed to
                                                                                                   # add to the 'last' space in json
    open(SDBN, '>', "$sdbloc/$nick.json");                                                              # opens user's profile
    print SDBN $newjsonout;                                                                        # creates profile
    close(SDBN);
    $injson = $newjsonout;
  }
  if (-e "$sdbloc/$nick.json") {
    open(SDBI, '<', "$sdbloc/$nick.json");
    $injson = <SDBI>;
    close(SDBI);
  }
  $lmn{$nick} = \@lm;
  my $dstruct                = parse_json($injson);
  my $queries                = $dstruct->{$nick}->{queries};
  my $queries_per_day        = $dstruct->{$nick}->{queries_per_day};
  my $messages_per_day       = $dstruct->{$nick}->{messages_per_day};
  my $create_date            = $dstruct->{$nick}->{create_date};
  my $change_date            = $dstruct->{$nick}->{change_date};
  my $average_message_length = $dstruct->{$nick}->{average_message_length};
  my $day                    = $dstruct->{$nick}->{day};
  my $ttls                   = $dstruct->{$nick}->{total_messages};
  @lm = @{$dstruct->{$nick}->{messages}->{last}};                                                  # this has to be encased in @{} to denote that is indeed an array ref
  my $hostn;

  foreach $n ($server->channel_find($channel)->nicks) {
    if ($n->{nick} eq $nick) {
      $hostn = $n->{host};
    }
    if ($n->{nick} eq $nick) {
      if ($n->{op} != 0) {
      $oper = true;
    }
    else { $oper = false; }
  }
  }
  if ($create_date eq "") {
    $create_date = strftime("%m-%d-%Y", localtime);
  }
  my $change_date = strftime("%m-%d-%Y", localtime);
  my $sdbjson     = buildjson($nick, $hostn, $oper, $create_date, $change_date, $ttls, $msg, $queries, $day, $average_message_length, @lm);
  open(SDBO, '>', "$sdbloc/$nick.json");
  print SDBO $sdbjson;                                                                             # update the user in dbase
  close(SDBO);
}
