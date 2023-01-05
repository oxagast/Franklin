use Irssi;
use 5.6.0;
use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "0.1.1";
%IRSSI   = (
    authors     => 'oxagast',
    contact     => 'marshall@oxagast.org',
    name        => 'franklin',
    description => 'Support script for Franklin GPT3 bot',
    license     => 'BSD',
    url         => 'http://gpt3.oxasploits.com',
    changed     => 'Jan, 5th 2023',
);

Irssi::signal_add_last( 'message public', 'frank' );

Irssi::print "Franklin $VERSION loaded";

sub frank {
    my ( $server, $msg, $nick, $address, $channel ) = @_;

    # channel in list?
    # check..
    if ( $msg =~ /^Franklin: (.*)/ ) {

        # increment
        my $textcall = $1;
        $textcall =~ s/`//g;
        $textcall =~ s/|//g;
        $textcall =~ s/>//g;
        $textcall =~ s/<//g;
        $textcall =~ s/#//g;
        $textcall =~ s/$//g;
        $textcall =~ s/'//g;
        $textcall =~ s/"//g;
        $textcall =~ s/;//g;
        $nick     =~ s/`//g;

        Irssi::print "$textcall from $nick";
        my $franksays = `/home/gpt3/Franklin/call_gpt3.sh "$textcall" "$nick"`;
        chomp($franksays);

        #Irssi::print "$franksays";
        if ( $franksays !~ m/^ https/ ) {
            $server->command("msg $channel $franksays");
        }
        else { $server->command("msg $channel No."); }

    }

}
