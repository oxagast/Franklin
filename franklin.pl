#!/usr/bin/perl
# Author: by oxagast
# Thanks: dclaw, proge, CerebraNet, atg, morb, bookworm, xibalba and more...
#
# Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
#                  ,   .
#   ,-             |   | o
#   |  ;-. ,-: ;-. | , | . ;-.
#   |- |   | | | | |<  | | | |
#   |  '   `-` ' ' ' ` ' ' ' '
#  -'
#
use Proc::Simple;
use Irssi;
use vars qw($VERSION %IRSSI);
use Sanitize;
use strict;
use warnings;
use LWP::UserAgent;
use utf8;
use URI;
use JSON;
use Digest::MD5 qw(md5_hex);
use Encode;
##
#####################################################################
### Adjust this variable to the location of Franklin's source!!!! ###
our $localdir = "/home/gpt3/Franklin/";    ##########################
#####################################################################
##
## these varaibles you can change from within irssi using /set
Irssi::settings_add_str("franklin", "franklin_http_location", "/var/www/html/said/");
Irssi::settings_add_str(
                        "franklin",
                        "franklin_response_webserver_addr",
                        "https://franklin.oxasploits.com/said/"
);
Irssi::settings_add_str("franklin", "franklin_max_retry",       "3");
Irssi::settings_add_str("franklin", "franklin_api_key",         "");
Irssi::settings_add_str("franklin", "franklin_heartbeat_url",   "");
Irssi::settings_add_str("franklin", "franklin_hard_limit",      "280");
Irssi::settings_add_str("franklin", "franklin_word_limit",      "600");
Irssi::settings_add_str("franklin", "franklin_history_length",  "8");
Irssi::settings_add_str("franklin", "franklin_chatterbox_mode", "0");
my $httploc = Irssi::settings_get_str('franklin_http_location');
my $webaddr = Irssi::settings_get_str('franklin_response_webserver_addr');
our $maxretry = Irssi::settings_get_str('franklin_max_retry');
my $wordlimit = Irssi::settings_get_str('franklin_word_limit');
my $hardlimit = Irssi::settings_get_str('franklin_hard_limit');
our $histlen     = Irssi::settings_get_str('franklin_history_length');
our $chatterbox  = Irssi::settings_get_str('franklin_chatterbox_mode');
our $msg_count   = 0;
our $say_rng     = $msg_count + int(rand(10)) + 10;
our $price_per_k = 0.02;
$VERSION = "2.7";
%IRSSI = (
          authors     => 'oxagast',
          contact     => 'marshall@oxagast.org',
          name        => 'franklin',
          description => 'Franklin ChatGPT bot',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'May, 2nd 2023',
);
Irssi::print "";
Irssi::print "Loading Franklin ChatGPT chatbot...";
Irssi::print "Use /set to set the following variables:";
Irssi::print "  franklin_http_location           (mandatory, pre-set)";
Irssi::print "  franklin_response_webserver_addr (mandatory)";
Irssi::print "  franklin_api_key                 (mandatory)";
Irssi::print "  franklin_heartbeat_url           (optional)";
Irssi::print "  franklin_hard_limit              (mandatory, pre-set)";
Irssi::print "  franklin_word_limit              (mandatory, pre-set)";
Irssi::print "  franklin_history_length          (mandatory, pre-set)";
our $apikey;

#our @chat;
## checking to see if the api key 'looks' valid before use
if (Irssi::settings_get_str('franklin_api_key') !~ m/^sk-.{48}$/) {
  Irssi::print "You must set a valid api key! /set franklin_api_key "
    . "sk-BCjqdsTcwu9ptwVlIASqT3BlbklJuXr7tIo1yRQEcHeqfVvZ, "
    . "then reload with /script load franklin.pl";
}
if (Irssi::settings_get_str('franklin_api_key') =~ m/^sk-.{48}$/) {
  my $aliveworker =
    Proc::Simple->new();    ## since you fags try to root me and crash franklin
  if (Irssi::settings_get_str('franklin_heartbeat_url') ne "") {   # i need this so that
    $aliveworker->start(\&falive);   ## i get alerts on my phone when franklin dies now.
  }
  $apikey = Irssi::settings_get_str('franklin_api_key');
  Irssi::signal_add_last('message public', 'frank');
  Irssi::print "Franklin: $VERSION loaded";
  Irssi::print "Franklin: API key: $apikey";
}
else { Irssi: print "Something went wrong with the API key..."; }


