#  Setup Manager - Change Log

## v1.0
(2024-07-01)

- updated to new Jamf Concepts Use Agreement
- updated German and Swedish localizations
- added name for macOS 15
- new `hideActionLabels` and `hideDebugLabel` keys
- 'Jamf ID' is now only visible in the extended 'About this Mac' View (reachable when holding the option key)
- messaging when Setup Manager is launched in user space or with missing configuration
- UI tweaks

## v1.0RC

(2024-03-11)

- various minor fixes to localization, documentation, and small UI tweaks
- better error handling and display for some edge cases
- added ReadMe and License to installer pkg

## v0.9.1

(2023-11-20)

- Norwegian and Swedish localizations, thanks to Sam Wennerlund
- refactored process launching code, this should help with some stalling issues
- shutdown button should not stall anymore
- Setup Manager now caches the defaults at launch. This makes it more resilient to its configuration profile "disappearing" because the computer is not scope. (We still recommend scoping the Setup Manager Configuration profile as well as adding it to the Prestage.) This also addresses the custom UI "flickering" while it runs. (#21)

## v0.9

(2023-10-26)

- Help button
  - new key `help` shows a help button (circled question mark) in the lower right corner. The "Continue" and/or "Shutdown" buttons will replace the "Help" when the appear
  - see [Configuration Profile documentation](ConfigurationProfile.md#help) for more detail
- "About this Mac" info window
  - now shows network connection status. With the option key, the info window shows the interface name and IP address
  - to keep the info window clean, some (more) items are now only shown when opening the info window while holding option keys (Jamf Pro and Setup Manager version)
- updated Installomator to v10.5
- added new defaults key `overrideSerialNumber` to display a preset serial number, this is useful for creating screenshots or recordings
- main window is not resizable (#26)
- user entry with options menu would be empty unless manually set (#23)
- item progress indicators are now more distinct (#25)
- added "Powered by Jamf" and icon in button bar
- Setup Manager rearranges windows properly when a screen is attached or removed
- app and pkg are now signed and notarized with Jamf Developer certificates
- many more bug fixes and improvements

## v0.8.2

(2023-09-19)

- local files are now shown correctly with `icon`
- download speed is shown in macOS Sonoma
- fixed a strange race condition that led to large installomator installations stalling with Jamf School
- 'Shutdown' button is now hidden by default, since it breaks some of the workflows. You can unhide it by setting the `finalAction` key to `shutdown` (this will hide the continue button) or setting the `showBothButtons` key to `true` which will show both buttons.


## v0.8

(2023-09-05)

- Italian and Spanish localizations (Thanks to Nicola Lecchi, Andre Vilja and Javier Tetuan)
- fixed crashing bug when `background` is set
- 'Save Button' in User Entry now enables properly
- UI layout improvements
- main `icon` now properly displays wide aspect images
- watchPath actions time faster in DEBUG mode
- unloads Jamf Pro background check-in during workflow
- About this Mac… 
  - downloand speed (measured with `networkQuality`) and esitmated download time
  - Jamf Pro version
- new preference keys (see [config profile documentation for details](ConfigurationProfile.md))
  - `accentColor`
  - `totalDownloadBytes`
  - `userEntry.showForUserIDs`

## v0.7.1

(2023-06-29)

- flag file is now created _before_ last recon, so Jamf can pick it up with an extension attribute
- fixed some UI bugs in action tiles
- added documentation for single touch workflow with Jamf Connect

## v0.7

(2023-06-27)

- added macOS Sonoma to list of known macOS releases
- added documentation for Jamf School
- added changelog and some more updates to documentation
- computer name can now be generated wihtout UI from a template
- added slight scale animation and edge fade to action list
- user entry fields can now be validated with a regular expression and localized message
- battery widget now display correctly on Macs without a battery

## v0.6

(2023-06-05)

- launchd plist is now removed when app launches and flag file is present. This will prevent further accidental restarts after the app has been re-installed
- improved logging when parsing an action fails
- added Pendo integration to track app launches
- hitting cmd-L multiple times would open multiple log windows
- log window now auto-scrolls to latest entry
- command-W no longer closes main window
- added French localization
- fixed some typos in Dutch localization
- Warning screen appears when battery drops below 20% and disappears when charger is connected
- you can show/hide battery status with cmd-B
- updated built-in Installomator to v10.4
- fixed some logic errors in the Jamf Pro workflow that were introduced when adding Jamf School support

## v0.5

(2023-05-09)

- should now support Jamf School, this required major changes throughout the code, please test everything, also on Jamf Pro
- added installomator as an option for actions (mostly for Jamf School, but this also works with Jamf Pro)
- changed packaging script so that Jamf School can parse the pkg
- while rebuilding everything found a few edge cases that weren't handled very well
- holding the option key when clicking "About this Mac…" will now show some extra info (want to add more data there going forward)
- added SwiftLint to the project

## v0.4

(2023-04-05)

- disk size is shown in "About this Mac…"
- display and Mac will not sleep during installations
- Setup Manager will ignore non-managed enrollmentActions when not in Debug mode
- Setup Manager shows when Debug mode is enabled
- command-Q no longer quits the app (you can use shift-control-command-E) instead

## v0.3

(2023-03-10)

- localization (English, German, Dutch)
- DEBUG mode now does something
- added flag requiresRoot to shell action
- Prerequisites now wait for Jamf keychain
- About this Mac info should work for Intel Macs
- Connected Shutdown button
- Setup Manager creates a flag file at /private/var/db/.JamfSetupEnrollmentDone when it finishes
- when this file exists when Setup Manager launches, the app will terminate immediately and do nothing.
- new defaults key finalCountdown which automatically continues (or shuts down) after a timer
- new defaults key finalAction which can set 'shut down' as the action when the timer runs out
- started out with localization
- background window and log window work over Setup Assistant
- show Jamf Computer ID in Info Window and re-worked Info View
- user input configurable in profile
- added department, building and room as options for input

## v0.2

- app should now work with macOS Monterey
- window not movable
- main window centered correctly
- menu bar hidden
- removed coverflow effect from main action list

known issues:

- log window and background image window don't open when run over login window
- user input not yet optional
- shutdown button does not work yet
