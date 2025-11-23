import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../functions/reserve.dart';
import '../../constants/is_logged_in_as_admin.dart' as AdminStatus;

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;
  String? lastScannedCode;

  @override
  void initState() {
    super.initState();
    // Check if user is admin, if not redirect back
    if (!AdminStatus.is_admin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access denied: Admin privileges required'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  void _onQRScanned(BarcodeCapture capture) async {
    if (isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    
    final String? scannedData = barcodes.first.rawValue;
    if (scannedData == null || scannedData == lastScannedCode) return;
    
    setState(() {
      isProcessing = true;
      lastScannedCode = scannedData;
    });

    // Parse the QR code data
    final eventId = _extractEventId(scannedData);
    
    if (eventId != null) {
      try {
        // Mark the user as entered
        await addCheckinToSupabase(eventId);
        
        if (mounted) {
          _showSuccessDialog('Check-in successful!');
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Check-in failed: $e');
        }
      }
    } else {
      if (mounted) {
        _showErrorDialog('Invalid QR code format');
      }
    }
    
    // Reset processing after 2 seconds to allow new scans
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isProcessing = false;
          lastScannedCode = null;
        });
      }
    });
  }

  String? _extractEventId(String qrData) {
    try {
      // Check if it's our app's deep link format
      if (qrData.startsWith('myapp://checkin?')) {
        final uri = Uri.parse(qrData);
        return uri.queryParameters['event_id'];
      }
      
      // Check if it's ICS format (calendar event)
      if (qrData.contains('UID:')) {
        final uidMatch = RegExp(r'UID:(.+)').firstMatch(qrData);
        return uidMatch?.group(1)?.trim();
      }
      
      return null;
    } catch (e) {
      print('Error parsing QR data: $e');
      return null;
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(Icons.error, color: Colors.red, size: 48),
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Double-check admin status in build method
    if (!AdminStatus.is_admin) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Access Denied\nAdmin privileges required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                return const Icon(Icons.camera_front);
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onQRScanned,
          ),
          // Overlay with instructions
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  const Text(
                    'Point camera at QR code to mark entry',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (isProcessing) ...[
                    const SizedBox(height: 8),
                    const CircularProgressIndicator(color: Colors.blue),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}