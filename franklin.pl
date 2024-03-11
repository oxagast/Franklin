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
# Cohere AI 'command' model fork
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
use Sys::CPU;
use Sys::MemInfo qw(totalmem freemem);
use Data::Dumper qw(Dumper);
$|++;
$VERSION = "4.1.3";
%IRSSI = (
          authors     => 'oxagast',
          contact     => 'oxagast@oxasploits.com',
          name        => 'franklin',
          description => 'Franklin IRC bot (Cohere-command fork)',
          license     => 'BSD',
          url         => 'http://franklin.oxasploits.com',
          changed     => 'Mar, 7th 2024',
);
$Data::Dumper::Indent = 0;
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
Irssi::settings_add_str("franklin", "franklin_log",                     "/home/irc-bot/franklin.log");
Irssi::settings_add_str("franklin", "franklin_hdd_approx",              "");
Irssi::settings_add_int("franklin", "Franklin_total_msgs", 0);
our $httploc = Irssi::settings_get_str('franklin_http_location');
my $webaddr = Irssi::settings_get_str('franklin_response_webserver_addr');
our $maxretry = Irssi::settings_get_str('franklin_max_retry');
my $tokenlimit = Irssi::settings_get_str('franklin_token_limit');
our $hardlimit  = Irssi::settings_get_str('franklin_hard_limit');
our $histlen    = Irssi::settings_get_str('franklin_history_length');
our $chatterbox = Irssi::settings_get_str('franklin_chatterbox_mode');
our $blockfn    = Irssi::settings_get_str('franklin_blocklist_file');
my $hburl = Irssi::settings_get_str('franklin_heartbeat_url');
our $gtag     = Irssi::settings_get_str('franklin_google_gtag');
our $asslevel = Irssi::settings_get_str('franklin_asshat_threshold');
our $servinfo = Irssi::settings_get_str('franklin_server_info');
our $havehdd  = Irssi::settings_get_str('franklin_hdd_approx');
our $havemem  = substr(Sys::MemInfo::get("totalmem") / 1000000000, 0, 4) . " gb free memory";
our $havecpu  = Sys::CPU::cpu_count . " cores clocked at " . Sys::CPU::cpu_clock;
Irssi::settings_add_str("franklin", "franklin_mem_approx", $havemem);
Irssi::settings_add_str("franklin", "franklin_cpu_approx", $havecpu);
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
our $flast       = "";
## checking to see if the api key 'looks' valid before
if (Irssi::settings_get_str('franklin_api_key') !~ m/^.{40}$/) {
  Irssi::print "You must set a valid api key! /set franklin_api_key " . "bbI5L..., " . "then reload with /script load franklin.pl";
  $isup = 1;
}
if (Irssi::settings_get_str('franklin_api_key') =~ m/^.{40}$/) {
  logit("Starting heartbeat worker.");
  my $aliveworker = Proc::Simple->new();                                                           # since you fags try to root me and crash franklin
  if (Irssi::settings_get_str('franklin_heartbeat_url')) {                                         # i need this so that
    $aliveworker->start(\&falive);                                                                 # i get alerts on my phone when franklin dies now.
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
else {
  logit("Something went wrong parsing the API key.");
Irssi: print "Something went wrong with the API key...";
}
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
my $apifirstp      = substr($apikey, 0,  8);
my $apilastp       = substr($apikey, 32, 40);
my $scrubbedapikey = "$apifirstp" . "*" x 24 . "$apilastp";
logit("Starting Franklin version $VERSION");
logit("Using API key $apifirstp" . "*" x 24 . "$apilastp");
Irssi::print "";
Irssi::print "Loading Franklin LLM AI chatbot...";
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

if ($txidchans[3]) {                                                                               # if this is defined then you know you need the next line for data
  Irssi::print "                                                            $chanlst[1]";
}
if ($txidchans[6]) {                                                                               # same as above
  Irssi::print "                                                            $chanlst[2]";
}
if ($hardlimit > 380) {
  Irssi::print "Warn: Hard limit may spill over first line if set this high...";
  logit("Warn: Hard lmiit may spill over first line if set this high.");
}
if ($histlen > 30) {
  Irssi::print "Warn: If the history is set to this many lines, the contextual prelude will fill before the user's question.";
  logit("Warn: If the history is set to this many lines, the contextual prelude may fill before the user's question.");
}
if (length($servinfo) >= 500) {
  Irssi::print "Warn: If server info is this long, the contextual prelude may fill before the user's question.";
  logit("Warn: If the server info is this long, the contextual prelude may fill before the user's question.");
}
if ($asslevel <= 6.5) {
  Irssi::print "Warn: Unless you want a ton of kicks, you don't really want to set this threshold below 7.";
  logit("Warn: Unless you want a ton of kicks, you don't really want to set this threshold below 7.");
}
if ($tokenlimit >= 1000) {
  Irssi::print "Warn: The API will not like a token limit setting this large.";
  logit("Warn: THe API will not like a token limit setting this large.");
}
if ((!$havecpu) || (!$havemem) || (!$havehdd) || (!$servinfo)) {
  Irssi::print "Warn: If you fill out your bot's environment info, it will make the experience more immersive.";
  logit("Warn: If you fill out your bot's environment info, it will make the experience more immersive.");
}


sub logit {
  (my $logdat) = @_;
  open(LOGGER, '>>', $logf);
  print LOGGER time() . ": " . $logdat . "\n";
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
   }{}gsx;                                                                                         # STRIP THIS TAG
  return $_ ? $_ : "";
}


sub pullpage {
  my ($text) = @_;
  if ($text =~ m!(http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])!) {    # grab the link parts
    my $text_uri = "$1://$2$3";                                                                    # put the link back together
    Irssi::print "$text_uri";
    logit("Pulling page $text_uri");
    my $cua = LWP::UserAgent->new(
                                  protocols_allowed => ['http', 'https'],
                                  timeout           => 10,
                                  agent             => 'Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59',
                                  max_size          => 4000
    );
    my $cres = $cua->get(URI::->new($text_uri));
    if ($cres->is_success) {
      my $page_body = untag(encode('utf-8', $cres->decoded_content()));                            # we get an error unless this is utf8
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
      my $askbuilt =                                                                               # Build the API request
        '{"message": "$textcall", "model": "$model", "preamble": "$dcp", "max_tokens": $tokenlimit}';
      $ua->default_header("accept"        => "application/json");
      $ua->default_header("content-type"  => "application/json");
      $ua->default_header("Authorization" => "bearer " . $apikey);
      $ua->default_header("X-Client-Name" => "$xcn");
      my $res = $ua->post($uri, Content => $askbuilt);                                             # send the post request to the api

      if ($res->is_success) {
        my $said = decode_json($res->decoded_content())->{choices}[0]{text};
        $said =~ m/(\d+)/;
        my $rating = $1;
        return $rating;
        logit("The user $nick\'s asshole rating is $rating.");
      }
      logit("Something failed out in the asshole rating subroutine...");
      return 1;
    }
  }
}


