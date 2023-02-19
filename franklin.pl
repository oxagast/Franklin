#!/usr/bin/perl
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
#####################################################################
### Adjust this variable to the location of Franklin's source!!!! ###
our $localdir = "/home/gpt3/Franklin/";    ##########################
#####################################################################
Irssi::settings_add_str( "franklin", "franklin_http_location",
                         "/var/www/html/said/" );
Irssi::settings_add_str( "franklin",
                         "franklin_response_webserver_addr",
                         "https://franklin.oxasploits.com/said/" );
Irssi::settings_add_str( "franklin", "franklin_max_retry",     "3" );
Irssi::settings_add_str( "franklin", "franklin_api_key",       "" );
Irssi::settings_add_str( "franklin", "franklin_heartbeat_url", "" );
my $httploc = Irssi::settings_get_str('franklin_http_location');
my $webaddr = Irssi::settings_get_str('franklin_response_webserver_addr');
our $maxretry = Irssi::settings_get_str('franklin_max_retry');
my $wordlimit = "250";
my $hardlimit = "280";
$VERSION = "2.0b1";
%IRSSI = (
           authors     => 'oxagast',
           contact     => 'marshall@oxagast.org',
           name        => 'franklin',
           description => 'Support script for Franklin GPT3 bot',
           license     => 'BSD',
           url         => 'http://franklin.oxasploits.com',
           changed     => 'Feb, 14th 2023',
);
our $apikey;

if ( Irssi::settings_get_str('franklin_api_key') !~ m/^sk-.{48}$/ ) {
  Irssi::print "You must set a valid api key! /set franklin_api_key "
    . "sk-BCjqdsTcwu9ptwVlIASqT3BlbklJuXr7tIo1yRQEcHeqfVvZ, "
    . "then reload with /script load franklin.pl";
}
if ( Irssi::settings_get_str('franklin_api_key') =~ m/^sk-.{48}$/ ) {
  my $aliveworker = Proc::Simple->new();
  if ( Irssi::settings_get_str('franklin_heartbeat_url') ne "" ) {
    $aliveworker->start( \&falive );
  }
  $apikey = Irssi::settings_get_str('franklin_api_key');
  Irssi::signal_add_last( 'message public', 'frank' );
  Irssi::print "Franklin: $VERSION loaded";
  Irssi::print "Franklin: API key: $apikey";
}
else { Irssi: print "Something went wrong with the API key..."; }

sub callapi {
  my ( $textcall, $server, $nick, $channel ) = @_;
  my $url   = "https://api.openai.com/v1/completions";
  my $model = "text-davinci-003";
  my $heat  = "0.7";
  my $uri   = URI->new($url);
  my $ua    = LWP::UserAgent->new;
  my $askbuilt =
      "{\"model\": \"$model\",\"prompt\": \"$textcall\","
    . "\"temperature\":$heat,\"max_tokens\": $wordlimit,"
    . "\"top_p\": 1,\"frequency_penalty\": 0,\"presence_"
    . "penalty\": 0}";
  $ua->default_header( "Content-Type"  => "application/json" );
  $ua->default_header( "Authorization" => "Bearer " . $apikey );
  my $res = $ua->post( $uri, Content => $askbuilt );

  if ( $res->is_success ) {
    my $json_rep  = $res->decoded_content();
    my $json_decd = decode_json($json_rep);
    my $said      = $json_decd->{choices}[0]{text};
    $said =~ s/^\n+//;
    my $hexfn = substr(
                        Digest::MD5::md5_hex(
                                                utf8::is_utf8($said)
                                              ? Encode::encode_utf8($said)
                                              : $said
                        ),
                        0, 8
    );
    umask(0133);
    open( SAID, '>', "$httploc$hexfn" ) or die $!;
    print SAID "$nick asked $textcall\n<---- snip ---->\n$said $webaddr$hexfn";
    close(SAID);
    my $said_cut = substr( $said, 0, $hardlimit );
    $said_cut =~ s/\n/ /g;
    Irssi::print "Franklin: Reply: $said_cut $webaddr$hexfn";
    $server->command("msg $channel $said_cut $webaddr$hexfn");
    return 0;
  }
  else {
    Irssi::print "Franklin: Something went wrong.";
    return 1;
  }
}

sub falive {
  while (1) {
    my $url = Irssi::settings_get_str('franklin_heartbeat_url');
    my $uri = URI->new($url);
    my $ua  = LWP::UserAgent->new;
    my $res = $ua->post($uri);
    sleep 30;
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
  if ( grep( /^$nick$/, @badnicks ) ) {
  Irssi: print "Franklin: $nick does not have privs to use this.";
  }
  else {
    if ( $msg =~ /^Franklin: (.*)/ ) {
      my $textcall = $1;
      Irssi::print "Franklin: $nick asked: $textcall";
      my $wrote = 1;
      my $try   = 1;
      while ( $wrote == 1 ) {
        $wrote = callapi( $textcall, $server, $nick, $channel );
        $try++;
        sleep 1;
        if ( $try >= $maxretry ) {
          $wrote = 0;
        }
      }
    }
  }
}
