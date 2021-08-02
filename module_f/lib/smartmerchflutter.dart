library smartmerchflutter;

export 'src/smart_merch_camera_controller.dart';
export 'src/smart_merch_camera_widget.dart';

import 'dart:async';

import 'package:flutter/services.dart';

class Smartmerchflutter {
  static const MethodChannel _channel =
      const MethodChannel('smartmerchflutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
