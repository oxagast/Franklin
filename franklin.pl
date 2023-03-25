#!/usr/bin/perl
# written by oxagast
#
# Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
#
use Proc::Simple;
use Irssi;
use vars qw($VERSION %IRSSI);
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
Irssi::settings_add_str( "franklin", "franklin_http_location",
                         "/var/www/html/said/" );
Irssi::settings_add_str( "franklin",
                         "franklin_response_webserver_addr",
                         "https://franklin.oxasploits.com/said/" );
Irssi::settings_add_str( "franklin", "franklin_max_retry",     "3" );
Irssi::settings_add_str( "franklin", "franklin_api_key",       "" );
Irssi::settings_add_str( "franklin", "franklin_heartbeat_url", "" );
Irssi::settings_add_str( "franklin", "franklin_hard_limit",    "280" );
Irssi::settings_add_str( "franklin", "franklin_word_limit",    "600" );
my $httploc = Irssi::settings_get_str('franklin_http_location');
my $webaddr = Irssi::settings_get_str('franklin_response_webserver_addr');
our $maxretry = Irssi::settings_get_str('franklin_max_retry');
my $wordlimit = Irssi::settings_get_str('franklin_word_limit');
my $hardlimit = Irssi::settings_get_str('franklin_hard_limit');
$VERSION = "3.1";
%IRSSI = (
           authors     => 'oxagast',
           contact     => 'marshall@oxagast.org',
           name        => 'franklin',
           description => 'Support script for Franklin GPT3 bot',
           license     => 'BSD',
           url         => 'http://franklin.oxasploits.com',
           changed     => 'March, 25 2023',
);
Irssi::print "Use /set to set the following variables:";
Irssi::print "  franklin_http_location           (mandatory, pre-set)";
Irssi::print "  franklin_response_webserver_addr (mandatory)";
Irssi::print "  franklin_api_key                 (mandatory)";
Irssi::print "  franklin_heartbeat_url           (optional)";
Irssi::print "  franklin_hard_limit              (mandatory, pre-set)";
Irssi::print "  franklin_word_limit              (mandatory, pre-set)";
our $apikey;
## checking to see if the api key 'looks' valid before use
if ( Irssi::settings_get_str('franklin_api_key') !~ m/^sk-.{48}$/ ) {
  Irssi::print "You must set a valid api key! /set franklin_api_key "
    . "sk-BCjqdsTcwu9ptwVlIASqT3BlbklJuXr7tIo1yRQEcHeqfVvZ, "
    . "then reload with /script load franklin.pl";
}
if ( Irssi::settings_get_str('franklin_api_key') =~ m/^sk-.{48}$/ ) {
  my $aliveworker =
    Proc::Simple->new();    ## since you fags try to root me and crash franklin
  if ( Irssi::settings_get_str('franklin_heartbeat_url') ne "" )
  {                         # i need this so that
    $aliveworker->start( \&falive )
      ;                     ## i get alerts on my phone when franklin dies now.
  }
  $apikey = Irssi::settings_get_str('franklin_api_key');
  Irssi::signal_add_last( 'message public', 'frank' );
  Irssi::print "Franklin: $VERSION loaded";
  Irssi::print "Franklin: API key: $apikey";
}
else { Irssi: print "Something went wrong with the API key..."; }

sub callapi {
  my ( $textcall, $server, $nick, $channel ) = @_;
  $textcall =~ s/\\"//g;
  $textcall =~ s/\\'//g;
  $textcall =~ s/\'/"/gs;
  $textcall =~ s/\"/\\"/g;
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
  $ua->default_header( "Content-Type"  => "application/json" );
  $ua->default_header( "Authorization" => "Bearer " . $apikey );
  my $res =
    $ua->post( $uri, Content => $askbuilt ); ## send the post request to the api

  if ( $res->is_success ) {
    my $json_rep  = $res->decoded_content();
    my $json_decd = decode_json($json_rep);
    my $said      = $json_decd->{choices}[0]{text};
    $said =~ s/^\n+//;
    $said =~ s/^\?\s+(\w)/$1/;
    my $hexfn = substr(
                        Digest::MD5::md5_hex(
                                                utf8::is_utf8($said)
                                              ? Encode::encode_utf8($said)
                                              : $said
                        ),
                        0, 8
    );
    $textcall =~ s/\\\"/"/g;
    umask(0133);
    open( SAID, '>', "$httploc$hexfn" ) or die $!;
    print SAID
      "$nick asked $textcall with hash $hexfn\n<---- snip ---->\n$said\n";
    close(SAID);
    my $said_cut = substr( $said, 0, $hardlimit );
    $said_cut =~ s/\n/ /g;    # fixes newlines for irc compat
    my $localnick = $IRSSI{name};
    Irssi::print "$localnick: Reply: $said_cut $webaddr$hexfn";
    $server->command("msg $channel $said_cut $webaddr$hexfn");
    return 0;
  }
  else {
    Irssi::print "Franklin: Something went wrong."
      ;                       ## damn it frank, ima bout to pimp you out
    return 1;                 ## to a two bit crackhead with a shlong dong
  }
}

sub falive {
  my $url = Irssi::settings_get_str('franklin_heartbeat_url');
  if ( $url ne "" ) {
    while (1) {
      my $uri = URI->new($url);
      my $ua  = LWP::UserAgent->new;
      $ua->post($uri);
      sleep 30;
    }
  }
}

sub frank {
  my ( $server, $msg, $nick, $address, $channel ) = @_;
  open( BN, '<', $localdir . "block.lst" )
    or die "Franklin: Sorry, you need a block.lst file, even"
    . " if it is empty!\nFranklin: $!";
  my @badnicks = <BN>;
  close BN;
  chomp(@badnicks);
  if ( grep( /^$nick$/, @badnicks ) ) { ## fuck everyone inside this conditional
  Irssi: print "Franklin: $nick does not have privs to use this.";
  }
  else {
    my $localnick = $IRSSI{name};
    if ( $msg =~ /^$localnick: (.*)/i ) {    ## added /i for case insensitivity
      my $textcall = $1;    ## $1 is the "dot star" inside the parenthesis
      Irssi::print "$localnick: $nick asked: $textcall";
      my $wrote = 1;
      my $try   = 1;
      while ( $wrote == 1 ) {
        $wrote = callapi( $textcall, $server, $nick, $channel );
        $try++;             ## increment the retry counter
        sleep 1;
        if ( $try >= $maxretry ) {
          $wrote = 0;    ## this is actually on fail, just so we don't get stuck
        }
      }
    }
  }
}
