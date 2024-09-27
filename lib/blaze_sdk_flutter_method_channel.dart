import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'blaze_sdk_flutter_platform_interface.dart';

class MethodChannelBlazeSdkFlutter extends BlazeSdkFlutterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('blaze_sdk_flutter');

  @override
  Future<void> initiate(Map<String, dynamic> payload,
      void Function(Map<String, dynamic>) callbackFn) async {
    registerCallback(callbackFn);
    methodChannel.invokeMethod<void>('initiate', jsonEncode(payload));
  }

  @override
  Future<void> process(Map<String, dynamic> payload) async {
    methodChannel.invokeMethod<void>('process', jsonEncode(payload));
  }

  @override
  Future<bool?> handleBackPress() async {
    return methodChannel.invokeMethod<bool>('handleBackPress');
  }

  @override
  Future<void> terminate() async {
    methodChannel.invokeMethod<void>('terminate');
  }

  void registerCallback(Function callbackFn) {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "blaze-callback") {
        callbackFn(call.arguments);
      }
    });
  }
}
