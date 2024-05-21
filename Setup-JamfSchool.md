#  Setup with Jamf School

## Setting Jamf Setup Manager Workflow in Jamf School

In order to configure the workflow in Jamf School you will need

- A Jamf Setup Manager Configuration Profile (configured for your deployment, example profile below) uploaded to Jamf School
- Jamf Setup Manager PKG (available from GitHub) uploaded to Jamf School
- An Automated Device Enrolment Profile with at least one setup assistant pane configured, “Wait for the configuration to be applied before continuing the Setup Assistant” box checked and an admin account configured as required and “skipped user creation” pane 
- Other ADE profile setting should be set as required but Do Not select Auto Advance (see below)


### Step 1 

- Create a Payloadless Profile for Smart Group Targeting
- Navigate to profiles and create a new macOS Profile.
- Name it “Jamf Setup Manager Installed”
- Do not scope the profile and do not configure any payloads. Simply save the profile

### Step 2 

- Create a Smart Group to target your required Macs
- Navigate to Devices → Device Groups and create a new group. Ensure you select “Smart Group”
- Name the Group “Jamf Setup Manager Profile” skip all other panes until members
- In members select “Operating System” “equals” “Any” and then leave the min and max OS blank. This will target any and all macOS devices in my environment
- If you only want to select a subset of macOS devices, for example Lab Mac devices and not 1:1 devices, configure this group to target the desired devices in your environment
- Save Scope

### Step 3 

- Create a Smart Group to target devices with Jamf Setup Manager Profile Installed to deploy JSM pkg
- Navigate to Devices → Device Groups and create a new group. Ensure you select “Smart Group”
- Name the Group “Install Jamf Setup Manager”, skip all other panes until members
- In members select “Managed Profile (Installed)” “equals” and then select the Jamf Setup Manager Configuration Profile that you uploaded to Jamf School
- Save Scope
- Next in the Apps tab add the Jamf Setup Manager pkg and in the Profiles tab select the “Jamf Setup Manager Installed” profile you created in Step 1
- If you named your profile in step 1 something different, be sure to select that profile in this step


### Step 4

- Create a Smart Group to target devices with the “JSM Installed” profile installed and deploy the rest of the profile and apps
- Navigate to Devices → Device Groups and create a new group. Ensure you select “Smart Group”
- Name the group “macOS Management & Apps”, skip all other panes until members
- In members select ““Managed Profile (Installed)” “equals” and then select “Jamf Setup Manager Installed”  profile that you created in Step 1
- If you named your profile in step 1 something different, be sure to select that profile in this step

- Next in the Apps tab add any apps or packages that will not be installed via Installomator as part of the Jamf Setup Workflow and in the Profiles tab any any and all config needed to manage your Macs
- If you install packages or App Store apps through Jamf School, if you want to report on them as part of the Jamf Setup Manager workflow be sure to add Watchpaths for the apps / content into the Jamf Setup Manager Configuration Profile before uploading to Jamf School


These chained Smart group actions then perform the following flow
- Scope the Jamf Setup Manager Config profiles to all macOS devices
- Once the Profile is reported as installed by Jamf School, it will then install the Jamf Setup Manager pkg (since we 100% know the config profile is on the device before the pkg, when know it’ll be configured in the correct manner) and the “Jamf Setup Manager Installed” profile
- Only when the device reports back that it has “Jamf Setup Manager Installed” profile will it move into the next smart group where it will receive the commands to install further apps / packages and the rest of the configuration profiles 
With this flow we are controlling the best we can that the first thing the device does it install Jamf Setup Manager and the required config rather than having Jamf Setup Manager queued rather down a list of apps that are installing. 
This activity log shows the order in which Jamf School issues and the device receives the commands. We can see that theres not a huge amount of time between all the actions but long enough that we can be sure that the device gets the Enterprise Install command to install Jamf Setup Manager before anything other apps

## Workflow Warnings

Since the Jamf Setup Manager workflow is very “specific” for Jamf School it shouldn’t be a surprise that there are some warnings, or gotcha’s. All mainly around the way that we’ve chained together the smart groups based on installed profiles, although it gives us the flow that we need it's also a little fragile. 
For example if you were to accidentally unscope the “Jamf Setup Manager Installed” profile from a device it would then fall out of scope of the “macOS Management & Apps” group, which is where all of the management and App Store apps are scoped. 
…and of course that means the device has the profiles removed and App Store apps removed AKA disaster 💥💥💥
The second smart group we create also is looking for a profile that is installed. You’re likely not going to unscope by accident this profile (although if you did is would mean the device has profiles removed and App Store app removed AKA disaster 💥💥💥) what is more likely to happen is that you UPDATE or REPLACE the “Jamf Setup Manager Configuration Profile”
Let's say you upload your JSM configure Profile and call its “JSM Setup V1” and this is the profile that you select in the smart group in Step 1 above. You then edit the config profile and call it JSM Setup V1.1, maybe even delete the JSM Setup V1 from Jamf School. 
The smart group is still looking for a profile called “JSM Setup V1”. 
Depending on your setup and how you’ve managed your profiles in Jamf School your deployed devices might not longer have JSM Setup V1 installed, which means it falls out of the “Install Jamf Setup Manager” group which in turn will fall out of the “macOS Management & Apps” group….which is where all of the management and App Store apps are scoped. 
Again, of course that means the device has the profiles removed and App Store apps removed AKA disaster 💥💥💥
Also newly deployed devices might not run through the workflow correctly as they are now have JSM Setup V1.1 installed and the smart group is looking for JSM Setup V1.
Bottom line here is be mindful about the name of your Jamf Setup Manager Profile and if you amend the config and upload a new version, scope that FIRST, then EDIT the smart group, wait for it to deploy and then remove the old profile. 
Although targeting the profile is what makes this workflow successful in Jamf School, its also a house of cards
