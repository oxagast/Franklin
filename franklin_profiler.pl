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
use strict;
use warnings;
use Data::Dumper;
use vars qw($VERSION %IRSSI);
use utf8;
use JSON::Create 'create_json';
use JSON::Parse ':all';
use Proc::Simple;
use POSIX qw(strftime);
my $franklinver = "4.5.0";
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

sub buildjson {2sas
  my $current_date = strftime("%m-%d-%Y", localtime);
  my ($qpd, $mspd);
  if ($change_date ne $current_date) {
    $day++;
  }
  
  # Prevent division by zero
  my $calc_day = $day > 0 ? $day : 1;

  if ($msg =~ m/^Franklin[:|,] /) {
    $queries++;
  }
  $qpd = $queries / $calc_day;
  $messages++;
  $mspd = $messages / $calc_day;
  my $alll = ($average_line_length + length($msg)) / 2;                                            # calcs avg line len
  my $totm = $totmsgs + 1;

  my %summdb = (
    (versions => {selfver => $userfile, frankver => $franklinver}),
    (
     $nick => {                                                                                    # all this gets rewritten back in json after modificaions
      create_date            => "$create_date",
      change_date            => "$change_date",
      total_messages         => "$totm",
      queries                => "$queries",
      messages               => "$messages",
      queries_per_day        => "$qpd",
      messages_per_day       => "$mspd",
      average_message_length => "$alll",
      day                    => "$day",
      hostname               => "$hostn",
      operator               => $oper,
      (
       messages => {
                    last   => [@lastm],
                    random => []
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
  my $sdbloc = Irssi::settings_get_str('franklin_profiles_dir');

  # Add error handling for the profiles directory
  if (!defined $sdbloc || $sdbloc eq '') {
    Irssi::print "Franklin Profiler Error: 'franklin_profiles_dir' setting is empty. Cannot save profile for $nick.";
    logit(0, "Franklin Profiler Error: 'franklin_profiles_dir' setting is empty. Cannot save profile for $nick.");
    return; # Stop processing if the path is invalid
  }

  if (!-d $sdbloc) {
    Irssi::print "Franklin Profiler Error: Profiles directory does not exist: $sdbloc. Cannot save profile for $nick.";
    logit(0, "Franklin Profiler Error: Profiles directory does not exist at $sdbloc. Cannot save profile for $nick.");
    return; # Stop processing if the directory doesn't exist
  }

  if (!-w $sdbloc) {
    Irssi::print "Franklin Profiler Error: Profiles directory is not writable: $sdbloc. Cannot save profile for $nick.";
    logit(0, "Franklin Profiler Error: Profiles directory is not writable at $sdbloc. Cannot save profile for $nick.");
    return; # Stop processing if the directory is not writable
  }

  my $injson = "";
  if (!-f "$sdbloc/$nick") {                                                                       # checks if the user is already in the database ad creates it if not
    my @init       = ();                                                                              # so that the random comes in blanked out
    my $today = strftime("%m-%d-%Y", localtime);
    my $newjsonout = buildjson($nick, "localhost", 0, $today, $today, 0, $msg, 0, 0, 0, 0, 1, length($msg), \@init, $msg);
                                                                                                   # add to the 'last' space in json
    if (open(my $fh, '>', "$sdbloc/$nick")) {
        print $fh $newjsonout;
        close($fh);
    }
    $injson = $newjsonout;
  }
  if (-e "$sdbloc/$nick") {
    if (open(my $fh, '<', "$sdbloc/$nick")) {
        $injson = <$fh>;
        close($fh);
    }
  }
  
  my $dstruct                = parse_json($injson);
  my $queries                = $dstruct->{$nick}->{queries};
  my $messages               = $dstruct->{$nick}->{messages};
  my $queries_per_day        = $dstruct->{$nick}->{queries_per_day};
  my $messages_per_day       = $dstruct->{$nick}->{messages_per_day};
  my $create_date            = $dstruct->{$nick}->{create_date};
  my $change_date            = $dstruct->{$nick}->{change_date};
  my $average_message_length = $dstruct->{$nick}->{average_message_length};
  my $day                    = $dstruct->{$nick}->{day};
  my $ttls                   = $dstruct->{$nick}->{total_messages};
  my @lm = @{$dstruct->{$nick}->{messages}->{last}};                                                  # this has to be encased in @{} to denote that is indeed an array ref
  my $hostn = "unknown";
  my $oper = 0;

  foreach $n ($server->channel_find($channel)->nicks) {
    if ($n->{nick} eq $nick) {
      $hostn = $n->{host};
      $oper = $n->{op} ? 1 : 0;
      last;
    }
  }
  if ($create_date eq "") {
    $create_date = strftime("%m-%d-%Y", localtime);
  }
  my $today = strftime("%m-%d-%Y", localtime);
  my $sdbjson     = buildjson($nick, $hostn, $oper, $create_date, $today, $ttls, $msg, $queries, $messages, $queries_per_day, $messages_per_day, $day, $average_message_length, \@lm, $msg);
  if (open(my $fh, '>', "$sdbloc/$nick")) {
      print $fh $sdbjson;
      close($fh);
  }
}
