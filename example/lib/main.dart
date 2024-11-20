import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {}
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _blazeSdkFlutterPlugin = BlazeSdkFlutter();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  Map<String, dynamic> createSDKPayload(Map<String, dynamic> payload) {
    return {
      "requestId": "randomId",
      "service": "in.breeze.onecco",
      "payload": payload
    };
  }

  Map<String, dynamic> createInitiatePayload() {
    return {
      "merchantId": "d2cstorebeta",
      "environment": "beta",
      "shopUrl": "https://d2cstore-custom.vercel.app"
    };
  }

  void handleCallbackEvent(Map<String, dynamic> callbackEvent) {
    print("Callback Event: $callbackEvent");
  }

  Map<String, dynamic> createProcessPayload() {
    return {
      "action": "startCheckout",
      "cart":
          "{\"id\":\"7feaa429-308d-49b7-8461-46bfa4b37ff7\",\"items\":[{\"id\":\"3aecf419-6823-4581-a093-0c90c5b5e1fc\",\"title\":\"Apple iPhone 7 Plus\",\"variantTitle\":\"256 GB / GOLD\",\"image\":\"https://dfelk5npz6ka0.cloudfront.net/products/40767940985052.jpg\",\"quantity\":1,\"initialPrice\":100,\"finalPrice\":100,\"discount\":0}],\"initialPrice\":100,\"totalPrice\":100,\"totalDiscount\":0,\"itemCount\":1,\"currency\":\"INR\"}",
      "signature":
          "T4BRKwHKWfkWRLgF5ecss2+2tyID4zKVUqkfEgdFS73lyAokBq92VJRz4g+xzCcUE84ZNl7oQ9t26i8zGQLgh/B/6vNliM9u7VMX0soYDC9pEWd4TsWeetlYMzl/UIzitYan5q9aQ2UfS7HENHQGvGfOjsa75gP3SVwpufK8Sb1VFRFsnJKsXzgWq+y9iWLieJe596poEzUP2Wkt17mSGwH9rWukTy5S1ddZoZXUxDQiMtfXFj9NOnPDUA8psmERifivaD8IvhMEYwlEk+u6MrxF7IhasBs8dYGEZW+YDeaRz6mzK37sarYWgCUJgEYTJ97rmcRedgvnj+28YES/pw==",
      "keyId": "90701"
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Blaze Integration Sample!'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _blazeSdkFlutterPlugin.initiate(
                      createSDKPayload(createInitiatePayload()),
                      handleCallbackEvent);
                },
                child: const Text('Initiate SDK'),
              ),
              ElevatedButton(
                onPressed: () {
                  _blazeSdkFlutterPlugin
                      .process(createSDKPayload(createProcessPayload()));
                },
                child: const Text('Process'),
              ),
              ElevatedButton(
                onPressed: () {
                  _blazeSdkFlutterPlugin.terminate();
                },
                child: const Text('Terminate'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
