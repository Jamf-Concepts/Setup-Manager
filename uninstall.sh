#!/bin/sh

# uninstall.sh

# removes Setup Manager app and all related files

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Note:
# Setup Manager creates a flag file at
#
# /private/var/db/.JamfSetupEnrollmentDone
#
# when it completes successfully. This uninstall script
# does NOT remove this file. When you re-install Setup
# Manager after running this script, the flag file's
# existence will suppress the launch of Setup Manager.
#
# Depending on your workflow needs, you may want to
# uncomment the last line which removes the flag file.

appName="Setup Manager"
bundleID="com.jamf.setupmanager"

appPath="/Applications/Utilities/${appName}.app"

if [ $(whoami) != "root" ]; then
    echo "needs to run as root!"
    exit 1
fi

if launchctl list | grep -q "$bundleID" ; then
    echo "unloading launch daemon"
    launchctl unload /Library/LaunchDaemons/"$bundleID".plist
fi

echo "removing files"
rm -rfv /Applications/Utilities/"$appName".app
rm -v /Library/LaunchDaemons/"$bundleID".plist

pkgutil --forget "$bundleID"

# rm -v /private/var/db/.JamfSetupEnrollmentDone
