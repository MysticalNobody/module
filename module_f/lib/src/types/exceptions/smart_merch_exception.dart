enum SmartMerchExceptionType {
  /// Errors from device camera
  camera,

  /// Errors from device sensors
  sensors,

  /// Uncategorized or unexpected errors
  other
}

/// This is thrown when the [SmartMerch] plugin reports an error.
class SmartMerchException implements Exception {
  /// Creates a new camera exception with the given error code, description and [SmartMerchExceptionType].
  SmartMerchException(this.code, this.description,
      {this.type = SmartMerchExceptionType.other});

  /// Error code for [SmartMerchException]
  ///
  /// if type is [SmartMerchExceptionType.camera]
  ///
  /// See: https://github.com/flutter/flutter/issues/69298#issuecomment-846599036
  ///
  /// else
  /// TODO: document other error codes

  String code;

  /// Error type
  ///
  /// See [SmartMerchExceptionType]
  SmartMerchExceptionType type;

  /// Textual description of the error.
  String? description;

  @override
  String toString() => 'SmartMerchException($type, $code, $description)';
}
