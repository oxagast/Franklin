# Changelog

## Franklin

**d66cf16a (HEAD -> cohere-base_command, origin/cohere-base_command)** (11 hours ago) _Marshall Whittaker_ Fixed stray 'i;', also fixed the recognition of alphanumeric chars with \w for the txid, fixed total chunks not right bug.
**aa9fb74e** (21 hours ago) _Marshall Whittaker_ Updated frank's version number.
**0f8ec9f6** (22 hours ago) _Marshall Whittaker_ Changelog addition.
**df732816** (22 hours ago) _Marshall Whittaker_ Perltidy.
**b297acaa** (22 hours ago) _Marshall Whittaker_ Fixed bug with the asshat level warning (our greater/lesser qualilifier was backwards).  Added a couple more things for more verbose logging.
**475bdce8 (origin/frank_master, origin/HEAD, frank_master)** (24 hours ago) _Marshall Whittaker_ Commiting the merge of of frank master and the cohere branch.
**059398f3** (24 hours ago) _Marshall Lee Whittaker_ Revamp on logging, now using a concise subroutine.
**62e4eb32** (31 hours ago) _Marshall Whittaker_ Unstashed.
**dcd080df** (32 hours ago) _GitHub_ Update franklin.pl
**16929aa9** (2 days ago) _Marshall Whittaker_ Fixed the case sensitivity bug in txidchans spec.  Also added the feature 'Franklin: continue [txid] [part]'.
**b3eca35e** (3 days ago) _Marshall Whittaker_ Fixed a double error message bug.
**07fb696c (tag: v4.0.0)** (4 days ago) _GitHub_ Merge pull request #16 from oxagast/cohere-base_command
**a7ad73fe** (4 days ago) _Marshall Whittaker_ Fixed comment outdenting for better readability, fixed some minor errors.
**a94fb641** (4 days ago) _Marshall Whittaker_ Fixed some minor things, added a autoreload on suspected hang.
**65f1b525** (5 days ago) _Marshall Whittaker_ Fixed how it would not respond on the first query after reload, becase there was nothing in the spots in the  array. Otherwise pulling undef from [1], [2], etc will not satisfy the json and make it valid.  Adding just bunk to the array works.
**fd7564b2** (5 days ago) _Marshall Whittaker_ Perltidy.
**260c3ea5** (5 days ago) _Marshall Whittaker_ Got rid of stray " in contetxt bug.  Repositioned the user articles to better match a conversation.
**48f2d1fa** (5 days ago) _Marshall Whittaker_ Fixed some sanitization issues with the dcp.
**8faabeba** (6 days ago) _Marshall Whittaker_ Added Sys:: related calls to get real mem and cpu stats.
**0a091c8c** (6 days ago) _Marshall Whittaker_ Version change and some comments.
**c7c42281** (6 days ago) _Marshall Whittaker_ Updated the said/ backup.
**07657b8a** (6 days ago) _Marshall Whittaker_ Scrubbed API key from log output.
**ad7d0418** (6 days ago) _Marshall Whittaker_ Fixed a minor bug, made some code comments.
**3dbb920b** (6 days ago) _Marshall Whittaker_ Fixed logging so it has a time() call (unix epoc timestamp).
**6d90158e** (6 days ago) _Marshall Whittaker_ Added some logging of the request.
**a382245a** (6 days ago) _Marshall Whittaker_ Version update.
**c8b6da38** (6 days ago) _Marshall Whittaker_ Revamed some code to work with Cohere LLM AI on this branch.
**daed6449** (7 weeks ago) _Marshall Whittaker_ Tested increase in token length accomodated by GPT 3.5 Turbo Instruct (4096 tok).
**f3e25bb0** (3 months ago) _marshall whittaker_ Added logging.
**f57f03f2** (3 months ago) _marshall whittaker_ Added a 2.5 second pause before retrying the API call.
**08085d9a** (3 months ago) _marshall whittaker_ Perltidy.
**6b5390af** (4 months ago) _Marshall Lee Whittaker_ Total messages count redo.
**4d6d920b** (4 months ago) _Marshall Lee Whittaker_ Total messages count.
**60c96c89** (4 months ago) _Marshall Lee Whittaker_ Try setting  to Franklin unless its already def.
**c7850f4c** (4 months ago) _Marshall Lee Whittaker_ So we can multiply without an err.
**b2c0c8f1** (4 months ago) _Marshall Lee Whittaker_ Changed version info, also readded warnigns and perl 5.10 spec.
**ee52e3e6** (4 months ago) _Marshall Lee Whittaker_ Revert "Revert "Perl 5.10+ for smartmatch.""
**24fd2d84** (4 months ago) _Marshall Lee Whittaker_ Revert "Revert "This will define  array through the 8th position, regaurdless of if it has data, so we don't have an undefined array.""
**39808fa8** (4 months ago) _Marshall Lee Whittaker_ Revert "Revert "Better to rewrite the @ array notation as a scalar ($).""
**24d0202c** (4 months ago) _Marshall Lee Whittaker_ Revert "Revert maybe?"
**e1034db9** (4 months ago) _Marshall Lee Whittaker_ Revert "Check if  is defined before checking if it equals nicks becase we should."
**cde3dcb6** (4 months ago) _Marshall Lee Whittaker_ Revert "Better to rewrite the @ array notation as a scalar ($)."
**45da2c4e** (4 months ago) _Marshall Lee Whittaker_ revert
**4082b657** (4 months ago) _Marshall Lee Whittaker_ Revert "This will define  array through the 8th position, regaurdless of if it has data, so we don't have an undefined array."
**c91bf670** (4 months ago) _Marshall Lee Whittaker_ Revert "Perl 5.10+ for smartmatch."
**c450f276** (4 months ago) _Marshall Lee Whittaker_ Revert maybe?
**d98e05d6** (4 months ago) _Marshall Lee Whittaker_ Bah.
**4abf8dac** (4 months ago) _Marshall Lee Whittaker_ Added a my for var.
**991924fe** (4 months ago) _Marshall Lee Whittaker_ This will define  array through the 8th position, regaurdless of if it has data, so we don't have an undefined array.
**67e1d4f2** (4 months ago) _Marshall Lee Whittaker_ Better to rewrite the @ array notation as a scalar ($).
**ef557968** (4 months ago) _Marshall Lee Whittaker_ Check if  is defined before checking if it equals nicks becase we should.
**fa693dd3** (4 months ago) _Marshall Lee Whittaker_ Fixed Franklin's own text not being pushed onto @chat stack.
**9fafba94** (4 months ago) _Marshall Lee Whittaker_ Asshat subroutine now uses gpt3.5 turbo instruct as well.
**645fb8ef** (4 months ago) _Marshall Lee Whittaker_ Perl 5.10+ for smartmatch.
**6b505445** (4 months ago) _Marshall Lee Whittaker_ Smartmatch instead of grep.
**bf43f161** (4 months ago) _Marshall Lee Whittaker_ No need for the responses.tar.gz file if we have the said/ folder.
**3fd91dc8** (4 months ago) _marshall whittaker_ Merge branch 'frank_master' of github.com:oxagast/Franklin into frank_master
**3df1185a** (4 months ago) _marshall whittaker_ Added more said/ responses.
**bceadd4c** (4 months ago) _GitHub_ Merge pull request #13 from oxagast/base_GPT-3.5-turbo-instruct
**4af5bc59 (origin/base_GPT-3.5-turbo-instruct)** (4 months ago) _GitHub_ Merge pull request #12 from oxagast/frank_master
**8d853624** (4 months ago) _GitHub_ Update franklin.pl
**685e4f74** (4 months ago) _Marshall Whittaker_ Better regex for alphanumspace
**f54072d1** (4 months ago) _Marshall Whittaker_ Better santitize.
**32404cac** (4 months ago) _Marshall Whittaker_ Version update for new output.
**51eecc15** (4 months ago) _Marshall Whittaker_ Cleanup.
**397da875** (4 months ago) _Marshall Whittaker_ Fix typo
**bc46cdd8** (4 months ago) _Marshall Whittaker_ So we have var1 and var2 on same line.
**11784634** (4 months ago) _Marshall Whittaker_ With Dumper.
**880fec7a** (4 months ago) _Marshall Whittaker_ Try JSON with dumper.
**217d6393** (4 months ago) _Marshall Whittaker_ JSON again.
**6d52e030** (4 months ago) _Marshall Whittaker_ Just JSON this time.
**98bb0c5e** (4 months ago) _Marshall Whittaker_ Fix JSON encode 2.
**a66d79b7** (4 months ago) _Marshall Whittaker_ Fix JSON encode.
**ffea1b46** (4 months ago) _Marshall Whittaker_ Pretty JSON?
**b0c8e108** (4 months ago) _Marshall Whittaker_ Santiize the wegpages.
**8bfae2bc** (4 months ago) _Marshall Whittaker_ Increased size of webpage read.
**b569ee8b** (4 months ago) _Marshall Whittaker_ Oops fixed typo.
**3a1fed80** (4 months ago) _Marshall Whittaker_ Merge remote-tracking branch 'refs/remotes/origin/frank_master' into frank_master
**91a5f00c** (4 months ago) _Marshall Whittaker_ Changes to output in /win1
**55e68e24** (4 months ago) _GitHub_ Fix on knowing which model it is.
**528f4b60** (4 months ago) _GitHub_ Merge pull request #11 from oxagast/base_GPT-3.5-turbo-instruct
**7065e793** (4 months ago) _Marshall Whittaker_ Comments.
**18085112** (4 months ago) _marshall whittaker_ Reverted ad commit message.
**c8ea0f91** (4 months ago) _marshall whittaker_ Merge
**f4a99295** (4 months ago) _marshall whittaker_ Edit to context.
**e8967e6f** (4 months ago) _GitHub_ Updated version string.
**724c08d5** (4 months ago) _GitHub_ Cleaned up whitespace.
**65dbe6e6** (4 months ago) _GitHub_ Updated change date and version number.
**74c4b568** (4 months ago) _marshall whittaker_ Took out txid awreness becaust it's too chatty about it.
**32c5e5d8** (4 months ago) _GitHub_ Correction on print.
**7faca4d9** (4 months ago) _GitHub_ Seeing if the array stack works.
**dcdfb1da** (4 months ago) _GitHub_ Update franklin.pl
**e725183d** (4 months ago) _marshall whittaker_ Fied the bugwhere frank sometimes not respond.  Also fixed data leak etween chnnels.
**2d24e1f7** (4 months ago) _marshall whittaker_ Perltidy
**ecf4228b** (4 months ago) _marshall whittaker_ Retries should work now, and can be set with the franklin_max_retry variable.
**066766b7** (4 months ago) _marshall whittaker_ Now knows what model it is running in context.
**bf74aedb** (4 months ago) _GitHub_ Merge pull request #10 from oxagast/frank_master
**93511442** (4 months ago) _GitHub_ Updated with new options.
**a761f270** (4 months ago) _GitHub_ New API
**56050702** (4 months ago) _marshall whittaker_ Version updated.
**d8731c36** (4 months ago) _marshall whittaker_ In the event of deprecation, bringing up to GPT-3.5-Turbo-Instruct model.
**0057c199 (origin/openai-base_text-davinci-003, origin/base_text-davinci-003)** (4 months ago) _marshall whittaker_ Token output now looks right.
**65bcce92** (4 months ago) _marshall whittaker_ Fixed token pulling from json
**6b91f4ec** (5 months ago) _GitHub_ Align Logo
**c809335f** (5 months ago) _marshall whittaker_ Run perltidy.
**0f2c15ae** (5 months ago) _marshall whittaker_ Now txid enabled channels display corretly in the var summary.
**e013f5b2** (5 months ago) _marshall whittaker_ Added some internal config warnings.
**a42e437d** (5 months ago) _marshall whittaker_ Condensing of some code around the URL resolver, made the vars menu a little more user friendly.
**cbd44836** (5 months ago) _marshall whittaker_ Added said/ from var-www
**f6074209** (5 months ago) _marshall whittaker_ Update helper script.
**639d902a** (5 months ago) _GitHub_ Some comments and chaned email address.
**8599ee26** (5 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**f2100665** (5 months ago) _marshall whittaker_ Added some more comment code docs, and added a total request count.
**6cc4c06b** (5 months ago) _GitHub_ Updated readme with logo
**3048b6fe** (5 months ago) _marshall whittaker_ Version change
**aa653e0c** (5 months ago) _marshall whittaker_ Now doesn't' respond i you give it a franklin_helper command
**85bab451** (5 months ago) _marshall whittaker_ Added some CPAN instructions.
**a6a3c2f8** (5 months ago) _marshall whittaker_ Removed extra g-tag output.
**e5061ce7** (5 months ago) _marshall whittaker_ woo
**09ece388** (5 months ago) _marshall whittaker_ Removed the start of a reposne 'response: '.
**1ce94fb3** (5 months ago) _marshall whittaker_ Rearranged some things that make the rolling chat history and permissions work.
**d858ab59** (5 months ago) _marshall whittaker_ Took some stuff out of the contextual prelude
**ea8f4b48** (5 months ago) _marshall whittaker_ HDD and MEM values were switched, fixed.
**9017ce01** (5 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**33227a93** (5 months ago) _Marshall Whittaker_ Minor changes.
**f6a1965a** (5 months ago) _Marshall Lee Whittaker_ Added a archive of previous Franklin responses.
**6c285343** (5 months ago) _Marshall Lee Whittaker_ Code cleanup, via perltidy.
**5260b2bf** (5 months ago) _marshall whittaker_ Cleaning up some.
**e529bb7e** (5 months ago) _marshall whittaker_ Now responds to PMs properly.
**70dbea5e** (5 months ago) _marshall whittaker_ Trying to iron bug out.
**2da3d7e7** (5 months ago) _marshall whittaker_ Franklin should now respodn to PMs.
**57eb9b8a** (5 months ago) _Marshall Lee Whittaker_ back
**fa9f710b** (5 months ago) _Marshall Lee Whittaker_ 'pull code' changed to one verb, pullcode
**a0b22a73** (5 months ago) _Marshall Lee Whittaker_ Negating grep if the user has entered a command verb
**c8290a69** (5 months ago) _marshall whittaker_ Part too.
**eeb5a7f0** (5 months ago) _marshall whittaker_ Modified franklin_helper to accept a few more usefull commands via irc admins.
**8da0b433** (5 months ago) _marshall whittaker_ Version num
**9800c030** (5 months ago) _marshall whittaker_ Added a git repo puller to franklin_helper.
**9734190b** (6 months ago) _GitHub_ Update franklin.pl
**3e4e16e9** (6 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**fe183898** (6 months ago) _marshall whittaker_ Shortened the contextual prelude some.
**63c94247** (6 months ago) _marshall whittaker_ Added some more information about the server Franklin is on.
**9897268e** (6 months ago) _marshall whittaker_ Oof don't overwtei me
**f805881b** (6 months ago) _Marshall Lee Whittaker_ Renamed helper.pl to franklin_helper.pl.
**abadb17d** (6 months ago) _GitHub_ Took out trigger and am now using franklin_helper
**4bcabcdd** (6 months ago) _GitHub_ Some updates to reflect new features.
**20314c81** (6 months ago) _marshall whittaker_ You can now add channels via /set franklin_txid_chans seperated by spaces to add a txid to the message.
**d0f40309** (6 months ago) _Marshall Lee Whittaker_ Trying out a new feature that allows you to hide txids from certain channels.
**9e8b9c86** (7 months ago) _marshall whittaker_ perltidy
**4938353f** (7 months ago) _GitHub_ Update helper.pl
**f1e0b242** (7 months ago) _GitHub_ Update helper.pl
**071ffcc6** (7 months ago) _GitHub_ Update helper.pl
**ff4be728** (7 months ago) _GitHub_ Removed trigger.pl as it is now unnecessary.
**f70e61c6** (7 months ago) _GitHub_ Version
**196b565a** (7 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**64659704** (7 months ago) _marshall whittaker_ Franklin reloading helper script up
**ed6fa416** (7 months ago) _Marshall Lee Whittaker_ Helper sript
**99bef826** (7 months ago) _Marshall Lee Whittaker_ oops
**b62dc1f4** (7 months ago) _Marshall Lee Whittaker_ Didn't open.
**70af927c** (7 months ago) _Marshall Lee Whittaker_ Didn't close those parenthesis. Oops.
**e33555c1** (7 months ago) _Marshall Lee Whittaker_ oops
**3aa7aa6f** (7 months ago) _Marshall Lee Whittaker_ Shoot at ducks but not every time.
**1e495f36** (7 months ago) _Marshall Lee Whittaker_ Revert
**cc7e0804** (7 months ago) _Marshall Lee Whittaker_ Sorry, forgot money tag.
**d07ab2e9** (7 months ago) _Marshall Lee Whittaker_ Frank loader?
**f50ac4a9** (7 months ago) _Marshall Lee Whittaker_ Trying to implemnt a thread for signal.
**6710b9aa** (7 months ago) _Marshall Lee Whittaker_ Added some returns for code correctness.
**379a3136** (7 months ago) _Marshall Whittaker_ aaa
**87741e62** (7 months ago) _Marshall Whittaker_ back
**6e5dae0e** (7 months ago) _Marshall Whittaker_ Try this.
**7a7c02ea** (7 months ago) _Marshall Whittaker_ Maybe it was in the wrong spot.
**3a2657f1** (7 months ago) _Marshall Whittaker_ try this
**fc7e64f5** (7 months ago) _Marshall Whittaker_ lets try passing a ref
**4505ae06** (7 months ago) _Marshall Whittaker_ revert with code commented
**ccf27033** (7 months ago) _Marshall Whittaker_ hmmm
**113f2980** (7 months ago) _Marshall Whittaker_ Trying thread forking.
**da61165e** (7 months ago) _Marshall Whittaker_ Fixed error message in chatterbox to reflect 0 to 1000 change.
**0ee3430c** (7 months ago) _Marshall Whittaker_ Added trigger.pl because we use it for 'Franklin: reload'.
**fdd0f03e** (7 months ago) _marshall whittaker_ Doubled a line somehow.
**66491cfc** (8 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**b156f05a** (8 months ago) _marshall whittaker_ cleaned some things up
**e0efb5a3** (8 months ago) _GitHub_ Update README.md
**a2bd82d0** (8 months ago) _Marshall Lee Whittaker_ Reapplied html fg_top and bottom right
**8eb9b4c8** (8 months ago) _Marshall Lee Whittaker_ Reapplied html fg_top
**445da911** (8 months ago) _Marshall Lee Whittaker_ No more need for debugging the asshole finder.
**adcb10a0** (8 months ago) _Marshall Lee Whittaker_ oops
**416c1c9d** (8 months ago) _Marshall Lee Whittaker_ oops
**5f2ddc2a** (8 months ago) _Marshall Lee Whittaker_ Fixed mispelling of moderate.
**e934dee1** (8 months ago) _Marshall Lee Whittaker_ Removed unused var.
**238f1093** (8 months ago) _Marshall Lee Whittaker_ For brevity collapsed page_body.
**8fead901** (8 months ago) _Marshall Lee Whittaker_ Shortening some things.
**cba76be8** (8 months ago) _Marshall Lee Whittaker_ For brevity we put it on one line.
**3ee8d524** (8 months ago) _Marshall Lee Whittaker_ Concat.
**87687e97** (8 months ago) _Marshall Lee Whittaker_ close bracket lost
**f3bdde29** (8 months ago) _Marshall Lee Whittaker_ oof
**79374f54** (8 months ago) _Marshall Lee Whittaker_ remove repaste
**7fae02af** (8 months ago) _Marshall Lee Whittaker_ fix
**10c9b6af** (8 months ago) _Marshall Lee Whittaker_ fix
**3c23d562** (8 months ago) _Marshall Lee Whittaker_ oof
**0dbdd9da** (8 months ago) _Marshall Lee Whittaker_ Collapse beginning spaces.
**9a8a6702** (8 months ago) _Marshall Lee Whittaker_ Concat.
**af8d6992** (8 months ago) _Marshall Lee Whittaker_ Fixed long string.
**982bd8ee** (8 months ago) _Marshall Lee Whittaker_ Fixed some formatting things.
**013acfad** (8 months ago) _marshall whittaker_ Added a user definable asshole setting.
**a5f4c66c** (8 months ago) _marshall whittaker_ Tuning asshole kicker modules.
**82ef7a70** (8 months ago) _marshall whittaker_ Finishing up the asshole aggregation.
**d1de953f** (8 months ago) _marshall whittaker_ Got the kicker working on bad words.
**621edfb3** (8 months ago) _marshall whittaker_ Got the asshole rating system kinda working. maybe.
**d33af2a5** (8 months ago) _marshall whittaker_ Started adding asshole detection, and updated readme for 1:1000.
**4df5cf55** (8 months ago) _marshall whittaker_ Fixed typo in the ua call.
**957a528b** (8 months ago) _GitHub_ Update franklin.pl
**21a12fab** (8 months ago) _GitHub_ Update franklin.pl
**cdc2151b** (9 months ago) _marshall whittaker_ Franklin now knows what time it is!
**6cc2a39f** (8 months ago) _marshall whittaker_ Trigger suggestion in readme.
**8dc6d019** (8 months ago) _marshall whittaker_ Now knows what the current date is.
**f74374cc** (8 months ago) _marshall whittaker_ Fixed if the context is too long it doesn't answer or answers garbled.
**05a3ed10** (8 months ago) _marshall whittaker_ Fixed it so that input is stripped of color codes so that Franklin doens't hang on them being in the context log.
**3ee3b132** (9 months ago) _marshall whittaker_ Better place to sanitize the html.
**84804974** (9 months ago) _marshall whittaker_ Fixed an XSS bug.
**a235b79f** (9 months ago) _marshall whittaker_ lets see if eniac can read the api key now.
**8647e2d5** (9 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**8ca5e055** (9 months ago) _marshall whittaker_ Added a setting to control the google analytics G- tag without changing the source.
**7f15642f** (9 months ago) _GitHub_ Removed some old comments that didn't mean anything anymore
**8162435d** (9 months ago) _marshall whittaker_ Fixed not having a franklin_http_location in settings and thus having it always set to undef and files saving to wront location.
**602b4e31** (9 months ago) _GitHub_ Comments for context
**69756e49** (9 months ago) _GitHub_ Update contextual prelude
**5b149dfb** (9 months ago) _marshall whittaker_ Added info str for user defined info about networks.
**9417dfba** (10 months ago) _marshall whittaker_ Some error correction checks for file existance and varaible defines.
**a002c354** (10 months ago) _marshall whittaker_ Formatting corrections.
**d55a6477** (10 months ago) _marshall whittaker_ Fixes the runaway process bug where heartbeat urls don't resolve and hang, then end with a zilion zombie processes after 5 days.
**0d212a11** (10 months ago) _Marshall Lee Whittaker_ Updated version to reflect new feature.
**0983a5e2** (10 months ago) _marshall whittaker_ Franklin now knows if it is an operator/moderator in a channel.
**140b5173** (10 months ago) _marshall whittaker_ Fixed the " character bug better.
**c31da0f3** (10 months ago) _marshall whittaker_ Fixed the not being able to deal with a double quote.
**7afcec50** (10 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**3278a496** (10 months ago) _marshall whittaker_ Now shows the settings when the settings on load.
**8afcbfb6** (10 months ago) _GitHub_ No need for this, its embedded.
**b602f57b** (10 months ago) _GitHub_ Update README.md
**c37c55ee** (10 months ago) _GitHub_ Update README.md
**f8dbb29b** (10 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**6d5e2c6e** (10 months ago) _marshall whittaker_ No need for the old dir, as there is a seperate branch for that.
**c5bae29c** (10 months ago) _GitHub_ Delete irc_chats.png
**bb1e9ae6** (10 months ago) _GitHub_ Update users who have helped
**721f9510** (10 months ago) _GitHub_ Update franklin.pl
**d79600b0** (10 months ago) _GitHub_ Merge pull request #4 from denzuko/patch-1
**e08e7d3d** (10 months ago) _GitHub_ Update README.md
**82d4204c** (10 months ago) _GitHub_ Update README.md
**58c04ff9** (10 months ago) _GitHub_ Update README.md
**9b35f2ff** (10 months ago) _GitHub_ Major updates to readme file formatting and info
**8623cf13** (10 months ago) _GitHub_ Update README.md
**8f12df46** (10 months ago) _GitHub_ Update README.md to reflect some additions to franklin.
**080ec6bc** (10 months ago) _marshall whittaker_ Version number change on page reader.:
**3a1c9a1e** (10 months ago) _marshall whittaker_ This lets franklin read and interpret link text.
**6b72f487** (10 months ago) _marshall whittaker_ Fixed wide character in print bug.
**84b3b3a2** (10 months ago) _marshall whittaker_ ahh
**2695a48a** (10 months ago) _marshall whittaker_ Added two new enteries into the load screen for their set values.
**9e1ad263** (10 months ago) _marshall whittaker_ Rearranged some things for efficiency.
**d4e8902c** (10 months ago) _marshall whittaker_ Fixed a default.
**02d8cd2c** (10 months ago) _marshall whittaker_ Fixing chatterbox mode.
**fc8f0e86** (10 months ago) _marshall whittaker_ Added some more text corrections, and some less vague error messages for users.
**b956aaca** (10 months ago) _marshall whittaker_ Removed the old html parts.
**06dee39d** (10 months ago) _marshall whittaker_ Modfied so that it no longer reads the HTML from files, this causes some errors sometimes.
**d57bc6a3** (10 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**cfc5ddee** (10 months ago) _marshall whittaker_ Got the lockup bug ironed out.
**69b88199** (10 months ago) _GitHub_ Update franklin.pl
**9b12aa40** (10 months ago) _GitHub_ Update README.md
**b0cba030** (10 months ago) _GitHub_ Thanks to the people this project has benefited from
**f56913ff** (10 months ago) _marshall whittaker_ Took out the entier frank_thinks subroutine becuase it needs to be redesigned from the ground up.
**b8a9224a** (10 months ago) _marshall whittaker_ Changed the loop to a goto statement, we're gonna see if tightening that up helps.
**69c2d73a** (10 months ago) _marshall whittaker_ Fixed the error always popping up about chatterbox mode.
**873dfc10** (10 months ago) _GitHub_ Update franklin.pl
**19822f4e** (10 months ago) _marshall whittaker_ Trying to get rid of the hang that stops it, also forks off the say's now.
**3348a1a6** (10 months ago) _marshall whittaker_ Now shows approx cost of generating a message.
**51268952** (10 months ago) _marshall whittaker_ Learning mode is getting better.
**6b4e1250** (10 months ago) _marshall whittaker_ Since the website is in a branch of its own now, its gone from here.
**7fe0f27e** (10 months ago) _marshall whittaker_ Trying to get chatterbox mode working.
**bceac410** (10 months ago) _marshall whittaker_ Updated the website mainpage.
**7d7f1fe9** (10 months ago) _marshall whittaker_ Fixed this branch.
**b8bacf1d** (10 months ago) _marshall whittaker_ So it knows what it is and it's role.
**8f669ac8** (10 months ago) _marshall whittaker_ Franklin now every so often says something itself.
**0159dd74** (10 months ago) _GitHub_ Update franklin.pl
**8dc1b7d6** (10 months ago) _marshall whittaker_ Broke up the long context setup.
**4eafb7c8** (10 months ago) _GitHub_ Update franklin.pl
**0ebf522d** (10 months ago) _GitHub_ Update franklin.pl
**e16c4850** (10 months ago) _marshall whittaker_ Context.
**7954a5d3** (10 months ago) _marshall whittaker_ Now has context of what is curently being duscussed in chat.
**ce534939** (10 months ago) _marshall whittaker_ Updated how franklin interacts.  Trying to keep tack of the convo.
**a236c050** (10 months ago) _marshall whittaker_ Readded franklin after merge fail.
**d1c532ed** (10 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**3ec159ae** (10 months ago) _marshall whittaker_ Told franklin a little about itself and its creator, and what it is.  Also the website now has a stats counter.
**23155d54** (11 months ago) _GitHub_ Update franklin.pl
**01002f3a** (11 months ago) _GitHub_ Don't know why my zsh config is here...
**71ecdd1e** (11 months ago) _marshall whittaker_ Took geert off ignore in the repo.
**13b82fd8** (11 months ago) _marshall whittaker_ Moved old franklin to old/
**fe3f7b2b** (11 months ago) _marshall whittaker_ Remove stat  file.
**ea7c833a** (11 months ago) _marshall whittaker_ Upgraded to GPT 3.5 Turbo and made some tweaks. Also updateed webpage to reflect this.
**5113a8c3** (11 months ago) _GitHub_ Delete .speed.dat
**582160af** (11 months ago) _marshall whittaker_ Upgraded to the GPT 3.5 Turbo model.
**40501fd0** (11 months ago) _marshall whittaker_ Perltidy.
**b435c616** (11 months ago) _marshall whittaker_ Removed the stray 'i' that makes it error out.
**df9f546a** (11 months ago) _marshall whittaker_ Changed html part names to something more obvious. Gives a loading message now.  Added colorization to the files section.
**a07c894b** (11 months ago) _marshall whittaker_ Edited the date and some little things on website.
**7f1e28ef** (11 months ago) _marshall whittaker_ Now shows date stamp.
**9278e5a7** (11 months ago) _marshall whittaker_ Adjusted the sanitzation to the proper spot in code.
**9fd3f01e** (11 months ago) _marshall whittaker_ klMerge branch 'main' of github.com:oxagast/Franklin
**26326d39** (11 months ago) _marshall whittaker_ Fixed double quote -> single quote bug, and added html pages as pretty output for IRC, but kept the .txt output too.
**01498105** (11 months ago) _GitHub_ Updated screenshot
**ec277be4** (11 months ago) _GitHub_ Add files via upload
**ffe13039** (11 months ago) _GitHub_ Update README.md
**f3d6ad49** (11 months ago) _marshall whittaker_ Now works when you address franklin with either : or ,.
**85f79801** (11 months ago) _GitHub_ Added .txt file extension to files in said/
**ee0bee05** (12 months ago) _marshall whittaker_ Changed website to reflect some changes and gpt4.
**24bf9f8b** (12 months ago) _GitHub_ Edited README resource.
**28fffd98** (12 months ago) _GitHub_ Edited the README resource.
**e24edbc4** (12 months ago) _GitHub_ Ascii frank!
**83348f61** (12 months ago) _GitHub_ Fixed indentation on a line.
**451b343c** (12 months ago) _marshall whittaker_ Fixed a bug that was introduced in last commit, and allows for comments in the badnicks file now.
**b0c9c7b8** (12 months ago) _oxagast_ Made some things clearer with comments.
**43d34e46** (12 months ago) _GitHub_ Update franklin.pl
**e202608c** (12 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin fixed
**f465dc3e** (12 months ago) _marshall whittaker_ Fixed ver.
**b39d7746** (12 months ago) _marshall whittaker_ Fixed getting current nick code.
**d022bb05** (12 months ago) _GitHub_ Update franklin.pl
**69a542f7** (12 months ago) _oxagast_ k Corrected version number.
**203c60ca** (12 months ago) _marshall whittaker_ Made some improvements such as knowing what it's own name is, and more settings, and a short settings help.
**17f1ac2c** (12 months ago) _marshall whittaker_ Fixes last commit, which should only apply to the beginning of a line.
**04a92f34** (12 months ago) _marshall whittaker_ Parsed out beginning of line question mark follwed by two spaces in ambiguous search.
**f1a86769** (1 year, 1 month ago) _GitHub_ # shouts
**5391245f** (1 year, 1 month ago) _GitHub_ New readme in txt format
**360f94ce** (1 year, 1 month ago) _GitHub_ Creative Commons Attribution-NonCommercial 4.0 International Public Llicense
**0b723a62** (1 year, 1 month ago) _GitHub_ Update franklin.pl
**2739d5a4** (1 year, 1 month ago) _marshall whittaker_ Edited the readme to reflect changes.
**d08aa3f7** (1 year, 1 month ago) _marshall whittaker_ Ver
**03a92fdd** (1 year, 1 month ago) _marshall whittaker_ Edited the way it deal with single and double quotes.
**a81c5fcd** (1 year, 1 month ago) _marshall whittaker_ Edit on comment
**7acc4fb9** (1 year, 1 month ago) _marshall whittaker_ woo woo 2.0
**2437b3d3** (1 year, 1 month ago) _marshall whittaker_ Added an irssi var setting for the api key.
**7db6dbcb** (1 year, 1 month ago) _marshall whittaker_ Added an alive worker heartbeat setting.
**63cb8e5e** (1 year, 1 month ago) _oxagast_ Added a pic of the source.
**12cfa695** (1 year, 1 month ago) _oxagast_ Added a mascot. Frankie.
**dede48c5** (1 year, 1 month ago) _marshall whittaker_ Added some variables you can change from within irssi.
**05e90e96** (1 year, 1 month ago) _marshall whittaker_ Fixes and spelling errors.
**8590a3bf** (1 year, 1 month ago) _marshall whittaker_ Pertidy'd.
**f203e9d2** (1 year, 1 month ago) _marshall whittaker_ Cha
**e8df4a05** (1 year, 1 month ago) _marshall whittaker_ Fixed a typo in the site.
**e6266fbd** (1 year, 1 month ago) _marshall whittaker_ Corrected somethings in the README for v2, and fixed the blacklisting code.  Tired to make the spacing more accurate.
**03ed8b08** (1 year, 1 month ago) _marshall whittaker_ Only pulls the api key once now, and can retry on error.
**f4f4eca5** (1 year, 1 month ago) _marshall whittaker_ Fixed a bug when converting partial md5 checksum when seeing wide characters.
**29809e1b** (1 year, 1 month ago) _marshall whittaker_ Edited setup in readme.
**6170c91a** (1 year, 1 month ago) _marshall whittaker_ OOps. No API keys, even though thats an old one.
**89b5f81d** (1 year, 1 month ago) _marshall whittaker_ Edits and perltidy config.
**2a3fcdd4** (1 year, 1 month ago) _GitHub_ spacing
**eb2ff74d** (1 year, 1 month ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**645b7294** (1 year, 1 month ago) _marshall whittaker_ Rewrite of franklin and bugfixes.
**440dade1** (1 year, 1 month ago) _marshall whittaker_ oof
**8d3c77d5** (1 year, 1 month ago) _marshall whittaker_ Rewrite for a Franklin v2 in pure perl.
**735b8e15** (1 year, 1 month ago) _Marshall Lee Whittaker_ GPTChat.
**cecec392** (1 year, 2 months ago) _GitHub_ Added a funding file
**14e83272** (1 year, 2 months ago) _marshall whittaker_ Spacing/newlines are right on the webserver.
**c7a7d0ae** (1 year, 2 months ago) _marshall whittaker_ Updated website instructions.
**8f99970a** (1 year, 2 months ago) _GitHub_ Update README.md
**7b638265** (1 year, 2 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**0dbbfeec** (1 year, 2 months ago) _root_ New calling script for franklin that is more secure.
**d4916327** (1 year, 2 months ago) _Marshall Lee Whittaker_ Merge remote-tracking branch 'refs/remotes/origin/main'
**3f1b156d** (1 year, 2 months ago) _Marshall Lee Whittaker_ Made some changes to filtering.
**03393bf7** (1 year, 2 months ago) _root_ Made image preview open into a larger img.
**e51d2190** (1 year, 2 months ago) _GitHub_ Updated date for file
**1f47bf78** (1 year, 2 months ago) _GitHub_ Delete .hugo_build.lock
**e835ff41** (1 year, 2 months ago) _marshall whittaker_ Quotes.
**6e6a6317** (1 year, 2 months ago) _marshall whittaker_ Reomved unnecessaray text tmp files.
**f7dec319** (1 year, 2 months ago) _Marshall Lee Whittaker_ Fixed help.
**1a28b0ae** (1 year, 2 months ago) _Marshall Lee Whittaker_ Fixed backtick in nicks RCE.
**3837c6dd** (1 year, 2 months ago) _Marshall Lee Whittaker_ Santisiation of nicks.
**7b851fde** (1 year, 2 months ago) _Marshall Lee Whittaker_ Fixed backticks in nicks maybe.
**0896e628** (1 year, 2 months ago) _Marshall Lee Whittaker_ Added the website
**d18b1e63** (1 year, 2 months ago) _Marshall Lee Whittaker_ Checking and setup.
**d9214351** (1 year, 2 months ago) _marshall whittaker_ Fixed collisons on md5 by checksumming the text itself.
**4c8e68e9** (1 year, 2 months ago) _GitHub_ Spelling
**fee04d09** (1 year, 2 months ago) _GitHub_ updated thanks
**d056148e** (1 year, 2 months ago) _GitHub_ Update README.md
**a80410e6** (1 year, 2 months ago) _GitHub_ screenshot up
**66508b61** (1 year, 2 months ago) _Marshall Lee Whittaker_ Screenie
**91313c7a** (1 year, 2 months ago) _Marshall Lee Whittaker_ Screenie.
**8bea61a3** (1 year, 2 months ago) _GitHub_ Delete irc_chats.png
**328fcef9** (1 year, 2 months ago) _Marshall Lee Whittaker_ IRC screenshot.
**d5790774** (1 year, 2 months ago) _Marshall Lee Whittaker_ removed swap file and added to gitignore
**308b32f0** (1 year, 2 months ago) _Marshall Lee Whittaker_ hehe
**28d69b24** (1 year, 2 months ago) _marshall whittaker_ Formatted the long api call to something more readable on multi lines.
**f3fdc979** (1 year, 2 months ago) _marshall whittaker_ some commenting
**372edc04** (1 year, 2 months ago) _marshall whittaker_ Fixed collisions.
**5f322dbe** (1 year, 2 months ago) _Marshall Lee Whittaker_ formatting.
**8190523b** (1 year, 2 months ago) _marshall whittaker_ Removed extreneous file.
**ed941965** (1 year, 2 months ago) _marshall whittaker_ readme heading
**6076b1fa** (1 year, 2 months ago) _marshall whittaker_ readme heading
**247d7c2a** (1 year, 2 months ago) _marshall whittaker_ Edited some readme stuff.
**88f3f7be** (1 year, 2 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**97b6d814** (1 year, 2 months ago) _marshall whittaker_ Added some setup info.
**97928e3c** (1 year, 2 months ago) _GitHub_ Added the callers nick for ban list use
**55f199a6** (1 year, 2 months ago) _marshall whittaker_ New api storing.
**4c5e3148** (1 year, 2 months ago) _marshall whittaker_ Merge branch 'main' of github.com:oxagast/Franklin
**a8bf2633** (1 year, 2 months ago) _marshall whittaker_ Removed some stuff that isn't needed.
**3e921c6f** (1 year, 2 months ago) _GitHub_ Update block.list
**adb033fc** (1 year, 2 months ago) _marshall whittaker_ oops Merge branch 'main' of github.com:oxagast/Franklin
**ce5fd6ea** (1 year, 2 months ago) _marshall whittaker_ Some acl as well as a lengthy message output holder.
**4338fa1d** (1 year, 2 months ago) _GitHub_ sanitize
**60018e39** (1 year, 2 months ago) _Marshall Whittaker_ Added soft and hard limit vars.
**332d1523** (1 year, 2 months ago) _Marshall Whittaker_ Fixed the jq line so it makes more sense.
**a4d3cdcc** (1 year, 2 months ago) _GitHub_ A perl script from the irssi archives.
**028a5bc5** (1 year, 2 months ago) _GitHub_ Create trigger_for_irssi.txt
**ae43719f** (1 year, 2 months ago) _GitHub_ Initial creation of the file that pulls the things to say with api.
**67c5ad74** (1 year, 2 months ago) _GitHub_ Initial commit