import 'package:sensors/sensors.dart';

class Accelerometer {
  Stream<AccelerometerEvent> get data => accelerometerEvents;
}