tell application "Terminal"    activate    set currentTab to do script ("/bin/zsh -c \"$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)\"")end tell