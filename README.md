# Blaze SDK Flutter

Blaze SDK Flutter is a easy-to-use toolkit that allows you to effortlessly integrate and utilize [Breeze 1 Click Checkout](https://breeze.in) & its services into your android app.

## Flutter SDK Integration

Follow the below steps to integrate Blaze SDK into your android application:

### Step 1: Obtaining the Blaze SDK

1.1. Adding the Blaze SDK dependency to your `pubspec.yaml` file.

Run following command to add blaze_sdk_flutter as a dependency to your flutter project

```bash
flutter pub add blaze_sdk_flutter
```

1.2. Include the repository for SDK Resolution to your project's `android/build.gradle` file.

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

### Step 2: Initialize the SDK

**2.1. Import the Blaze SDK package in your application class.**

```dart
  import 'package:blaze_sdk_flutter/blaze_sdk_flutter.dart';
```

**2.2. Create an instance of the `BlazeSdkFlutter` class in your application class.**

```kotlin
final _blaze = BlazeSdkFlutter();
```

**2.2. Initiate the Blaze instance. Preferably when Checkout page opens up or app launches.**

In order to call initiate you need to perform the following steps:

#### 2.2.1: Construct the Initiate Payload

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

#### 2.2.2: Construct the Callback Method

During the user journey the SDK will call the callback method with the result of the SDK operation.
You need to implement this method in order to handle the result of the SDK operation.

```dart
  void handleCallbackEvent(Map<String, dynamic> callbackEvent) {
    print("Callback Event: $callbackEvent");
  }
```

#### 2.2.3: Call the initiate method on Blaze Instance

Finally, call the initiate method on the Blaze instance with the payload and the callback method.
The first parameter is the context of the application.

```dart
  _blaze_.initiate(initiatePayload, handleCallbackEvent);
```

### Step 3: Start processing your requests

Once the SDK is initiated, you can start processing your requests using the initialized instance of the SDK.
The SDK will call the callback method with the result of the SDK operation.

#### 3.1: Construct the Process Payload

Create a Json payload with the required parameters to process the request.
The process payload differs based on the request.
Refer to schemas sections to understand what kind of data is required for different requests

```dart

// 3.1 Create SDK Process Payload
// Create a JSONObject for the Process data
Map<String, dynamic> createProcessPayload() {
  return {
    "action": "<ACTION>",
    // .. rest of the keys
  };
}


var processPayload = createSDKPayload(createProcessPayload());

```

#### 3.2: Call the process method on Blaze Instance

Call the process method on the Blaze instance with the process payload to start the user journey or a headless flow.

```dart
  _blaze_.process(processSDKPayload)
```
