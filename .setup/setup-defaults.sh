#!/usr/bin/env bash

ecoh "Dock: speed up showing and hiding"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 1.0
# back to original setting
#defaults delete com.apple.dock autohide-delay
#defaults delete com.apple.dock autohide-time-modifier

echo "Suppress creating .DS_Store in external storage"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

defaults write com.hegenberg.BetterTouchTool BTTDisableSecureInputLookup YES
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
defaults write org.python.python ApplePersistenceIgnoreState NO

echo "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Finder: show hidden files by default"
defaults write com.apple.Finder AppleShowAllFiles -bool false

echo "Finder: use current directory as default search scope"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Finder: show Path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "Finder: Show Status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "Finder: show the ~/Library folder"
chflags nohidden ~/Library

echo "Terminal: only use UTF-8"
defaults write com.apple.terminal StringEncodings -array 4

echo "Expand save dialog by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# キーのリピート・リピート認識時間
# System Preferencesのカーソルで合わせられる最速よりも、リピートは1.5倍、入力認識は2倍早くできる
# floatや0も可能だがOSによって壊れる
echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1
echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# echo "Trackpad: Enable tap to click"
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

echo "Safari: enable debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo "Kill affected applications"
for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
