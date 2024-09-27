import 'blaze_sdk_flutter_platform_interface.dart';

class BlazeSdkFlutter {
  Future<void> initiate(Map<String, dynamic> payload,
      void Function(Map<String, dynamic>) callbackFn) {
    return BlazeSdkFlutterPlatform.instance.initiate(payload, callbackFn);
  }

  Future<void> process(Map<String, dynamic> payload) {
    return BlazeSdkFlutterPlatform.instance.process(payload);
  }

  Future<bool?> handleBackPress() {
    return BlazeSdkFlutterPlatform.instance.handleBackPress();
  }

  Future<void> terminate() {
    return BlazeSdkFlutterPlatform.instance.terminate();
  }
}
