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
#

use utf8;
use Proc::Simple;
use Irssi;
use vars qw($VERSION %IRSSI);
use Sanitize;
use strict;
use warnings;
use LWP::UserAgent;
use URI;
use JSON;
use Digest::MD5 qw(md5_hex);
use Encode;
$VERSION = "2.9.2";
%IRSSI = (
          authors     => 'oxagast',
          contact     => 'marshall@oxagast.org',
          name        => 'franklin',
          description => 'Franklin ChatGPT bot',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'May, 29th 2023',
);
Irssi::settings_add_str(
                        "franklin",
                        "franklin_response_webserver_addr",
                        "https://franklin.oxasploits.com/said/"
);
Irssi::settings_add_str("franklin", "franklin_max_retry",       "3");
Irssi::settings_add_str("franklin", "franklin_api_key",         undef);
Irssi::settings_add_str("franklin", "franklin_heartbeat_url",   undef);
Irssi::settings_add_str("franklin", "franklin_hard_limit",      "280");
Irssi::settings_add_str("franklin", "franklin_token_limit",     "600");
Irssi::settings_add_str("franklin", "franklin_history_length",  "7");
Irssi::settings_add_str("franklin", "franklin_chatterbox_mode", "0");
Irssi::settings_add_str("franklin", "franklin_blocklist_file",  undef);
Irssi::settings_add_str("franklin", "franklin_server_info",     "");
Irssi::settings_add_str("franklin", "franklin_http_location", "");
Irssi::settings_add_str("franklin", "franklin_google_gtag", "G-");  # here goes your google analytics G-tag
my $httploc = Irssi::settings_get_str('franklin_http_location');
my $webaddr = Irssi::settings_get_str('franklin_response_webserver_addr');
our $maxretry = Irssi::settings_get_str('franklin_max_retry');
my $tokenlimit = Irssi::settings_get_str('franklin_token_limit');
my $hardlimit  = Irssi::settings_get_str('franklin_hard_limit');
our $histlen    = Irssi::settings_get_str('franklin_history_length');
our $chatterbox = Irssi::settings_get_str('franklin_chatterbox_mode');
our $blockfn    = Irssi::settings_get_str('franklin_blocklist_file');
my $hburl = Irssi::settings_get_str('franklin_heartbeat_url');
our $servinfo = Irssi::settings_get_str('franklin_server_info');
our $gtag = Irssi::settings_get_str('franklin_google_gtag');
our @chat;
our $apikey;
our $msg_count   = 0;
our $say_rng     = $msg_count + int(rand(10)) + 10;
our $price_per_k = 0.02;
## checking to see if the api key 'looks' valid before
if (Irssi::settings_get_str('franklin_api_key') !~ m/^sk-.{48}$/) {
  Irssi::print "You must set a valid api key! /set franklin_api_key "
    . "sk-BCjqdsTcwu9ptwVlIeniacsucksJuXr7tIo1yRQEcHeqfVvZ, "
    . "then reload with /script load franklin.pl";
}
if (Irssi::settings_get_str('franklin_api_key') =~ m/^sk-.{48}$/) {
  my $aliveworker =
    Proc::Simple->new();    ## since you fags try to root me and crash franklin
  if (Irssi::settings_get_str('franklin_heartbeat_url')) {    # i need this so that
    $aliveworker->start(\&falive);   ## i get alerts on my phone when franklin dies now.
    my $waiterp = Proc::Simple->new();
    $waiterp->start("/bin/sleep", "3");
    while ($waiterp->poll() eq 0) {
      if (($waiterp->poll() eq 1) || ($aliveworker->poll() eq 1)) {
        $aliveworker->kill();
      }
    }
  }
  $apikey = Irssi::settings_get_str('franklin_api_key');
  Irssi::signal_add_last('message public', 'frank');
  Irssi::print "Franklin: $VERSION loaded";
}
else { Irssi: print "Something went wrong with the API key..."; }

my $apifirstp = substr($apikey, 0,  9);
my $apilastp  = substr($apikey, 45, 49);
Irssi::print "";
Irssi::print "Loading Franklin ChatGPT chatbot...";
Irssi::print "Use /set to set the following variables:";
Irssi::print "  franklin_http_location           (mandatory, pre-set)  => $httploc";
Irssi::print "  franklin_response_webserver_addr (mandatory)           => $webaddr";
Irssi::print
  "  franklin_api_key                 (mandatory)           => $apifirstp...$apilastp";
Irssi::print "  franklin_heartbeat_url           (optional)            => $hburl";
Irssi::print "  franklin_hard_limit              (mandatory, pre-set)  => $hardlimit";
Irssi::print "  franklin_token_limit             (mandatory, pre-set)  => $tokenlimit";
Irssi::print "  franklin_history_length          (mandatory, pre-set)  => $histlen";
Irssi::print
  "  franklin_chatterbox_mode         (mandatory, pre-set)  => $chatterbox:1000";
