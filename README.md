# Blaze SDK Flutter

Blaze SDK Flutter is an easy-to-use toolkit that allows you to effortlessly integrate and utilize [Breeze 1 Click Checkout](https://breeze.in) & its services into your Flutter app.

## Flutter SDK Integration

Follow the below steps to integrate Blaze SDK into your Flutter application:

### Step 1: Obtaining the Blaze SDK

1.1. Adding the Blaze SDK dependency to your `pubspec.yaml` file.

Run following command to add blaze_sdk_flutter as a dependency to your flutter project

```bash
flutter pub add blaze_sdk_flutter
```

### Step 2: Platform-Specific Setup

Complete the setup below for the platform(s) you are targeting.

#### Android

2.1. Include the repository for SDK Resolution to your project's `android/build.gradle` file.

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        // add this line
        maven { url "https://jitpack.io" }
    }
}
```

#### iOS

2.2. Install CocoaPods dependencies. Run this from your project root:

```bash
cd ios && pod install
```

> **Tip:** If you use `flutter run` or `flutter build ios`, CocoaPods dependencies are installed automatically. You only need to run `pod install` manually if you want to update pods independently.

2.3. Add the following URL schemes inside the `<dict>` tag of your `ios/Runner/Info.plist` to allow the SDK to detect and launch payment apps:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>credpay</string>
    <string>phonepe</string>
    <string>paytmmp</string>
    <string>tez</string>
    <string>paytm</string>
    <string>bhim</string>
    <string>myairtel</string>
    <string>slice-upi</string>
    <string>ppe</string>
    <string>amazonpay</string>
</array>
```

> **Note:** Minimum iOS version supported is **12.0**.

### Step 3: Initialize the SDK

**3.1. Import the Blaze SDK package in your application class.**

```dart
  import 'package:blaze_sdk_flutter/blaze_sdk_flutter.dart';
```

**3.2. Create an instance of the `BlazeSdkFlutter` class in your application class.**

```dart
final _blaze = BlazeSdkFlutter();
```

**3.3. Initiate the Blaze instance. Preferably when Checkout page opens up or app launches.**

In order to call initiate you need to perform the following steps:

#### 3.3.1: Construct the Initiate Payload

Create a Json with correct parameters to initiate the SDK. This is the data that will be used to initialize the SDK.

```dart
// Create a JSONObject for the Initiate data
Map<String, dynamic> createInitiatePayload() {
  return {
    "merchantId": "<MERCHANT_ID>",
    "environment": "<ENVIRONMENT>",
    "shopUrl": "<SHOP_URL>"
  };
}

// Place Initiate Payload into SDK Payload
Map<String, dynamic> createSDKPayload(Map<String, dynamic> payload) {
  return {
    "requestId": "randomId",
    "service": "in.breeze.onecco",
    "payload": payload
  };
}

var initiatePayload = createSDKPayload(createInitiatePayload());

```

Note: Obtain values for `merchantId`, `environment` and `shopUrl` from the Breeze team.

Refer to schemas for understanding what keys mean.

#### 3.3.2: Construct the Callback Method

During the user journey the SDK will call the callback method with the result of the SDK operation.
You need to implement this method in order to handle the result of the SDK operation.

```dart
  void handleCallbackEvent(Map<String, dynamic> callbackEvent) {
    print("Callback Event: $callbackEvent");
  }
```

#### 3.3.3: Call the initiate method on Blaze Instance

Finally, call the initiate method on the Blaze instance with the payload and the callback method.

```dart
  _blaze_.initiate(initiatePayload, handleCallbackEvent);
```

### Step 4: Start processing your requests

Once the SDK is initiated, you can start processing your requests using the initialized instance of the SDK.
The SDK will call the callback method with the result of the SDK operation.

#### 4.1: Construct the Process Payload

Create a Json payload with the required parameters to process the request.
The process payload differs based on the request.
Refer to schemas sections to understand what kind of data is required for different requests

```dart

// Create a JSONObject for the Process data
Map<String, dynamic> createProcessPayload() {
  return {
    "action": "<ACTION>",
    // .. rest of the keys
  };
}


var processPayload = createSDKPayload(createProcessPayload());

```

#### 4.2: Call the process method on Blaze Instance

Call the process method on the Blaze instance with the process payload to start the user journey or a headless flow.

```dart
  _blaze_.process(processSDKPayload)
```
