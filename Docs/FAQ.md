#  Frequently Asked Questions

## Is there are custom JSON Schema for Jamf Pro?

[Yes.](Extras.md#custom-json-schema-for-jamf-pro)

## Can you block the user desktop with user initiated enrollment?

Yes, use the top-level `background` key and point it to a local image file or a http URL to an image file. If you don't want custom branding, you can set `background` to `/System/Library/CoreServices/DefaultDesktop.heic` for the default image.

## Setup Manager is not launching after enrollment

There can be many causes for this. A few common causes are:
 
- Jamf Pro: check that Setup Manager is added to your prestage and the package does not have the label "Availability pending" in Settings> Packages
- Jamf Pro: do not install JamfConnect.pkg in prestage when you want to use Setup Manager. Install JamfConnect with Setup Manager instead
- you need at least one of the 'Setup Assistant Options' in the prestage to be set to _not_ skip. Location Services or 'Choose your Look' are common choices, that you generally want to leave up the user anyway. Otherwise Setup Assistant may quit before Setup Manager can launch and do its actions.

## Does Setup Manager require Jamf Connect

No.

Setup Manager will run fine without Jamf Connect. You can even build 'single-touch' style workflows with Setup Manager withough Jamf Connect. Some features, such as pre-assigning a device to a specific user require Jamf Connect, though.

## How can I use the icon for an app before the app is installed?

- preinstall icon files with a custom package installer in prestage. Set the priority of the media/branding package lower than that for Setup Manager, or give the branding/media package a name that is alphabetically earlier than Setup Manager, so it installs before Setup Manager
- use http(s) urls to the image files
    - you can host them on a web server/service that you have control over
    - you can add the icon as an icon for a self service policy in Jamf and then copy the url to the icon once uploaded


## What is happening during the "Getting Ready" steps?

During the "Getting Ready" phase, Setup Manager is waiting for the Jamf Pro configuration to be complete, and runs a recon, so that policies during the enrollment phase can already be scoped. You cannot change the steps in this phase. You can see the details and possibly failures in the Setup Manager log.
