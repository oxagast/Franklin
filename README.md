# Franklin

## Franklin is a GPTChat backed IRC bot

**Franklin runs inside irssi.**

![irc](https://raw.githubusercontent.com/oxagast/Franklin/main/irc_chats.png)

*Setup*

1) You should configure `franklin.pl` to autoload on irssi start, and optionally configure your channel autojoins.

2 Set the API key by running `/set franklin_api_key [key goes here]` inside irssi.

3) You'll need to set up a webserver with a directory under it's root called `said` (usually something like `/var/www/html/said/`),
that is writable by the `franklin.pl` script.

4) Create a file called `block.lst` and fill it, line by line, with any users that abuse the bot.

5) Edit any variables in franklin you need to from within irssi, such as the domain name of your server where the long-text is hosted,
   by using `/set fraklin_...`.

6) Finally, test it by calling with Franklin: say hi! in chat.

*Debugging*

... Now test the bot by calling it with "Franklin: print me a test message" in channel (do this from a different nick, 
not Franklin's nick!)

Sometimes Fraklin fails because of heavy load on the API, connection issues, or the like.  It has primitive recovery methods, if
it happens to get stuck, just `script load franklin.pl` again. Should reload Franklin.

*Settings*

`/set franklin_api_key [apikey]`

This is the API key you need to get from OpenAI.

`/set franklin_heartbeat_url [url]`

A url that the franklin script will hit every 30 seconds to show it has not crashed. This setting is optional, to turn it off: /set franklin_heartbeat_url "".

`/set franklin_response_webserver_addr [address]`

The directory of where the said files were saved on the domain your running franklin on. This is something like: https://franklin.com/said/.

`/set franklin_http_location [dir]`

The directory location of where the files are to be saved to be served by the webserver. Should look like: /var/www/html/said/.

`/set franklin_max_retry [int]`

How many times the script should retry connecting to the API before giving up.

`/set franklin_hard_limit [int]`

The hard limit of characters that the response should be to fit in an IRC chat.
This should be something like greater than 30 and less than 300.

`/set franklin_word_limit [int]`

This is the limit of words that the API should generate form the backend. Should
be ~600.

*Authors*

oxagast / Marshall Whittaker

*Thanks to people who asked for features or found bugs*

atg, dclaw, proge, CerebraNet and more...
