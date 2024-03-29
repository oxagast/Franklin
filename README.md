# Franklin
<p align="center"><img src="https://raw.githubusercontent.com/oxagast/Franklin/webpage/logo.png" alt="Logo"></p>



## Franklin is a ChatGPT backed IRC bot

### Examples

This is a log from #GPT3, Franklin's unoffcial but _defaco_ channel.

> _oxagast_: Franklin: hello good sir<br>
> _Franklin_: Hello oxagast! How can I help you today?  Please let me know if I can assist with any tasks or provide information on any topic you'd like to discuss. Feel free to ask me questions or prompt me with writing tasks. I'll do my best to be of use! TXID:c16b33c8<br>
> _zyme_: Franklin: What do you know about Prompting DALL-E 3, anything?<br>
> _Franklin_: DALL-E is a research project developed by the company OpenAI, known for its successful bid in the AI language model chatbot race. DALL-E stands for "DAVE AI, Large Language Model, Engagement." It is a text-to-image generation model that takes natural language input and generates images that are intended to match the de TXID:052b4be0<br>
> _oxagast_: Franklin: what are those pet electronic devices you could get, neutuer and watch grow on the little screen in the 90s called?
> _Franklin_: It sounds like you're referring to the Tamagotchi. They were small, egg-shaped devices with a pixelated screen, released in the 1990s. Users could raise a virtual pet on the device and perform activities like feeding, cleaning, and playing games. TXID:76c7edfc<br>
> _oxagast_: Franklin: when was that first sold?<br>
> _Franklin_: The Tamagotchi was first sold in Japan in November 1996 and quickly gained popularity worldwide. They became a global phenomenon, with multiple generations of the device released, featuring different shapes, colors, and characters. TXID:dcbdcc6c<br>
> _aestetix_: from this https://old.reddit.com/r/PoliticalCompassMemes/comments/1beilus/anon_likes_to_troll/<br>
> _aestetix_: I recently found this subredit, it's fucking hilarious<br>
> _oxagast_> Franklin: what is aestetix talking about in #0xa28?<br>
> _Franklin_: aestetix is referencing a post from the subreddit PoliticalCompassMemes. They find this subreddit hilarious and shared a specific post from it with the chat. TXID:d134552e<br>
> _oxagast_: Franklin: what are the lyrics to 'never gonna give you up'?<br>
> _Franklin_: The lyrics to "Never Gonna Give You Up" by Rick Astley are as follows:  [Verse 1] We've known each other for so long Your heart's been aching, but you're too shy to say it Inside, we both know what's been going on We know the game and we're gonna play it  [Chorus] I'm never gonna give you up I'm never gonna let you dow TXID:3620b242<br>
> _oxagast_: Franklin: continue 3620b242 1<br>
> _Franklin_:  gonna say goodbye I'm never gonna tell a lie and hurt you [Verse 2] We've known each other for so long And oh, the places that we've been But all the roads we took have led us here And now it's time to see there's more than friends [Chorus] I'm never gonna give you up I'm never gonna let you down I'm never gonna run around and desert you I'm never gonna make you cry I'm never gonna say goodbye I' (2/4)

### Major features of Franklin

* Now upgraded to use the ~~OpenAI GPT 3.5 Turbo Instruct API~~ Cohere Coral command API.
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
* You can now make Franklin continue what he was saying, if the first message didn't fit in chat, you can call this feature using: `Franklin: continue 582c8157 1`.  Replace the txid and chunk number respectively.

### Setup

