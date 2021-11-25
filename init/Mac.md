## Preliminary
1. Preferences -> Software Update -> Make sure the system is up to date
1. Install Xcode
2. Open Xcode and Agree to the license
3. `sudo xcode-select --install`
4. `DOTPATH=$HOME/Projects/github.com/nobu-g/dotfiles FULL_INSTALL=1 SUDO=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/nobu-g/dotfiles/main/install.sh)"`

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
- Keyboard -> tab:Shortcuts -> Mission Control -> Application windows: Off
- tab:Shortcuts -> Input Sources -> Select the previous input source: Off
- tab:Shortcuts -> Input Sources -> Select next source in input menu: Off
- tab:Shortcuts -> Spotlight -> Show Spotlight search: Opt-Cmd-Space
- tab:Shortcuts -> Spotlight -> Show Finder search window: Off
- tab:Shortcuts -> App Shortcuts
### Trackpad
- tab:Point & Click -> Click: Lightest
- tab:Point & Click -> Tracking speed: Fastest
### Internet Accounts
- iCloud -> iCloud Drive -> tab:Documents -> Desktop & Documents Folder: On

## Docker Desktop
- Log in using your Docker Hub account
- Preferences -> General -> Start Docker Desktop when you log in: On
- Preferences -> General -> Use Docker Compose V2: On

## BetterTouchTool
1. Sync preferences manually
  ```shell
  cd ~/Library/Application\ Support
  ln -s $HOME/Dropbox/Settings/BetterTouchTool/BetterTouchTool .
  ```
2. Search "BetterTouchTool" in your mail box and find activation link
3. Go to the link and activate the license
4. Settings -> Basic -> Launchc BetterTouchTool on startup: On

## VSCode
1. Install Setting sync extension
2. Open the command palette and run "Setting Sync: Turn On..."
3. Log in using your GitHub account

## Slack
- Input your email address and receive an invitation link
- Open the invitation link
