import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'blaze_sdk_flutter_method_channel.dart';

abstract class BlazeSdkFlutterPlatform extends PlatformInterface {
  BlazeSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static BlazeSdkFlutterPlatform _instance = MethodChannelBlazeSdkFlutter();

  static BlazeSdkFlutterPlatform get instance => _instance;

  static set instance(BlazeSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initiate(Map<String, dynamic> payload,
      void Function(Map<String, dynamic>) callbackFn) {
    throw UnimplementedError('initiate() has not been implemented.');
  }

  Future<void> process(Map<String, dynamic> payload) {
    throw UnimplementedError('process() has not been implemented.');
  }

  Future<bool?> handleBackPress() {
    throw UnimplementedError('handleBackPress() has not been implemented.');
  }

  Future<void> terminate() {
    throw UnimplementedError('terminate() has not been implemented.');
  }
}
