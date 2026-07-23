import 'package:flutter_test/flutter_test.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter_platform_interface.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBlazeSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements BlazeSdkFlutterPlatform {
  final List<String> calls = [];
  Map<String, dynamic>? lastPayload;

  @override
  Future<void> initiate(Map<String, dynamic> payload,
      void Function(Map<String, dynamic>) callbackFn) async {
    calls.add('initiate');
    lastPayload = payload;
  }

  @override
  Future<void> process(Map<String, dynamic> payload) async {
    calls.add('process');
    lastPayload = payload;
  }

  @override
  Future<bool?> handleBackPress() async {
    calls.add('handleBackPress');
    return true;
  }

  @override
  Future<void> terminate() async {
    calls.add('terminate');
  }
}

void main() {
  final BlazeSdkFlutterPlatform initialPlatform =
      BlazeSdkFlutterPlatform.instance;

  test('$MethodChannelBlazeSdkFlutter is the default instance', () {
    expect(initialPlatform, isA<MethodChannelBlazeSdkFlutter>());
  });

  group('BlazeSdkFlutter delegates to the platform instance', () {
    late BlazeSdkFlutter plugin;
    late MockBlazeSdkFlutterPlatform fakePlatform;

    setUp(() {
      plugin = BlazeSdkFlutter();
      fakePlatform = MockBlazeSdkFlutterPlatform();
      BlazeSdkFlutterPlatform.instance = fakePlatform;
    });

    tearDown(() {
      BlazeSdkFlutterPlatform.instance = initialPlatform;
    });

    test('initiate', () async {
      await plugin.initiate({'clientId': 'demo'}, (_) {});
      expect(fakePlatform.calls, ['initiate']);
      expect(fakePlatform.lastPayload, {'clientId': 'demo'});
    });

    test('process', () async {
      await plugin.process({'action': 'startCheckout'});
      expect(fakePlatform.calls, ['process']);
      expect(fakePlatform.lastPayload, {'action': 'startCheckout'});
    });

    test('handleBackPress', () async {
      expect(await plugin.handleBackPress(), isTrue);
      expect(fakePlatform.calls, ['handleBackPress']);
    });

    test('terminate', () async {
      await plugin.terminate();
      expect(fakePlatform.calls, ['terminate']);
    });
  });
}
