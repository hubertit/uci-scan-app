import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
              cutOutBottomOffset: 120, // Adjusted to bring frame down a bit
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
            top: 20, // Moved closer to app bar
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
