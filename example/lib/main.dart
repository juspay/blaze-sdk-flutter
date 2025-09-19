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
      "merchantId": "d2cstore",
      "environment": "release",
      "shopUrl": "https://breeze-it-store.myshopify.com"
    };
  }

  void handleCallbackEvent(Map<String, dynamic> callbackEvent) {
    print("Callback Event: $callbackEvent");
  }

  Map<String, dynamic> createProcessPayload() {
    return {
      "action": "startCheckout",
      "cart": {
        "token":
            "hWN398h1MYYGTJK83e2rDznA?key=29cbc71d22b49a79cb8e25229de5813d",
        "note": "",
        "attributes": {},
        "original_total_price": 1400,
        "total_price": 1400,
        "total_discount": 0,
        "total_weight": 0.0,
        "item_count": 2,
        "items": [
          {
            "id": 44182614474984,
            "properties": {},
            "quantity": 2,
            "variant_id": 44182614474984,
            "key": "44182614474984:14a856f03fde63adbb7df3da56d64b10",
            "title": "Blackout Shirt - black",
            "price": 700,
            "original_price": 700,
            "presentment_price": 7.0,
            "discounted_price": 700,
            "line_price": 1400,
            "original_line_price": 1400,
            "total_discount": 0,
            "discounts": [],
            "sku": "1233",
            "grams": 0,
            "vendor": "Bombay Shirt Company",
            "taxable": true,
            "product_id": 8070198591720,
            "product_has_only_default_variant": false,
            "gift_card": false,
            "final_price": 700,
            "final_line_price": 1400,
            "url": "\/products\/blackout-shirt?variant=44182614474984",
            "featured_image": {
              "aspect_ratio": 1.0,
              "alt": "Blackout Shirt",
              "height": 1200,
              "url":
                  "https:\/\/cdn.shopify.com\/s\/files\/1\/0647\/6526\/4104\/products\/bmb1.webp?v=1670259737",
              "width": 1200
            },
            "image":
                "https:\/\/cdn.shopify.com\/s\/files\/1\/0647\/6526\/4104\/products\/bmb1.webp?v=1670259737",
            "handle": "blackout-shirt",
            "requires_shipping": true,
            "product_type": "",
            "product_title": "Blackout Shirt",
            "product_description": "Built for your adventures after dark.",
            "variant_title": "black",
            "variant_options": ["black"],
            "options_with_values": [
              {"name": "Color", "value": "black"}
            ],
            "line_level_discount_allocations": [],
            "line_level_total_discount": 0,
            "has_components": false
          }
        ],
        "requires_shipping": true,
        "currency": "INR",
        "items_subtotal_price": 1400,
        "cart_level_discount_applications": [],
        "discount_codes": []
      }
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
