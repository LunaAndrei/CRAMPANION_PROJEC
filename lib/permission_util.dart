import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> checkAndRequestPermission(Permission permission) async {
    var status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      var result = await permission.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      // Handle the case when the user has permanently denied the permission.
      // You might want to show a dialog or navigate to app settings.
      openAppSettings();
      return false;
    }
    return false;
  }

  static Future<void> checkAndRequestStoragePermission() async {
    await checkAndRequestPermission(Permission.storage);
  }
}
