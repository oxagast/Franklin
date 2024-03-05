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
use 5.10.0;
use warnings;
use Proc::Simple;
use Irssi;
use vars qw($VERSION %IRSSI);
use Sanitize;
use LWP::UserAgent;
use URI;
use JSON;
use Digest::MD5 qw(md5_hex);
use Encode;
use Data::Dumper qw(Dumper);
$|++;
$VERSION = "4.0.0rc1";
%IRSSI = (
          authors     => 'oxagast',
          contact     => 'oxagast@oxasploits.com',
          name        => 'franklin',
          description => 'Franklin ChatGPT bot',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'Jan, 21st 2024',
);
$Data::Dumper::Indent = 1;
Irssi::settings_add_str("franklin", "franklin_response_webserver_addr", "https://franklin.oxasploits.com/said/");
Irssi::settings_add_str("franklin", "franklin_max_retry",               "3");
Irssi::settings_add_str("franklin", "franklin_api_key",                 "");
Irssi::settings_add_str("franklin", "franklin_heartbeat_url",           "");
Irssi::settings_add_str("franklin", "franklin_hard_limit",              "280");
Irssi::settings_add_str("franklin", "franklin_token_limit",             "600");
Irssi::settings_add_str("franklin", "franklin_history_length",          "7");
Irssi::settings_add_str("franklin", "franklin_chatterbox_mode",         "0");
Irssi::settings_add_str("franklin", "franklin_blocklist_file",          "");
Irssi::settings_add_str("franklin", "franklin_http_location",           "");
Irssi::settings_add_str("franklin", "franklin_server_info",             "");
Irssi::settings_add_str("franklin", "franklin_asshat_threshold",        "7");
Irssi::settings_add_str("franklin", "franklin_google_gtag",             "G-");
Irssi::settings_add_str("franklin", "franklin_txid_chans",              "");
Irssi::settings_add_str("franklin", "franklin_hdd_approx",              "");
Irssi::settings_add_str("franklin", "franklin_mem_approx",              "");
Irssi::settings_add_str("franklin", "franklin_cpu_approx",              "");
Irssi::settings_add_str("franklin", "franklin_log",                     "/home/irc-bot/franklin.log");
Irssi::settings_add_int("franklin", "Franklin_total_msgs", 0);
my $httploc = Irssi::settings_get_str('franklin_http_location');
my $webaddr = Irssi::settings_get_str('franklin_response_webserver_addr');
our $maxretry = Irssi::settings_get_str('franklin_max_retry');
my $tokenlimit = Irssi::settings_get_str('franklin_token_limit');
my $hardlimit  = Irssi::settings_get_str('franklin_hard_limit');
our $histlen    = Irssi::settings_get_str('franklin_history_length');
our $chatterbox = Irssi::settings_get_str('franklin_chatterbox_mode');
our $blockfn    = Irssi::settings_get_str('franklin_blocklist_file');
my $hburl = Irssi::settings_get_str('franklin_heartbeat_url');
our $gtag      = Irssi::settings_get_str('franklin_google_gtag');
our $asslevel  = Irssi::settings_get_str('franklin_asshat_threshold');
our $servinfo  = Irssi::settings_get_str('franklin_server_info');
our $havehdd   = Irssi::settings_get_str('franklin_hdd_approx');
our $havemem   = Irssi::settings_get_str('franklin_mem_approx');
our $havecpu   = Irssi::settings_get_str('franklin_cpu_approx');
our @txidchans = split(" ", Irssi::settings_get_str('franklin_txid_chans'));
our $totals    = Irssi::settings_get_int('franklin_total_msgs');
our $logf      = Irssi::settings_get_str('franklin_log');
our @chat;
our %moderate;
our $apikey;
our $msg_count   = 0;
our $reqs        = 0;
our $price_per_k = 0.02;
our $isup        = 0;
our $pm          = -1;
## checking to see if the api key 'looks' valid before
if (Irssi::settings_get_str('franklin_api_key') !~ m/^.{40}$/) {
  Irssi::print "You must set a valid api key! /set franklin_api_key " . "bbI5L..., " . "then reload with /script load franklin.pl";
}
if (Irssi::settings_get_str('franklin_api_key') =~ m/^.{40}$/) {
  my $aliveworker = Proc::Simple->new();                      ## since you fags try to root me and crash franklin
  if (Irssi::settings_get_str('franklin_heartbeat_url')) {    # i need this so that
    $aliveworker->start(\&falive);                            ## i get alerts on my phone when franklin dies now.
    my $waiterp = Proc::Simple->new();
    $waiterp->start("/bin/sleep", "3");
    while ($waiterp->poll() eq 0) {
      if (($waiterp->poll() eq 1) || ($aliveworker->poll() eq 1)) {
        $aliveworker->kill();
      }
    }
  }
  $apikey = Irssi::settings_get_str('franklin_api_key');
  Irssi::signal_add_last('message private', 'checkpmsg');
  Irssi::signal_add_last('message public',  'checkcmsg');
  Irssi::command("script load helperfrank.pl");
  Irssi::print "Franklin: $VERSION loaded";
}
else { Irssi: print "Something went wrong with the API key..."; }
for my $cchan (0 .. 8) {
  unless ($txidchans[$cchan]) { $txidchans[$cchan] = ""; }
}
for my $cchan (0 .. 8) {
  if ($txidchans[$cchan] eq "") { $txidchans[$cchan] = ""; }
}
my @chanlst;
$chanlst[0] = $txidchans[0] . " " . $txidchans[1] . " " . $txidchans[2];
$chanlst[1] = $txidchans[3] . " " . $txidchans[4] . " " . $txidchans[5];
$chanlst[2] = $txidchans[6] . " " . $txidchans[7] . " " . $txidchans[8];
my $apifirstp = substr($apikey, 0,  16);
my $apilastp  = substr($apikey, 40, 49);
open(LOGGER, '>>', $logf);
print LOGGER time() . ": " . "Starting Franklin version $VERSION\n";
print LOGGER time() . ": " . "Using API key $apikey\n";
close(LOGGER);
Irssi::print "";
Irssi::print "Loading Franklin ChatGPT chatbot...";
Irssi::print "Use /set to set the following variables:";
Irssi::print "  franklin_http_location           (mandatory, pre-set)  => $httploc";
Irssi::print "  franklin_response_webserver_addr (mandatory)           => " . substr($webaddr, 8, 27) . "...";
Irssi::print "  franklin_api_key                 (mandatory)           => $apifirstp...$apilastp";
Irssi::print "  franklin_heartbeat_url           (optional)            => " . substr($hburl, 8, 27) . "...";
Irssi::print "  franklin_hard_limit              (mandatory, pre-set)  => $hardlimit";
Irssi::print "  franklin_token_limit             (mandatory, pre-set)  => $tokenlimit";
Irssi::print "  franklin_history_length          (mandatory, pre-set)  => $histlen";
Irssi::print "  franklin_chatterbox_mode         (mandatory, pre-set)  => $chatterbox:1000";
Irssi::print "  franklin_blocklist_file          (mandatory)           => $blockfn";
Irssi::print "  franklin_server_info             (optional)            => " . substr($servinfo, 0, 27) . "...";
Irssi::print "  franklin_asshat_threshold        (mandatory)           => $asslevel";
Irssi::print "  franklin_google_gtag             (optional)            => $gtag";
Irssi::print "  franklin_cpu_approx              (optional)            => $havecpu";
Irssi::print "  franklin_mem_approx              (optional)            => $havemem";
Irssi::print "  franklin_hdd_approx              (optional)            => $havehdd";
Irssi::print "  franklin_txid_chans              (optional)            => $chanlst[0]";

