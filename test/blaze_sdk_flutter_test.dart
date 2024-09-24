import 'package:flutter_test/flutter_test.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter_platform_interface.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBlazeSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements BlazeSdkFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BlazeSdkFlutterPlatform initialPlatform = BlazeSdkFlutterPlatform.instance;

  test('$MethodChannelBlazeSdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBlazeSdkFlutter>());
  });

  test('getPlatformVersion', () async {
    BlazeSdkFlutter blazeSdkFlutterPlugin = BlazeSdkFlutter();
    MockBlazeSdkFlutterPlatform fakePlatform = MockBlazeSdkFlutterPlatform();
    BlazeSdkFlutterPlatform.instance = fakePlatform;

    expect(await blazeSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
