import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blaze_sdk_flutter/blaze_sdk_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelBlazeSdkFlutter platform = MethodChannelBlazeSdkFlutter();
  const MethodChannel channel = MethodChannel('blaze_sdk_flutter');

  final List<MethodCall> log = [];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        log.add(methodCall);
        if (methodCall.method == 'handleBackPress') {
          return true;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('process sends the json-encoded payload over the channel', () async {
    await platform.process({'action': 'startCheckout'});
    await Future<void>.delayed(Duration.zero);

    expect(log, hasLength(1));
    expect(log.single.method, 'process');
    expect(jsonDecode(log.single.arguments as String),
        {'action': 'startCheckout'});
  });

  test('handleBackPress returns the platform value', () async {
    expect(await platform.handleBackPress(), isTrue);
    expect(log.single.method, 'handleBackPress');
  });

  test('terminate invokes the channel', () async {
    await platform.terminate();
    await Future<void>.delayed(Duration.zero);

    expect(log.single.method, 'terminate');
  });

  test('initiate sends the payload and receives blaze-callback events',
      () async {
    Map<String, dynamic>? received;
    await platform.initiate({'clientId': 'demo'}, (data) => received = data);
    await Future<void>.delayed(Duration.zero);

    expect(log.single.method, 'initiate');
    expect(jsonDecode(log.single.arguments as String), {'clientId': 'demo'});

    final ByteData message = const StandardMethodCodec().encodeMethodCall(
      MethodCall('blaze-callback', jsonEncode({'status': 'SUCCESS'})),
    );
    ServicesBinding.instance.channelBuffers
        .push('blaze_sdk_flutter', message, (_) {});
    await Future<void>.delayed(Duration.zero);

    expect(received, {'status': 'SUCCESS'});
  });
}
