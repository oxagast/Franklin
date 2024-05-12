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
$userfile    = "1.1.2";
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
my $sdbloc = "/home/franklin/Franklin/fprofiles/";                                                 # this is the location of the dbase dir


sub buildjson {
  my ($nick, $create_date, $change_date, $totmsgs, $msg, $queries_per_day, $messages_per_day, $average_line_length, @lastm, @rndm) = @_;
  if (scalar(@lastm) > 8) {
    shift(@lastm);                                                                                 # this stuff makes it so that there i
  }                                                                                                # maximum of x items in the 'last' array
  my $create_date;
  if (-e "$sdbloc/$nick") {
    $create_date = strftime("%m%d%Y", localtime);                                                  # creation time in dbase
  }
  ($sec, $min, $hour, $day, $mon, $year_1900, $wday, $yday, $isdst) = localtime;
  if (($hour == 0) && ($min == 0)) {
    $nh{'qpd'}  = $nh{'qpd'} / 2;
    $nh{'mnpd'} = $nh{'mnpd'} / 2;
    $nh{'mspd'} = $nh{'msd'} / 2;
  }
  if ($msg =~ m/^Franklin[:|,] /) {
    $nh{'qpd'} = ($queries_per_day + 1);                                                           # franklin was called, we know it was a query
  }
  $nh{'mspd'} = ($messages_per_day + 1);                                                           # this is reset every morning at midnight
  $nh{'lll'}  = ($average_line_length + length($msg)) / 2;                                         # calcs avg line len
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
                        total_messages         => $hn{'tot'},
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
  if (!-e "$sdbloc/$nick") {                                                                       # checks if the user is already in the database ad creates it if not
    @init       = ();                                                                              # so that the random comes in blanked out
    $newjsonout = buildjson($nick, strftime("%m%d%Y", localtime), strftime("%m%d%Y", localtime), 1, 1, 1, 0, $msg, @init);    # the final $msg is needed to
                                                                                                   # add to the 'last' space in json
    open(SDBN, '>', "$sdbloc/$nick");                                                              # opens user's profile
    print SDBN $newjsonout;                                                                        # creates profile
    close(SDBN);
    $injson = $newjsonout;
  }
  if (-e "$sdbloc/$nick") {
    open(SDBI, '<', "$sdbloc/$nick");
    $injson = <SDBI>;
    close(SDBI);
  }
  $lmn{$nick} = \@lm;
  $rmn{$nick} = \@rm;
  my $dstruct                = parse_json($injson);
  my $queries_per_day        = $dstruct->{$nick}->{queries_per_day};
  my $messages_per_day       = $dstruct->{$nick}->{messages_per_day};
  my $create_date            = $dstruct->{$nick}->{create_date};
  my $change_date            = $dstruct->{$nick}->{change_date};
  my $average_message_length = $dstruct->{$nick}->{average_message_length};
  my $oper                   = $dstruct->{$nick}->{operator};
  my $ttls                   = $dstruct->{$nick}->{total_messages};
  my $create_date;
  @lm = @{$dstruct->{$nick}->{messages}->{last}};

  if (-e "$sdbloc/$nick") {
    $change_date = strftime("%m%d%Y", localtime);                                                  # if existing user write update date
  }
  my $change_date = strftime("%m%d%Y", localtime);
  my $sdbjson     = buildjson($nick, $create_date, $change_date, $ttls, $msg, $queries_per_day, $messages_per_day, $average_message_length, @lm, $msg);
  open(SDBO, '>', "$sdbloc/$nick");
  print SDBO $sdbjson;                                                                             # update the user in dbase
  close(SDBO);
  Irssi::print $sdbjson;
}
