
import 'blaze_sdk_flutter_platform_interface.dart';

class BlazeSdkFlutter {
  Future<String?> getPlatformVersion() {
    return BlazeSdkFlutterPlatform.instance.getPlatformVersion();
  }
}
