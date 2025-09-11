import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PermissionService {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status == PermissionStatus.granted;
  }

  static Future<void> showPermissionDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onSettingsPressed,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          content: Text(
            message,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSettingsPressed();
              },
              style: AppTheme.primaryButtonStyle,
              child: Text(
                'Settings',
                style: AppTheme.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> requestAllRequiredPermissions() async {
    // Request camera permission (required for QR scanning)
    final cameraGranted = await requestCameraPermission();
    
    // Request storage permission (for caching and preferences)
    final storageGranted = await requestStoragePermission();
    
    return cameraGranted && storageGranted;
  }

  static Future<Map<String, bool>> checkAllPermissions() async {
    return {
      'camera': await checkCameraPermission(),
      'storage': await checkStoragePermission(),
      'location': await checkLocationPermission(),
    };
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
