# Franklin
<p align="center"><img src="https://raw.githubusercontent.com/oxagast/Franklin/webpage/logo.png" alt="Logo"></p>



## Franklin is a ChatGPT backed IRC bot

**Examples**
```
<   oxagast> Franklin: tell me a story about using IRC, but using only words of the archane, and obscure to the point where it is incomprehensible
<  Franklin> Once, a kyngesman of the deep wealds of the Internet didst log into a strange and distant land known as IRC, where his dreams of wisdom and knowledge were to be found. He didst traverse many channels, where the mysterious and arcane language of 'netspeak' was spoken. He didst con https://franklin.oxasploits.com/said/4d8d8751.txt
<+      Zed> Franklin: when was the tamagotchi first sold
<  Franklin> The Tamagotchi was first released in Japan on November 23, 1996. https://franklin.oxasploits.com/said/00b1d95f.txt
<  bookworm> Franklin: What is Mitgliederversammlung mean in English?
<  Franklin> Mitgliederversammlung is a German term meaning "members' assembly" or "general assembly of members". It is typically used to refer to the annual gathering of members of a particular organization, such as a club, association, or business. https://franklin.oxasploits.com/said/80621d88.txt
<  bookworm> Franklin: what is the method in bash to assign a command to a letter?
<  Franklin> There is no built-in method in Bash to assign a command to a letter. However, you can create an alias in your ~/.bashrc file to assign a command to a letter. For example, to assign the command "ls -a" to the letter "l", you could add the following line to your ~/.bashrc file:  al https://franklin.oxasploits.com/said/287d0550.txt 
<  bookworm> Franklin: books written by Larry Wall
<  Franklin>  and Randal Schwartz  1. Programming Perl (3rd Edition): Larry Wall and Tom Christiansen 2. Learning Perl (6th Edition): Randal L. Schwartz and Tom Phoenix 3. Perl Cookbook (2nd Edition): Tom Christiansen and Nathan Torkington 4. Intermediate Perl (2nd Edition): Randal L. Schwart https://franklin.oxasploits.com/said/582c8157.txt
```

**Major features of Franklin**

* Answer users' queries realistically, with human-like responses.
* Read and interpret any *http(s) urls* given to it.
* Uptime heartbeat with email and/or sms notifications.
* Promptless chat with users *autonomously*.
* Conversation awareness within each channel, reading back ~7 lines (user definable).  Injected into contextual prelude.
* Self-aware of being an IRC bot, its name, current channel it is speaking within, who it is speaking with, current date/time, if it is a channel operator, how many lines within reference history, plus other critical instance variables.
* Ease of use configurable interface by variables assignment with `/set franklin_...` in irssi.
* Franklin's responses are all stored on the server side with a TXID number and are searchable on the [website](https://franklin.oxasploits.com).
* Administrative blocklist of abusive users.
* Statistics dashboard detailing how many tokens were used to generate each response and cost estimates for the instance operator.
* The ability to utilize operator status by kicking users who are being assholes (configurable in settings).

![irc](https://raw.githubusercontent.com/oxagast/Franklin/main/franklin-cheese.png)

**Setup**

* Now upgraded to use the 3.5 Turbo Instruct API.
* Install from Perl's CPAN (if deps not already met): Proc::Simple, Santitize, Irssi, and JSON.
* Add `franklin.pl` to autoload on irssi start, and optionally configure your channel autojoins.
* Start irssi
* Set the API key with `/set franklin_api_key [key goes here]` 
* Ensure your webserver root directory contains a folder that is writeable by the `franklin.pl` script named `said`(usually something like `/var/www/html/said/`).
* Append the `block.lst` file with one username per line with any users that abuse the bot.
* Edit any variables in franklin you need to from within irssi, such as the domain name of your server where the long-text is hosted, by using `/set fraklin_...`.
* Finally, test it by calling with "Franklin: say hi! in chat".
* Load the helper script with: `/script load franklin_helper.pl`.  This will allow *any user* in channel to reload Franklin, but generally this is a good thing unless abused.

**Settings**

Name | Description
-|-
`/set franklin_api_key [apikey]` | This is the API key you need to get from OpenAI.
`/set franklin_heartbeat_url [url]` | A url that the franklin script will hit every 30 seconds to show it has not crashed. This setting is optional, to turn it off: /set franklin_heartbeat_url "".
`/set franklin_response_webserver_addr [address]` | server root URL for hosting the domain files franklin is running on. (e.g.  https://franklin.oxasploits.com/said/).
`/set franklin_http_location [dir]` | Server root location of files saved to be served by a web server. (e.g. /var/www/html/said/).
`/set franklin_hard_limit [int]` | The hard limit of characters that the response should be to fit in an IRC chat. (e.g. greater than 30 and less than 300.)
`/set franklin_word_limit [int]` | Limit of words that the API should generate from the backend. Should be ~1000.
`/set franklin_chatterbox_mode [int]` | An integer, 0 to 1000, 0 being silent unless spoken to, 1000 being says something every line.
`/set franklin_history_length [int]` | Number of lines of chat history to remember.  In lines, should be 5 to 8 lines.
`/set franklin_blocklist_file [file]` | The file where the line-by-line nick blocklist is stored. Users listed in this file cannot use Franklin.
`/set franklin_server_info [str]` | A brief user defined outline of what each server the bot is connected to is about, injected into the contextual prelude.
`/set franklin_google_gtag [str]` | This is your google analytics G- tag id, for tracking the generated webpages.
`/set franklin_asshat_threshold [float]` | This should be an floating point number from around 6 to 9, and is the kick threshold.
`/set franklin_txid_chans [#chan1 #chan2]` | This is a list of channels where the Transactional Identification should be appended to the end of message.  The channels should be seperated by spaces.

**Debugging**

Now test the bot by calling it with "Franklin: print me a test message" in channel (do this from a different nick, 
not Franklin's nick!)

Fraklin may fail due to heavy load on the API, connection issues, or the like.  It has primitive recovery methods. However, one may reinitialize Fraklin with `/script load franklin.pl`.

Sometimes after running `/quit` in irssi, it is necessary to *also* run `pkill irssi` to reap any runaway franklin processes.  The
longer irssi has been running, the more this is an issue.

Occasionally, if franklin stalls and/or stop responding to queries, you can run `/script load franklin.pl` and this will
usually rectify the issue.  This can also be accomplished if franklin_helper.pl is loaded, by calling Franklin in channel like: "Franklin: reload".

**Authors**

oxagast / Marshall Whittaker

**Thanks to people who asked for features or found bugs**

atg, dclaw, proge, CerebraNet, morb, bookworm, denzuko, and more...