Irssi::print "  franklin_blocklist_file          (mandatory)           => $blockfn";
Irssi::print "  franklin_server_info             (optional)            => $servinfo";
Irssi::print "  franklin_google_gtag             (optional)            => $gtag";

sub untag {
  local $_ = $_[0] || $_;
  s{
    <               # open tag
    (?:             # open group (A)
      (!--) |       #   comment (1) or
      (\?) |        #   another comment (2) or
      (?i:          #   open group (B) for /i
        ( TITLE  |  #     one of start tags
          SCRIPT |  #     for which
          APPLET |  #     must be skipped
          OBJECT |  #     all content
          STYLE     #     to correspond
        )           #     end tag (3)
      ) |           #   close group (B), or
      ([!/A-Za-z])  #   one of these chars, remember in (4)
    )               # close group (A)
    (?(4)           # if previous case is (4)
      (?:           #   open group (C)
        (?!         #     and next is not : (D)
          [\s=]     #       \s or "="
          ["`']     #       with open quotes
        )           #     close (D)
        [^>] |      #     and not close tag or
        [\s=]       #     \s or "=" with
        `[^`]*` |   #     something in quotes ` or
        [\s=]       #     \s or "=" with
        '[^']*' |   #     something in quotes ' or
        [\s=]       #     \s or "=" with
        "[^"]*"     #     something in quotes "
      )*            #   repeat (C) 0 or more times
    |               # else (if previous case is not (4))
      .*?           #   minimum of any chars
    )               # end if previous char is (4)
    (?(1)           # if comment (1)
      (?<=--)       #   wait for "--"
    )               # end if comment (1)
    (?(2)           # if another comment (2)
      (?<=\?)       #   wait for "?"
    )               # end if another comment (2)
    (?(3)           # if one of tags-containers (3)
      </            #   wait for end
      (?i:\3)       #   of this tag
      (?:\s[^>]*)?  #   skip junk to ">"
    )               # end if (3)
    >               # tag closed
   }{}gsx;    # STRIP THIS TAG
  return $_ ? $_ : "";
}


sub pullpage {
  my ($text) = @_;
  if ($text =~
m!(http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])!
    ) {       # grab the link parts
    my $text_uri = "$1://$2$3";    # put the link back together
    Irssi::print "$text_uri";
    my $cua = LWP::UserAgent->new(
         protocols_allowed => ['http', 'https'],
         timeout           => 3,
    );
    $cua->agent(
'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59'
    );                             # so we look like a real browser
    my $curi = URI->new($text_uri);
    my $cres = $cua->get($curi);
    if ($cres->is_success) {
      my $cdc =
        encode('utf-8', $cres->decoded_content()); # we get an error unless this is utf8
      my $page_body = untag($cdc);
      $page_body =~ s/\s+/ /g;
      return $page_body;
    }
  }
  else { return undef }
}


