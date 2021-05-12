#!/usr/bin/env bash

# Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "0x6D746873"
#sudo scutil --set HostName "0x6D746873"
#sudo scutil --set LocalHostName "0x6D746873"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

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

echo "Finder: show the /Volumes folder"
sudo chflags nohidden /Volumes

echo "Terminal: only use UTF-8"
defaults write com.apple.terminal StringEncodings -array 4

echo "Expand save dialog by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Printer: Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

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

echo "Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top left screen corner → Mission Control
#defaults write com.apple.dock wvous-tl-corner -int 2
#defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

echo "Kill affected applications"
for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
