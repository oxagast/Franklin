# Franklin
![irc](https://raw.githubusercontent.com/oxagast/Franklin/main/franklin-cheese.png)

## Franklin is a ChatGPT backed IRC bot

**Examples**
```
<   oxagast> Franklin: tell me a story about using irc, but using only words of the archane, and obscure to the point where it is incomprehensible
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

**Major features**
* Franklin can answer users queries realistically, with close to human responses.
* Franklin can read and interpret any *links* (starting with http or https) given to it.
* Franklin has an uptime heartbeat, so if the instance crashes, you can get an email, or notification to your phone.
* Fraklin has the ability to chat with users *autonomously*, meaning, he can say things without being prompted.
* Franklin is aware of the conversation in each channel, reading back ~7 lines, for context.
* Franklin is aware of what it is (an irc bot), it's own name, which channel it is speaking to, who it is speaking to, how many lines back it can reference, as well as some other critical instance variables.
* Franklin's configurable interface is easy to use, just set the varaibles with `/set franklin_...` in irssi.
* Franklin's responses are all stored on the server he is hosted on (the TXID number), and are searchable on the [website](https://franklin.oxasploits.com).
* Franklin has a blocklist for abusive users.
* Statistics are genearted on the webpage showing how many tokens were used to generate each response, and an estimate of how much it cost the instance operator.

**Setup**

* You should configure `franklin.pl` to autoload on irssi start, and optionally configure your channel autojoins.
*  Set the API key by running `/set franklin_api_key [key goes here]` inside irssi.
*  You'll need to set up a webserver with a directory under it's root called `said` (usually something like `/var/www/html/said/`), that is writable by the `franklin.pl` script.
*  Create a file called `block.lst` and fill it, line by line, with any users that abuse the bot.
*  Edit any variables in franklin you need to from within irssi, such as the domain name of your server where the long-text is hosted, by using `/set fraklin_...`.
*  Finally, test it by calling with "Franklin: say hi! in chat".


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
be ~1000.

`/set franklin_chatterbox_mode [int]`
An integer, 0 to 100, 0 being silent unless spoken to, 100 being says something every line.

`/set franklin_history_length [int]`
How far back the chat history goes.  In lines, should be 5 to 8 lines.

`/set franklin_blocklist_file [file]`
The file where the line-by-line nick blocklist is stored. Users in this file cannot use Franklin.


**Debugging**

Now test the bot by calling it with "Franklin: print me a test message" in channel (do this from a different nick, 
not Franklin's nick!)

Sometimes Fraklin fails because of heavy load on the API, connection issues, or the like.  It has primitive recovery methods, if
it happens to get stuck, just `script load franklin.pl` again. Should reload Franklin.

Sometimes after running /quit in irssi, it is necessary to *also* run `pkill irssi` to reap any runaway franklin processes.  The
longer irssi has been running, the more this is an issue.

Ocassionally, if franklin is to "stall" and stop responding to queries, you can run `/script load franklin.pl` and this will
usually rectify the issue.

**Authors**

oxagast / Marshall Whittaker

**Thanks to people who asked for features or found bugs**

atg, dclaw, proge, CerebraNet, morb, bookworm and more...
