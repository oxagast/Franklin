# new files get these permissions
umask 027

# theme
ZSH_THEME="essembeh"

# oh my zsh plugins
plugins=()

# some env vars
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/.bin/FileZilla3/bin/:/home/marshall/.cargo/bin:/snap/bin
export PNPM_HOME="/home/marshall/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"


# source oh my zsh!
source $ZSH/oh-my-zsh.sh


# title
function set-term-title-precmd() {
  emulate -L zsh
  print -rn -- $'\e]0;'${(V%):-'%~'}$'\a' >$TTY
}
function set-term-title-preexec() {
  emulate -L zsh
  print -rn -- $'\e]0;'${(V)1}$'\a' >$TTY
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec set-term-title-preexec
add-zsh-hook precmd set-term-title-precmd
set-term-title-precmd


alias reload="source ~/.zshrc"
alias lots="history | cut -f 7- -d " " | sort | uniq -c | sort | tail -20"
alias ac="grep -B 5 -A 5"
alias grep="grep --color=never"
alias ls="ls --color=never"
alias evolution="GIO_USE_NETWORK_MONITOR=base evolution"
alias extip="curl -s ifconfig.me" # external ip addr
alias exthost="host `curl -s ifconfig.me` | sed -e 's/.*pointer //' -e s'/\.$//'"  # external hostname
alias tb="nc termbin.com 9999"
alias hisgrp="history|grep"
alias upgradde='sudo apt update && sudo apt upgrade -y' 
alias screen="~/.screenrc_speed2.sh;screen"
alias shfmt="shfmt -i 2 -ci -fn"
alias aes256="openssl enc -e -aes256 -out"  # encrypt something
alias gdrive="rclone mount GDrive: /home/marshall/GDrive &"
alias burp="java -noverify -javaagent:'/home/marshall/Code/burp/Burp Suite Professional 2022.8.1 + Loader-Keygen/Application/burploader.jar' -jar '/home/marshall/Code/burp/Burp Suite Professional 2022.8.1 + Loader-Keygen/Application/burpsuite_pro_v2022.8.1.jar'"
alias wpscan="wpscan --api-token s18IRij3FjWpHrFVyrcSvpbo5Eu3LY8vi7MmOL7jAYA" # wpscan with my api key
alias speedtest='wget -O /dev/null https://ice.seedhost.eu/oxagast/test.rnd.100mb.dat'  # speed test
alias cb="xclip -selection clipboard" # clipboard
alias enc="cd ~/NunyoBeezWax"
alias androidide="/home/marshall/.bin/android-studio/bin/studio.sh"
alias hack="cd ~/NunyoBeezWax/Hacking"
alias hdd="cd /mnt/large_storage"
alias nas="cd /mnt/nas_storage"
alias site="cd ~/NunyoBeezWax/Site/oxasploits-site/oxasploits.com"
alias -s json=jshon -F
alias -s pdf=atril
alias -s {mkv,mov,avi,mp4,m4v}=vlc
alias -s {jpg,jpeg,png,webp,bmp,gif}=feh
alias -s {md,markdown,conf,config,txt,html,c,rb,pl,php,py}=vim

# functions (like alias++)
ft() { gh search repos --sort stars -L 10 --topic $1 | cat }  # search github repos
lo() { ls -t -1 $1 | head -n 5 }   # see where you last made changes
nws() { cat $1 | grep -v ^$ |grep -v "^[[:space:]]*#" |grep -v ^\; }  # remove coments and whitespace for pastes
cbos() { ssh $1 "$2" | xclip -selection $1 -in }  # clip board offsite

