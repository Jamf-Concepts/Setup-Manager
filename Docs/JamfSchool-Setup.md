# Installation and Configuration: Jamf School

## Selecting Deployment Method

Jamf Setup Manager can be deployed to run at two different points during a device deployment. Right after enrollment (the default) and at login window. You must select which method is appropriate for your deployment before configuring the Jamf Setup Manager Workflow in Jamf School

### At Enrollment (Default)

Jamf Setup Managers default deployment action is to run at `Setup Assistant`.

Setup Manager will appear and during `Setup Assistant` allowing the user to continue to configure `Setup Assistant` after Setup Manager has completed its tasks. 

_**This method is recomended for 1:1 environments**_

Example
> You deploy 1:1 MacBooks, want to ensure that critical software installed prior to the user working on the device but also require the user to configure TouchID and create a user account during the onboarding. 

> The user will connect the MacBook to the network and enroll into MDM. After a short delay Setup Manger will run and complete its tasks and install critical software

> Once complete the user will be released back to Setup Assistant where they will be able to use the Setup Assistant panes to configure TouchID and create a user



With this default method you will require an Automated Device Enrollment Profile configured with

- At least one setup assistant pane configured 
- *“Wait for the configuration to be applied before continuing the Setup Assistant”* box checked
- An admin account should be configured as required
- Other ADE profile setting should be set as required
- _**Do Not**_ select `Auto Advance`

> If the user skips through all of the Setup Assistant panes before Setup Manager launches or Auto Advance is selected. and the device lands on the login screen, Setup Manager will not launch


### At Login Window

Jamf Setup Manager can be configured to run at `Login Window`.

Setup Manager will appear once the device has ran through `Setup Assistant` and is waiting at the login screen and run through its tasks. Releasing back to the login window once complete. 

_**This method is recommended for lab environment**_

Example
> You are deploying a lab of iMacs ready for the new academic year. You wish to connect iMacs to the network with ethernet, power on and leave the devices to enroll and build while you complete other tasks. 

> After configuring an ADE profile with Auto Advance an iMac will enroll into Jamf School and move through Setup Assistant without any user interaction. Once at the login Window Setup Manager will run and complete its tasks. 

> Once Setup Manager is complete the build is complete


To run Setup Manager at `Login Window` you will require

1. A Setup Manager Profile with the key `runAt` and `String Value` of `loginwindow`
2. An Automated Device Enrollment Profile configured with

- An admin account
- `Auto Advance` configured
-  Other ADE profile setting should be set as required


---

## Jamf Setup Manager Workflow Requirements

In order to configure the workflow in Jamf School you will need

- A Jamf Setup Manager Configuration Profile (customized for your deployment, example profile below) uploaded to Jamf School 
- Jamf Setup Manager package installer (available from Jamf Concepts) uploaded to Jamf School
- An Automated Device Enrollment Profile with the correct settings for your chosen deployment method (`default` or `LoginWindow`)

	
---

**Step 1: Configuration Profile**
Create a Payload-less Profile for Smart Group Targeting

- Navigate to profiles and create a new macOS Profile
- Name it *“Jamf Setup Manager Installed”*
- Do not scope the profile and do not configure any payloads. Simply save the profile

---

**Step 2: Smart Group for Setup Manger Config Profile**
Create a Smart Group to target your required Macs

- Navigate to `Devices → Device Groups` and create a new group. Ensure you select `Smart Group`
- Name the Group *“Jamf Setup Manager Profile”* skip all other panes until members
- In members select `Automated Device Enrollment Profile` `equals` and then select the ADE profile that you created as part of the requirements step. This will target any and all devices that enrol using that ADE profile

> If you only want to select a subset of macOS devices, for example Lab Mac devices and not 1:1 devices, configure this group to target additional critera the desired devices in your environment will have 

- `Save` Scope
- Next in the `Profiles` tab add the Jamf Setup Manager Configuration Profile that you uploaded to Jamf School

---

**Step 3: Smart Group to install Setup Manager**
Create a Smart Group to target devices with Jamf Setup Manager Profile Installed to deploy the Setup Manager pkg

