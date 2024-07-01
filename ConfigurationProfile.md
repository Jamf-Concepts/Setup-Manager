# Configuration Profile format

The project includes a [custom profile plist](sample-com.jamf.setupmanager.plist) for Jamf Pro and [an example configuration profile](sample-jamfschool.mobileconfig) for Jamf School. 

## Top-level keys

#### `DEBUG`

(Boolean, default: `false`)

When this is set to `true` any steps that actually change software on the disk will not be performed.

These behaviors change in debug mode: 
- checks for the existence of the Jamf binary and keychain are skipped
- Jamf Setup manager will accept enrollmentActions from a non-managed preference file
- `policy`, `recon`, and `shell` actions that require root are replaced with a 10 second delay (and will always complete successfully)
- watchPath and wait actions timeout and fail after 10 seconds

When in debug mode, you have to set the `simulateMDM` preference key to `Jamf Pro` or `Jamf School`. This allows you to do test runs on un-enrolled Macs.

#### `title`

(String, default: `Welcome to Setup Manager`, localized)

The main title over the window.

Example:

```
<key>title</key>
<string>Welcome to your new Mac!</string>
```

#### `icon`

(String, default: `name:AppIcon`, localized)

The icon shown at the top center of the window. There are many options to define icons, described in the [Icon Sources](#icon-sources) section later.

#### `message`

(String, default: `Setup Manager is configuring your Mac…`, localized)

The message shown below the title.

Example:

```
<key>message</key>
<string>Please wait a few moments while we install essential software…</string>
```

#### `background`

(String, optional, localized)

When this key is set, Setup Manager treats it as an image/[icon source](#icon-source) and displays the image in a screen covering background.

#### `enrollmentActions`

(Array of Dicts, required)

This array contains a list of `Dict`s which describe the individual actions to be performed in order. Actions are described in detail in the [Actions](#actions) section.

#### `userEntry`

(Dict of Dicts, optional)

When this key exists, Setup Manager will prompt for user data while the enrollment actions are running. The individual keys are described in [User Entry](#user-entry).

#### `help`

(Dict of Strings, optional)

When this key exists, Setup Manager will show a "Help" button (a circled question mark) in the lower right corner while it is running. You can add subkeys with content for the help, which are described in [Help](#help). When Setup Manager has completed, the "Help" button will be replaced with the "Continue" and/or "Shutdown" button.

#### `accentColor`

(String, optional, default: system blue)

When present sets the accent color for buttons, progress bar and other UI elements. You can use this to match branding. Color is encoded as a six digit hex code, i.e. `#FF0088`.

#### `finalCountdown`

(Number/integer, optional, default: `60`)

This key changes the duration (in seconds) of the "final countdown" before the app automatically quits. Set to `-1` (or any negative number) to disable automated continue.

Examples:

```
<key>finalCountdown</key>
<integer>30</integer>
```

```
<key>finalCountdown</key>
<integer>-1</integer>
```

#### `finalAction`

(String, optional, default: `continue`)

This key sets the action and label for the button shown when Setup Manger has completed. When this key is set to `shutdown` (no space!) it will shutdown the computer, other wise it will just quit Setup Manager ("continue"). This is also the action that is performed when the `finalCountdown` timer runs out.

Example:

```
<key>finalAction</key>
<string>shutdown</string>
```

#### `showBothButtons`

(Bool, optional default: `false`)

This key determines whether both the 'Shutdown' and 'Continue' are shown or just the button set in the `finalAction` key.

Example:

```
<key>showBothButtons</key>
<true/>
```

#### `totalDownloadBytes` : (Integer, opitonal, default: 1000000000 or 1GB, v0.8)

Use this value to provide an estimate for the total size of all items that will be downloaded. Setup Manager will display and estimated download time for this sum in the "About this Mac..." popup window.

Example:

```
<key>totalDownloadBytes</key>
<integer>4500000000</integer>
```

#### `jssID`

(String, Jamf Pro only)

Set this to `$JSSID` in the configuration profile and Setup Manager will be aware of its computer's id in Jamf Pro. It will be display in the 'About this Mac…' popup.

Example:

```
<key>jssID</key>
<string>$JSSID</string>
```

#### `userID`

(String, Jamf Pro only)

Set this to `$EMAIL` in the configuration profile. This communicates the user who logged in to customized enrollment to Setup Manager. This can be used together with the `userEntry.showForUserIDs` key to control which users see the user entry UI.

Example:

```
<key>userID</key>
<string>$EMAIL</string>
```

#### `computerNameTemplate`

(String, Jamf Pro only)

When this key is set, Setup Manager will generate the computer name from this template and set it. When this key is present, a `computerName` dict or string in `userEntry` will be ignored.

The template uses tokens, which begin and end with `%` character. The tokens will be replaced with data from the device or from user entry. For example, in the template `Mac-%serial%` the `%serial%` token will be replaced with the computer's serial number. (A double `%%` will be substituted with a single `%`, in case you need to represent this symbol in the computer name.)

The following tokens are available:

- `serial`: the computer's serial number
- `udid`: the computer's provisioning udid
- `model`: the computer's model name, e.g. `MacBook Air` or `Mac mini`
- `model-short`: the first word of `model` (no spaces), i.e. `MacBook`, `Mac` or `iMac`
- these values from user entry: `email`, `assetTag`, `building`, `department`, `room`

If the value for a token cannot be retrieved or is empty, it will be substituted with `%%%` (three percentage signs).

You can add a `:n` (where `n` is an integer number) to a token. This will substitute only the first `n` characters of the string. For example `%serial:5%` will be substituted with the first 5 characters of the serial number. When `n` is negative, it will substitute the _last_ `n` characters. For example, `%udid:-8%` will substitute the last eight characters of the udid.

Example:

```
<key>computerNameTemplate</key>
<string>Mac-%serial:-6%</string>
```

This will set the computer name to `Mac-ABC123` where `ABC123` is the last six characters of the serial number 

#### `overrideSerialNumber`

(String, optional)

When set, the "About this Mac" info window will show this value instead of the real serial number. This is useful when making screen shots or recordings for documentation or presentations where you do not want to expose real serial numbers.

#### `hideActionLabels`

(Bool, default: `false`)

Hides the individual labels under each action's icon.

Example:

```
<key>hideActionLabels</key>
<true/>
``` 

#### `hideDebugLabel`

(Bool, default: `false`)

When set, suppresses display of the red 'DEBUG' label in debug mode. Useful for screenshots and recordings.

Example:

```
	<key>hideDebugLabel</key>
	<true/>
```


## Actions

All actions should have these keys:

#### `label`

(String, required, localized)

The label is used as the name of the action in display.

#### `icon`

(String, optional, localized)

The icon source string used for the display of the label. Different types of actions will have different default icons, which is used when no `icon` key is present.

There are several different types of actions, and these are defined by additional keys. These keys will be on the same level as the keys above.

### Shell Command

#### `shell`

(String)

The path to the command or script that should be run for this action. You need to provide the absolute full path to the command, e.g. `/usr/bin/say`.

#### `arguments`

(Array of Strings, optional)

When the command given in `shell` requires arguments they are listed here, one item per argument. Do _not_ escape or quote spaces or other special characters.

#### `requiresRoot`

(Bool, default: `false`, optional)

When this key is set to `true` Setup Manager will only run this when itself is running as root. Otherwise it will fail the action. When `DEBUG` is enabled, it will replace the action with a delay instead.

Example:

```
<dict>
  <key>label</key>
  <string>Set Time Zone</string>
  <key>icon</key>
  <string>symbol:clock</string>
  <key>shell</key>
  <string>/usr/sbin/systemsetup</string>
  <key>arguments</key>
  <array>
    <string>-setTimeZone</string>
    <string>Europe/Amsterdam</string>
  </array>
  <key>requiresRoot</key>
  <true/>
</dict>
```

### Jamf Policy Trigger

#### `policy`

(String)

(Jamf Pro only)

This will run the jamf policy or polices with the given trigger name. This is the equivalent of running `jamf policy -event <triggername>`

Example:

```
<dict>
  <key>label</key>
  <string>BBEdit</string>
  <key>icon</key>
  <string>https://ics.services.jamfcloud.com/icon/hash_abcdefghj</string>
  <key>policy</key>
  <string>install_bbedit</string>
</dict>
```

### Watch Path

#### `watchPath`

(String)

This action will wait until a file at the given path exists (`wait` is `untilExists`, default) or is removed (`wait` is `whileExists`).

#### `wait`

(String, default: `untilExists`)

Determines if the action waits until the file exists (`untilExists`) or until the file is removed (`whileExists`).

#### `timeout`

(Number/integer, in seconds, default: `600`)

The action will fail after this timeout.

Example:

```
<dict>
  <key>label</key>
  <string>Jamf Protect</string>
  <key>icon</key>
  <string>symbol:app.badge</string>
  <key>watchPath</key>
  <string>/Applications/JamfProtect.app</string>
  <key>wait</key>
	<integer>300</integer>
</dict>
```

Note: This is intended to check if app are installed from the Mac App Store or Jamf App Installers. In my experience, these methods are very unreliable, hence the timeout. Since you cannot anticipate the order in which these apps may be installed, it is best to put the `watchPath` actions at the end. For large installations (Xcode) you want to have a large timeout.

### Wait

#### `wait`

(Number/integer, in seconds)

Wait for a given time. Use this to let the system catch up with previous installations.

Example:

```
<dict>
  <key>label</key>
  <string>Waiting…</string>
  <key>wait</key>
  <integer>20</integer>
</dict>
```


### Jamf Inventory Update (recon)

#### `recon`

(String, value is ignored, Jamf Pro only)

This will run a Jamf Inventory update.

You should usually not need to add a recon step. By default Setup Manager will automatically run an inventory update before and after running the enrollment actions.

Example:

```
<dict>
  <key>recon</key>
  <string/>
</dict>
```

### Installomator

This will run Installomator to install a given label.

Note: by default, Setup manager will add `NOTIFY=silent` to the arguments to suppress notfications. You can override this in the `arguments`.

#### `installomator`

(String)

The installomator label to run.

#### `arguments`

(Array of Strings, optional)

List of additional arguments passed into Installomator.

Example:

```
<dict>
  <key>label</key>
  <string>Google Chrome</string>
  <key>icon</key>
  <string>symbol:gearshape.2</string>
  <key>installomator</key>
  <string>googlechromepkg</string>
</dict>
```


## Icon Sources

Icons can be defined in several ways in Setup Manager. These different approaches for the top-level `icon` and `background` key, as well as the `icon` key in an action.

### From the web

When the icon source string starts with `http` or `https`, Setup Manager will attempt to download a file from that URL and interpret it as an image file. It will show a spinning progress view while downloading.

```
<key>icon</key>
<string>https://example.com/path/to/icon.png</string>
```

### Local file

When the icon source is an absolute file path, Setup Manager will attempt to read that file as an image file and display it.

```
<key>icon</key>
<string>/Library/Organization/image.png</string>
```

### Application:

When the icon source is an absolute file path that ends in `.app`, Setup Manager will get the icon from that app.

```
<key>icon</key>
<string>/System/Applications/App Store.app</string>
```

### Name:

When the icon source starts with `name:`, Setup Manager will get the icon with that name. Two names are useful: `AppIcon` gets Setup Manager's app icon and `NSComputer` will get an icon representing the current hardware.

```
<key>icon</key>
<string>name:AppIcon</string>
```

### SF Symbols:

When the icon source starts with `symbol:`, Setup Manager will create the icon using that symbols name. You can look up symbol names using the [SF Symbols app](https://developer.apple.com/sf-symbols/).

Note that the availability of SF Symbols will vary with the OS version and that some SF Symbols may look different in different localizations.

```
<key>icon</key>
<string>symbol:clock</string>
```

## User Entry

You can enable user entry for the following keys:

- `userID`
- `department`
- `building`
- `room`
- `assetTag`
- `computerName`

Any of the fields will only be shown when its key exists. If you were to create an empty `userEntry` dict, you get an empty user input screen with a 'Save' button - not a good user experience.

#### `default`

(String, localized)

You provide a default value in two ways:

Example:

```
<key>computerName</key>
<string>Mac-12345</string>
```

Use this simple `string` form, when all you need is the field with a default value filled in. Leave the `string` value empty if you don't even want a default value.

When you want to configure other options of the field, you need to use the `dict` form:

Example:

```
<key>computerName</key>
<dict>
  <key>default</key>
  <string>ABC12345</string>
</dict>
```

With the second, longer form you can have different default values per [localization](#localization).

```
<key>computerName</key>
<dict>
  <key>default</key>
  <string>Device-12345</string>
  <key>default.de</key>
  <string>Gerät-12345</string>
</dict>
```


#### `placeholder`

(String, localized)

This will show the string value given as a greyed out placeholder in the empty text field.

```
<key>assetTag</key>
<dict>
  <key>placeholder</key>
  <string>ABC12345</string>
</dict>
```

Note: a `default` value will prevent the placeholder from appearing, unless the user actively deletes the contents of a field.

#### `options`

(Array of Strings, optional)

This will show a popup list of preset options:

```
<key>department</key>
<dict>
  <key>options</key>
  <array>
    <string>IT</string>
    <string>Sales</string>
    <string>R&amp;D</string>
  </array>
</dict>
```

The first option is the default selection.

Note: since we want to avoid having to provide Jamf Pro API credentials to Setup Manager, JSM does _not_ read the list of  buildings or departments from Jamf and you will have to transcribe them into the profile. Annoying, but the lesser of two evils, here.

#### `validation`

(String, optional)

The value of this key is a regular expression string. When the expression matches the entire string entered, it validates. For example, a `validation` of `[A-Z]{3}\d{5}` will match three uppercase letters (`[A-Z]{3}`) and then five numbers (`\d{5}`).

Some useful regular expressions:

- `.+`: at least one character (i.e. not empty)
- `[a-z]{7}`: exactly seven lowercase letters
- `\d{3,5}`: three to five digits (numbers)
- `\S+\@(example\.com|example.org)`: email ending with `example.com` or `example.org`

Detailed description of the regular expression syntax: [NSRegularExpression](https://developer.apple.com/documentation/foundation/nsregularexpression)

Example:

```
<key>userID</key>
<dict>
  <key>placeholder</key>
  <string>first.last@example.com</string>
  <key>validation</key>
  <string>\S+\.\S+\@example\.com</string>
</dict>
```

#### `validationMessage`

(String, optional, localized)

The default validation message will show the regular expression the value is not matching. This is suitable for debugging but not at all user friendly. You really should provide a localized message explaining how the value can conform.

```
<key>assetTag</key>
<dict>
  <key>placeholder</key>
  <string>ABC12345</string>
  <key>validation</key>
  <string>[A-Z]{3}\d{5}</string>
  <key>validationMessage</key>
  <string>Asset Tag needs to be of format 'ABC12345'</string>
  <key>validationMessage.de</key>
  <string>Etikett Nummer muss im Format 'ABC12345' sein</string>
  <key>validationMessage.fr</key>
  <string>L'étiquette d'actif doit être au format 'ABC12345'</string>
  <key>validationMessage.nl</key>
  <string>Asset Tag moet het formaat 'ABC12345' hebben</string>
</dict>
```

### Conditionally show the user entry for certain users

You can configure Setup Manager to only show the user entry section when specified users have authentication in enrollment customization. This enables workflows, where certain users (techs and admins) gets the option to re-assign the device to another user, but other users don't see the option.

For this, you need to setup the top-level `userID` to receive the `$EMAIL` variable. This will communicate the user who logged in with customized enrollment back into  Setup Manager. Then you add key `showForUserIDs` with an array of user emails to the `userEntry` dict. When both `userID` and `userEntry.showForUserIDs` are set, the user entry UI will only show for the listed users.

#### `showForUserIDs`

(Array of Strings, optional)

Example:

```
<key>userEntry</key>
<dict>
  <key>showForUserIDs</key>
  <array>
    <string>a.b@example.com</string>
    <string>m.b@example.com</string>
    <string>r.p@example.com</string>
  </array>
  <key>userID</key>
  <dict>
    <key>placeholder</key>
    <string>first.last@example.com</string>
    <key>validation</key>
    <string>\S+\.\S+@example.com</string>
  </dict>
</dict>
<key>userID</key>
<string>$EMAIL</string>
```

## Help

When you provide a top-level `help` key with a dictionary a help button (with a circled question mark) will be shown in the lower right corner. When you click on the help button a window with information will be shown. You can set the information with the following keys in the `help` dictionary.

#### `title`

(String, optional, localized)

#### `message`

(String, optional, localized)

#### `url`: 

(String, optional, localized)

The contents of the `url` key will be translated into a QR code and displayed next to the help message. This allows for end users to follow a link to more information on their devices while the Mac is performing installations.

Example:

```
<key>help</key>
<dict>
  <key>message</key>
  <string>This is some help message content.</string>
  <key>title</key>
  <string>Help Content</string>
  <key>url</key>
  <string>https://jamf.com</string>
</dict>
```

## Localization

The app will pick up the user choice of the UI language for the interface elements. Right now it supports English, French, German, Italian, Spanish, and Dutch. The app will fall back to English for other language choices.

You can provide localizations for the texts given in the configuration profile. You can do so by adding the two-letter language abbreviation (e.g. `de`, `fr`, or `nl`) to the key, separated with a `.` (dot or period character). The value of the key without a "language extension" is used for English and as a fallback value for other languages.

Example:

```
<key>title</key>
<string>Welcome!</string>
<key>title.de</key>
<string>Willkommen!</string>
<key>title.fr</key>
<string>Bienvenu!</string>
<key>title.nl</key>
<string>Welkom!</string>
```

If you do not provide or have deleted a `title.de` key and value, the app will choose the value of the `title` key even when in the German setting.

The following keys can be localized:

### Top-level keys

- `title`
- `message`
- `icon`
- `background`

### Action keys

- `label`
- `icon`

### User Entry keys

- `default`
- `placeholder`
- `validationMessage`

Use these two-letter codes for these languages:

| Language           | two-letter code |
|--------------------|-----------------|
| Dutch (Nederlands) | nl              |
| English            | en (default)    |
| French             | fr              |
| German             | de              |
| Italian            | it              |
| Norwegian          | nb              |
| Spanish            | es              |
| Swedish            | sv              |
