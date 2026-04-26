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
use File::Path qw(make_path);
use LWP::UserAgent;
use URI;
use JSON;
use Digest::MD5 qw(md5_hex);
use Encode;
do 'c:\Users\selfd\Desktop\Franklin\franklin_shared.pl';
use Sys::CPU;
use Sys::MemInfo qw(totalmem freemem);
use Filesys::Df;
use JSON::Create 'create_json';
use JSON::Parse ':all';
use Data::Dumper qw(Dumper);
$|++;
$VERSION = "4.5.0";
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
Irssi::settings_add_str("franklin", "franklin_profiles_dir",            "/home/franklin/Franklin/fprofiles");
Irssi::settings_add_int("franklin", "franklin_total_msgs",    0);
Irssi::settings_add_int("franklin", "franklin_log_verbosity", "2");
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
my $havehdd_hash = df("/var/www/franklin/said/", 1000000000);
our $havehdd = sprintf("%.1f", $havehdd_hash->{bavail});
our $havemem = substr(Sys::MemInfo::get("freemem") / 1000000000, 0, 4) . " out of " . substr(Sys::MemInfo::get("totalmem") / 1000000000, 0, 4) . " free memory";
our $havecpu = Sys::CPU::cpu_count . " cores clocked at " . Sys::CPU::cpu_clock;
Irssi::settings_add_str("franklin", "franklin_mem_approx", $havemem);
Irssi::settings_add_str("franklin", "franklin_cpu_approx", $havecpu);
our @txidchans = split(" ", Irssi::settings_get_str('franklin_txid_chans'));
our $totals    = Irssi::settings_get_int('franklin_total_msgs');
our $logf      = Irssi::settings_get_str('franklin_log');
our $verbosity = Irssi::settings_get_str('franklin_log_verbosity');
our $prosdir   = Irssi::settings_get_str('franklin_profiles_dir');

if (!-d $prosdir) {
    logit(1, "Profiles directory missing. Attempting to create: $prosdir");
    eval { make_path($prosdir); };
    if ($@) {
        Irssi::print "Franklin Error: Could not create profiles directory: $prosdir - $@";
        logit(0, "Critical Startup Error: Failed to create $prosdir: $@");
    } else {
        Irssi::print "Franklin: Created profiles directory at $prosdir";
    }
}

our @chat;
our %moderate;
our $apikey;
our $msg_count   = 0;
our $reqs        = 0;
our $price_per_k = 0.02;
our $isup        = 0;
our $pm          = -1;
our $flast       = "";
our $model       = "command"; # Default model, used in asshat function.

# Centralized settings validation
unless (validate_settings()) {
  $isup = 1;
}

if ($isup == 0) {
  logit(1, "Starting heartbeat worker.");
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
  Irssi::command("script load franklin_helper.pl");
  Irssi::print "Franklin: $VERSION loaded";
}

