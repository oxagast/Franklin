# Changelog

## oxagast/Franklin

**57fbdb13 (HEAD -> cohere-base_command, origin/cohere-base_command)** (13 minutes ago) _GitHub_: Update .perltidyrc<br>
**9e4f7bf3** (2 hours ago) _Marshall Whittaker_: Updated readme.<br>
**9a6720b0** (2 hours ago) _Marshall Whittaker_: Changelog updated<br>
**5e7efd6f** (2 hours ago) _Marshall Whittaker_: Try adding a html linbraek in changelog.<br>
**328ef590** (2 hours ago) _Marshall Whittaker_: Added changelog in markdown.<br>
**d66cf16a** (13 hours ago) _Marshall Whittaker_: Fixed stray 'i;', also fixed the recognition of alphanumeric chars with \w for the txid, fixed total chunks not right bug.<br>
**aa9fb74e** (24 hours ago) _Marshall Whittaker_: Updated frank's version number.<br>
**0f8ec9f6** (24 hours ago) _Marshall Whittaker_: Changelog addition.<br>
**df732816** (24 hours ago) _Marshall Whittaker_: Perltidy.<br>
**b297acaa** (24 hours ago) _Marshall Whittaker_: Fixed bug with the asshat level warning (our greater/lesser qualilifier was backwards).  Added a couple more things for more verbose logging.<br>
**475bdce8** (26 hours ago) _Marshall Whittaker_: Commiting the merge of of frank master and the cohere branch.<br>
**059398f3** (26 hours ago) _Marshall Lee Whittaker_: Revamp on logging, now using a concise subroutine.<br>
**62e4eb32** (34 hours ago) _Marshall Whittaker_: Unstashed.<br>
**dcd080df** (34 hours ago) _GitHub_: Update franklin.pl<br>
**16929aa9** (2 days ago) _Marshall Whittaker_: Fixed the case sensitivity bug in txidchans spec.  Also added the feature 'Franklin: continue [txid] [part]'.<br>
**b3eca35e** (3 days ago) _Marshall Whittaker_: Fixed a double error message bug.<br>
**07fb696c (tag: v4.0.0)** (4 days ago) _GitHub_: Merge pull request #16 from oxagast/cohere-base_command<br>
**a7ad73fe** (4 days ago) _Marshall Whittaker_: Fixed comment outdenting for better readability, fixed some minor errors.<br>
**a94fb641** (4 days ago) _Marshall Whittaker_: Fixed some minor things, added a autoreload on suspected hang.<br>
**65f1b525** (5 days ago) _Marshall Whittaker_: Fixed how it would not respond on the first query after reload, becase there was nothing in the spots in the  array. Otherwise pulling undef from [1], [2], etc will not satisfy the json and make it valid.  Adding just bunk to the array works.<br>
**fd7564b2** (5 days ago) _Marshall Whittaker_: Perltidy.<br>
**260c3ea5** (5 days ago) _Marshall Whittaker_: Got rid of stray " in contetxt bug.  Repositioned the user articles to better match a conversation.<br>
**48f2d1fa** (5 days ago) _Marshall Whittaker_: Fixed some sanitization issues with the dcp.<br>
**8faabeba** (6 days ago) _Marshall Whittaker_: Added Sys:: related calls to get real mem and cpu stats.<br>
**0a091c8c** (6 days ago) _Marshall Whittaker_: Version change and some comments.<br>
**c7c42281** (6 days ago) _Marshall Whittaker_: Updated the said/ backup.<br>
**07657b8a** (6 days ago) _Marshall Whittaker_: Scrubbed API key from log output.<br>
**ad7d0418** (6 days ago) _Marshall Whittaker_: Fixed a minor bug, made some code comments.<br>
**3dbb920b** (6 days ago) _Marshall Whittaker_: Fixed logging so it has a time() call (unix epoc timestamp).<br>
**6d90158e** (6 days ago) _Marshall Whittaker_: Added some logging of the request.<br>
**a382245a** (6 days ago) _Marshall Whittaker_: Version update.<br>
**c8b6da38** (6 days ago) _Marshall Whittaker_: Revamed some code to work with Cohere LLM AI on this branch.<br>
**daed6449** (7 weeks ago) _Marshall Whittaker_: Tested increase in token length accomodated by GPT 3.5 Turbo Instruct (4096 tok).<br>
**f3e25bb0** (3 months ago) _marshall whittaker_: Added logging.<br>
**f57f03f2** (3 months ago) _marshall whittaker_: Added a 2.5 second pause before retrying the API call.<br>
**08085d9a** (3 months ago) _marshall whittaker_: Perltidy.<br>
**6b5390af** (4 months ago) _Marshall Lee Whittaker_: Total messages count redo.<br>
**4d6d920b** (4 months ago) _Marshall Lee Whittaker_: Total messages count.<br>
**60c96c89** (4 months ago) _Marshall Lee Whittaker_: Try setting  to Franklin unless its already def.<br>
**c7850f4c** (4 months ago) _Marshall Lee Whittaker_: So we can multiply without an err.<br>
**b2c0c8f1** (4 months ago) _Marshall Lee Whittaker_: Changed version info, also readded warnigns and perl 5.10 spec.<br>
**ee52e3e6** (4 months ago) _Marshall Lee Whittaker_: Revert "Revert "Perl 5.10+ for smartmatch.""<br>
**24fd2d84** (4 months ago) _Marshall Lee Whittaker_: Revert "Revert "This will define  array through the 8th position, regaurdless of if it has data, so we don't have an undefined array.""<br>
**39808fa8** (4 months ago) _Marshall Lee Whittaker_: Revert "Revert "Better to rewrite the @ array notation as a scalar ($).""<br>
**24d0202c** (4 months ago) _Marshall Lee Whittaker_: Revert "Revert maybe?"<br>
**e1034db9** (4 months ago) _Marshall Lee Whittaker_: Revert "Check if  is defined before checking if it equals nicks becase we should."<br>
**cde3dcb6** (4 months ago) _Marshall Lee Whittaker_: Revert "Better to rewrite the @ array notation as a scalar ($)."<br>
**45da2c4e** (4 months ago) _Marshall Lee Whittaker_: revert<br>
**4082b657** (4 months ago) _Marshall Lee Whittaker_: Revert "This will define  array through the 8th position, regaurdless of if it has data, so we don't have an undefined array."<br>
**c91bf670** (4 months ago) _Marshall Lee Whittaker_: Revert "Perl 5.10+ for smartmatch."<br>
**c450f276** (4 months ago) _Marshall Lee Whittaker_: Revert maybe?<br>
**d98e05d6** (4 months ago) _Marshall Lee Whittaker_: Bah.<br>
**4abf8dac** (4 months ago) _Marshall Lee Whittaker_: Added a my for var.<br>
**991924fe** (4 months ago) _Marshall Lee Whittaker_: This will define  array through the 8th position, regaurdless of if it has data, so we don't have an undefined array.<br>
**67e1d4f2** (4 months ago) _Marshall Lee Whittaker_: Better to rewrite the @ array notation as a scalar ($).<br>
**ef557968** (4 months ago) _Marshall Lee Whittaker_: Check if  is defined before checking if it equals nicks becase we should.<br>
**fa693dd3** (4 months ago) _Marshall Lee Whittaker_: Fixed Franklin's own text not being pushed onto @chat stack.<br>
**9fafba94** (4 months ago) _Marshall Lee Whittaker_: Asshat subroutine now uses gpt3.5 turbo instruct as well.<br>
**645fb8ef** (4 months ago) _Marshall Lee Whittaker_: Perl 5.10+ for smartmatch.<br>
**6b505445** (4 months ago) _Marshall Lee Whittaker_: Smartmatch instead of grep.<br>
**bf43f161** (4 months ago) _Marshall Lee Whittaker_: No need for the responses.tar.gz file if we have the said/ folder.<br>
**3fd91dc8** (4 months ago) _marshall whittaker_: Merge branch 'frank_master' of github.com:oxagast/Franklin into frank_master<br>
**3df1185a** (4 months ago) _marshall whittaker_: Added more said/ responses.<br>
**bceadd4c** (4 months ago) _GitHub_: Merge pull request #13 from oxagast/base_GPT-3.5-turbo-instruct<br>
**4af5bc59 (origin/base_GPT-3.5-turbo-instruct)** (4 months ago) _GitHub_: Merge pull request #12 from oxagast/frank_master<br>
**8d853624** (4 months ago) _GitHub_: Update franklin.pl<br>
**685e4f74** (4 months ago) _Marshall Whittaker_: Better regex for alphanumspace<br>
**f54072d1** (4 months ago) _Marshall Whittaker_: Better santitize.<br>
**32404cac** (4 months ago) _Marshall Whittaker_: Version update for new output.<br>
**51eecc15** (4 months ago) _Marshall Whittaker_: Cleanup.<br>
**397da875** (4 months ago) _Marshall Whittaker_: Fix typo<br>
**bc46cdd8** (4 months ago) _Marshall Whittaker_: So we have var1 and var2 on same line.<br>
**11784634** (4 months ago) _Marshall Whittaker_: With Dumper.<br>
**880fec7a** (4 months ago) _Marshall Whittaker_: Try JSON with dumper.<br>
**217d6393** (4 months ago) _Marshall Whittaker_: JSON again.<br>
**6d52e030** (4 months ago) _Marshall Whittaker_: Just JSON this time.<br>
**98bb0c5e** (4 months ago) _Marshall Whittaker_: Fix JSON encode 2.<br>
**a66d79b7** (4 months ago) _Marshall Whittaker_: Fix JSON encode.<br>
**ffea1b46** (4 months ago) _Marshall Whittaker_: Pretty JSON?<br>
**b0c8e108** (4 months ago) _Marshall Whittaker_: Santiize the wegpages.<br>
**8bfae2bc** (4 months ago) _Marshall Whittaker_: Increased size of webpage read.<br>
**b569ee8b** (4 months ago) _Marshall Whittaker_: Oops fixed typo.<br>
**3a1fed80** (4 months ago) _Marshall Whittaker_: Merge remote-tracking branch 'refs/remotes/origin/frank_master' into frank_master<br>
**91a5f00c** (4 months ago) _Marshall Whittaker_: Changes to output in /win1<br>
**55e68e24** (4 months ago) _GitHub_: Fix on knowing which model it is.<br>
**528f4b60** (4 months ago) _GitHub_: Merge pull request #11 from oxagast/base_GPT-3.5-turbo-instruct<br>
**7065e793** (4 months ago) _Marshall Whittaker_: Comments.<br>
**18085112** (4 months ago) _marshall whittaker_: Reverted ad commit message.<br>
**c8ea0f91** (4 months ago) _marshall whittaker_: Merge<br>
**f4a99295** (4 months ago) _marshall whittaker_: Edit to context.<br>
**e8967e6f** (4 months ago) _GitHub_: Updated version string.<br>
**724c08d5** (4 months ago) _GitHub_: Cleaned up whitespace.<br>
**65dbe6e6** (4 months ago) _GitHub_: Updated change date and version number.<br>
**74c4b568** (4 months ago) _marshall whittaker_: Took out txid awreness becaust it's too chatty about it.<br>
**32c5e5d8** (4 months ago) _GitHub_: Correction on print.<br>
**7faca4d9** (4 months ago) _GitHub_: Seeing if the array stack works.<br>
**dcdfb1da** (4 months ago) _GitHub_: Update franklin.pl<br>
**e725183d** (4 months ago) _marshall whittaker_: Fied the bugwhere frank sometimes not respond.  Also fixed data leak etween chnnels.<br>
**2d24e1f7** (4 months ago) _marshall whittaker_: Perltidy<br>
**ecf4228b** (4 months ago) _marshall whittaker_: Retries should work now, and can be set with the franklin_max_retry variable.<br>
**066766b7** (4 months ago) _marshall whittaker_: Now knows what model it is running in context.<br>
**bf74aedb** (4 months ago) _GitHub_: Merge pull request #10 from oxagast/frank_master<br>
**93511442** (4 months ago) _GitHub_: Updated with new options.<br>
**a761f270** (4 months ago) _GitHub_: New API<br>
**56050702** (4 months ago) _marshall whittaker_: Version updated.<br>
**d8731c36** (4 months ago) _marshall whittaker_: In the event of deprecation, bringing up to GPT-3.5-Turbo-Instruct model.<br>
**0057c199 (origin/openai-base_text-davinci-003, origin/base_text-davinci-003)** (4 months ago) _marshall whittaker_: Token output now looks right.<br>
**65bcce92** (4 months ago) _marshall whittaker_: Fixed token pulling from json<br>
**6b91f4ec** (5 months ago) _GitHub_: Align Logo<br>
**c809335f** (5 months ago) _marshall whittaker_: Run perltidy.<br>
**0f2c15ae** (5 months ago) _marshall whittaker_: Now txid enabled channels display corretly in the var summary.<br>
**e013f5b2** (5 months ago) _marshall whittaker_: Added some internal config warnings.<br>
**a42e437d** (5 months ago) _marshall whittaker_: Condensing of some code around the URL resolver, made the vars menu a little more user friendly.<br>
**cbd44836** (5 months ago) _marshall whittaker_: Added said/ from var-www<br>
**f6074209** (5 months ago) _marshall whittaker_: Update helper script.<br>
**639d902a** (5 months ago) _GitHub_: Some comments and chaned email address.<br>
**8599ee26** (5 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**f2100665** (5 months ago) _marshall whittaker_: Added some more comment code docs, and added a total request count.<br>
**6cc4c06b** (5 months ago) _GitHub_: Updated readme with logo<br>
**3048b6fe** (5 months ago) _marshall whittaker_: Version change<br>
**aa653e0c** (5 months ago) _marshall whittaker_: Now doesn't' respond i you give it a franklin_helper command<br>
**85bab451** (5 months ago) _marshall whittaker_: Added some CPAN instructions.<br>
**a6a3c2f8** (5 months ago) _marshall whittaker_: Removed extra g-tag output.<br>
**e5061ce7** (5 months ago) _marshall whittaker_: woo<br>
**09ece388** (5 months ago) _marshall whittaker_: Removed the start of a reposne 'response: '.<br>
**1ce94fb3** (5 months ago) _marshall whittaker_: Rearranged some things that make the rolling chat history and permissions work.<br>
**d858ab59** (5 months ago) _marshall whittaker_: Took some stuff out of the contextual prelude<br>
**ea8f4b48** (5 months ago) _marshall whittaker_: HDD and MEM values were switched, fixed.<br>
**9017ce01** (5 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**33227a93** (5 months ago) _Marshall Whittaker_: Minor changes.<br>
**f6a1965a** (5 months ago) _Marshall Lee Whittaker_: Added a archive of previous Franklin responses.<br>
**6c285343** (5 months ago) _Marshall Lee Whittaker_: Code cleanup, via perltidy.<br>
**5260b2bf** (5 months ago) _marshall whittaker_: Cleaning up some.<br>
**e529bb7e** (5 months ago) _marshall whittaker_: Now responds to PMs properly.<br>
**70dbea5e** (5 months ago) _marshall whittaker_: Trying to iron bug out.<br>
**2da3d7e7** (5 months ago) _marshall whittaker_: Franklin should now respodn to PMs.<br>
**57eb9b8a** (5 months ago) _Marshall Lee Whittaker_: back<br>
**fa9f710b** (5 months ago) _Marshall Lee Whittaker_: 'pull code' changed to one verb, pullcode<br>
**a0b22a73** (5 months ago) _Marshall Lee Whittaker_: Negating grep if the user has entered a command verb<br>
**c8290a69** (5 months ago) _marshall whittaker_: Part too.<br>
**eeb5a7f0** (5 months ago) _marshall whittaker_: Modified franklin_helper to accept a few more usefull commands via irc admins.<br>
**8da0b433** (5 months ago) _marshall whittaker_: Version num<br>
**9800c030** (5 months ago) _marshall whittaker_: Added a git repo puller to franklin_helper.<br>
**9734190b** (6 months ago) _GitHub_: Update franklin.pl<br>
**3e4e16e9** (6 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**fe183898** (6 months ago) _marshall whittaker_: Shortened the contextual prelude some.<br>
**63c94247** (6 months ago) _marshall whittaker_: Added some more information about the server Franklin is on.<br>
**9897268e** (6 months ago) _marshall whittaker_: Oof don't overwtei me<br>
**f805881b** (6 months ago) _Marshall Lee Whittaker_: Renamed helper.pl to franklin_helper.pl.<br>
**abadb17d** (6 months ago) _GitHub_: Took out trigger and am now using franklin_helper<br>
**4bcabcdd** (6 months ago) _GitHub_: Some updates to reflect new features.<br>
**20314c81** (6 months ago) _marshall whittaker_: You can now add channels via /set franklin_txid_chans seperated by spaces to add a txid to the message.<br>
**d0f40309** (6 months ago) _Marshall Lee Whittaker_: Trying out a new feature that allows you to hide txids from certain channels.<br>
**9e8b9c86** (7 months ago) _marshall whittaker_: perltidy<br>
**4938353f** (7 months ago) _GitHub_: Update helper.pl<br>
**f1e0b242** (7 months ago) _GitHub_: Update helper.pl<br>
**071ffcc6** (7 months ago) _GitHub_: Update helper.pl<br>
**ff4be728** (7 months ago) _GitHub_: Removed trigger.pl as it is now unnecessary.<br>
**f70e61c6** (7 months ago) _GitHub_: Version<br>
**196b565a** (7 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**64659704** (7 months ago) _marshall whittaker_: Franklin reloading helper script up<br>
**ed6fa416** (7 months ago) _Marshall Lee Whittaker_: Helper sript<br>
**99bef826** (7 months ago) _Marshall Lee Whittaker_: oops<br>
**b62dc1f4** (7 months ago) _Marshall Lee Whittaker_: Didn't open.<br>
**70af927c** (7 months ago) _Marshall Lee Whittaker_: Didn't close those parenthesis. Oops.<br>
**e33555c1** (7 months ago) _Marshall Lee Whittaker_: oops<br>
**3aa7aa6f** (7 months ago) _Marshall Lee Whittaker_: Shoot at ducks but not every time.<br>
**1e495f36** (7 months ago) _Marshall Lee Whittaker_: Revert<br>
**cc7e0804** (7 months ago) _Marshall Lee Whittaker_: Sorry, forgot money tag.<br>
**d07ab2e9** (7 months ago) _Marshall Lee Whittaker_: Frank loader?<br>
**f50ac4a9** (7 months ago) _Marshall Lee Whittaker_: Trying to implemnt a thread for signal.<br>
**6710b9aa** (7 months ago) _Marshall Lee Whittaker_: Added some returns for code correctness.<br>
**379a3136** (7 months ago) _Marshall Whittaker_: aaa<br>
**87741e62** (7 months ago) _Marshall Whittaker_: back<br>
**6e5dae0e** (7 months ago) _Marshall Whittaker_: Try this.<br>
**7a7c02ea** (7 months ago) _Marshall Whittaker_: Maybe it was in the wrong spot.<br>
**3a2657f1** (7 months ago) _Marshall Whittaker_: try this<br>
**fc7e64f5** (7 months ago) _Marshall Whittaker_: lets try passing a ref<br>
**4505ae06** (7 months ago) _Marshall Whittaker_: revert with code commented<br>
**ccf27033** (7 months ago) _Marshall Whittaker_: hmmm<br>
**113f2980** (7 months ago) _Marshall Whittaker_: Trying thread forking.<br>
**da61165e** (7 months ago) _Marshall Whittaker_: Fixed error message in chatterbox to reflect 0 to 1000 change.<br>
**0ee3430c** (7 months ago) _Marshall Whittaker_: Added trigger.pl because we use it for 'Franklin: reload'.<br>
**fdd0f03e** (7 months ago) _marshall whittaker_: Doubled a line somehow.<br>
**66491cfc** (8 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**b156f05a** (8 months ago) _marshall whittaker_: cleaned some things up<br>
**e0efb5a3** (8 months ago) _GitHub_: Update README.md<br>
**a2bd82d0** (8 months ago) _Marshall Lee Whittaker_: Reapplied html fg_top and bottom right<br>
**8eb9b4c8** (8 months ago) _Marshall Lee Whittaker_: Reapplied html fg_top<br>
**445da911** (8 months ago) _Marshall Lee Whittaker_: No more need for debugging the asshole finder.<br>
**adcb10a0** (8 months ago) _Marshall Lee Whittaker_: oops<br>
**416c1c9d** (8 months ago) _Marshall Lee Whittaker_: oops<br>
**5f2ddc2a** (8 months ago) _Marshall Lee Whittaker_: Fixed mispelling of moderate.<br>
**e934dee1** (8 months ago) _Marshall Lee Whittaker_: Removed unused var.<br>
**238f1093** (8 months ago) _Marshall Lee Whittaker_: For brevity collapsed page_body.<br>
**8fead901** (8 months ago) _Marshall Lee Whittaker_: Shortening some things.<br>
**cba76be8** (8 months ago) _Marshall Lee Whittaker_: For brevity we put it on one line.<br>
**3ee8d524** (8 months ago) _Marshall Lee Whittaker_: Concat.<br>
**87687e97** (8 months ago) _Marshall Lee Whittaker_: close bracket lost<br>
**f3bdde29** (8 months ago) _Marshall Lee Whittaker_: oof<br>
**79374f54** (8 months ago) _Marshall Lee Whittaker_: remove repaste<br>
**7fae02af** (8 months ago) _Marshall Lee Whittaker_: fix<br>
**10c9b6af** (8 months ago) _Marshall Lee Whittaker_: fix<br>
**3c23d562** (8 months ago) _Marshall Lee Whittaker_: oof<br>
**0dbdd9da** (8 months ago) _Marshall Lee Whittaker_: Collapse beginning spaces.<br>
**9a8a6702** (8 months ago) _Marshall Lee Whittaker_: Concat.<br>
**af8d6992** (8 months ago) _Marshall Lee Whittaker_: Fixed long string.<br>
**982bd8ee** (8 months ago) _Marshall Lee Whittaker_: Fixed some formatting things.<br>
**013acfad** (8 months ago) _marshall whittaker_: Added a user definable asshole setting.<br>
**a5f4c66c** (8 months ago) _marshall whittaker_: Tuning asshole kicker modules.<br>
**82ef7a70** (8 months ago) _marshall whittaker_: Finishing up the asshole aggregation.<br>
**d1de953f** (8 months ago) _marshall whittaker_: Got the kicker working on bad words.<br>
**621edfb3** (8 months ago) _marshall whittaker_: Got the asshole rating system kinda working. maybe.<br>
**d33af2a5** (8 months ago) _marshall whittaker_: Started adding asshole detection, and updated readme for 1:1000.<br>
**4df5cf55** (8 months ago) _marshall whittaker_: Fixed typo in the ua call.<br>
**957a528b** (8 months ago) _GitHub_: Update franklin.pl<br>
**21a12fab** (8 months ago) _GitHub_: Update franklin.pl<br>
**cdc2151b** (9 months ago) _marshall whittaker_: Franklin now knows what time it is!<br>
**6cc2a39f** (8 months ago) _marshall whittaker_: Trigger suggestion in readme.<br>
**8dc6d019** (8 months ago) _marshall whittaker_: Now knows what the current date is.<br>
**f74374cc** (8 months ago) _marshall whittaker_: Fixed if the context is too long it doesn't answer or answers garbled.<br>
**05a3ed10** (8 months ago) _marshall whittaker_: Fixed it so that input is stripped of color codes so that Franklin doens't hang on them being in the context log.<br>
**3ee3b132** (9 months ago) _marshall whittaker_: Better place to sanitize the html.<br>
**84804974** (9 months ago) _marshall whittaker_: Fixed an XSS bug.<br>
**a235b79f** (9 months ago) _marshall whittaker_: lets see if eniac can read the api key now.<br>
**8647e2d5** (9 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**8ca5e055** (9 months ago) _marshall whittaker_: Added a setting to control the google analytics G- tag without changing the source.<br>
**7f15642f** (9 months ago) _GitHub_: Removed some old comments that didn't mean anything anymore<br>
**8162435d** (9 months ago) _marshall whittaker_: Fixed not having a franklin_http_location in settings and thus having it always set to undef and files saving to wront location.<br>
**602b4e31** (9 months ago) _GitHub_: Comments for context<br>
**69756e49** (9 months ago) _GitHub_: Update contextual prelude<br>
**5b149dfb** (9 months ago) _marshall whittaker_: Added info str for user defined info about networks.<br>
**9417dfba** (10 months ago) _marshall whittaker_: Some error correction checks for file existance and varaible defines.<br>
**a002c354** (10 months ago) _marshall whittaker_: Formatting corrections.<br>
**d55a6477** (10 months ago) _marshall whittaker_: Fixes the runaway process bug where heartbeat urls don't resolve and hang, then end with a zilion zombie processes after 5 days.<br>
**0d212a11** (10 months ago) _Marshall Lee Whittaker_: Updated version to reflect new feature.<br>
**0983a5e2** (10 months ago) _marshall whittaker_: Franklin now knows if it is an operator/moderator in a channel.<br>
**140b5173** (10 months ago) _marshall whittaker_: Fixed the " character bug better.<br>
**c31da0f3** (10 months ago) _marshall whittaker_: Fixed the not being able to deal with a double quote.<br>
**7afcec50** (10 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**3278a496** (10 months ago) _marshall whittaker_: Now shows the settings when the settings on load.<br>
**8afcbfb6** (10 months ago) _GitHub_: No need for this, its embedded.<br>
**b602f57b** (10 months ago) _GitHub_: Update README.md<br>
**c37c55ee** (10 months ago) _GitHub_: Update README.md<br>
**f8dbb29b** (10 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**6d5e2c6e** (10 months ago) _marshall whittaker_: No need for the old dir, as there is a seperate branch for that.<br>
**c5bae29c** (10 months ago) _GitHub_: Delete irc_chats.png<br>
**bb1e9ae6** (10 months ago) _GitHub_: Update users who have helped<br>
**721f9510** (10 months ago) _GitHub_: Update franklin.pl<br>
**d79600b0** (10 months ago) _GitHub_: Merge pull request #4 from denzuko/patch-1<br>
**e08e7d3d** (10 months ago) _GitHub_: Update README.md<br>
**82d4204c** (10 months ago) _GitHub_: Update README.md<br>
**58c04ff9** (10 months ago) _GitHub_: Update README.md<br>
**9b35f2ff** (10 months ago) _GitHub_: Major updates to readme file formatting and info<br>
**8623cf13** (10 months ago) _GitHub_: Update README.md<br>
**8f12df46** (10 months ago) _GitHub_: Update README.md to reflect some additions to franklin.<br>
**080ec6bc** (10 months ago) _marshall whittaker_: Version number change on page reader.:<br>
**3a1c9a1e** (10 months ago) _marshall whittaker_: This lets franklin read and interpret link text.<br>
**6b72f487** (10 months ago) _marshall whittaker_: Fixed wide character in print bug.<br>
**84b3b3a2** (10 months ago) _marshall whittaker_: ahh<br>
**2695a48a** (10 months ago) _marshall whittaker_: Added two new enteries into the load screen for their set values.<br>
**9e1ad263** (10 months ago) _marshall whittaker_: Rearranged some things for efficiency.<br>
**d4e8902c** (10 months ago) _marshall whittaker_: Fixed a default.<br>
**02d8cd2c** (10 months ago) _marshall whittaker_: Fixing chatterbox mode.<br>
**fc8f0e86** (10 months ago) _marshall whittaker_: Added some more text corrections, and some less vague error messages for users.<br>
**b956aaca** (10 months ago) _marshall whittaker_: Removed the old html parts.<br>
**06dee39d** (10 months ago) _marshall whittaker_: Modfied so that it no longer reads the HTML from files, this causes some errors sometimes.<br>
**d57bc6a3** (10 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**cfc5ddee** (10 months ago) _marshall whittaker_: Got the lockup bug ironed out.<br>
**69b88199** (10 months ago) _GitHub_: Update franklin.pl<br>
**9b12aa40** (10 months ago) _GitHub_: Update README.md<br>
**b0cba030** (10 months ago) _GitHub_: Thanks to the people this project has benefited from<br>
**f56913ff** (10 months ago) _marshall whittaker_: Took out the entier frank_thinks subroutine becuase it needs to be redesigned from the ground up.<br>
**b8a9224a** (10 months ago) _marshall whittaker_: Changed the loop to a goto statement, we're gonna see if tightening that up helps.<br>
**69c2d73a** (10 months ago) _marshall whittaker_: Fixed the error always popping up about chatterbox mode.<br>
**873dfc10** (10 months ago) _GitHub_: Update franklin.pl<br>
**19822f4e** (10 months ago) _marshall whittaker_: Trying to get rid of the hang that stops it, also forks off the say's now.<br>
**3348a1a6** (10 months ago) _marshall whittaker_: Now shows approx cost of generating a message.<br>
**51268952** (10 months ago) _marshall whittaker_: Learning mode is getting better.<br>
**6b4e1250** (10 months ago) _marshall whittaker_: Since the website is in a branch of its own now, its gone from here.<br>
**7fe0f27e** (10 months ago) _marshall whittaker_: Trying to get chatterbox mode working.<br>
**bceac410** (10 months ago) _marshall whittaker_: Updated the website mainpage.<br>
**7d7f1fe9** (10 months ago) _marshall whittaker_: Fixed this branch.<br>
**b8bacf1d** (10 months ago) _marshall whittaker_: So it knows what it is and it's role.<br>
**8f669ac8** (10 months ago) _marshall whittaker_: Franklin now every so often says something itself.<br>
**0159dd74** (10 months ago) _GitHub_: Update franklin.pl<br>
**8dc1b7d6** (10 months ago) _marshall whittaker_: Broke up the long context setup.<br>
**4eafb7c8** (10 months ago) _GitHub_: Update franklin.pl<br>
**0ebf522d** (10 months ago) _GitHub_: Update franklin.pl<br>
**e16c4850** (10 months ago) _marshall whittaker_: Context.<br>
**7954a5d3** (10 months ago) _marshall whittaker_: Now has context of what is curently being duscussed in chat.<br>
**ce534939** (10 months ago) _marshall whittaker_: Updated how franklin interacts.  Trying to keep tack of the convo.<br>
**a236c050** (10 months ago) _marshall whittaker_: Readded franklin after merge fail.<br>
**d1c532ed** (10 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**3ec159ae** (10 months ago) _marshall whittaker_: Told franklin a little about itself and its creator, and what it is.  Also the website now has a stats counter.<br>
**23155d54** (11 months ago) _GitHub_: Update franklin.pl<br>
**01002f3a** (11 months ago) _GitHub_: Don't know why my zsh config is here...<br>
**71ecdd1e** (11 months ago) _marshall whittaker_: Took geert off ignore in the repo.<br>
**13b82fd8** (11 months ago) _marshall whittaker_: Moved old franklin to old/<br>
**fe3f7b2b** (11 months ago) _marshall whittaker_: Remove stat  file.<br>
**ea7c833a** (11 months ago) _marshall whittaker_: Upgraded to GPT 3.5 Turbo and made some tweaks. Also updateed webpage to reflect this.<br>
**5113a8c3** (11 months ago) _GitHub_: Delete .speed.dat<br>
**582160af** (11 months ago) _marshall whittaker_: Upgraded to the GPT 3.5 Turbo model.<br>
**40501fd0** (11 months ago) _marshall whittaker_: Perltidy.<br>
**b435c616** (11 months ago) _marshall whittaker_: Removed the stray 'i' that makes it error out.<br>
**df9f546a** (11 months ago) _marshall whittaker_: Changed html part names to something more obvious. Gives a loading message now.  Added colorization to the files section.<br>
**a07c894b** (11 months ago) _marshall whittaker_: Edited the date and some little things on website.<br>
**7f1e28ef** (11 months ago) _marshall whittaker_: Now shows date stamp.<br>
**9278e5a7** (11 months ago) _marshall whittaker_: Adjusted the sanitzation to the proper spot in code.<br>
**9fd3f01e** (11 months ago) _marshall whittaker_: klMerge branch 'main' of github.com:oxagast/Franklin<br>
**26326d39** (11 months ago) _marshall whittaker_: Fixed double quote -> single quote bug, and added html pages as pretty output for IRC, but kept the .txt output too.<br>
**01498105** (11 months ago) _GitHub_: Updated screenshot<br>
**ec277be4** (11 months ago) _GitHub_: Add files via upload<br>
**ffe13039** (11 months ago) _GitHub_: Update README.md<br>
**f3d6ad49** (11 months ago) _marshall whittaker_: Now works when you address franklin with either : or ,.<br>
**85f79801** (11 months ago) _GitHub_: Added .txt file extension to files in said/<br>
**ee0bee05** (12 months ago) _marshall whittaker_: Changed website to reflect some changes and gpt4.<br>
**24bf9f8b** (12 months ago) _GitHub_: Edited README resource.<br>
**28fffd98** (12 months ago) _GitHub_: Edited the README resource.<br>
**e24edbc4** (12 months ago) _GitHub_: Ascii frank!<br>
**83348f61** (12 months ago) _GitHub_: Fixed indentation on a line.<br>
**451b343c** (12 months ago) _marshall whittaker_: Fixed a bug that was introduced in last commit, and allows for comments in the badnicks file now.<br>
**b0c9c7b8** (12 months ago) _oxagast_: Made some things clearer with comments.<br>
**43d34e46** (12 months ago) _GitHub_: Update franklin.pl<br>
**e202608c** (12 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin fixed<br>
**f465dc3e** (12 months ago) _marshall whittaker_: Fixed ver.<br>
**b39d7746** (12 months ago) _marshall whittaker_: Fixed getting current nick code.<br>
**d022bb05** (12 months ago) _GitHub_: Update franklin.pl<br>
**69a542f7** (12 months ago) _oxagast_: k Corrected version number.<br>
**203c60ca** (12 months ago) _marshall whittaker_: Made some improvements such as knowing what it's own name is, and more settings, and a short settings help.<br>
**17f1ac2c** (12 months ago) _marshall whittaker_: Fixes last commit, which should only apply to the beginning of a line.<br>
**04a92f34** (12 months ago) _marshall whittaker_: Parsed out beginning of line question mark follwed by two spaces in ambiguous search.<br>
**f1a86769** (1 year, 1 month ago) _GitHub_: # shouts<br>
**5391245f** (1 year, 1 month ago) _GitHub_: New readme in txt format<br>
**360f94ce** (1 year, 1 month ago) _GitHub_: Creative Commons Attribution-NonCommercial 4.0 International Public Llicense<br>
**0b723a62** (1 year, 1 month ago) _GitHub_: Update franklin.pl<br>
**2739d5a4** (1 year, 1 month ago) _marshall whittaker_: Edited the readme to reflect changes.<br>
**d08aa3f7** (1 year, 1 month ago) _marshall whittaker_: Ver<br>
**03a92fdd** (1 year, 1 month ago) _marshall whittaker_: Edited the way it deal with single and double quotes.<br>
**a81c5fcd** (1 year, 1 month ago) _marshall whittaker_: Edit on comment<br>
**7acc4fb9** (1 year, 1 month ago) _marshall whittaker_: woo woo 2.0<br>
**2437b3d3** (1 year, 1 month ago) _marshall whittaker_: Added an irssi var setting for the api key.<br>
**7db6dbcb** (1 year, 1 month ago) _marshall whittaker_: Added an alive worker heartbeat setting.<br>
**63cb8e5e** (1 year, 1 month ago) _oxagast_: Added a pic of the source.<br>
**12cfa695** (1 year, 1 month ago) _oxagast_: Added a mascot. Frankie.<br>
**dede48c5** (1 year, 1 month ago) _marshall whittaker_: Added some variables you can change from within irssi.<br>
**05e90e96** (1 year, 1 month ago) _marshall whittaker_: Fixes and spelling errors.<br>
**8590a3bf** (1 year, 1 month ago) _marshall whittaker_: Pertidy'd.<br>
**f203e9d2** (1 year, 1 month ago) _marshall whittaker_: Cha<br>
**e8df4a05** (1 year, 1 month ago) _marshall whittaker_: Fixed a typo in the site.<br>
**e6266fbd** (1 year, 1 month ago) _marshall whittaker_: Corrected somethings in the README for v2, and fixed the blacklisting code.  Tired to make the spacing more accurate.<br>
**03ed8b08** (1 year, 1 month ago) _marshall whittaker_: Only pulls the api key once now, and can retry on error.<br>
**f4f4eca5** (1 year, 1 month ago) _marshall whittaker_: Fixed a bug when converting partial md5 checksum when seeing wide characters.<br>
**29809e1b** (1 year, 1 month ago) _marshall whittaker_: Edited setup in readme.<br>
**6170c91a** (1 year, 1 month ago) _marshall whittaker_: OOps. No API keys, even though thats an old one.<br>
**89b5f81d** (1 year, 1 month ago) _marshall whittaker_: Edits and perltidy config.<br>
**2a3fcdd4** (1 year, 1 month ago) _GitHub_: spacing<br>
**eb2ff74d** (1 year, 1 month ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**645b7294** (1 year, 1 month ago) _marshall whittaker_: Rewrite of franklin and bugfixes.<br>
**440dade1** (1 year, 1 month ago) _marshall whittaker_: oof<br>
**8d3c77d5** (1 year, 1 month ago) _marshall whittaker_: Rewrite for a Franklin v2 in pure perl.<br>
**735b8e15** (1 year, 1 month ago) _Marshall Lee Whittaker_: GPTChat.<br>
**cecec392** (1 year, 2 months ago) _GitHub_: Added a funding file<br>
**14e83272** (1 year, 2 months ago) _marshall whittaker_: Spacing/newlines are right on the webserver.<br>
**c7a7d0ae** (1 year, 2 months ago) _marshall whittaker_: Updated website instructions.<br>
**8f99970a** (1 year, 2 months ago) _GitHub_: Update README.md<br>
**7b638265** (1 year, 2 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**0dbbfeec** (1 year, 2 months ago) _root_: New calling script for franklin that is more secure.<br>
**d4916327** (1 year, 2 months ago) _Marshall Lee Whittaker_: Merge remote-tracking branch 'refs/remotes/origin/main'<br>
**3f1b156d** (1 year, 2 months ago) _Marshall Lee Whittaker_: Made some changes to filtering.<br>
**03393bf7** (1 year, 2 months ago) _root_: Made image preview open into a larger img.<br>
**e51d2190** (1 year, 2 months ago) _GitHub_: Updated date for file<br>
**1f47bf78** (1 year, 2 months ago) _GitHub_: Delete .hugo_build.lock<br>
**e835ff41** (1 year, 2 months ago) _marshall whittaker_: Quotes.<br>
**6e6a6317** (1 year, 2 months ago) _marshall whittaker_: Reomved unnecessaray text tmp files.<br>
**f7dec319** (1 year, 2 months ago) _Marshall Lee Whittaker_: Fixed help.<br>
**1a28b0ae** (1 year, 2 months ago) _Marshall Lee Whittaker_: Fixed backtick in nicks RCE.<br>
**3837c6dd** (1 year, 2 months ago) _Marshall Lee Whittaker_: Santisiation of nicks.<br>
**7b851fde** (1 year, 2 months ago) _Marshall Lee Whittaker_: Fixed backticks in nicks maybe.<br>
**0896e628** (1 year, 2 months ago) _Marshall Lee Whittaker_: Added the website<br>
**d18b1e63** (1 year, 2 months ago) _Marshall Lee Whittaker_: Checking and setup.<br>
**d9214351** (1 year, 2 months ago) _marshall whittaker_: Fixed collisons on md5 by checksumming the text itself.<br>
**4c8e68e9** (1 year, 2 months ago) _GitHub_: Spelling<br>
**fee04d09** (1 year, 2 months ago) _GitHub_: updated thanks<br>
**d056148e** (1 year, 2 months ago) _GitHub_: Update README.md<br>
**a80410e6** (1 year, 2 months ago) _GitHub_: screenshot up<br>
**66508b61** (1 year, 2 months ago) _Marshall Lee Whittaker_: Screenie<br>
**91313c7a** (1 year, 2 months ago) _Marshall Lee Whittaker_: Screenie.<br>
**8bea61a3** (1 year, 2 months ago) _GitHub_: Delete irc_chats.png<br>
**328fcef9** (1 year, 2 months ago) _Marshall Lee Whittaker_: IRC screenshot.<br>
**d5790774** (1 year, 2 months ago) _Marshall Lee Whittaker_: removed swap file and added to gitignore<br>
**308b32f0** (1 year, 2 months ago) _Marshall Lee Whittaker_: hehe<br>
**28d69b24** (1 year, 2 months ago) _marshall whittaker_: Formatted the long api call to something more readable on multi lines.<br>
**f3fdc979** (1 year, 2 months ago) _marshall whittaker_: some commenting<br>
**372edc04** (1 year, 2 months ago) _marshall whittaker_: Fixed collisions.<br>
**5f322dbe** (1 year, 2 months ago) _Marshall Lee Whittaker_: formatting.<br>
**8190523b** (1 year, 2 months ago) _marshall whittaker_: Removed extreneous file.<br>
**ed941965** (1 year, 2 months ago) _marshall whittaker_: readme heading<br>
**6076b1fa** (1 year, 2 months ago) _marshall whittaker_: readme heading<br>
**247d7c2a** (1 year, 2 months ago) _marshall whittaker_: Edited some readme stuff.<br>
**88f3f7be** (1 year, 2 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**97b6d814** (1 year, 2 months ago) _marshall whittaker_: Added some setup info.<br>
**97928e3c** (1 year, 2 months ago) _GitHub_: Added the callers nick for ban list use<br>
**55f199a6** (1 year, 2 months ago) _marshall whittaker_: New api storing.<br>
**4c5e3148** (1 year, 2 months ago) _marshall whittaker_: Merge branch 'main' of github.com:oxagast/Franklin<br>
**a8bf2633** (1 year, 2 months ago) _marshall whittaker_: Removed some stuff that isn't needed.<br>
**3e921c6f** (1 year, 2 months ago) _GitHub_: Update block.list<br>
**adb033fc** (1 year, 2 months ago) _marshall whittaker_: oops Merge branch 'main' of github.com:oxagast/Franklin<br>
**ce5fd6ea** (1 year, 2 months ago) _marshall whittaker_: Some acl as well as a lengthy message output holder.<br>
**4338fa1d** (1 year, 2 months ago) _GitHub_: sanitize<br>
**60018e39** (1 year, 2 months ago) _Marshall Whittaker_: Added soft and hard limit vars.<br>
**332d1523** (1 year, 2 months ago) _Marshall Whittaker_: Fixed the jq line so it makes more sense.<br>
**a4d3cdcc** (1 year, 2 months ago) _GitHub_: A perl script from the irssi archives.<br>
**028a5bc5** (1 year, 2 months ago) _GitHub_: Create trigger_for_irssi.txt<br>
**ae43719f** (1 year, 2 months ago) _GitHub_: Initial creation of the file that pulls the things to say with api.<br>
**67c5ad74** (1 year, 2 months ago) _GitHub_: Initial commit<br>