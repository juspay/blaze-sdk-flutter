import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'blaze_sdk_flutter_platform_interface.dart';

class BlazeSdkFlutterWeb extends BlazeSdkFlutterPlatform {
  BlazeSdkFlutterWeb();

  static void registerWith(Registrar registrar) {
    BlazeSdkFlutterPlatform.instance = BlazeSdkFlutterWeb();
  }
}