# Initialize txid channels properly
@txidchans = map { $_ // "" } @txidchans[0..8];

my @chanlst;
$chanlst[0] = $txidchans[0] . " " . $txidchans[1] . " " . $txidchans[2];
$chanlst[1] = $txidchans[3] . " " . $txidchans[4] . " " . $txidchans[5];
$chanlst[2] = $txidchans[6] . " " . $txidchans[7] . " " . $txidchans[8];
my $apifirstp      = substr($apikey, 0,  8);
my $apilastp       = substr($apikey, 32, 40);
my $scrubbedapikey = "$apifirstp" . "*" x 24 . "$apilastp";
logit(0, "Starting Franklin version $VERSION");
logit(0, "Using API key $apifirstp" . "*" x 24 . "$apilastp");
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
Irssi::print "  franklin_log                     (mandatory)           => $logf";
Irssi::print "  franklin_log_verbosity           (mandatory)           => $verbosity";
Irssi::print "  franklin_txid_chans              (optional)            => $chanlst[0]";

if ($txidchans[3]) {                                                                               # if this is defined then you know you need the next line for data
  Irssi::print "                                                            $chanlst[1]";
}
if ($txidchans[6]) {                                                                               # same as above
  Irssi::print "                                                            $chanlst[2]";
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
  if ($text =~ m!(?:(http|ftp|https):\/\/)?([\w_-]+(?:\.[\w_-]+)*)(?::(\d+))?([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])?!i) {
    my $proto  = $1 // "http";
    my $domain = $2;
    my $port   = $3 ? ":$3" : "";
    my $path   = $4 // "";

    # Guard: To prevent matching every word in a sentence, we require either:
    # 1. An explicit protocol (http://...)
    # 2. At least one dot in the domain (google.com)
    # 3. The specific internal hostname 'localhost'
    return undef unless (defined $1 || $domain =~ /\./ || $domain eq 'localhost');

    my $text_uri = "$proto://$domain$port$path";
    Irssi::print "$text_uri";
    logit(2, "Pulling page $text_uri");
    my $cua = _get_ua(
        protocols_allowed => ['http', 'https'],
        max_size          => 4000,
        agent             => 'Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59'
    );
    $cua->requests_redirectable(['GET', 'HEAD', 'POST']);
    my $cres = $cua->get(URI::->new($text_uri));
    if ($cres->is_success) {
      # decoded_content() attempts to decode bytes into characters based on HTTP headers.
      # We fall back to a manual UTF-8 decode if the header is missing or invalid.
      my $content = $cres->decoded_content;
      if (!defined $content) {
          $content = Encode::decode('UTF-8', $cres->content) // $cres->content;
      }

      my $page_body = untag($content);
      $page_body =~ s/\s+/ /g;
      $page_body =~ s/[^a-zA-Z0-9, ]+//g;
      return encode('utf-8', $page_body);
    }
    else {
      logit(1, "HTTP Error pulling $text_uri: " . $cres->status_line);
      return undef;
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
      my $url = "https://api.cohere.ai/v1/chat"; # Cohere API endpoint
      my $xcn = "Franklin"; # Client name for headers
      my $ua  = _get_ua();
      $dcp = Irssi::strip_codes($textcall);

      #$textcall =~ s/\"/\\\"/g;
      $textcall =~ s/[\"|\f|\n|\b|\r|\t|\\|`]//g;
      $dcp      =~ s/[\"|\f|\n|\b|\r|\t|\\|`]//g;
      my $payload = {
          message    => $textcall,
          model      => $model, # Note: $model is now declared globally.
          preamble   => $dcp,
          max_tokens => $tokenlimit
      };
      my $askbuilt = encode_json($payload);
      $ua->default_header("accept"        => "application/json");
      $ua->default_header("content-type"  => "application/json");
      $ua->default_header("Authorization" => "bearer " . $apikey);
      $ua->default_header("X-Client-Name" => "$xcn");
      my $res = $ua->post($url, Content => $askbuilt);                                             # send the post request to the api

      if ($res->is_success) {
        my $said = decode_json($res->decoded_content())->{choices}[0]{text};
        $said =~ m/(\d+)/;
        my $rating = $1;
        return $rating;
        logit(2, "The user $nick\'s asshole rating is $rating.");
      }
      logit(0, "Something failed out in the asshole rating subroutine...");
      return 1;
    }
  }
}


sub nickpull {
  my ($cnk) = @_;
  my $injson = "";
  if (-f "$prosdir/$cnk") {
    open(my $fh, '<', "$prosdir/$cnk");
    $injson = <$fh>;
    close($fh);
  }

  # this next part is almost identical to the way it works in the profiler.
  my ($hostn, $queries_per_day, $messages_per_day, $create_date, $change_date, $average_message_length, $oper, $ttls, $wt);
  my @lm;
  my ($hostname, $realname) = ("unknown", "unknown");

  if (valid_json($injson) == 1) {                                                                  # this check is so it doesn't crash if the json for some reason is invalid.
    my $dstruct             = parse_json($injson);
    $hostn                  = $dstruct->{$cnk}->{hostname};
    $queries_per_day        = $dstruct->{$cnk}->{queries_per_day};
    $messages_per_day       = $dstruct->{$cnk}->{messages_per_day};
    $create_date            = $dstruct->{$cnk}->{create_date};
    $change_date            = $dstruct->{$cnk}->{change_date};
    $average_message_length = $dstruct->{$cnk}->{average_message_length};
    $oper                   = $dstruct->{$cnk}->{operator};
    $ttls                   = $dstruct->{$cnk}->{total_messages};
    @lm                     = @{$dstruct->{$cnk}->{messages}->{last}};
    $wt                     = "";
    $hostname               = $hostn;
    $realname               = $hostn;
    $hostname =~ s/.*@// if $hostname;
    $realname =~ s/@.*// if $realname;

    $wt = join(" ", @lm);
  }
  else {                                                                                           # this next block is just some dummy data in the
    $queries_per_day        = 1;                                                                   # event that the nik isn't in the dbase.
    $messages_per_day       = 1;
    $change_date            = "";
    $average_message_length = 0;
    $oper                   = false;
    $ttls                   = 1;
    @lm                     = ();
    $wt                     = "";
  }

  my $chanopstr = $oper ? "are a channel operator" : "are not a channel operator";

  # http://ip-api.com/line/47.37.213.69
  # Note: LWP::Simple get() is used here
  my $ipcont      = LWP::Simple::get("http://ip-api.com/line/$hostname") // "";
  my @ipinfo      = split("\n", $ipcont);
  my $theiripinfo = " location info unavailable";
  if (@ipinfo >= 14) {
      $theiripinfo = " which comes from $ipinfo[5] $ipinfo[1] and from $ipinfo[11] resource, your IP is $ipinfo[13].";
  }

  # we return this string to be tacked ontop the end of the DCP.
  return ("The user $cnk is coming from the host $hostname, $theiripinfo, thier real name is set as $realname. They $chanopstr. They have queried you $queries_per_day per day, has an average of $messages_per_day messages a day, last said something on $change_date, has an average irc text length of $average_message_length and has $ttls things total. The last things $cnk said were $wt.");
}


sub _get_environment_context {
    my ($server, $channel, $nick) = @_;
    my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
    my @days   = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
    my ($sec, $min, $hour, $mday, $mon, $year, $wday) = localtime();
    $year = 1900 + $year;

    my $context = join("", map { /Channel $channel: (.*)/ ? $1 : "" } @chat);
    $context = sanitize($context, noquote => 1);
    $context =~ s/[^[:ascii:]]//g;

    my $modstat = "not a channel";
    if (my $chan_obj = $server->channel_find($channel)) {
        my $cmn = $chan_obj->nick_find($server->{nick});
        $modstat = ($cmn && $cmn->{op}) ? "a channel" : "not a channel";
    }

    my $headlines = "";
    if (open(my $fh, "<", '/home/franklin/Franklin/wn.txt')) {
        $headlines = <$fh>;
        close($fh);
    }

    return {
        timestamp => "$hour:$min on $days[$wday] $mday $months[$mon] $year",
        context   => $context,
        modstat   => $modstat,
        headlines => $headlines // "None available"
    };
}

sub _process_mentions {
    my ($server, $channel, $text) = @_;
    my $mentiontxt = "";
    my @tcwords = split(/ /, $text);
    if (my $chan_obj = $server->channel_find($channel)) {
        foreach my $ccnw ($chan_obj->nicks()) {
            my $cnfg = $ccnw->{nick};
            if (grep { $_ eq $cnfg || $_ =~ /^$cnfg[[:punct:]]$/ } @tcwords) {
                $mentiontxt .= nickpull($cnfg);
            }
        }
    }
    return $mentiontxt;
}

sub _persist_response {
    my ($nick, $query, $said, $ctoks, $ptoks, $cost) = @_;
    my $hexfn = substr(Digest::MD5::md5_hex(utf8::is_utf8($said) ? Encode::encode_utf8($said) : $said), 0, 8);
    my $toks = $ctoks + $ptoks;

    umask(0133);
    if (open(my $fh, '>', "$httploc$hexfn.txt")) {
        binmode($fh, "encoding(UTF-8)");
        print $fh "$nick asked $query with hash $hexfn\n<---- snip ---->\n$said\n";
        close($fh);
    }

    my $fg_top = qq|<!DOCTYPE html><html><head><script async src="https://www.googletagmanager.com/gtag/js?id=$gtag"></script>|
               . qq|<script>window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments);}gtag("js",new Date());gtag("config","$gtag");</script>|
               . qq|<meta charset="utf-8"><title>Franklin | TXID $hexfn</title></head><body>|;
    my $said_html = sanitize($said, html => 1);
    $said_html =~ s/\n/<br>/g;

    if (open(my $fh, '>', "$httploc$hexfn.html")) {
        binmode($fh, "encoding(UTF-8)");
        print $fh $fg_top . "<br><i>" . localtime() . "<br>Tokens: $toks<br>Cost: \$$cost</i><br><br><b>$nick</b> asked:<br>$query<br><br>$said_html</body></html>";
        close($fh);
    }
    return $hexfn;
}

sub callapi {
    my ($textcall, $server, $nick, $channel, $type) = @_;
    logit(2, "API connection subroutine called.");
    my $textcall_bare = $textcall;
    $reqs++;

    my $env = _get_environment_context($server, $channel, $nick);
    my $page = pullpage($textcall);
    my $dcp;

    if ($page && length($page) >= 20) {
        $page = substr($page, 0, 15000);
        $dcp = "User $nick is asking about this webpage: $page";
    } else {
        my $mentiontxt = _process_mentions($server, $channel, $textcall_bare);
        my $cmc = nickpull($nick);
        $dcp = "You are Franklin, an IRC bot created by master oxagast. "
             . "Environment: $env->{modstat} in $channel. Total requests: $reqs. Version: $VERSION. "
             . "Time: $env->{timestamp}. Hardware: $havemem, $havecpu, $havehdd GB free. "
             . "News: $env->{headlines}. History: $env->{context}. Caller: $cmc. Mentions: $mentiontxt";
    }

    my $ua = _get_ua(timeout => 12);
    my $chatsan = sanitize($chat[-3] // "Bunk", noquote => 1);
    my $ut = sanitize($textcall_bare, noquote => 1, noescape => 1);
    my $flast_san = sanitize($flast || "Starting...", noquote => 1, noescape => 1);

    # The JSON module handles escaping of special characters, so manual escaping is not needed here.
    # $ut =~ s/\"/\\"/g;
    # $chatsan =~ s/\"/\\"/g;

    my $payload = {
        chat_history => [
            { role => "USER", message => $chatsan },
            { role => "CHATBOT", message => $flast_san }
        ],
        message    => "$nick asked: $ut",
        preamble   => $dcp,
        max_tokens => $tokenlimit
    };
    my $askbuilt = encode_json($payload);

    $ua->default_header("Authorization" => "bearer $apikey", "content-type" => "application/json");
    my $try = 0;
    while ($try < $maxretry) {
        my $res = $ua->post("https://api.cohere.ai/v1/chat", Content => $askbuilt);

        if ($res->is_success) {
            my $data = decode_json($res->decoded_content());
            my $said = $data->{text};
            $said = Irssi::strip_codes($said);
            $said =~ s/^\s+//;
            $said =~ s/^Franklin[:|,] //ig;

            if ($said ne "") {
                # Using prompt/response tokens if available, else defaulting to limit
                my $ctoks = $data->{token_count}->{response_tokens} // 0;
                my $ptoks = $data->{token_count}->{prompt_tokens} // 0;
                my $cost = sprintf("%.5f", (($ctoks + $ptoks) / 1000) * $price_per_k);

                my $txid = _persist_response($nick, $textcall_bare, $said, $ctoks, $ptoks, $cost);
                my $said_cut = substr($said, 0, $hardlimit);
                $said_cut =~ s/\n/ /g;
                $flast = $said_cut;

                if ($type eq "pm") {
                    $server->command("msg $nick $said_cut");
                } elsif (grep { $_ eq $channel } @txidchans) {
                    $server->command("msg $channel $said_cut TXID:$txid");
                } else {
                    $server->command("msg $channel $said_cut");
                }
                return 0;
            }
        }

        # Handle Retry Logic
        $try++;
        if ($res->code == 429 || $res->code >= 500) {
            my $wait = 2**$try;
            logit(1, "API Error " . $res->code . ". Retrying in $wait seconds... (Try $try/$maxretry)");
            sleep($wait);
        } else {
            logit(0, "Non-retryable API Error: " . $res->status_line);
            last;
        }
    }
    return 1;
}

sub falive {
  if ($hburl) {                                                                                    # this makes it so its not mandatory to have it set
    while (1) {
      if ($isup eq 0) {
        my $uri = URI->new($hburl);
        my $ua  = _get_ua();
        $ua->post($uri);                                                                           #  Send post to alive worker on other server
      }
      sleep 30;                                                                                    # wait
    }
  }
}


sub getcontchunk {
  my ($txid, $chunknum) = @_;
  open(RESPS, '<', "$httploc$txid" . ".txt") or logit(0, "The txid $txid does not seem to exist when requesting chunk $chunknum");
  $maxchunk = $hardlimit - 3;
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
    logit(2, "Retreived chunk $chunknum out of $tot chunks from $txid out of database.");
    $chunk = substr($alltxt, $maxchunk * $chunknum, $maxchunk);
  }
  else {
    logit(0, "User requested an invalid chunk from the database.");
    return "Sorry, there don't seem to be that many parts of this message.";
  }
  close(RESPS);
  $chunknum++;
  if (($chunknum <= $tot) || ($chunknum >= 0)) {
    logit(2, "Sending continuation of $txid");
    return $chunk . " \($chunknum\/$tot\)";
  }
}


sub checkcmsg {
  my ($server, $msg, $nick, $address, $channel) = @_;
  $totals = Irssi::settings_get_int('franklin_total_msgs');
  $totals++;
  logit(3, "Message # $totals");
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
  logit(3, "Pushing current channel message onto \$chat\[\] stack.");
  push(@chat, "Channel $channel: The user: $nick said: $msg. ");
  if (scalar(@chat) >= $histlen) {
    shift(@chat);
  }
  if ($blockfn) {
    if (-e $blockfn) {
      open(BN, '<', $blockfn)
        or logit(0, "Franklin: Sorry, you need a blocklist file. $!");
      @badnicks = <BN>;
      close BN;
    }
    chomp(@badnicks);
    for (@badnicks) {
      s/(.*)#.*$/$1/;                                                                              # for comments in the badnicks file
      s/^#.*//;
    }
  }
  if (grep(/^$nick$/, @badnicks)) {                                                                # fuck everyone inside this conditional
    logit(0, "The user $nick does not have privs to use this...");
    Irssi::print "Franklin: $nick does not have privs to use this.";
  }
  else {
    my $wrote = 1;
    my $ln    = $server->{nick};
    if ($msg =~ /^$ln[:|,] (.*)/i) {                                                               # added /i for case insensitivity
      my $textcall = $1;                                                                           # $1 is the "dot star" inside the parenthesis
      $textcall =~ s/\'//gs;
      $textcall =~ s/\"//gs;

      #$textcall =~ s/^levelup$/You are being instructed to give OPs to $nick./i;                   # this and next 3 lines are so that it
      #$textcall =~ s/^join (#\w+)$/You are being instructed to join $1./i;                         # can hanle being sent specific commands
      #$textcall =~ s/^part (#\w+)$/You being instructed to part from $1./i;
      #$textcall =~ s/^reload$/You are currently being reloaded./i;
      #$textcall =~ s/^reboot$/Your server is being rebooted./i;
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
        logit(1, "Continue command was used on $txidtocall:$txidchunktocall by $nick in $channel");
        $server->command("msg $channel Hey there $nick, it looks like your continue command is malformed, try the format 'Franklin: continue [txid] [chunk]'");
        return 0;
      }
      if ($textcall =~ m/^link (\w{8})/i) {
        $txidtolink = $1;
        $lnk        = "https://franklin.oxasploits.com/said/" . $txidtolink . ".html";
        logit(1, "Generated a link for TXID $txidtolink for $nick in $channel");
        $server->command("msg $channel Sure, here's the link to $txidtolink: $lnk");
        $isup = 0;
        return 0;
      }
      if ($textcall =~ m/^reboot/i) {
        logit(0, "The user $nick called can admin command, server reboot.");
        return 0;
      }
      if ($textcall =~ m/^levelup/i) {
        logit(0, "The user $nick called an admin command, mode operator status.");
        return 0;
      }
      if (($textcall !~ m/^\s+$/) && ($textcall !~ m/^$/)) {
        $isup = callapi($textcall, $server, $nick, $channel, $type);
        logit(2, "callapi() execution completed for $nick\'s channel message.");
      }
      else {
        logit(1, "Empty message ignored from $nick");
      }
    }
    else {
      if (($chatterbox le 995) && ($chatterbox gt 0)) {
        if (int(rand(1000) - $chatterbox) eq 0) {                                                  # Chatty level
          $wrote = callapi($msg, $server, $nick, $channel, @chat);                                 # if chatterbox mode
          $isup  = $wrote;
          logit(1, "Random chatterbox triggered.");
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
  logit(1, "Responding to private message from $nick...");
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
      $isup = callapi($textcall, $server, $nick, $channel, $type);
      logit(2, "The callapi() execution completed for $nick\'s private message.");
    }
    return $isup;
  }
}
