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
      "environment": "sandbox",
      "shopUrl": "https://d2c-store-beta.myshopify.com"
    };
  }

  void handleCallbackEvent(Map<String, dynamic> callbackEvent) {
    print("Callback Event: $callbackEvent");
  }

  Map<String, dynamic> createProcessPayload() {
    return {
      "action": "startCheckout",
      "cart": {
        "token": "c1-473243a885065ad7c911dc334255d73e",
        "note": "",
        "attributes": {
          "bundleData": "-",
          "discountName": "-",
          "variant_ids": "-",
          "target_variant_ids": "-",
          "discount": "-"
        },
        "original_total_price": 100,
        "total_price": 100,
        "total_discount": 0,
        "total_weight": 0.0,
        "item_count": 1,
        "items": [
          {
            "id": 45938457084219,
            "properties": {},
            "quantity": 1,
            "variant_id": 45938457084219,
            "key": "45938457084219:7df34184-c212-44dc-8d8e-8954b890646d",
            "title": "Sony PS5 Digital Standalone",
            "price": 100,
            "original_price": 100,
            "discounted_price": 100,
            "line_price": 100,
            "original_line_price": 100,
            "total_discount": 0,
            "discounts": [],
            "sku": "",
            "grams": 0,
            "vendor": "Sony",
            "taxable": true,
            "product_id": 8561540628795,
            "product_has_only_default_variant": true,
            "gift_card": false,
            "final_price": 100,
            "final_line_price": 100,
            "url":
                "/products/sony-ps5-digital-standalone?variant=45938457084219",
            "featured_image": {
              "aspect_ratio": 1.0,
              "alt": "Sony PS5 Digital Standalone",
              "height": 679,
              "url":
                  "https://cdn.shopify.com/s/files/1/0684/1624/1979/files/51wPWj--fAL._SX679.jpg?v=1690641107",
              "width": 679
            },
            "image":
                "https://cdn.shopify.com/s/files/1/0684/1624/1979/files/51wPWj--fAL._SX679.jpg?v=1690641107",
            "handle": "sony-ps5-digital-standalone",
            "requires_shipping": true,
            "product_type": "",
            "product_title": "Sony PS5 Digital Standalone",
            "product_description":
                "Maximize your play sessions with near instant load times for installed PS5 games. The custom integration of the PS5 console's systems lets creators pull data from the SSD so quickly that they can design games in ways never before possible. Immerse yourself in worlds with a new level of realism as rays of light are individually simulated, creating true-to-life shadows and reflections in supported PS5 games. Play your favorite PS5 games on your stunning 4K TV. Enjoy smooth and fluid high frame rate gameplay at up to 120fps for compatible games, with support for 120Hz output on 4K displays. With an HDR TV, supported PS5 games display an unbelievably vibrant and lifelike range of colors. PS5 consoles support 8K Output, so you can play games on your 4320p resolution display. Immerse yourself in soundscapes where it feels as if the sound comes from every direction. Through your headphones or TV speakers your surroundings truly come alive with Tempest 3D AudioTech in supported games. Experience haptic feedback via the DualSense wireless controller in select PS5 titles and feel the effects and impact of your in-game actions through dynamic sensory feedback. Get to grips with immersive adaptive triggers, featuring dynamic resistance levels which simulate the physical impact of in-game activities in select PS5 games.",
            "variant_title": null,
            "variant_options": ["Default Title"],
            "options_with_values": [
              {"name": "Title", "value": "Default Title"}
            ],
            "line_level_discount_allocations": [],
            "line_level_total_discount": 0,
            "has_components": false
          }
        ],
        "requires_shipping": true,
        "currency": "INR",
        "items_subtotal_price": 100,
        "cart_level_discount_applications": []
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
                child: const Text('Initiate'),
              ),
              ElevatedButton(
                onPressed: () {
                  _blazeSdkFlutterPlugin
                      .process(createSDKPayload(createProcessPayload()));
                },
                child: const Text('Process'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