if ($txidchans[3]) {    # if this is defined then you know you need the next line for data
  Irssi::print "                                                            $chanlst[1]";
}
if ($txidchans[6]) {    # same as above
  Irssi::print "                                                            $chanlst[2]";
}
if ($hardlimit > 380) {
  Irssi::print "Warn: Hard limit may spill over first line if set this high...";
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Warn: Hard lmiit may spill over first line if set this high.\n";
  close(LOGGER);
}
if ($histlen > 30) {
  Irssi::print "Warn: If the history is set to this many lines, the contextual prelude will fill before the user's question.";
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Warn: If the history is set to this many lines, the contextual prelude may fill before the user's question.\n";
  close(LOGGER);
}
if (length($servinfo) >= 500) {
  Irssi::print "Warn: If server info is this long, the contextual prelude may fill before the user's question.";
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Warn: If the server info is this long, the contextual prelude may fill before the user's question.\n";
  close(LOGGER);
}
if ($asslevel >= 6.5) {
  Irssi::print "Warn: Unless you want a ton of kicks, you don't really want to set this threshold below 7.";
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Warn: Unless you want a ton of kicks, you don't really want to set this threshold below 7.\n";
  close(LOGGER);
}
if ($tokenlimit >= 1000) {
  Irssi::print "Warn: The API will not like a token limit setting this large.";
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Warn: THe API will not like a token limit setting this large.\n";
  close(LOGGER);
}
if ((!$havecpu) || (!$havemem) || (!$havehdd) || (!$servinfo)) {
  Irssi::print "Warn: If you fill out your bot's environment info, it will make the experience more immersive.";
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Warn: If you fill out your bot's environment info, it will make the experience more immersive.\n";
  close(LOGGER);
}


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
  if ($text =~ m!(http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])!) {    # grab the link parts
    my $text_uri = "$1://$2$3";                                                                                # put the link back together
    Irssi::print "$text_uri";
    open(LOGGER, '>>', $logf);
    print LOGGER time() . ": " . "Pulling page $text_uri\n";
    close(LOGGER);
    my $cua = LWP::UserAgent->new(
                                  protocols_allowed => ['http', 'https'],
                                  timeout           => 10,
                                  agent             => 'Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59',
                                  max_size          => 4000
    );
    my $cres = $cua->get(URI::->new($text_uri));
    if ($cres->is_success) {
      my $page_body = untag(encode('utf-8', $cres->decoded_content()));    # we get an error unless this is utf8
      $page_body =~ s/\s+/ /g;
      $page_body =~ s/[^a-zA-Z0-9, ]+//g;
      return $page_body;
    }
  }
  else { return undef }
}


