# Franklin

## Franklin is a GPTChat backed IRC bot

**Franklin runs inside irssi.**

![irc](https://raw.githubusercontent.com/oxagast/Franklin/main/irc_chats.png)

*Setup*

1) You should configure `franklin.pl` to autoload on irssi start, and optionally configure your channel autojoins.

2) Create an API key, then put it in a file called `api.key` in the scripts working directory.

3) You'll need to set up a webserver with a directory under it's root called `said` (usually something like `/var/www/html/said/`),
that is writable by the call_gpt3.sh script.

4) Create a file called `block.lst` and fill it, line by line, with any users that abuse the bot.

5) Edit any variables in franklin.pl you need to, such as the domain name of your server where the long-text is hosted.

6) Finally, test it by calling with Franklin: say hi! in chat.

*Debugging*

... Now test the bot by calling it with "Franklin: print me a test message" in channel (do this from a different nick, 
not Franklin's nick!)

If you get an error from jq it means that it got something back from the api that it didn't expect, probably due to a bad 
API key or excessive server load.

*Authors*

oxagast

*Thanks to people who asked for features*

dclaw, proge, CerebraNet and more...
