# Assignment
A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.


# Build and Deployment Documentation

This document outlines the steps required to build, deploy, and configure the Flutter app for both Android and iOS platforms. It includes details on generating APK/IPA files, setting up the environment, and deploying the app to the Google Play Store and Apple App Store.

## 1. Build Process

### 1.1. Android Build

#### Prerequisites

Flutter SDK installed.
Android Studio installed.
Android SDK configured.
Firebase configuration file (google-services.json) placed in android/app.
Steps

#### Update App Configuration:
Open android/app/build.gradle and set the versionCode and versionName:
gradle

`defaultConfig {
  applicationId "com.example.assignment"
  minSdkVersion 21
  targetSdkVersion 33
  versionCode 1
  versionName "1.0.0"
}`

Ensure android/app/src/main/AndroidManifest.xml contains the correct app name and permissions.
Generate APK:
Run the following command in the terminal:

`flutter build apk --release`
The APK will be generated at:

` build/app/outputs/flutter-apk/app-release.apk `
Generate App Bundle (Optional):
For Google Play Store, generate an App Bundle:
`flutter build appbundle --release`
The App Bundle will be generated at:
Copy
`build/app/outputs/bundle/release/app-release.aab`
## 1.2. iOS Build

### Prerequisites

Flutter SDK installed.
Xcode installed.
Apple Developer account with a valid provisioning profile.
Firebase configuration file (GoogleService-Info.plist) placed in ios/Runner.
Steps

Update App Configuration:
Open ios/Runner/Info.plist and set the app name, version, and permissions:
xml
`
<key>CFBundleName</key> 
<string>Assignment App</string> 
<key>CFBundleVersion</key> 
<string>1.0.0</string> 
<key>CFBundleShortVersionString</key> 
<string>1.0.0</string>` 

### Configure Signing in Xcode:
Open the ios folder in Xcode.
Go to Runner > Signing & Capabilities.
Enable Automatically manage signing and select your team.
Generate IPA:
Run the following command in the terminal:

`flutter build ipa --release`

The IPA will be generated at:

`build/ios/ipa/Runner.ipa`

## 2. Deployment Process

### 2.1. Android Deployment

Google Play Store

Create a developer account on the Google Play Console.
Upload the App Bundle (app-release.aab) or APK (app-release.apk).
Fill in the required details (app name, description, screenshots, etc.).
Submit the app for review.
Alternative Distribution

Share the APK (app-release.apk) directly with users or upload it to third-party app stores.
2.2. iOS Deployment

Apple App Store

Create a developer account on App Store Connect.
Upload the IPA using Xcode or App Store Connect.
Fill in the required details (app name, description, screenshots, etc.).
Submit the app for review.
TestFlight (Beta Testing)

Use TestFlight to distribute the app to beta testers before releasing it on the App Store.
## 3. Environment Configurations

### 3.1. Flutter Environment

Ensure Flutter is installed and configured correctly:

`flutter doctor`
Fix any issues reported by flutter doctor.
### 3.2. Firebase Configuration

Add the Firebase configuration files:
For Android: google-services.json in android/app.
For iOS: GoogleService-Info.plist in ios/Runner.
3.3. Version Control

Use Git to track changes and manage releases:

`git tag v1.0.0`

`git push origin v1.0.0`

## 4. Final Checklist

Android

APK or App Bundle generated.
Firebase configuration added.
App tested on multiple devices.
iOS

IPA generated.
Firebase configuration added.
App tested on multiple devices.
Documentation

Build process documented.
Deployment steps documented.
## 5. Troubleshooting

Common Issues

Missing Firebase Configuration:
Ensure google-services.json and GoogleService-Info.plist are placed in the correct directories.
Signing Errors (iOS):
Verify that the provisioning profile and signing certificates are correctly configured in Xcode.
Build Failures:
Run flutter clean and rebuild the app.
Ensure all dependencies are up-to-date (flutter pub get).
## 6. Conclusion

This document provides a comprehensive guide to building, deploying, and configuring the Flutter app for both Android and iOS platforms. By following these steps, you can ensure a smooth release process and deliver a high-quality app to your users.
