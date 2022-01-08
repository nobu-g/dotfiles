## Preliminary
1. System Preferences -> Software Update -> Make sure the system is up to date
1. Install Xcode
2. Open Xcode and agree to the license
3. `sudo xcode-select --install`
4. Open Terminal.app and install dotfiles specifying a location
    ```shell
    DOTPATH=$HOME/Projects/github.com/nobu-g/dotfiles \
    FULL_INSTALL=1 \
    SUDO=1 \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"
    ```

## Google Chrome
1. Log in using your Google account
2. Log in to Chrome extensions

## System Preferences
### Apple ID
- Log in
### Software Update
- Automatically keep my Mac up to date: On
### Dock & Menu Bar
- Automatically hide and show the Dock: On
- Show recent applications in Dock: Off
- Battery -> Show Percentage: On
- Spotlight -> Show in Menu Bar: Off
### Keyboard
- tab:Keyboard -> Key Repeat: Fastest
- tab:Keyboard -> Delay Until Repeat: Shortest
- tab:Shortcuts -> Launchpad & Dock -> Turn Dock Hiding On/Off: Off
- tab:Shortcuts -> Mission Control -> Mission Control: Off
- tab:Shortcuts -> Mission Control -> Application windows: Off
- tab:Shortcuts -> Input Sources -> Select the previous input source: Off
- tab:Shortcuts -> Input Sources -> Select next source in input menu: Off
- tab:Shortcuts -> Spotlight -> Show Spotlight search: Opt-Cmd-Space
- tab:Shortcuts -> Spotlight -> Show Finder search window: Off
- tab:Shortcuts -> App Shortcuts -> Add Google Chrome.app
- tab:Shortcuts -> App Shortcuts -> Google Chrome.app -> Select Next Tab: Cmd-]
- tab:Shortcuts -> App Shortcuts -> Google Chrome.app -> Select Previous Tab: Cmd-[
- tab:Shortcuts -> App Shortcuts -> Google Chrome.app -> Forward: Cmd-→
- tab:Shortcuts -> App Shortcuts -> Google Chrome.app -> Back: Cmd-←
- tab:Shortcuts -> App Shortcuts -> Google Chrome.app -> Duplicate Tab: Cmd-K
- tab:Shortcuts -> App Shortcuts -> Google Chrome.app -> Enter Full Screen: Cmd-Ctrl-Shift-F
- tab:Shortcuts -> App Shortcuts -> Add Papers.app
- tab:Shortcuts -> App Shortcuts -> Papers.app -> Select Next Tab: Cmd-]
- tab:Shortcuts -> App Shortcuts -> Papers.app -> Select Previous Tab: Cmd-[
- tab:Shortcuts -> App Shortcuts -> Papers.app -> Papers Settings: Cmd-,
- tab:Shortcuts -> App Shortcuts -> Papers.app -> Close All: Cmd-Shift-W
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
- Preferences -> tab:Advanced -> Show all filename extensions: On
- Preferences -> tab:Advanced -> Show warning before changing an extension: Off
- Preferences -> tab:Advanced -> Show warning before removing from iCloud Drive: Off

## Docker Desktop
- Log in using your Docker Hub account
- Preferences -> General -> Start Docker Desktop when you log in: On
- Preferences -> General -> Use Docker Compose V2: On

## BetterTouchTool
1. Sync preferences manually
    ```shell
    ln -s ~/Dropbox/Settings/BetterTouchTool/BetterTouchTool ~/Library/Application\ Support/
    ```
2. Search "BetterTouchTool" in your mail box and find an activation link
3. Go to the link and activate the license
4. Settings -> Basic -> Launch BetterTouchTool on startup: On

## VSCode
1. Install the Setting Sync extension
2. Open the command palette and run "Setting Sync: Turn On..."
3. Log in using your GitHub account

## Slack
- Input your email address and receive an invitation link
- Open the invitation link
