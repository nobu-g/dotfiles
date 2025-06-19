#!/usr/bin/env bash

set -uo pipefail

SUDO="${SUDO:-0}"

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

# The following commands are equivalent:
# defaults write "Apple Global Domain"
# defaults write NSGlobalDomain
# defaults write -g

echo "Always show scrollbars"
# Possible values: `WhenScrolling`, `Automatic`, and `Always`
defaults write -g AppleShowScrollBars -string "Always"

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write -g AppleKeyboardUIMode -int 3

echo "Expand save dialog by default"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Expand print panel by default"
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write -g AppleKeyboardUIMode -int 3

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write -g AppleFontSmoothing -int 2

echo "Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

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
defaults write com.apple.finder DisableAllAnimations -bool true
# defaults delete com.apple.finder DisableAllAnimations  # back to the original

echo "Finder: when performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Finder: disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Finder: show all filename extensions"
defaults write -g AppleShowAllExtensions -bool true

echo "Finder: show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool false

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
# Window Manager                                                              #
###############################################################################

# Use an alternative functionality provided by the BetterTouchTool app
echo "Window Manager: disable Desktop & Dock -> Tile by dragging windows to screen edges"
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false

echo "Window Manager: disable Desktop & Dock -> Hold ⌥ key while dragging windows to tile"
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false

echo "Window Manager: disable Desktop & Dock -> Tiled windows have margins"
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

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
defaults write com.apple.screencapture disable-shadow -bool true
killall SystemUIServer

###############################################################################
# Keyboard and Trackpad                                                       #
###############################################################################

echo "Trackpad: fastest tracking speed"
defaults write -g com.apple.trackpad.scaling -float 3

echo "Trackpad: lightest click"
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# キーのリピート・リピート認識時間
# System Preferencesのカーソルで合わせられる最速よりも、リピートは1.5倍、入力認識は2倍早くできる
echo "Set a blazingly fast keyboard repeat rate"
defaults write -g KeyRepeat -int 1 # system fastest: 2
echo "Set a shorter Delay until key repeat"
defaults write -g InitialKeyRepeat -int 10 # system fastest: 15

defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Duplicate Tab" -string "@k"
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "复制标签" -string "@k"
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "タブを複製" -string "@k"

defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Select Previous Tab" -string "@["
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "选择上一个标签" -string "@["
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "前のタブを選択" -string "@["

defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Select Next Tab" -string "@]"
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "选择下一个标签" -string "@]"
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "次のタブを選択" -string "@]"

# These commands are not working because macOS inserts extra backslashes (e.g., `@\\\\U2190``)
# defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Back" -string "@\U2190"
# defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "返回" -string "@\U2190"
# defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "戻る" -string "@\U2190"

# defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Forward" -string "@\U2192"
# defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "前进" -string "@\U2192"
# defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "進む" -string "@\U2192"

# shellcheck disable=SC2016
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Enter Full Screen" -string '@^$f'
# shellcheck disable=SC2016
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "进入全屏幕" -string '@^$f'
# shellcheck disable=SC2016
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "フルスクリーンにする" -string '@^$f'

# shellcheck disable=SC2016
defaults write com.ReadCube.Papers NSUserKeyEquivalents -dict-add "Close All" -string '@$w'
defaults write com.ReadCube.Papers NSUserKeyEquivalents -dict-add "Papers Settings" -string "@,"
defaults write com.ReadCube.Papers NSUserKeyEquivalents -dict-add "Select Next Tab" -string "@]"
defaults write com.ReadCube.Papers NSUserKeyEquivalents -dict-add "Select Previous Tab" -string "@["

# https://apple.stackexchange.com/questions/91679/is-there-a-way-to-set-an-application-shortcut-in-the-keyboard-preference-pane-vi
# Turn Dock Hiding On/Off: Off
# LaunchpadとDock -> Dockを自動的に表示/非表示のオン/オフ: Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 52 "<dict><key>enabled</key><false/></dict>"

# Mission Control -> Mission Control: Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>126</integer><integer>10747904</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>126</integer><integer>10747904</integer></array><key>type</key><string>standard</string></dict></dict>"

# Mission Control -> アプリケーションウインドウ: Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 "<dict><key>enabled</key><false/></dict>"

# Select the previous input source: Off
# 入力ソース -> 前の入力ソースを選択: Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"

# Select next source in input menu: Off
# 入力ソース -> 入力メニューの次のソースを選択: Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"

# Show Spotlight search field
# Spotlight検索を表示
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"

# Show Spotlight window: Off
# Finderの検索ウインドウを表示: Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/></dict>"

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
