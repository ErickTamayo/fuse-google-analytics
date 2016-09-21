# fuse-google-analytics - Beta

[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE.md)

This is the integration of the native iOS and Android bindings for Fuse of Google Analytics.

The current Firebase Analytics doesn't have real time analaytics. This package is intended to be able to satisfy the need to register pageviews and events of your Fuse Application in the easiest possible way.

## Contents
- [AnalyticsExample Project](#analyticsexample-project)
- [Usage](#usage)
- [Making the AnalyticsExample Work](#making-the-analyticsexample-work)
    - [Setting up the Project on Google Console](#setting-up-the-project-on-google-console)
    - [iOS](#ios)
    - [Android](#android)
- [License](#license)

## Usage
#### Using the Javascript API
```javascript
var GoogleAnalytics = require("Google/Analytics");

module.exports.ScreenView = function() {
    GoogleAnalytics.ScreenView("App-JS");
};

module.exports.TrackEvent = function() {
    GoogleAnalytics.TrackEvent("js_action", "button_press", "play", "0");
};
```

#### Using as TriggerActions in the UI

```HTML
<Button Height="50" Width="300" Background="Black">
    <Clicked>
        <GAPageView Page="App-UI"/>
    </Clicked>
    <Text TextAlignment="Center" Alignment="Center" Color="White">Generate Screenview From UI</Text>
</Button>
<Button Height="50" Width="300" Background="Black">
    <Clicked>
        <GATrackEvent Category="ui_action" Action="button_press" Label="play" Value="0"/>
    </Clicked>
    <Text TextAlignment="Center" Alignment="Center" Color="White">Track Event From UI</Text>
</Button>
```

## AnalyticsExample Project

This project contains the basic implementation to make the Google Analytics integration work. Some of these files should be in the same directory as the project that you want integrate Google Analytics. The functions of the files are the following:

**AnalyticsExample.unoproj**

This file contains the configuration of the project. To make analytics work, you must add the bundle identifier and the package. This needs to be the same as your Google configuration file (google-services.xml for Android and GoogleService-Info.plist for iOS). How to get the Google configurations files will be explained later.

Include Google Analytics Project

```
  "Projects": [
    "../Google.Analytics/Google.Analytics.unoproj"
  ],
```

Configured BundleIdentifier and Package

```json
"iOS": {
    "BundleIdentifier": "com.ericktamayo.example"
},
"Android" : {
    "Package" : "com.ericktamayo.example"
}
 ```

Also, you must include the *GoogleService-Info.plist* in the file.

```
"Includes": [
    "*",
    "GoogleService-Info.plist:ObjCSource:iOS"
],
```

**google-services-xml-gen.php**

This php file converts the *google-services.json* in *google_services.xml*. The reason of this is because in normal circumstances this file should just be copied instead of converting, but theres a known issue that with the current Gradle version that Fuse uses to build the project is not being able to run the task to make it the app to be able to read it, so we do that for Gradle :).

The bug: https://code.google.com/p/analytics-issues/issues/detail?id=939

**AndroidImpl.uxl**

Basically this file is in charge of copying the google-services.xml file to your Android build directory.

**MainView.ux**

This file contains how the integration should be used.

## Making the AnalyticsExample Work

**Note: You must to be able to install the project in an Android or iOS device. The preview won't work on Mac or Windows. The app will still be able to be previewed however, just you won't see anything happening on your Google Analytics Site**

**Note for the iOS we asume that you have installed cocoapods, if not refer to https://cocoapods.org/ to install**

### Setting up the Project on Google Console

- Visit https://console.developers.google.com
- On the top left side, click on **Project** and then **Create project**
- Name your project, and accept the Terms and services, then click **Create**

### iOS

##### Enabling Google Services for iOS on Google
- Visit https://developers.google.com/mobile/add?platform=ios.
- In the App Name Dropdown you should see listed your Google Project, select it.
- Write your iOS Bundle, remember, it must be the same that you will put in the **.unoproj** file. For example *com.your.bundlename*.
- Click on **Continue to Choose and configure services**.
- Now choose Analytics
- In the dropdown, choose or create your Analytics account and fill fields with the needed information.
- After filling out the info and enabling the Service, click on *Continue to Generate configuration files*
- Click on *Download GoogleService-Info.plist* and save the file in the AnalyticsExample directory

##### Setting the .unoproj file
- Change the **BundleIdentifier** to the one you selected configuring the service on Google

##### Build your project
- Run `fuse build -t=iOS -DCOCOAPODS -adebug`

**Notes: CocoaPods the first time will take long downloading the Google Analytics dependencies**

When Xcode opens, sign your code and run on your iPhone. You should see 4 buttons for generating the events. Click on them and your Google Analytics account should have activity.

### Android
- Visit https://developers.google.com/mobile/add?platform=android.
- In the App Name Dropdown you should see listed your Google Project, select it.
- Write your Package Name, remember, it must be the same that you will put in the **.unoproj** file. For example *com.your.packagename*.
- Click on **Continue to Choose and configure services**.
- Now choose Analytics
- In the dropdown, choose or create your Analytics account and fill fields with the needed information.
- After filling out the info and enabling the Service, click on *Continue to Generate configuration files*
- Click on *Download google-services.json* and save the file in the AnalyticsExample directory
- In your terminal, in the directory run `php google-services-xml-gen.php`, a new file should be generated named `google_services.xml`

##### Build and run your project
- Run `fuse build -t=android -DGRADLE -run`

When the app runs, you should see 4 buttons for generating the events. Click on them and your Google Analytics account should have activity.

## License

MIT