* Install [Irssi](https://irssi.org), Franklin's host process.
* Install from Perl's CPAN (if deps not already met): Proc::Simple, Santitize, Irssi, and JSON.
* Add `franklin.pl` to autoload on irssi start, and optionally configure your channel autojoins.
* Start irssi
* Set the API key with `/set franklin_api_key [key goes here]` 
* Ensure your webserver root directory contains a folder that is writeable by the `franklin.pl` script named `said`(usually something like `/var/www/html/said/`).
* Append the `block.lst` file with one username per line with any users that abuse the bot.
* Edit any variables in franklin you need to from within irssi, such as the domain name of your server where the long-text is hosted, by using `/set fraklin_...`.
* Finally, test it by calling with "Franklin: say hi!" in chat.
* Load the helper script with: `/script load franklin_helper.pl`.  This will allow *any user* in channel to reload Franklin, but generally this is a good thing unless abused.
* To make Franklin start on server bootup, add this to Franklin's user's crontab: `@reboot sleep 45 && cd ~/Franklin && screen -dmS Franklin`. Then add the following
  .screenrc file:
```
    sessionname Franklin
    startup_message off
    screen -t bot     1 irssi
    screen -t log     3 tail -f /var/log/franklin.log
```
`

### Settings

Name | Description
-|-
`/set franklin_api_key [apikey]` | This is the API key you need to get from OpenAI.
`/set franklin_heartbeat_url [url]` | A url that the franklin script will hit every 30 seconds to show it has not crashed. This setting is optional, to turn it off: /set franklin_heartbeat_url "".
`/set franklin_response_webserver_addr [address]` | server root URL for hosting the domain files franklin is running on. (e.g.  https://franklin.oxasploits.com/said/).
`/set franklin_http_location [dir]` | Server root location of files saved to be served by a web server. (e.g. /var/www/html/said/).
`/set franklin_hard_limit [int]` | The hard limit of characters that the response should be to fit in an IRC chat. (e.g. greater than 30 and less than 300.)
`/set franklin_word_limit [int]` | Limit of words that the API should generate from the backend. Should be ~1000.
`/set franklin_max_retry [int]` | The number of times Franklin should retry generating a response if the previous attempts fail.  Should be set anywhere from 2 to 5.
`/set franklin_chatterbox_mode [int]` | An integer, 0 to 1000, 0 being silent unless spoken to, 1000 being says something every line.
`/set franklin_history_length [int]` | Number of lines of chat history to remember.  In lines, should be 5 to 8 lines.
`/set franklin_blocklist_file [file]` | The file where the line-by-line nick blocklist is stored. Users listed in this file cannot use Franklin.
`/set franklin_server_info [str]` | A brief user defined outline of what each server the bot is connected to is about, injected into the contextual prelude.
`/set franklin_google_gtag [str]` | This is your google analytics G- tag id, for tracking the generated webpages.
`/set franklin_asshat_threshold [float]` | This should be an floating point number from around 6 to 9, and is the kick threshold.
`/set franklin_txid_chans [#chan1 #chan2]` | This is a list of channels where the Transactional Identification should be appended to the end of message.  The channels should be seperated by spaces.
`/set franklin_mem_approx [string]` | The amount of memory Franklin has to work with.
`/set franklin_hdd_approx [string]` | The amount of hard drive space.
`/set franklin_cpu_approx [string]` | Number of allocatable CPU cores.

### Debugging

Now test the bot by calling it with "Franklin: print me a test message" in channel (do this from a different nick, 
not Franklin's nick!)

Fraklin may fail due to heavy load on the API, connection issues, or the like.  It has primitive recovery methods. However, one may reinitialize Fraklin with `/script load franklin.pl`.

Sometimes after running `/quit` in irssi, it is necessary to *also* run `pkill irssi` to reap any runaway franklin processes.  The
longer irssi has been running, the more this is an issue.

Occasionally, if franklin stalls and/or stop responding to queries, you can run `/script load franklin.pl` and this will
usually rectify the issue.  This can also be accomplished if franklin_helper.pl is loaded, by calling Franklin in channel like: "Franklin: reload".

Franklin has a log file you can check!  You can look in the irssi settings to see where it is saved.  You can usually [view the online version](https://franklin.oxasploits.com/bot.log) of my Franklin instance.

Check if the message has been recorded in the `said/` directory!  It's usually in your webserver, so for me `/var/www/franklin/`.  You can [view mine](https://franklin.oxasploits.com/said/?C=M;O=D)!

### Authors

oxagast / Marshall Whittaker

### Thanks

The following people have found verified bugs, or asked for features that ended up being implemented.

atg, dclaw, proge, CerebraNet, morb, bookworm, denzuko, and more...
