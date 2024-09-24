import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'blaze_sdk_flutter_platform_interface.dart';

/// An implementation of [BlazeSdkFlutterPlatform] that uses method channels.
class MethodChannelBlazeSdkFlutter extends BlazeSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('blaze_sdk_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
