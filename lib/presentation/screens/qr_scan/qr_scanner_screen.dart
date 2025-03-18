// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// class QRCodeScanner extends StatefulWidget {
//   @override
//   _QRCodeScannerState createState() => _QRCodeScannerState();
// }

// class _QRCodeScannerState extends State<QRCodeScanner> {
//   String scannedResult = "No data scanned";

//   Future<void> startQRScanner() async {
//     try {
//       // Start scanning
//       String scanResult = await FlutterBarcodeScanner.scanBarcode(
//         "#ff6666", // Color for the scan line
//         "Cancel", // Cancel button text
//         true, // Show the flash icon
//         ScanMode.QR,
//       );

//       if (scanResult != "-1") {
//         setState(() {
//           scannedResult = scanResult;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         scannedResult = "Failed to scan QR code: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Code Scanner'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               scannedResult,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: startQRScanner,
//               child: const Text('Scan QR Code'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