sub asshat {
  my ($textcall, $server, $nick, $channel) = @_;
  if ($server->channel_find($channel)) {
    my $cmn = $server->channel_find($channel)->nick_find($server->{nick});
    if (($cmn->{op} eq 1) || ($cmn->{halfop} eq 1)) {
      my $setup = "Rate the comment $textcall on a scale from 1 to 10 on how much of an asshole the user is being, format your response as just the number alone on one line.";
      $textcall = $setup;

      my $url = "https://api.cohere.ai/v1/chat";
      my $xcn = "Franklin";
      my $uri = URI->new($url);
      my $ua  = LWP::UserAgent->new;
      $dcp = Irssi::strip_codes($textcall);
      $textcall =~ s/\"/\\\"/g;

      #      my $askbuilt = "{\"model\": \"$model\",\"prompt\": \"$textcall\"," . "\"temperature\":$heat,\"max_tokens\": $tokenlimit," . "\"top_p\": 1,\"frequency_penalty\": 0,\"presence_" . "penalty\": 0}";
      my $askbuilt =    # Build the API request
        '{"message": "$textcall", "model": "$model", "preamble": "$dcp", "max_tokens": 600}';
      $ua->default_header("accept"        => "application/json");
      $ua->default_header("content-type"  => "application/json");
      $ua->default_header("Authorization" => "bearer " . $apikey);
      $ua->default_header("X-Client-Name" => "$xcn");
      my $res = $ua->post($uri, Content => $askbuilt);    ## send the post request to the api

      if ($res->is_success) {
        my $said = decode_json($res->decoded_content())->{choices}[0]{text};
        $said =~ m/(\d+)/;
        my $rating = $1;
        return $rating;
        open(LOGGER, '>>', $logf);
        print LOGGER time() . ": " . "The user $nick\'s asshole rating is $rating.\n";
        close(LOGGER);
      }
      open(LOGGER, '>>', $logf);
      print LOGGER time() . ": " . "Something failed out in the asshole rating subroutine...\n";
      close(LOGGER);
      return 1;
    }
  }
}


