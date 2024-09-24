import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'blaze_sdk_flutter_method_channel.dart';

abstract class BlazeSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a BlazeSdkFlutterPlatform.
  BlazeSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static BlazeSdkFlutterPlatform _instance = MethodChannelBlazeSdkFlutter();

  /// The default instance of [BlazeSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelBlazeSdkFlutter].
  static BlazeSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BlazeSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(BlazeSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
