import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelBlazeSdkFlutter platform = MethodChannelBlazeSdkFlutter();
  const MethodChannel channel = MethodChannel('blaze_sdk_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    // TODO: Add test code
  });
}