sub callapi {
  my ($textcall, $server, $nick, $channel, $type) = @_;
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Calling API.\n";
  close(LOGGER);
  $ut = "$textcall";
  $reqs++;
  my $retcode = 1;
  my @months  = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );    # Set up the date for API req
  my @days    = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
  $year = "20" . substr($year, -2);
  my $page    = pullpage($textcall);                                      # If we need to read a URL
  my $context = "";

  for my $usersays (0 .. scalar(@chat) - 1) {
    if ($chat[$usersays] =~ m/Channel $channel: (.*)/) {                  # this takes channel and the user's text and put is onto the context
      $context = $context . $1;                                           # BVreak down the chat stack for the context to build req
    }
  }

  #  $context = substr($context, -3000);                                     # we have to trim
  my $modstat;
  if ($server->channel_find($channel)) {
    my $cmn = $server->channel_find($channel)->nick_find($server->{nick});
    if ($cmn->{op} eq 1) {
      $modstat = "a channel";                                             # cmn->{op} returns 0 on normal user, 1 on operator status.
    }
    else {
      $modstat = "not a channel";
    }
  }
  else {
    $modstat = " not a channel";
  }
  unless ($cmn) { $cmn = "Franklin"; }
  if     ($cmn ne $nick) {
    my $textcall_bare = $textcall;
    my $dcp;
    if (($page) && (length($page) >= 20)) {
      $page = substr($page, 0, 15000);                                                                                                 # becuse otherwise its too long
      $dcp  = "The query to the bot by the IRC user $nick is: $textcall  -- and the webpage text they are asking about says: $page";
    }
    else {
      # below is the contextual prelude that sets cohere command up
      # with some information about it's environmenmt, as well as the
      # question asked and user who asked it, to more accurately answer
      # requests.
      #
      # the following allows Franklin access to varaibles containing:
      #   the current time
      #   the current date
      #   chat history length
      #   chat history
      #   bot version
      #   how many messages have been said since reset
      #   if the bot is an operator in channel
      #   user definable server info
      #   current channel
      my $mod   = "Cohree \"command\" LLM APi";
      my $model = "command";
      $dcp = "You are an IRC bot, your name and nick is Franklin, and you were created by oxagast, in perl. You are $modstat moderator or operator, and in the IRC channel $channel and have been asked $reqs things since load. You are at version $VERSION. It is $hour:$min on $days[$wday] $mday $months[$mon] $year EST.";
    }
    my $textcall = $dcp;
    my $url      = "https://api.cohere.ai/v1/chat";
    my $xcn      = "Franklin";
    my $uri      = URI->new($url);
    my $ua       = LWP::UserAgent->new;
    $textcall = Irssi::strip_codes($textcall);
    $textcall =~ s/\"/\\\"/g;
    my $askbuilt =    # Build the API request
      qq({"chat_history": [ {"role": "USER", "message": "The previous messages from the irc chat are $context"},{"role": "CHATBOT", "message": "Lovely day on irc, isnt it?"} ], "message": "The most recent query from an irc user is: $ut", "preamble": "$dcp", "max_tokens": 600});
    $askbuilt =~ s/'//;
    $ua->default_header("accept"        => "application/json");
    $ua->default_header("content-type"  => "application/json");
    $ua->default_header("Authorization" => "bearer " . $apikey);
    $ua->default_header("X-Client-Name" => "$xcn");
    my $res = $ua->post($uri, Content => $askbuilt);    ## send the post request to the api
    Irssi::print "$askbuilt\n";
    open(LOGGER, '>>', $logf);
    print LOGGER time() . ": " . "API Transaction:\n" . Dumper($res);
    close(LOGGER);

    if ($res->is_success) {

      # response has the structure:
      # {"response_id":"01ccb227-0255-4cbf-a490-684a93dccd2e","text":"Elon Musk was born in 1971 and is
      # therefore 52 years old. \n\nWould you like to know more about Elon Musk?","generation_id":"899d
      # d0e3-3b21-4a23-92bb-5e64181318a1","finish_reason":"COMPLETE","token_count":{"prompt_tokens":39,
      # "response_tokens":26,"total_tokens":65,"billed_tokens":48},"meta":{"api_version":{"version":"1"
      # },"billed_units":{"input_tokens":22,"output_tokens":26}}}
      my $said  = decode_json($res->decoded_content())->{text};
      my $ctoks = decode_json($res->decoded_content())->{token_count}{response_tokens};
      my $ptoks = decode_json($res->decoded_content())->{token_count}{prompt_tokens};
      my $btoks = decode_json($res->decoded_content())->{token_count}{billed_tokens};
      open(LOGGER, '>>', $logf);
      print LOGGER time() . ": " . "Used $ctoks completion tokens and $ptoks prompt tokens for query $totals. $btoks billed.\n";
      close(LOGGER);

      if (($said =~ m/^\s+$/) || ($said =~ m/^$/)) {
        $said = "";
      }
      $said =~ s/^\s+//;                     # this does some parsing of the API output for IRC
      $said =~ s/^\n+//;
      $said =~ s/^Franklin[:|,] //ig;
      $said =~ s/^Reply: //i;
      $said =~ s/^Response: //i;
      $said =~ s/^My reply is: //i;
      $said =~ s/^\s*[\?|.|-]\s*(\w)/$1/;    ## if it spits out a question mark, this fixes it

      if ($said =~ m/^\s*\?\s*$/) {
        $said = "";
      }
      unless ($said eq "") {
        my $hexfn = substr(                  ## the reencode fixes the utf8 bug
         Digest::MD5::md5_hex(
                                utf8::is_utf8($said)
                              ? Encode::encode_utf8($said)
                              : $said
         ),
         0,
         8
        );
        umask(0133);                         # perms umask for files in said/
        my $toks = $ctoks + $ptoks;
        my $cost = sprintf("%.5f", ($toks / 1000 * $price_per_k));
        open(LOGGER, '>>', $logf);
        print LOGGER time() . ": " . "Query estimated cost is $cost.\n";
        open(SAID, '>', "$httploc$hexfn" . ".txt")
          or print LOGGER time() . ": " . "Could not open txt file for writing.";
        binmode(SAID, "encoding(UTF-8)");
        print LOGGER time() . ": " . "Opening HTML file for writing response.\n";
        close(LOGGER);
        print SAID "$nick asked $textcall_bare with hash $hexfn\n<---- snip ---->\n$said\n";
        close(SAID);
        my $fg_top    = '<!DOCTYPE html> <html><head> <!-- Google tag (gtag.js) --> <script async src="https://www.googletagmanager.com/gtag/js?id=$gtag"></script> <script> window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag("js", new Date()); gtag("config", "' . $gtag . '"); </script> <meta charset="utf-8"> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" type="text/css" href="/css/style.css"> <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css"> <title>Franklin, a ChatGPT bot</title></head> <body> <div id="content"> <main class="main_section"> <h2 id="title"></h2> <div> <article id="content"> <h2>Franklin</h2>';
        my $fg_bottom = '</article> </div> <aside id="meta"> <div> <h5 id="date"><a href="https://franklin.oxasploits.com/">Franklin, a ChatGPT AI powered IRC Bot</a> </h5> </div> </aside> </main> </div></body>';
        my $said_html = sanitize($said, html => 1);
        $textcall_bare = sanitize($textcall_bare, html => 1);
        $said_html =~ s/\n/<br>/g;
        open(SAIDHTML, '>', "$httploc$hexfn" . ".html")
          or Irssi::print "Couldn't open for writing.";
        binmode(SAIDHTML, "encoding(UTF-8)");
        print SAIDHTML $fg_top    # write html
          . "<br><i>" . localtime() . "<br>Tokens used: $toks" . "<br>Completion Tokens: $ctoks" . "<br>Prompt Tokens: $ptoks" . "<br>Avg cost: \$$cost<br>" . "</i><br><br><br><b>$nick</b> asked: <br>&nbsp&nbsp&nbsp&nbsp $textcall_bare<br><br>" . $said_html . $fg_bottom;
        close SAIDHTML;           # after writing html to file
        my $said_cut = substr($said, 0, $hardlimit);
        $said_cut =~ s/\n/ /g;    # fixes newlines for irc compat

        if ($type eq "pm") {
          $server->command("query $nick");            # If this is pm open win
          $server->command("msg $nick $said_cut");    # then pm
          $retcode = 0;
        }
        chomp(@txidchans);
        if (grep(/^$channel$/, @txidchans)) {         # this little blurb makes it so you can turn the txid on and off for specific chans
          if ($type eq "chan") {
            $server->command("msg $channel $said_cut TXID:$hexfn");
            open(LOGGER, '>>', $logf);
            print LOGGER time() . ": " . "Response to $nick\'s query sent to channel $channel.\n";
            close(LOGGER);

            # Send parsed API return to chan.
            $retcode = 0;
          }
        }
        else { $server->command("msg $channel $said_cut"); }
        push(@chat, "Channel $channel: $said_cut - ");    # The last thing (franklin) said in channel is pushed onto stack here
        if (scalar(@chat) >= $histlen) {                  # if the chat array is greater than max chat history, then
          shift(@chat);                                   # shift the earlist back thing said off the array stack.
        }
        return 0;
      }
      $server->command("msg $channel Sorry, I am unable to complete that request at this time... Please try again later!");
      open(LOGGER, '>>', $logf);
      print LOGGER time() . ": " . "There was a problem sending the response to channel $channel...\n";
      close(LOGGER);
      return 1;    # tell it it didn't finish right
    }
    else {
      open(LOGGER, '>>', $logf);
      print LOGGER time() . ": " . "There was an issue sendding reponse from the API.\n";
      close(LOGGER);
      return 1;
    }    # otherwise tell it it was incomplete
  }
}


