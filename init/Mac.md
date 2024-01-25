# Setup procedures for Mac

## Preliminary

1. System Preferences -> Software Update -> Make sure the system is up to date
1. Install Xcode
1. Open Xcode and agree to the license
1. `sudo xcode-select --install`
1. Open Terminal.app and install dotfiles specifying a location

    ```shell
    DOTPATH=$HOME/Projects/github.com/nobu-g/dotfiles \
    FULL_INSTALL=1 \
    SUDO=1 \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"
    ```

## Google Chrome

1. Log in using your Google account
1. Log in to your Chrome extensions

## System Preferences

### Apple ID

- Log in

### Software Update

- Automatically keep my Mac up to date: On

### Dock & Menu Bar

- Automatically hide and show the Dock: On
- Battery -> Show Percentage: On
- Spotlight -> Show in Menu Bar: Off

### Keyboard

- tab:Keyboard -> Key Repeat: Fastest
- tab:Keyboard -> Delay Until Repeat: Shortest
- tab:Shortcuts -> Mission Control -> Mission Control: Off
- tab:Shortcuts -> Mission Control -> Application windows: Off
- tab:Shortcuts -> App Shortcuts -> Add Google Chrome.app
- tab:Shortcuts -> App Shortcuts -> Google Chrome.app -> Forward: Cmd-→
- tab:Shortcuts -> App Shortcuts -> Google Chrome.app -> Back: Cmd-←
- tab:Input Sources -> Add Google Japanese Input

### Trackpad

- tab:Point & Click -> Click: Lightest
- tab:Point & Click -> Tracking speed: Fastest

### Internet Accounts

- iCloud -> iCloud Drive -> tab:Documents -> Desktop & Documents Folder: On

### Mission Control

- Automatically rearrange Spaces based on most recent use: Off

### Displays

- Display Settings -> Resolution: Scaled -> More Space

## Finder

- Preferences -> tab:Advanced -> Show warning before removing from iCloud Drive: Off

## Docker Desktop

- Log in using your Docker Hub account
- Preferences -> General -> Start Docker Desktop when you log in: On
- Preferences -> General -> Use Docker Compose V2: On

## BetterTouchTool

1. Sync your preferences manually

    ```shell
    ln -s ~/Dropbox/Settings/BetterTouchTool/BetterTouchTool ~/Library/Application\ Support/
    ```

1. Search "BetterTouchTool" in your mail box and find an activation link
1. Go to the link and activate the license
1. Settings -> Basic -> Launch BetterTouchTool on startup: On

## VSCode

1. Install the Setting Sync extension
1. Open the command palette and run "Setting Sync: Turn On..."
1. Log in using your GitHub account

## Slack

- Input your email address and receive an invitation link
- Open the invitation link

## Disable Input Method Indicator

cf. <https://stackoverflow.com/questions/77248249/disable-macos-sonoma-text-insertion-point-cursor-caps-lock-indicator>

```shell
sudo mkdir -p /Library/Preferences/FeatureFlags/Domain
sudo /usr/libexec/PlistBuddy -c "Add 'redesigned_text_cursor:Enabled' bool false" /Library/Preferences/FeatureFlags/Domain/UIKit.plist
```