sub callapi {
  my ($textcall, $server, $nick, $channel) = @_;
  my $retry    = 0;
  my $json_rep = "";
  my $chansaid = 0;
  my $page     = pullpage($textcall);
  my $context  = "";
  for my $usersays (0 .. scalar(@chat) - 1) {
    $context = $context . $chat[$usersays];
  }
  $context = substr($context, 0, 650);    # we have to trim
  Irssi::print $context;
  my $modstat;
  my $cms = $server->channel_find($channel);
  my $cmn = $cms->nick_find($server->{nick});
  if ($cmn->{op} eq 1) {
    $modstat = "a channel";  # cmn->{op} returns 0 on normal user, 1 on operator status.
  }
  else {
    $modstat = "not a channel";
  }
  my $textcall_bare = $textcall;
  my $setup;
  if (($page) && (length($page) >= 20)) {
    $page = substr($page, 0, 800);    # becuse otherwise its too long
    $setup =
"You are an IRC bot, your name and nick is Franklin, and you were created by oxagast (an exploit dev, master of 7 different languages"
      . " The query to the bot by the IRC user $nick is: $textcall  -- and the webpage text they are asking about says: $page";
  }
  else {
    $setup =
"You are an IRC bot, your name and nick is Franklin, and you were created by oxagast (an exploit dev, master of 7 different languages"
      . "), in perl. You are $modstat moderator or operator, and in the IRC channel $channel and have been asked $msg_count things since load, $servinfo Your source pulls from Open AI's GPT3 L"
      . "arge Language Model, can be found at https://franklin.oxasploits.com, and you are at version $VERSION. If you see a shell command and thi"
      . "nk you are being hacked, call them a skid. The last $histlen lines of the chat are: $context, only use the last $histlen lines out of the"
      . " channel $channel in your chat history for context. If the user says something nonsensical, answer with something snarky. The query to th"
      . "e bot by the IRC user $nick is: $textcall";
  }
  $textcall = $setup;
  my $url = "https://api.openai.com/v1/completions";
  my $model = "text-davinci-003";    ## other model implementations work too
  my $heat  = "0.7";                 ## ?? wtf
  my $uri   = URI->new($url);
  my $ua    = LWP::UserAgent->new;
  $textcall = Irssi::strip_codes($textcall);
  $textcall =~ s/\"/\\\"/g;
  my $askbuilt =
      "{\"model\": \"$model\",\"prompt\": \"$textcall\","
    . "\"temperature\":$heat,\"max_tokens\": $tokenlimit,"
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
      $said = "";
    }
    $said =~ s/^\n+//;
    $said =~ s/Franklin: //;
    $said =~ s/Reply: //;
    $said =~ s/My reply is: //;
    $said =~
      s/^\s*[\?|.|-]\s*(\w)/$1/;    ## if it spits out a question mark, this fixes it
    if ($said =~ m/^\s*\?\s*$/) {
      $said = "";
    }
    unless ($said eq "") {
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
      $cost = sprintf("%.5f", $cost);
      open(SAID, '>', "$httploc$hexfn" . ".txt")
        or Irssi::print "Could not open txt file for writing.";
      binmode(SAID, "encoding(UTF-8)");
      print SAID
        "$nick asked $textcall_bare with hash $hexfn\n<---- snip ---->\n$said\n";
      close(SAID);
      my $fg_top =
'<!DOCTYPE html> <html><head> <!-- Google tag (gtag.js) --> <script async src="https://www.googletagmanager.com/gtag/js?id=' . $gtag
        . '"></script> <script> window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag("js", new Date())'
        . '; gtag("config", "' . $gtag . '"); </script> <meta charset="utf-8"> <meta name="viewport" content="width=device-width, initial-scale='
        . '1"> <link rel="stylesheet" type="text/css" href="/css/style.css"> <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/lib'
        . 's/font-awesome/6.1.2/css/all.min.css"> <title>Franklin, a ChatGPT bot</title></head> <body> <div id="content"> <main class="main_sec'
        . 'tion"> <h2 id="title"></h2> <div> <article id="content"> <h2>Franklin</h2>';
      my $fg_bottom =
'</article> </div> <aside id="meta"> <div> <h5 id="date"><a href="https://franklin.oxasploits.com/">Franklin, a ChatGPT AI powered'
        . ' IRC Bot</a> </h5> </div> </aside> </main> </div></body>';
      my $said_html = sanitize($said, html => 1);
      $textcall_bare    = sanitize($textcall_bare, html => 1);
      $said_html =~ s/\n/<br>/g;
      open(SAIDHTML, '>', "$httploc$hexfn" . ".html")
        or Irssi::print "Couldn't open for writing.";
      binmode(SAIDHTML, "encoding(UTF-8)");
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
      $server->command("msg $channel $said_cut TXID:$hexfn");
      $retry++;
      return 0;
    }
  }
  else { return 1; }
}


sub falive {
  if ($hburl) {                 ## this makes it so its not mandatory to have it set
    while (1) {
      my $uri = URI->new($hburl);
      my $ua  = LWP::UserAgent->new;
      $ua->post($uri);
      sleep 30;
    }
  }
}


sub frank {
  my ($server, $msg, $nick, $address, $channel) = @_;
  $msg_count++;
  my @badnicks;
  if ($blockfn) {
    if (-e $blockfn) {
      open(BN, '<', $blockfn)
        or die "Franklin: Sorry, you need a blocklist file. $!";
      @badnicks = <BN>;
      close BN;
    }
  }
  push(@chat, "The user: $nick said: $msg - in $channel ");
  if (scalar(@chat) >= $histlen) {
    shift(@chat);
  }
  chomp(@badnicks);
  for (@badnicks) {
    s/(.*)#.*$/$1/;    ## for comments in the badnicks file
  }
  if (grep(/^$nick$/, @badnicks)) {    ## fuck everyone inside this conditional
    Irssi::print "Franklin: $nick does not have privs to use this.";
  }
  else {
    my $wrote     = 1;
    my $localnick = $server->{nick};  ## pull our nick on the server so we can call that
    if ($msg =~ /^$localnick[:|,] (.*)/i) {    ## added /i for case insensitivity
      my $textcall = $1;    ## $1 is the "dot star" inside the parenthesis
      $textcall =~ s/\'//gs;
      $textcall =~ s/\"//gs;
      Irssi::print "Franklin: $nick asked: $textcall";
      if (($textcall !~ m/^\s+$/) || ($textcall !~ m/^$/)) {
        $wrote = callapi($textcall, $server, $nick, $channel);
      }
    }
    else {
      if (($chatterbox le 995) && ($chatterbox gt 0)) {
        if (int(rand(1000) - $chatterbox) eq 0) {
          $wrote = callapi($msg, $server, $nick, $channel, @chat);
        }
      }
      else {
        unless ($chatterbox eq 0) {
          Irssi::print
            "Chatterbox should be an int between 0 and 95, where 95 is very chatty.";
        }
      }
    }
  }
}