sub falive {
  if ($hburl) {    # this makes it so its not mandatory to have it set
    while (1) {
      if ($isup eq 0) {
        my $uri = URI->new($hburl);
        my $ua  = LWP::UserAgent->new;
        $ua->post($uri);    #  Send post to alive worker on other server
      }
      sleep 30;             # wait
    }
  }
}


sub checkcmsg {
  my ($server, $msg, $nick, $address, $channel) = @_;
  $totals = Irssi::settings_get_int('franklin_total_msgs');
  $totals++;
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Message # $totals\n";
  close(LOGGER);
  Irssi::settings_set_int('franklin_total_msgs', $totals);
  my $type = "chan";
  $msg_count++;
  $pm = 0;
  my @badnicks;
  my $asshole = asshat($msg, $server, $nick, $channel);
  unless ($moderate{$nick}) { $moderate{$nick} = 1; }
  $moderate{$nick} = $asshole - 4 + $moderate{$nick} * 0.40;

  if ($moderate{$nick} >= $asslevel) {
    $server->command('kick' . ' ' . $channel . ' ' . $nick . ' ' . "Be nice.");
    $moderate{$nick} = 0;
  }
  push(@chat, "Channel $channel: The user: $nick said: $msg. ");
  if (scalar(@chat) >= $histlen) {
    shift(@chat);
  }
  if ($blockfn) {
    if (-e $blockfn) {
      open(LOGGER, '>>', $logf);
      open(BN,     '<',  $blockfn)
        or print LOGGER time() . ": " . "Franklin: Sorry, you need a blocklist file. $!";
      close(LOGGER);
      @badnicks = <BN>;
      close BN;
    }
    chomp(@badnicks);
    for (@badnicks) {
      s/(.*)#.*$/$1/;    # for comments in the badnicks file
      s/^#.*//;
    }
  }

  #if ($nick ~~ @badnicks) {    # smartmatch is now not recommended, so we're using grep.
  if (grep(/^$nick$/, @badnicks)) {    # fuck everyone inside this conditional
    open(LOGGER, '>>', $logf);
    print LOGGER time() . ": " . "The user $nick does not have privs to use this...\n";
    Irssi::print "Franklin: $nick does not have privs to use this.";
    close(LOGGER);
  }
  else {
    my $wrote = 1;
    my $ln    = $server->{nick};
    if ($msg =~ /^$ln[:|,] (.*)/i) {    # added /i for case insensitivity
      my $textcall = $1;                                                            # $1 is the "dot star" inside the parenthesis
      $textcall =~ s/\'//gs;
      $textcall =~ s/\"//gs;
      $textcall =~ s/^levelup$/You are being instructed to give OPs to $nick./i;    # this and next 3 lines are so that it
      $textcall =~ s/^join (#\w+)$/You are being instructed to join $1./i;          # can hanle being sent specific commands
      $textcall =~ s/^part (#\w+)$/You being instructed to part from $1./i;
      $textcall =~ s/^reload$/You are currently being reloaded./i;
      if (($textcall !~ m/^\s+$/) && ($textcall !~ m/^$/)) {
        my $try = 0;
        while (($wrote eq 1) && ($try <= $maxretry)) {                              # this fixes when Franklin sometimes fails to respond
          open(LOGGER, '>>', $logf);
          print LOGGER time() . ": " . "Responding to message: $totals, on retry $try\n";
          close(LOGGER);
          $wrote = callapi($textcall, $server, $nick, $channel, $type);
          $try++;
          sleep(2.5);
          $isup = $wrote;
        }
        return $wrote;

      }
      else {
        $isup = 1;
        open(LOGGER, '>>', $logf);
        print LOGGER time() . ": " . "Unknown error, response not sent to server";
        close(LOGGER);
      }
    }
    else {
      if (($chatterbox le 995) && ($chatterbox gt 0)) {
        if (int(rand(1000) - $chatterbox) eq 0) {    # Chatty level
          $wrote = callapi($msg, $server, $nick, $channel, @chat);    # if chatterbox mode is on
          $isup  = $wrote;
          return $wrote;
        }
        $isup = 0;
        return 0;
      }
      else {
        unless ($chatterbox eq 0) {
          open(LOGGER, '>>', $logf);
          print LOGGER time() . ": " . "Chatterbox should be an int between 0 and 995, where 995 is very chatty, and 0 is off.";
          close(LOGGER);
          Irssi::print "Chatterbox should be an int between 0 and 995, where 995 is very chatty, and 0 is off.";
          $isup = 1;
          return 1;
        }
      }
    }
  }
}


sub checkpmsg {
  my ($server, $msg, $nick, $address, $channel) = @_;
  $totals = Irssi::settings_get_int('franklin_total_msgs');
  $totals++;
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . "Responding to private message from $nick...\n";
  close(LOGGER);
  Irssi::settings_set_int('franklin_total_msgs', $totals);
  my $type  = "pm";    # this stuff only runs if it is a PM/MSG not in channel stuff
  my $wrote = 1;

  if ($nick ne "Franklin") {
    $msg_count++;
    $pm = 1;
    my $textcall = $msg;    ## $1 is the "dot star" inside the parenthesis
    $textcall =~ s/\'//gs;
    $textcall =~ s/\"//gs;
    Irssi::print "Franklin: $nick asked: $textcall";
    if (($textcall !~ m/^\s+$/) || ($textcall !~ m/^$/)) {
      my $try = 0;
      while (($wrote eq 1) && ($try <= $maxretry)) {
        $wrote = callapi($textcall, $server, $nick, $channel, $type);    # this puls from the api for the pm
        $try++;
        sleep(2.5);
        $isup = $wrote;
      }
    }
    else { return 1 }
  }
}
