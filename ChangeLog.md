#  Setup Manager - Change Log


## v1.0RC

(2024-03-11)

- various minor fixes to localization, documentation, and small UI tweaks (#128)
- better error handling and display for some edge cases (#52, #53, #120)
- added ReadMe and License to installer pkg (#126)

## v0.9.1

(2023-11-20)

- Norwegian and Swedish localizations, thanks to Sam Wennerlund (#111, #112)
- refactored process launching code, this should help with some stalling issues (#95)
- shutdown button should not stall anymore (#118)
- Setup Manager now caches the defaults at launch. This makes it more resilient to its configuration profile "disappearing" because the computer is not scope. (We still recommend scoping the Setup Manager Configuration profile as well as adding it to the Prestage.) This also addresses the custom UI "flickering" while it runs. (#99, setup-manager/setup-manager#21)


## v0.9

(2023-10-26)

- Help button
  - new key `help` shows a help button (circled question mark) in the lower right corner. The "Continue" and/or "Shutdown" buttons will replace the "Help" when the appear (#113)
  - see [Configuration Profile documentation](ConfigurationProfile.md#help) for more detail
- "About this Mac" info window
  - now shows network connection status. (#116) With the option key, the info window shows the interface name (#90) and IP address (#106)
  - to keep the info window clean, some (more) items are now only shown when opening the info window while holding option keys (#115) (Jamf Pro and Setup Manager version)
- updated Installomator to v10.5 (#107)
- added new defaults key `overrideSerialNumber` to display a preset serial number (#100), this is useful for creating screenshots or recordings
- main window is not resizable (#103, setup-manager/setup-manager#26)
- user entry with options menu would be empty unless manually set (#110, setup-manager/setup-manager#23)
- item progress indicators are now more distinct (#109, setup-manager/setup-manager#25)
- added "Powered by Jamf" and icon in button bar (#117)
- Setup Manager rearranges windows properly when a screen is attached or removed (#105)
- app and pkg are now signed and notarized with Jamf Developer certificates
- many more bug fixes and improvements (#98, #102)


## v0.8.2

(2023-09-19)

- local files are now shown correctly with `icon` (#93)
- download speed is shown in macOS Sonoma (#94)
- fixed a strange race condition that led to large installomator installations stalling with Jamf School (#80)
- 'Shutdown' button is now hidden by default, since it breaks some of the workflows (#25). You can unhide it by setting the `finalAction` key to `shutdown` (this will hide the continue button) or setting the `showBothButtons` key to `true` which will show both buttons.

## v0.8

(2023-09-05)

- Italian and Spanish localizations (Thanks to Nicola Lecchi, Andre Vilja and Javier Tetuan) (#71, #85)
- fixed crashing bug when `background` is set (#73)
- 'Save Button' in User Entry now enables properly (#76)
- UI layout improvements (#74, #75, #88)
- main `icon` now properly displays wide aspect images (#82)
- watchPath actions time faster in DEBUG mode (#70)
- unloads Jamf Pro background check-in during workflow (#81)
- About this Mac… 
  - downloand speed (measured with `networkQuality`) and esitmated download time (#84)
  - Jamf Pro version (#43)
- new preference keys (see [config profile documentation for details](ConfigurationProfile.md))
  - `accentColor` (#83)
  - `totalDownloadBytes` (#91)
  - `userEntry.showForUserIDs` (#87)

## v0.7.1

(2023-06-29)

- flag file is now created _before_ last recon, so Jamf can pick it up with an extension attribute
- fixed some UI bugs in action tiles
- added documentation for single touch workflow with Jamf Connect

## v0.7

(2023-06-27)

- added macOS Sonoma to list of known macOS releases
- added documentation for Jamf School
- added changelog and some more updates to documentation (#68, #67)
- computer name can now be generated wihtout UI from a template (#8, #69)
- added slight scale animation and edge fade to action list
- user entry fields can now be validated with a regular expression and localized message (#6, #7)
- battery widget now display correctly on Macs without a battery (#66)

## v0.6

(2023-06-05)

- launchd plist is now removed when app launches and flag file is present. This will prevent further accidental restarts after the app has been re-installed (#54)
- improved logging when parsing an action fails (#55)
- added Pendo integration to track app launches (#57, #58)
- hitting cmd-L multiple times would open multiple log windows (#61)
- log window now auto-scrolls to latest entry (#62)
- command-W no longer closes main window (#63)
- added French localization
- fixed some typos in Dutch localization
- Warning screen appears when battery drops below 20% (#37, #38) and disappears when charger is connected
- you can show/hide battery status with cmd-B
- updated built-in Installomator to v10.4
- fixed some logic errors in the Jamf Pro workflow that were introduced when adding Jamf School support

## v0.5

(2023-05-09)

- should now support Jamf School, this required major changes throughout the code, please test everything, also on Jamf Pro (#47, #48)
- added installomator as an option for actions (mostly for Jamf School, but this also works with Jamf Pro) (#49)
- changed packaging script so that Jamf School can parse the pkg (#46)
- while rebuilding everything found a few edge cases that weren't handled very well
- holding the option key when clicking "About this Mac…" will now show some extra info (want to add more data there going forward)
- added SwiftLint to the project

## v0.4

(2023-04-05)

- disk size is shown in "About this Mac…" (#30)
- display and Mac will not sleep during installations (#28)
- Setup Manager will ignore non-managed enrollmentActions when not in Debug mode (#32)
- Setup Manager shows when Debug mode is enabled (#39)
- command-Q no longer quits the app (you can use shift-control-command-E) instead (#29)

## v0.3

(2023-03-10)

- localization (English, German, Dutch)
- DEBUG mode now does something (#10)
- added flag requiresRoot to shell action (#42)
- Prerequisites now wait for Jamf keychain (#41)
- About this Mac info should work for Intel Macs (#41)
- Connected Shutdown button (#1)
- Setup Manager creates a flag file at /private/var/db/.JamfSetupEnrollmentDone when it finishes. (#2)
- when this file exists when Setup Manager launches, the app will terminate immediately and do nothing. (#3)
- new defaults key finalCountdown which automatically continues (or shuts down) after a timer (#27)
- new defaults key finalAction which can set 'shut down' as the action when the timer runs out
- started out with localization (#23)
- background window and log window work over Setup Assistant #22
- show Jamf Computer ID in Info Window #13 and re-worked Info View
- user input configurable in profile #4
- added department, building and room as options for input #5

## v0.2

- app should now work with macOS Monterey #9
- window not movable #18
- main window centered correctly #17
- menu bar hidden #20
- removed coverflow effect from main action list #14

known issues:

- log window and background image window don't open when run over login window #22
- user input not yet optional #4
- shutdown button does not work yet #1
