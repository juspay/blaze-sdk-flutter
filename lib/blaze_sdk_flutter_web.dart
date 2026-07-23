import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'blaze_sdk_flutter_platform_interface.dart';

class BlazeSdkFlutterWeb extends BlazeSdkFlutterPlatform {
  bool _isSdkLoaded = false;
  final List<Map<String, dynamic>> _eventQueue = [];
  void Function(Map<String, dynamic>)? _callbackFn;
  JSObject? _core;

  BlazeSdkFlutterWeb() {
    loadBlaze();
  }

  static void registerWith(Registrar registrar) {
    BlazeSdkFlutterPlatform.instance = BlazeSdkFlutterWeb();
  }

  void loadBlaze() {
    final blazeSDKWebHolder =
        (web.document.createElement('script') as web.HTMLScriptElement)
          ..src = 'https://sdk.breeze.in/packages/blaze/0.1.0/cdn.js'
          ..type = 'text/javascript';

    blazeSDKWebHolder.addEventListener(
      'load',
      ((web.Event event) {
        _core = globalContext['BlazeSDKWeb'] as JSObject?;
        _isSdkLoaded = true;
        _flushEventQueue();
      }).toJS,
    );

    web.document.body!.appendChild(blazeSDKWebHolder);
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
    globalContext['blazeCallback'] = _coreCallbackHandler.toJS;
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

  @override
  Future<void> terminate() async {
    if (_isSdkLoaded) {
      _invokeCoreMethod('terminate', []);
    }
  }

  void _flushEventQueue() {
    final pendingEvents = List<Map<String, dynamic>>.from(_eventQueue);
    _eventQueue.clear();
    for (final event in pendingEvents) {
      final eventName = event['eventName'];
      final eventPayload = event['eventPayload'] as String;
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

  void _invokeCoreMethod(String method, List<String> args) {
    if (_core != null) {
      _core!.callMethodVarArgs(
          method.toJS, [for (final arg in args) arg.toJS]);
    }
  }

  void _coreCallbackHandler(String event) {
    try {
      final eventMap = jsonDecode(event);
      _callbackFn!(eventMap);
    } catch (e) {
      web.console.log('Error in callback handler: $e'.toJS);
    }
  }
}
