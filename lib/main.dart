import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: QRViewScanner());
  }
}

class QRViewScanner extends StatefulWidget {
  const QRViewScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewScannerState();
}

class _QRViewScannerState extends State<QRViewScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _buildQrView(context),
        Positioned(bottom: 10, child: buildResult()),
      ],
    ));
  }

  // Result Show
  Widget buildResult() => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white24,
      ),
      child: Text(
        barcode != null ? 'Result: ${barcode!.code}' : 'Scan a code!',
        maxLines: 3,
      ));

  Widget _buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );
  void onQRViewCreated(QRViewController controller) {
    setState(() {
      controller.scannedDataStream.listen((barcode) => setState(() {
            this.barcode = barcode;
          }));
    });
  }
}
