import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/services/permission_service.dart';
import 'ticket_details_screen.dart';

class QRScannerScreen extends ConsumerStatefulWidget {
  const QRScannerScreen({super.key});

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;
  bool hasPermission = false;
  bool permissionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _checkCameraPermission() async {
    final granted = await PermissionService.checkCameraPermission();
    setState(() {
      hasPermission = granted;
      permissionChecked = true;
    });
    
    if (!granted) {
      _requestCameraPermission();
    }
  }

  Future<void> _requestCameraPermission() async {
    final granted = await PermissionService.requestCameraPermission();
    setState(() {
      hasPermission = granted;
    });
    
    if (!granted) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    PermissionService.showPermissionDialog(
      context,
      title: 'Camera Permission Required',
      message: 'UCI KIGALI needs camera access to scan QR codes from tickets. Please enable camera permission in settings.',
      onSettingsPressed: () {
        PermissionService.openAppSettings();
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (isScanning) {
        setState(() {
          isScanning = false;
        });
        
        // Navigate to ticket details screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TicketDetailsScreen(
              ticketId: scanData.code ?? '',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!permissionChecked) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }

    if (!hasPermission) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Camera Permission'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: AppTheme.spacing24),
                Text(
                  'Camera Permission Required',
                  style: AppTheme.headlineSmall.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  'UCI KIGALI needs camera access to scan QR codes from tickets.',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing32),
                ElevatedButton(
                  onPressed: _requestCameraPermission,
                  style: AppTheme.primaryButtonStyle,
                  child: const Text('Grant Permission'),
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Go Back',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // QR Scanner View
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: AppTheme.primaryColor,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: AppConfig.qrScanAreaSize,
            ),
          ),
          
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    'Position the QR code within the frame',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    'The ticket will be automatically scanned',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          // Flashlight toggle
          Positioned(
            top: 100,
            right: AppTheme.spacing24,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.flashlight_on,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await controller?.toggleFlash();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
