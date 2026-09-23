class DeviceNativeService {
  static Future<Map<String, dynamic>> pickDeviceContact() async {
    return {
      'success': false,
      'error': 'Native contact picker stub for mobile VM',
    };
  }

  static Future<Map<String, dynamic>> getLiveGpsCoordinates() async {
    return {
      'success': true,
      'lat': 12.9716,
      'lng': 77.5946,
      'accuracy': 15.0,
      'address': 'Current Mobile Device Location',
    };
  }

  static Future<Map<String, dynamic>> capturePhoto({bool preferCamera = true}) async {
    return {
      'success': false,
      'error': 'Native camera stub for mobile VM',
    };
  }
}