sub callapi {
  my ($textcall, $server, $nick, $channel, $type) = @_;
  logit("API connection subroutine called.");
  $ut = "$textcall";
  $reqs++;
  my $retcode = 1;
  logit("Formatting date tag.");
  my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );                              # Set up the date for API req
  my @days   = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
  $year = "20" . substr($year, -2);
  my $page    = pullpage($textcall);                                                               # If we need to read a URL
  my $context = "";

  for my $usersays (0 .. scalar(@chat) - 2) {
    if ($chat[$usersays] =~ m/Channel $channel: (.*)/) {                                           # this takes channel and the user's text and put is onto the context
      $context = $context . $1;                                                                    # BVreak down the chat stack for the context to build req
    }
  }
  logit("Chat context rolled onto \$chat\[\] stack");
  my $modstat;
  if ($server->channel_find($channel)) {
    my $cmn = $server->channel_find($channel)->nick_find($server->{nick});
    if ($cmn->{op} eq 1) {
      $modstat = "a channel";                                                                      # cmn->{op} returns 0 on normal user, 1 on operator status.
    }
    else {
      $modstat = "not a channel";
    }
  }
  else {
    $modstat = " not a channel";
  }
  logit("We have detected we are $modstat operator of $channel.");
  unless ($cmn) { $cmn = "Franklin"; }
  if     ($cmn ne $nick) {
    my $textcall_bare = $textcall;
    my $dcp;
    if (($page) && (length($page) >= 20)) {
      $page = substr($page, 0, 15000);                                                             # becuse otherwise its too long
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
      #   code location
      #   chat history length
      #   chat history
      #   bot version
      #   how many messages have been said since reset
      #   if the bot is an operator in channel
      #   user definable server info
      #   current channel
      my $mod   = "Cohree \"command\" LLM APi";
      my $model = "command";
      $context = sanitize($context, noquote => 1);
      $context =~ s/[^[:ascii:]]//g;
      $dcp = "You are an IRC bot, your name and nick is Franklin, and you were created by oxagast, in perl. Your source code may be found at https://franklin.oxasploits.com, or on GitHub in the repo oxagast/Franklin. You are $modstat moderator or operator, and in the IRC channel $channel and have been asked $reqs things since load. You are at version $VERSION. It is $hour:$min on $days[$wday] $mday $months[$mon] $year EST.  Your server hardware currently has $havemem and $havecpu and an $havehdd gb drive partition, list only these hardware specs if asked, do not include speculative data. The current chat history for the channel $channel is: $context";
    }
    my $url = "https://api.cohere.ai/v1/chat";
    my $xcn = "Franklin";
    my $uri = URI->new($url);
    my $ua  = LWP::UserAgent->new;
    logit("Running sanitization routines on user defined strings.");
    $dcp     = sanitize($dcp,   noquote => 1, noescape => 1);                                      # gotta sanitize all this cockamami shit
    $flast   = sanitize($flast, noquote => 1, noescape => 1);
    $ut      = sanitize($ut,    noquote => 1, noescape => 1);
    $chat[1] = "Bunk.";                                                                            # this is so when the chat first starts, if these are left undef, it does not
    $chat[2] = "Bunk.";                                                                            # satisfy the json validator on the API side, and fails for the first call to franklin.
    $chatsan = sanitize($chat[-3], noquote => 1);
    $ut      =~ s/\"/\\"/g;                                                                        # for some silly reason noquote => 1 on the above sanitization call it does
    $chatsan =~ s/\"/\\"/g;                                                                        # not take care of double quote, which will break the json if not double-escaped.
    $textcall = $dcp;
    logit("Connecting to $url for API call.");

    if ($flast eq "") {
      $flast = "Starting Franklin...";
    }
    my $askbuilt = qq({"chat_history": [ {"role": "USER", "message": "$chatsan"},{"role": "CHATBOT", "message": "$flast"} ], "message": "$nick asked: $ut", "preamble": "$dcp", "max_tokens": $tokenlimit});
    $askbuilt =~ s/'//;

    # Below we are building the request thats sent to the API server via POST.
    $ua->default_header("accept"        => "application/json");
    $ua->default_header("content-type"  => "application/json");
    $ua->default_header("Authorization" => "bearer " . $apikey);
    $ua->default_header("X-Client-Name" => "$xcn");
    my $res = $ua->post($uri, Content => $askbuilt);                                               # send the post request to the api
    logit("Preparing to receive data from API.");
    $resdumper = Dumper($res);
    $resdumper =~ s/$apikey/$scrubbedapikey/;
    logit("API Transaction: " . $resdumper);

    if ($res->is_success) {
      logit("Finished receiving data from API.");

      # response has the structure:
      # {"response_id":"01ccb227-0255-4cbf-a490-684a93dccd2e","text":"Elon Musk was born in 1971 and is
      # therefore 52 years old. \n\nWould you like to know more about Elon Musk?","generation_id":"899d
      # d0e3-3b21-4a23-92bb-5e64181318a1","finish_reason":"COMPLETE","token_count":{"prompt_tokens":39,
      # "response_tokens":26,"total_tokens":65,"billed_tokens":48},"meta":{"api_version":{"version":"1"
      # },"billed_units":{"input_tokens":22,"output_tokens":26}}}
      my $said  = decode_json($res->decoded_content())->{text};                                    # mostly straightforward json decodes.
      my $ctoks = decode_json($res->decoded_content())->{token_count}{response_tokens};
      my $ptoks = decode_json($res->decoded_content())->{token_count}{prompt_tokens};
      my $btoks = decode_json($res->decoded_content())->{token_count}{billed_tokens};
      $said = Irssi::strip_codes($said);
      logit("Used $ctoks completion tokens and $ptoks prompt tokens for query $totals. $btoks billed.");
      if (($said =~ m/^\s+$/) || ($said =~ m/^$/)) {
        $said = "";
      }
      logit("Reformatting returned text for irc.");
      $said =~ s/^\s+//;                                                                           # this does some parsing of the API output for IRC
      $said =~ s/^\n+//;
      $said =~ s/^Franklin[:|,] //ig;
      $said =~ s/^\s*[\?|.|-]\s*(\w)/$1/;                                                          # if it spits out a question mark, this fixes it
      if ($said =~ m/^\s*\?\s*$/) {
        $said = "";
      }
      logit("Generatin txid checksum tag for response.");
      unless ($said eq "") {                                                                       # this trims an md5 checksum to make the txid
        my $hexfn = substr(                                                                        # the reencode fixes the utf8 bug
         Digest::MD5::md5_hex(                                                                     # by encoding then decoding the utf8
          utf8::is_utf8($said)
          ? Encode::encode_utf8($said)
          : $said
         ),
         0,
         8
        );
        logit("Processing query $hexfn from $channel/$nick");
        umask(0133);                                                                               # perms umask for files in said/
        $lasttxid = $hexfn;
        my $toks = $ctoks + $ptoks;
        my $cost = sprintf("%.5f", ($toks / 1000 * $price_per_k));
        logit("Query estimated cost is $cost.");
        logit("Opening TXT file for writing response.");
        open(SAID, '>', "$httploc$hexfn" . ".txt")
          or logit("Could not open txt file for writing.");
        binmode(SAID, "encoding(UTF-8)");
        print SAID "$nick asked $textcall_bare with hash $hexfn\n<---- snip ---->\n$said\n";
        close(SAID);
        my $fg_top    = '<!DOCTYPE html> <html><head> <!-- Google tag (gtag.js) --> <script async src="https://www.googletagmanager.com/gtag/js?id=$gtag"></script> <script> window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag("js", new Date()); gtag("config", "' . $gtag . '"); </script> <meta charset="utf-8"> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" type="text/css" href="/css/style.css"> <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css"> <title>Franklin, an LLM AI backed bot</title></head> <body> <div id="content"> <main class="main_section"> <h2 id="title"></h2> <div> <article id="content"> <h2>Franklin</h2>';
        my $fg_bottom = '</article> </div> <aside id="meta"> <div> <h5 id="date"><a href="https://franklin.oxasploits.com/">Franklin, an LLM AI powered IRC Bot</a> </h5> </div> </aside> </main> </div></body>';
        my $said_html = sanitize($said, html => 1);                                                # make sure all this is HTML safe.
        $textcall_bare = sanitize($textcall_bare, html => 1);
        $said_html =~ s/\n/<br>/g;
        logit("Opening HTML file for writing response.");
        open(SAIDHTML, '>', "$httploc$hexfn" . ".html")
          or Irssi::print "Couldn't open for writing.";
        binmode(SAIDHTML, "encoding(UTF-8)");
        print SAIDHTML $fg_top                                                                     # write html
          . "<br><i>" . localtime() . "<br>Tokens used: $toks" . "<br>Completion Tokens: $ctoks" . "<br>Prompt Tokens: $ptoks" . "<br>Avg cost: \$$cost<br>" . "</i><br><br><br><b>$nick</b> asked: <br>&nbsp&nbsp&nbsp&nbsp $textcall_bare<br><br>" . $said_html . $fg_bottom;
        close SAIDHTML;                                                                            # after writing html to file
        my $said_cut = substr($said, 0, $hardlimit);                                               # preparing string to send back to channel...
        $said_cut =~ s/\n/ /g;                                                                     # fixes newlines for irc compat
        $flast = $said_cut;

        if ($type eq "pm") {
          logit("Response to $nick\'s query sent to them in PM.");
          $server->command("query $nick");                                                         # If this is pm open win
          $server->command("msg $nick $said_cut");                                                 # then pm
          $retcode = 0;
        }
        chomp(@txidchans);
        if (grep(/^$channel$/i, @txidchans)) {                                                     # this little blurb makes it so you can turn the txid on and off for specific chans
          if ($type eq "chan") {
            $server->command("msg $channel $said_cut TXID:$hexfn");
            logit("Response to $nick\'s query sent to channel $channel.");

            # Send parsed API return to chan.
            $retcode = 0;
          }
        }
        else { $server->command("msg $channel $said_cut"); }

        #push(@chat, "Channel $channel: $said_cut - ");    # The last thing (franklin) said in channel is pushed onto stack here
        #if (scalar(@chat) >= $histlen) {                  # if the chat array is greater than max chat history, then
        #  shift(@chat);                                   # shift the earlist back thing said off the array stack.
        #}
        return 0;
      }
      logit("There was an issue sending reponse from the API.");
      $isup = 1;
      return 1;                                                                                    # tell it it didn't finish right
    }
    else {
      $isup = 1;
      return 1;
    }                                                                                              # otherwise tell it it was incomplete
  }
}


