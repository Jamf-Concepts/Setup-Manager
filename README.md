![Setup Manager Icon](Images/SetupManager250.png)

# Setup Manager

_"Every Assistant has a Manager"_

![Setup Manager Logo](https://img.shields.io/badge/macOS-12%2B-success)

Updates are published in the '[Releases](https://github.com/jamf-concepts/setup-manager/releases)' section of the repo. There you can also [download the latest pkg installer](https://github.com/jamf-concepts/setup-manager/releases/latest). You can subscribe to notifications for the repo using the 'Watch' button above.

Please report issues, feature requests [as an issue.](https://github.com/jamf-concepts/setup-manager/issues)

We have opened the [discussions](https://github.com/jamf-concepts/setup-manager/discussions) area for questions and more generic feedback.

There is also a [`#jamf-setup-manager`](https://macadmins.slack.com/archives/C078DDLKRDW) channel on the [MacAdmins Slack](https://macadmins.org).

![setup manager progress dialog](Images/setup-manager-progress-screenshot.png)

## What it does

There are many enrollment progress tools available for Mac admins, each with their own strengths. Jamf Setup Manager approaches the problem from the perspective of an IT service provider.

Setup Manager offers many of the same features of these utilities but is especially useful for the case where an IT department or provisioning depot wants to ensure that a new Mac is properly configured and assigned before sending the device to its new user. It runs over Setup Assistant before a user is created, so it won't interfere with MDM-capable user or the secure token flow for FileVault. You can control which policies and installations Setup Manager runs with a configuration profile.

Setup Manager provides:

- a nice modern UI
- configuration with a configuration profile, no need to modify shell scripts or json
- works with different deployment workflows
  - zero-touch (user-driven)
  - single-touch (tech-driven)
  - user initiated enrollment
  - handsfree deployment with AutoAdvance (beta)
- customized branding
- localized interface and custom text
- support for Jamf Pro and Jamf School

## Installation and Configuration

- Jamf Pro
  - [JamfPro-Quick Start](Docs/JamfPro-QuickStart.md)
  - zero-touch and user-initiated deployments (forthcoming)
  - [extra installations based on user data entry](Docs/JamfPro-TwoPhase.md)
  - [Single-touch workflow with user re-assignment using Jamf Connect](Docs/JamfProConnect-SingleTouch.md)
  - [handsfree deployment with AutoAdvance and Setup Manager at login window (beta)](Docs/JamfPro-LoginWindow.md)
- [Jamf School](Docs/JamfSchool-Setup.md)
- [Extras and Notes](Docs/Extras.md)
- [Frequently Asked Questions](Docs/FAQ.md)

## Configuration Profile

The structure of the configuration profile [is documented here](ConfigurationProfile.md).

There is also a [custom schema for Jamf Pro](Docs/Extras).

## Requirements

Setup Manager requires macOS 12.0.0 or higher. It will work only with Jamf Pro or Jamf School.

## Known Issues

- Setup Manager will **_not_** launch at enrollment with Auto-Advance enabled, use the option to run at login window
- Setup Manager may **_not_** launch or launch and quit quickly when you disable _all_ Setup Assistant screens, leave at least one Setup Assistant option enabled, or use the option to run at login window
- When you install **_Jamf Connect_** during the Prestage together with Setup Manager, you may see Setup Assistant for some time before Setup Manager launches or Setup Manager may not launch at all. Remove Jamf Connect from the Prestage and install it with Setup Manager policy or installomator action.
- Policies that are triggered by `enrollmentComplete` may disrupt Setup Manager running from Prestage/Automated Device Enrollment. Disable or unscope policies triggered by `enrollmentComplete` on devices using Setup Manager.
- In some deployments, Setup Manager attempts to start while Jamf Pro is still installing. Try adding a 30-60 second `wait` action as the first action.
- With Jamf School, there will be a few seconds after the remote management dialog where Setup Assistant shows before Setup Manager launches. With the Jamf School enrollment architecture, this is unavoidable.

---

Please report issues, feature requests, and feedback (positive and negative) [as an issue.](https://github.com/Jamf-Concepts/Setup-Manager/issues)
