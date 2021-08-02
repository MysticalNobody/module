import 'dart:async';

import 'package:camera/camera.dart';
import 'package:sensors/sensors.dart';
import 'smart_merch_accelerometer.dart';

/// Controls sensors data and device camera.
///
/// Before using [SmartMerchCameraController] a call to [initialize] must complete.

class SmartMerchCameraController {
  SmartMerchCameraController({
    required this.description,
    this.resolutionPreset = ResolutionPreset.max,
    this.imageFormatGroup,
  });

  /// True after [initialize] has completed successfully.
  bool get isInitialized => _initCompleter.isCompleted && _error == null;

  Object? _error;

  /// Complete when [initialize] has completed successfully.
  /// Complete with error when [initialize] has completed unsuccessfully.
  Completer _initCompleter = Completer();

  /// The controller user to access device camera
  ///
  /// See also: [CameraController]
  late CameraController cameraController;

  /// Takes photo
  ///
  /// See [CameraController.takePicture()]
  Future<XFile> takePicture() => cameraController.takePicture();

  /// The properties of the camera device
  ///
  /// See also: [CameraDescription] and [CameraController]
  final CameraDescription description;

  /// The resolution [CameraController] is targeting.
  ///
  /// This resolution preset is not guaranteed to be available on the device,
  /// if unavailable a lower resolution will be used.
  ///
  /// See also: [ResolutionPreset].
  final ResolutionPreset resolutionPreset;

  /// The [ImageFormatGroup] describes the output of the raw image format.
  ///
  /// When null the imageFormat will fallback to the platforms default.
  final ImageFormatGroup? imageFormatGroup;

  /// [Accelerometer.data] returns changing the positions of the device [x,y,z]
  final Accelerometer _accelerometer = Accelerometer();
  Stream<AccelerometerEvent> get accelerometer => _accelerometer.data;

  /// Initializes the camera and prepare sensors on the device.
  ///
  /// Throws a [SmartMerchExceptionType] if the initialization fails.
  Future<void> initialize() async {
    cameraController = CameraController(description, resolutionPreset,
        imageFormatGroup: imageFormatGroup);
    await cameraController.initialize();
    _initCompleter.complete();
  }
}
