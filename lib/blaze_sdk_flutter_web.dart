import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'dart:js_util' as js_util;
import 'dart:js' as js;

import 'blaze_sdk_flutter_platform_interface.dart';

class BlazeSdkFlutterWeb extends BlazeSdkFlutterPlatform {
  bool _isSdkLoaded = false;
  final List<Map<String, dynamic>> _eventQueue = [];
  void Function(Map<String, dynamic>)? _callbackFn;
  dynamic _core;

  BlazeSdkFlutterWeb() {
    loadBlaze();
  }

  static void registerWith(Registrar registrar) {
    BlazeSdkFlutterPlatform.instance = BlazeSdkFlutterWeb();
  }

  void loadBlaze() {
    final blazeSDKWebHolder = html.ScriptElement()
      ..src = 'https://sdk.breeze.in/packages/blaze/0.0.4/cdn.js'
      ..type = 'text/javascript';

    blazeSDKWebHolder.onLoad.listen((event) {
      _core = js_util.getProperty(js_util.globalThis, 'BlazeSDKWeb');
      _isSdkLoaded = true;
      _flushEventQueue();
    });

    html.document.body!.append(blazeSDKWebHolder);
  }

  @override
  Future<void> initiate(Map<String, dynamic> payload,
      void Function(Map<String, dynamic>) callbackFn) async {
    final payloadString = jsonEncode(payload);
    if (_isSdkLoaded) {
      _invokeCoreMethod('initiate', [payloadString]);
    } else {
      _eventQueue.add({'eventName': 'initiate', 'eventPayload': payloadString});
    }
    _callbackFn = callbackFn;
    final blazeCallback = js.allowInterop(_coreCallbackHandler);
    js_util.setProperty(js_util.globalThis, 'blazeCallback', blazeCallback);
  }

  @override
  Future<void> process(dynamic payload) async {
    final payloadString = jsonEncode(payload);
    if (_isSdkLoaded) {
      _invokeCoreMethod('process', [payloadString]);
    } else {
      _eventQueue.add({'eventName': 'process', 'eventPayload': payloadString});
    }
  }

  void _flushEventQueue() {
    final pendingEvents = _eventQueue;
    _eventQueue.clear();
    for (final event in pendingEvents) {
      final eventName = event['eventName'];
      final eventPayload = event['eventPayload'];
      switch (eventName) {
        case 'initiate':
          _invokeCoreMethod("initiate", [eventPayload]);
          break;
        case 'process':
          _invokeCoreMethod("process", [eventPayload]);
          break;
        default:
          break;
      }
    }
  }

  void _invokeCoreMethod(String method, List<dynamic> args) {
    if (_core != null) {
      js_util.callMethod(_core, method, args);
    }
  }

  void _coreCallbackHandler(String event) {
    try {
      final eventMap = jsonDecode(event);
      _callbackFn!(eventMap);
    } catch (e) {
      html.window.console.log('Error in callback handler: $e');
    }
  }
}
