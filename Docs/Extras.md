# Extras and Notes

## Custom JSON Schema for Jamf Pro

- create a new profile
- go to ‘Application & Custom Settings’
- select ‘Jamf Applications’
- click the ‘+ Add’ button
- in the ‘Jamf Application Domain’ popup select ‘com.jamf.setupmanager’
- for the version select the version of Setup Manager you are using
- for the ‘Variant’, select ‘Setup Manager.json’
- fill in your fields!

The custom schema does not contain all keys and options available in the [configuration profile](../ConfigurationProfile.md). Specifically, the `wait` action and the option to [localize values](../ConfigurationProfile.md#localization) are not available.

When you reach the limits of the custom schema, use the XML it generates as a starting to building a custom XML.

Note that the custom schema can become confused when you switch between enrollment action types and you will need to clean up extra empty fields.

## Quit

The command-Q keyboard shortcut to quit the app is disabled. Use `shift-control-command-E` instead. This should only be used when debugging and troubleshooting, as it will leave the client in an undetermined state when installations are aborted.

## Logging

Setup Manager logs to `/Library/Logs/Setup Manager.log`. While Setup Manager is running you can open a log window with command-L.

## Debug mode

When you set the `DEBUG` key to `true` in the profile or locally with the `defaults` command Setup Manager will not perform any tasks that actually perform installations or otherwise change the system. When in DEBUG mode, Setup Manager will also read settings from the local settings (i.e. `~/Library/Preferences/com.jamf.setupmanager.plist`) which simplifies iterating through different settings. If you want to run Setup Manager on an unmanaged Mac, you may need to provide a `simulateMDM` key with a value of either `Jamf Pro` or `Jamf School`.

You may also need to remember to remove the [flag file](#flag-file) before launching Setup Manager.

You will also be able launch the app as the user, by double-clicking the app in `/Applications/Utilities`. This is useful to test the look and feel of your custom icons, text and localization. When you use this to create screenshots for documentation, also note the `overrideSerialNumber` and `hideDebugLabel` keys.

For testing, you can also re-launch Setup Manager from the command line as root with `sudo "/Applications/Utilities/Setup Manager.app/Contents/Resources/Setup Manager"`

## Flag file

Setup Manager creates a flag file at `/private/var/db/.JamfSetupEnrollmentDone` when it finishes.

If this file exists when Setup Manager launches, the app will terminate immediately without taking any action. You can use this flag file in an extension attribute in Jamf to determine whether the enrollment steps were performed. (Setup Manager does not care if the actions were performed successfully.)

When `DEBUG` is set to `true` in the defaults/configuration profile, the flag file is ignored at launch, but may still be created when done. 

In Jamf Pro, you can create an Extension Attribute named "Setup Manager Done" with the script code:

```sh
if [ -f "/private/var/db/.JamfSetupEnrollmentDone" ]; then
  echo "<result>done</result>"
else
  echo "<result>incomplete</result>"
fi
```

And then create a Smart Group named "Setup Manager Done" with the criteria `"Setup Manager Done" is "done"`. This can be very useful for scoping and limitations.

## User Data file

The data from user entry is written to a file when Setup Manager reaches a `waitForUserEntry` step and again when it finishes. The file is stored at `/private/var/db/SetupManagerUserData.txt`. When `DEBUG` is enabled, the file will be written to `/Users/Shared/`.

The file is plain text with the following format:

```
start: 2024-08-14T13:52:56Z
userID: a.b@example.com
department: Sales
building: Example
room: ABC123
assetTag: XYZ888
computerName: MacBook-M7WGMK
submit: 2024-08-14T13:54:37Z
duration: 101
```

Start time (`start`) and finish/submission time (`submit`) are given in ISO8601 format, universal time (UTC). Duration is given in seconds.

Fields that were not set in user entry will not be shown at all. You can use this file in scripts or extension attributes. One possible way is to parse it with `awk`, e.g.

```xml
duration=$(awk -F ': ' '/duration: / {print $2}' /private/var/db/SetupManagerUserData.txt)
```

## "About This Mac…" window

When you hold the option key when clicking on "About This Mac…" you will see more information.

## Uninstall Setup Manager

Setup Manager will unload and remove its LaunchAgent and LauchDaemon files upon successful completion. That together with the [flag file](#flag-file) should prevent Setup Manager from launching on future reboots.

If you still want to remove Setup Manager after successful enrollment, there is [a sample uninstaller script in the Examples folder](../Examples/uninstall.sh).

