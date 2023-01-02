# Franklin

## Franklin is a GPT3 backed IRC bot

**Franklin runs inside irssi.**

*Setup*

1) You should configure `trigger.pl` to autoloadd on irssi start, and optionally configure your channel autojoins.

2) Also you need to create an API key, then put it in a file called `api.key` in the scripts working directory.

3) You'll need to set up a webserver with a directory under it's root called `said` (usually something like `/var/www/html/said/`),
that is writable by the call_gpt3.sh script.

4) Create a file called `block.lst` and fill it, line by line, with any users that abuse the bot.

5) Edit any variables in call_gpt3.sh you need to, such as the domain name of your server where the long-text is hosted.

6) Finally, add a trigger: `/trigger add -publics -regexp '^Franklin. (.*)' -command 'exec -o ~/call_gpt3.sh "$1" "$N"'`

*Debugging*

... Now test the bot by calling it with "Franklin: print me a test message" in channel (do this from a different nick, 
not Franklin's nick!)

When debugging you can run the `call_gpt3.sh` script like: `./call_gpt3.sh "print me a test message" yournick`, as it does
not necessarily need to be called from within irssi to work.

*Authors*

oxagast
