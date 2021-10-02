# GodotFacebookAuth
Plugin for authorization with Facebook for Godot Game Engine (iOS)

## Installation

1. [Download Plugin](https://github.com/kurtsev0103/godot-facebook-auth/releases/download/1.0.1/GodotFacebookAuth_plugin.zip), unzip and copy files to your Godot project's ```res://ios/plugins``` directory. You can also group files in a sub-directory, like ```res://ios/plugins/godot_facebook_auth```
	> The latest version of this plugin requires ```Godot 3.3.4```. If you have a lower version of Godot, see the [Releases](https://github.com/kurtsev0103/godot-facebook-auth/releases) tab.

2. You can find and activate plugin by going to Project -> Export... -> iOS and in the Options tab, scrolling to the Plugins section.

<img width="429" alt="img" src="https://user-images.githubusercontent.com/27446881/132989486-73508e21-bdc7-4d01-accc-4b316866149e.png">

3. After exporting, you must configure an Info.plist file with an XML snippet that contains data about your app.
  
  - Right-click Info.plist, and choose Open As ▸ Source Code.

<img width="1180" alt="img" src="https://user-images.githubusercontent.com/27446881/132990169-d8f813fc-c762-45fe-991a-25bd42b34ad0.png">
    
  - Copy and paste the following XML snippet into the body of your file ( \<dict>...\</dict>).

<img width="720" alt="img" src="https://user-images.githubusercontent.com/27446881/132990120-b735c2b6-4201-43e2-b803-edcd64922c57.png">

  - XML snippet

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
  <key>CFBundleURLSchemes</key>
  <array>
    <string>fbAPP-ID</string>
  </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>APP-ID</string>
<key>FacebookClientToken</key>
<string>CLIENT-TOKEN</string>
<key>FacebookDisplayName</key>
<string>APP-NAME</string>

<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fbauth</string>
  <string>fbauth2</string>
</array>
```

> 1. In ```<array><string>``` in the key [CFBundleURLSchemes], replace APP-ID with your App ID.
> 2. In ```<string>``` in the key FacebookAppID, replace APP-ID with your App ID.
> 3. In ```<string>``` in the key FacebookClientToken, replace CLIENT-TOKEN with the value found under Settings > Advanced > Client Token in your App Dashboard.
> 4. In ```<string>``` in the key FacebookDisplayName, replace APP-NAME with the name of your app.

## Samples and Example Usage

Description

> Methods
```gdscript
# Check the status of authentication
credential() -> void
# Sign in with facebook
sign_in() -> void
# Sign out with facebook
sign_out() -> void
```

> Signals
```gdscript
credential(result: Dictionary)
authorization(result: Dictionary)
```

Initialization
```gdscript
var godot_facebook_auth: Object

func _ready():
	if Engine.has_singleton("GodotFacebookAuth"):
		godot_facebook_auth = Engine.get_singleton("GodotFacebookAuth")
		godot_facebook_auth.connect("credential", self, "_on_credential")
		godot_facebook_auth.connect("authorization", self, "_on_authorization")
```

Checking credential status
```gdscript
# 1. Call the method anywhere in the code
godot_facebook_auth.credential()
# 2. Wait for the answer in the method below
func _on_credential(result: Dictionary):
	if result.has("error"):
		print(result.error)
	else:
		print(result.state)
		# "authorized" <- user ID is in good state
		# "not_found" <- user ID was not found
		# "revoked" <- user ID was revoked by the user
```

Sign In
```gdscript
# 1. Call the method anywhere in the code
godot_facebook_auth.sign_in()
# 2. Wait for the answer in the method below
func _on_authorization(result: Dictionary):
	if result.has("error"):
		print(result.error)
	else:
		# Required
		print(result.token)
		print(result.user_id)
		# Optional (can be empty)
		print(result.email)
		print(result.name)
```

Sign Out
```gdscript
# Call the method anywhere in the code
godot_facebook_auth.sign_out()
```

## Created by Oleksandr Kurtsev (Copyright © 2021) [LICENSE](https://github.com/kurtsev0103/godot-facebook-auth/blob/main/LICENSE)