sub falive {
  if ($hburl) {                                                                                    # this makes it so its not mandatory to have it set
    while (1) {
      if ($isup eq 0) {
        my $uri = URI->new($hburl);
        my $ua  = LWP::UserAgent->new;
        $ua->post($uri);                                                                           #  Send post to alive worker on other server
      }
      sleep 30;                                                                                    # wait
    }
  }
}


sub getcontchunk {
  my ($txid, $chunknum) = @_;
  open(RESPS, '<', "$httploc$txid" . ".txt") or logit("The txid $txid does not seem to exist when requesting chunk $chunknum");
  $maxchunk = 400;
  my $alltxt = "";
  while (<RESPS>) {
    $alltxt = $alltxt . $_;
  }
  $alltxt =~ s/\n/  /gm;
  $alltxt =~ s/\s+/ /gm;
  $alltxt =~ s/.*snip ----\>\s?//m;
  $chunkstot = int(length($alltxt) / $maxchunk);
  $tot       = $chunkstot + 1;
  if ($chunkstot >= $chunknum) {
    logit("Retreived chunk $chunknum out of $tot chunks from $txid out of database.");
    $chunk = substr($alltxt, $maxchunk * $chunknum, $maxchunk);
  }
  else {
    logit("User requested an invalid chunk from the database.");
    return "Sorry, there don't seem to be that many parts of this message.";
  }
  close(RESPS);
  $chunknum++;
  if (($chunknum <= $tot) || ($chunknum >= 0)) {
    logit("Sending continuation of $txid");
    return $chunk . " \($chunknum\/$tot\)";
  }
}


