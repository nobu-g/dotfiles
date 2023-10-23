#!/usr/bin/env bash

set -uo pipefail

# Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "0x6D746873"
#sudo scutil --set HostName "0x6D746873"
#sudo scutil --set LocalHostName "0x6D746873"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

if [[ ${SUDO} -eq 1 ]]; then
  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "
fi

###############################################################################
# Global Config                                                               #
###############################################################################

echo "Always show scrollbars"
# Possible values: `WhenScrolling`, `Automatic`, and `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Expand save dialog by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Speedup dialog display"
defaults write -g NSWindowResizeTime 0.001
# defaults delete -g NSWindowResizeTime  # back to the original

###############################################################################
# Dock                                                                        #
###############################################################################

echo "Dock: speed up showing and hiding"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 1.0
# back to original setting
#defaults delete com.apple.dock autohide-delay
#defaults delete com.apple.dock autohide-time-modifier

echo "Dock: automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "Dock: set the icon on the Dock to semi-transparent after hiding the app"
defaults write com.apple.dock showhidden -bool true

echo "Dock: speed up moving apps across desktops"
defaults write com.apple.dock workspaces-edge-delay -float 0.2
# defaults delete com.apple.finder AnimateInfoPanes  # back to the original

echo "Dock: don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "Dock: enable highlight hover effect for the grid view of a stack"
defaults write com.apple.dock mouse-over-hilite-stack -bool true

echo "Mission Control: speed up animation"
defaults write com.apple.dock expose-animation-duration -float 0.1

###############################################################################
# Finder                                                                      #
###############################################################################

echo "Finder: suppress creating .DS_Store in external storage"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "Finder: disble animations"
defaults write com.apple.finder DisableAllAnimations -boolean true
# defaults delete com.apple.finder DisableAllAnimations  # back to the original

echo "Finder: when performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Finder: disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

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

echo "Finder: Hide Quick Look when switching to other apps"
defaults write com.apple.finder QLHidePanelOnDeactivate -bool true
# defaults delete com.apple.finder QLHidePanelOnDeactivate  # back to the original

if [[ ${SUDO} -eq 1 ]]; then
  echo "Finder: show the /Volumes folder"
  sudo chflags nohidden /Volumes
fi

###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo "ActivityMonitor: show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "ActivityMonitor: visualize CPU usage in the Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo "ActivityMonitor: show all processes"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "ActivityMonitor: sort results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Other Apps                                                                  #
###############################################################################

echo "Terminal: only use UTF-8"
defaults write com.apple.terminal StringEncodings -array 4

echo "Printer: Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

defaults write com.hegenberg.BetterTouchTool BTTDisableSecureInputLookup YES
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
defaults write org.python.python ApplePersistenceIgnoreState NO

echo "iTerm2: don't display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

echo "Safari: enable debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo "Safari: Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo "Screencapture: save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "Screencapture: save screenshots in PNG format"
# Other options: BMP, GIF, JPG, PDF, TIFF
defaults write com.apple.screencapture type -string "png"

echo "Screencapture: remove shadows from screenshots"
defaults write com.apple.screencapture disable-shadow -boolean true
killall SystemUIServer

###############################################################################
# Keyboard and Trackpad                                                       #
###############################################################################

# キーのリピート・リピート認識時間
# System Preferencesのカーソルで合わせられる最速よりも、リピートは1.5倍、入力認識は2倍早くできる
# floatや0も可能だがOSによって壊れる
echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1
echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# echo "Trackpad: Enable tap to click"
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

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
# defaults write com.apple.dock wvous-tr-corner -int 4
# defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
# defaults write com.apple.dock wvous-bl-corner -int 5
# defaults write com.apple.dock wvous-bl-modifier -int 0

echo "Kill affected applications"
for app in Safari Finder Dock Mail SystemUIServer; do
  killall "$app" &> /dev/null
done
