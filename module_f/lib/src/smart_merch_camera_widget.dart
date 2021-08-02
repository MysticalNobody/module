import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'smart_merch_camera_controller.dart';

import 'types/exceptions/smart_merch_exception.dart';

/// A widget showing camera scene
///
/// [title] is a title which displayed on scene
class SmartMerchCameraWidget extends StatefulWidget {
  const SmartMerchCameraWidget({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  _SmartMerchCameraWidgetState createState() => _SmartMerchCameraWidgetState();
}

class _SmartMerchCameraWidgetState extends State<SmartMerchCameraWidget>
    with WidgetsBindingObserver {
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  late SmartMerchCameraController controller;

  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      controller.cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initController();
    }
  }

  Future<void> initController() async {
    _isLoading.value = true;
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw SmartMerchException(
        'cameraNotFound',
        "Camera not found. Please call the 'create' method before calling 'initialize'.",
        type: SmartMerchExceptionType.camera,
      );
    } else {
      final frontCameraIndex = cameras
          .indexWhere((cam) => cam.lensDirection == CameraLensDirection.back);
      if (frontCameraIndex > -1) {
        controller =
            SmartMerchCameraController(description: cameras[frontCameraIndex]);
      } else {
        controller = SmartMerchCameraController(description: cameras.first);
      }
      try {
        await controller.initialize();
      } on CameraException catch (e) {
        throw SmartMerchException(
          e.code,
          e.description,
          type: SmartMerchExceptionType.camera,
        );
      }
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return Center(
              child: SizedBox(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final padding = (size.width -
                controller.cameraController.value.previewSize!.height);
            return SafeArea(
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: CameraPreview(controller.cameraController)),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 38.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: isLandscape
                            ? size.width * 0.1 + padding
                            : size.width * 0.1,
                        bottom: size.height * 0.03),
                    child: SizedBox(
                      height: size.height,
                      width: 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.yellow.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: isLandscape
                            ? size.width * 0.9 - padding
                            : size.width * 0.9,
                        bottom: size.height * 0.03),
                    child: SizedBox(
                      height: size.height,
                      width: 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.yellow.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  //todo transform logic
                  Center(
                    child: SizedBox(
                      height: 5,
                      width: size.width,
                      child: DecoratedBox(
                        decoration:
                            BoxDecoration(color: Colors.red.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: GestureDetector(
                      onTap: () {
                        //todo
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Icon(Icons.close, size: 40)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: isLandscape
                        ? Alignment.centerRight
                        : Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        //todo
                      },
                      child: Padding(
                        padding: isLandscape
                            ? const EdgeInsets.only(right: 12.0)
                            : const EdgeInsets.only(bottom: 50.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          // margin: EdgeInsets.all(100.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              color: Colors.redAccent,
                              shape: BoxShape.circle),
                          child:
                              Icon(Icons.lock, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white),
                      child: StreamBuilder<AccelerometerEvent>(
                          stream: controller.accelerometer,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'x: ${snapshot.data!.x.toStringAsFixed(5)}, y: ${snapshot.data!.y.toStringAsFixed(5)}, z: ${snapshot.data!.z.toStringAsFixed(5)}',
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              );
                            }
                            return Container();
                          }),
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