sub checkcmsg {
  my ($server, $msg, $nick, $address, $channel) = @_;
  $totals = Irssi::settings_get_int('franklin_total_msgs');
  $totals++;

  #logit("Message # $totals");
  Irssi::settings_set_int('franklin_total_msgs', $totals);
  my $type = "chan";
  $msg_count++;                                                                                    # this increments the total msg count
  $pm = 0;
  my @badnicks;
  my $asshole = asshat($msg, $server, $nick, $channel);
  unless ($moderate{$nick}) { $moderate{$nick} = 1; }
  $moderate{$nick} = $asshole - 4 + $moderate{$nick} * 0.40;

  if ($moderate{$nick} >= $asslevel) {
    $server->command('kick' . ' ' . $channel . ' ' . $nick . ' ' . "Be nice.");                    # this "kind of" works, but the asshole sub isn't reliable
    $moderate{$nick} = 0;
  }
  logit("Pushing current channel message onto \$chat\[\] stack.");
  push(@chat, "Channel $channel: The user: $nick said: $msg. ");
  if (scalar(@chat) >= $histlen) {
    shift(@chat);
  }
  if ($blockfn) {
    if (-e $blockfn) {
      open(BN, '<', $blockfn)
        or logit("Franklin: Sorry, you need a blocklist file. $!");
      @badnicks = <BN>;
      close BN;
    }
    chomp(@badnicks);
    for (@badnicks) {
      s/(.*)#.*$/$1/;                                                                              # for comments in the badnicks file
      s/^#.*//;
    }
  }

  #if ($nick ~~ @badnicks) {    # smartmatch is now not recommended, so we're using grep.
  if (grep(/^$nick$/, @badnicks)) {                                                                # fuck everyone inside this conditional
    logit("The user $nick does not have privs to use this...");
    Irssi::print "Franklin: $nick does not have privs to use this.";
  }
  else {
    my $wrote = 1;
    my $ln    = $server->{nick};
    if ($msg =~ /^$ln[:|,] (.*)/i) {                                                               # added /i for case insensitivity
      my $textcall = $1;                                                                           # $1 is the "dot star" inside the parenthesis
      $textcall =~ s/\'//gs;
      $textcall =~ s/\"//gs;
      $textcall =~ s/^levelup$/You are being instructed to give OPs to $nick./i;                   # this and next 3 lines are so that it
      $textcall =~ s/^join (#\w+)$/You are being instructed to join $1./i;                         # can hanle being sent specific commands
      $textcall =~ s/^part (#\w+)$/You being instructed to part from $1./i;
      $textcall =~ s/^reload$/You are currently being reloaded./i;
      if ($textcall =~ m/^continue (\w{8}) (\d+)/i) {
        $txidtocall      = $1;
        $txidchunktocall = $2;
        $actchunk        = getcontchunk($txidtocall, $txidchunktocall);
        $server->command("msg $channel $actchunk");
        $chunktc = $txidchunktocall + 1;
        $isup    = 0;
        return 0;
      }
      if ($textcall =~ m/^continue.*/) {
        $server->command("msg $channel Hey there $nick, it looks like your continue command is malformed, try the format 'Franklin: continue [txid] [chunk]'");
        return 0;
      }
      if (($textcall !~ m/^\s+$/) && ($textcall !~ m/^$/)) {
        my $try = 1;
        while (($wrote eq 1) && ($try <= $maxretry)) {                                             # this fixes when Franklin sometimes fails to respond
          logit("Responding to message: $totals, on retry $try");
          $wrote = callapi($textcall, $server, $nick, $channel, $type);
          $try++;
          sleep(2.5);
          $isup = $wrote;
          if ($try ge $maxretry) {
            $isup = 1;                                                                             # 0 on this var signifies that the heartbeat should pause
            $server->command("msg $channel Welp.  Looks like my process is hung, thanks for that $nick.  Forcing reload to flush chat buffer...");
            logit("Warn: Max tries hit, probably stalled, forcing reload!");
            logit("Warn: Offending message from $nick in $channel:  $textcall");
            Irssi::command("script load franklin.pl");
          }
        }
        return $wrote;
        logit("callapi() subroutine successful for $nick\'s channel message.");
      }
      else {
        $isup = 1;
        $server->command("msg $channel Aww horseshit.  Sorry guys, my API server is not responding, please try again later!");
      }
    }
    else {
      if (($chatterbox le 995) && ($chatterbox gt 0)) {
        if (int(rand(1000) - $chatterbox) eq 0) {                                                  # Chatty level
          $wrote = callapi($msg, $server, $nick, $channel, @chat);                                 # if chatterbox mode is on
          $isup  = $wrote;
          logit("Random chatterbox triggered.");
          return $wrote;
        }
        $isup = 0;
        return 0;
      }
      else {
        unless ($chatterbox eq 0) {
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
  logit("Responding to private message from $nick...");
  Irssi::settings_set_int('franklin_total_msgs', $totals);
  my $type  = "pm";                                                                                # this stuff only runs if it is a PM/MSG not in channel stuff
  my $wrote = 1;
  if ($nick ne "Franklin") {
    $msg_count++;
    $pm = 1;
    my $textcall = $msg;                                                                           ## $1 is the "dot star" inside the parenthesis
    $textcall =~ s/\'//gs;
    $textcall =~ s/\"//gs;
    Irssi::print "Franklin: $nick asked: $textcall";
    if (($textcall !~ m/^\s+$/) || ($textcall !~ m/^$/)) {
      my $try = 1;
      while (($wrote eq 1) && ($try le $maxretry)) {
        $wrote = callapi($textcall, $server, $nick, $channel, $type);                              # this puls from the api for the pm
        $try++;
        sleep(2.5);
        if ($try ge $maxretry) {
          $isup = 1;
          $server->command("msg $channel Welp.  Looks like my process is hung, $nick.  Forcing reload to flush chat buffer...");
          logit("Warn: Max tries hit, probably stalled, forcing reload!");
          logit("Warn: Offending message from $nick in $channel:  $textcall");
          Irssi::command("script load franklin.pl");
        }
        $isup = $wrote;
      }
      logit("The callapi() subroutine successful for $nick\'s private message.");
    }
    else {
      logit("Warn: The callapi() subroutine failed after $maxretry tries for $nick\'s message.");
      $isup = 1;
      return 1;
    }
  }
}