- Navigate to `Devices` → `Device Groups` and create a new group. Ensure you select `Smart Group`
- Name the Group *“Install Jamf Setup Manager”*, skip all other panes until members
- In members select `Managed Profile (Installed)` `equals` and then select the Jamf Setup Manager Configuration Profile that you uploaded to Jamf School
- `Save` Scope
- Next in the `Apps` tab add the Jamf Setup Manager pkg and in the `Profiles` tab select the *“Jamf Setup Manager Installed”* profile you created in Step 1


> If you named your profile in step 1 something different, be sure to select that profile in this step

---

**Step 4: Smart Group for all other apps and configurations**
Create a Smart Group to target devices with the “Jamf Setup Manager Installed” profile installed and deploy the rest of the profile and apps

- Navigate to `Devices` → `Device Groups` and create a new group. Ensure you select `Smart Group`
- Name the group *“macOS Management & Apps”*, skip all other panes until members
In members select `Managed Profile (Installed)` `equals` and then select *"Jamf Setup Manager Installed"* profile that you created in Step 1

> If you named your profile in step 1 something different, be sure to select that profile in this step

- Next in the `Apps` tab add any apps or packages that will not be installed via Installomator as part of the Jamf Setup Workflow and in the `Profiles` tab any any and all config needed to manage your Macs
- If you install packages or App Store apps through Jamf School, and you want to report on them as part of the Jamf Setup Manager workflow be sure to add `Watchpaths` for the apps / content into the Jamf `Setup Manager Configuration Profile` before uploading to Jamf School

---

### Workflow

These chained amart group actions then perform the following flow

- Scope the Jamf Setup Manager Config profiles to all macOS devices enrolled with a given ADE profile
- Once the Profile is reported as installed by Jamf School, it will then install the Jamf Setup Manager pkg (since we 100% know the config profile is on the device before the pkg, we know it’ll be configured in the correct manner) and the *“Jamf Setup Manager Installed”* profile 
- Only when the device reports back that it has *“Jamf Setup Manager Installed”* profile will it move into the next smart group where it will receive the `commands` to install further apps / packages and the rest of the configuration profiles. 


With this flow we are controlling, the best we can, that the first thing the device does is install Jamf Setup Manager and the required config. This is rather than having Jamf Setup Manager queued further down a list of apps that are installing. 

> You can view the device activity log in the Jamf School console to ensure that the InstallEnterpriseApp command for Setup Manager is received before other app commands, for testing and troubleshooting.


---

### Workflow Considerations and Warnings

The Jamf Setup Manager workflow for Jamf School has been designed to take advantage of profile installation reporting in smart groups and in part to tackle the fact that Jamf School does not have a concept of *“Pre-Stage Packages”*. As such the workflow relies on chaining together smart groups where membership of one group is dependent on an action of the previous step.

Example
> You can view the device activity log in the Jamf School console to ensure that the InstallEnterpriseApp command for Setup Manager is received before other app commands, for testing and troubleshooting. 
> 
If an admin to accidentally unscoped the *“Jamf Setup Manager Installed”* profile from a device it would then fall out of scope of the *“macOS Management & Apps”* group, as its membership criteria requires the *“Jamf Setup Manager Installed”* profile to be installed on the device. 

> Since the *“macOS Management & Apps”* group is where all of the management and App Store apps are scoped removal from this group means the device has the profiles and App Store apps removed, resulting in a device in an unexpected state. 

Therefore it is essential that the device maintains this chained smart group flow throughout its deployment. 

Should you need to `update`, `amend` or `edit` the `Jamf Setup Manager Configuration Profile` that controls Setup Manager, you will need to do this locally and then re-upload to Jamf School. 

For best results we recommend the following workflow 

- Navigate to the current profile in Jamf School in the `Profiles` -> `Configuration Profiles` menu
- Click the `pencil icon` to edit
- Click `replace profile`
- Drag local updated profile to the revealed box or click on the box to navigate to the profile
- Click `save`

Following this workflow keeps the name of the profile in Jamf School the same as the previous version and there is no need to edit / add a different or new profile the the scope in `Step 2` or change the criteria for the name of the installed profile in `Step 3`

Should you want to keep different versions of the Jamf Setup Manager Configuration Profile in Jamf School in order to switch between different Setup Manager actions please ensure that you update the profile in `Step 2` and `Step 3` to match the desired Jamf Setup Manager Configuration Profile prior to deploying devices. Failure to do this could result in the breaking of the smart group chain required for Jamf School resulting in devices in an unexpected state (ie not with the desired configurations and/or apps)
