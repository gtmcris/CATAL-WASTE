// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class ScanCodePage extends StatefulWidget {
//   const ScanCodePage({Key? key});

//   @override
//   State<ScanCodePage> createState() => _ScanCodePageState();
// }

// class _ScanCodePageState extends State<ScanCodePage> {
//   String? scannedCode;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan QR Code'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.popAndPushNamed(context, "/generate");
//             },
//             icon: const Icon(
//               Icons.qr_code,
//             ),
//           ),
//         ],
//       ),
//       body: MobileScanner(
//         controller: MobileScannerController(
//           detectionSpeed: DetectionSpeed.noDuplicates,
//           returnImage: true,
//         ),
//         onDetect: (capture) {
//           final List<Barcode> barcodes = capture.barcodes;
//           final Uint8List? image = capture.image;
//           if (barcodes.isNotEmpty) {
//             setState(() {
//               scannedCode = barcodes.first.rawValue;
//             });
//             if (image != null) {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: Text(
//                       'Scanned QR Code',
//                     ),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           scannedCode ?? 'No QR code detected',
//                         ),
//                         SizedBox(height: 10),
//                         Image.memory(image),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }