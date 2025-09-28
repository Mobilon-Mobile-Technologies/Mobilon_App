import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../functions/reserve.dart';

class QRReservationPage extends StatefulWidget {
  const QRReservationPage({super.key});

  @override
  State<QRReservationPage> createState() => _QRReservationPageState();
}

class _QRReservationPageState extends State<QRReservationPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;
  String? lastScannedCode;

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
        // Check if already reserved
        final isReserved = await checkIfReserved(eventId);
        
        if (!isReserved) {
          // Already reserved
          if (mounted) {
            _showInfoDialog('You have already reserved this event!');
          }
        } else {
          // Not reserved yet, make reservation
          reserveEvent(eventId);
          
          if (mounted) {
            _showSuccessDialog('Event reserved successfully!');
          }
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Reservation failed: $e');
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
      if (qrData.startsWith('myapp://reserve?')) {
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
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(Icons.info, color: Colors.blue, size: 48),
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous screen
              },
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan to Reserve Event'),
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
                    'Scan event QR code to make a reservation',
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