sub callapi {
  my ($textcall, $server, $nick, $channel, @chat) = @_;
  my $retry     = 0;
  my $json_rep  = "";
  my $fg_top    = "";
  my $fg_bottom = "";
  my $chansaid  = 0;
  $textcall =~ s/\"/\\"/gs;
  $textcall =~ s/\'/\\\\'/gs;
  my $context = "";

  for my $usersays (0 .. scalar(@chat) - 1) {
    $context = $context . $chat[$usersays];
  }
  $context = substr($context, 0, 650);
  my $textcall_bare = $textcall;
  my $setup =
"You are an IRC bot, your name and nick is Franklin, and you were created by oxagast (an exploit dev, master of 7 different "
    . "languages), in perl. You are in the IRC channel $channel. Your source pulls from Open"
    . "AI's GPT3 Large Language Model, you are at version $VERSION. If you see a shell command, call them a silly hacker or a skid."
    . " The last $histlen lines of the chat are: $context, only use the last "
    . "$histlen lines out of the channel $channel in your chat history. The question the IRC user $nick is asking is: $textcall";
  $textcall = $setup;
  my $url = "https://api.openai.com/v1/completions";
  my $model = "text-davinci-003";    ## other model implementations work too
  my $heat  = "0.7";                 ## ?? wtf
  my $uri   = URI->new($url);
  my $ua    = LWP::UserAgent->new;
  my $askbuilt =
      "{\"model\": \"$model\",\"prompt\": \"$textcall\","
    . "\"temperature\":$heat,\"max_tokens\": $wordlimit,"
    . "\"top_p\": 1,\"frequency_penalty\": 0,\"presence_"
    . "penalty\": 0}";
  $ua->default_header("Content-Type"  => "application/json");
  $ua->default_header("Authorization" => "Bearer " . $apikey);
  my $res = $ua->post($uri, Content => $askbuilt);   ## send the post request to the api

  if ($res->is_success) {
    $json_rep = $res->decoded_content();
    ## response should look like
    ## {"id":"cmpl-6yAcIQuEz2hkg6Isvgg29KllzTn63","object":"text_completion","created":1679798510,"model"
    ## :"text-davinci-003","choices":[{"text":"\n\nThis is indeed a test","index":0,"logprobs":null,"fini
    ## sh_reason":"length"}],"usage":{"prompt_tokens":5,"completion_tokens":7,"total_tokens":12}}
    ## so we use a json decoder and fix for utf8
    my $json_decd = decode_json($json_rep);
    my $said      = $json_decd->{choices}[0]{text};
    my $toks      = $json_decd->{usage}{total_tokens};
    if (($said =~ m/^\s+$/) || ($said =~ m/^$/)) {
      $said = "Oof.";
    }
    $said =~ s/^\n+//;
    $said =~ s/^\?\s+(\w)/$1/;    ## if it spits out a question mark, this fixes it
    my $hexfn = substr(           ## the reencode fixes the utf8 bug
      Digest::MD5::md5_hex(
                             utf8::is_utf8($said)
                           ? Encode::encode_utf8($said)
                           : $said
      ),
      0,
      8
    );
    umask(0133);
    my $cost = $toks / 1000 * $price_per_k;
    $cost = printf("%.4f", $cost);
    open(SAID, '>', "$httploc$hexfn" . ".txt")
      or Irssi::print "Could not oepn txt file for writing.";
    print SAID "$nick asked $textcall_bare with hash $hexfn\n<---- snip ---->\n$said\n";
    close(SAID);
    open(FGT, "fg_top.html.part")
      or Irssi::print "Could not open the top html part for reading.";
    while (<FGT>) {
      $fg_top = $fg_top . $_;
    }
    close FGT;
    open(FGB, "fg_bottom.html.part")
      or Irssi::print "Could not open the bottom html part for reading.";
    while (<FGB>) {
      $fg_bottom = $fg_bottom . $_;
    }
    close FGB;
    my $said_html = sanitize($said, html => 1);
    $said_html =~ s/\n/<br>/g;
    open(SAIDHTML, '>', "$httploc$hexfn" . ".html")
      or Irssi::print "Couldn't open for writing.";
    print SAIDHTML $fg_top
      . "<br><i>"
      . localtime()
      . "<br>Tokens used: $toks<br>Avg cost: \$$cost<br>"
      . "</i><br><br><br><b>$nick</b> asked: <br>&nbsp&nbsp&nbsp&nbsp $textcall_bare<br><br>"
      . $said_html
      . $fg_bottom;
    close SAIDHTML;
    my $said_cut = substr($said, 0, $hardlimit);
    $said_cut =~ s/\n/ /g;    # fixes newlines for irc compat
    Irssi::print "Franklin: Reply: $said_cut $webaddr$hexfn" . ".html";
    $server->command("msg $channel $said_cut $webaddr$hexfn" . ".html");
    $retry++;
    return 0;
  }
  else { return 1; }
}


sub falive {
  my $url = Irssi::settings_get_str('franklin_heartbeat_url');
  if ($url ne "") {           ## this makes it so its not mandatory to have it set
    while (1) {
      my $uri = URI->new($url);
      my $ua  = LWP::UserAgent->new;
      $ua->post($uri);
      sleep 30;
    }
  }
}


sub frank {
  my ($server, $msg, $nick, $address, $channel) = @_;
  open(BN, '<', $localdir . "block.lst")
    or die "Franklin: Sorry, you need a block.lst file, even"
    . " if it is empty!\nFranklin: $!";
  my @badnicks = <BN>;
  close BN;
  my @chat = "";
  push(@chat, "The user: $nick said: $msg - in $channel");
  if (scalar(@chat) - 1 >= $histlen) {
    shift(@chat);
  }

  $msg_count++;
  chomp(@badnicks);
  for (@badnicks) {
    s/(.*)#.*$/$1/;    ## for comments in the badnicks file
  }
  if (grep(/^$nick$/, @badnicks)) {    ## fuck everyone inside this conditional
    Irssi::print "Franklin: $nick does not have privs to use this.";
  }
  else {
    my $localnick = $server->{nick};  ## pull our nick on the server so we can call that
    if ($msg =~ /^$localnick[:|,] (.*)/i) {    ## added /i for case insensitivity
      my $textcall = $1;    ## $1 is the "dot star" inside the parenthesis
      Irssi::print "Franklin: $nick asked: $textcall";
      my $wrote = 1;
      if (($textcall !~ m/^\s+$/) || ($textcall !~ m/^$/)) {
        $wrote = callapi($textcall, $server, $nick, $channel, @chat);
      }
    }
  }
}
