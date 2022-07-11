import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  // declaring a global key
  final qrKey = GlobalKey(debugLabel: 'QR');

  // storing the detected barcode
  Barcode? barcode;

  // creating a qr view controller
  QRViewController? controller;

  // cleaning the controller after use
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // to fx the hot reload in android, so it works without any issues
  @override
  void reassemble() async {
    super.reassemble();

    // to pause the camera and resume the camera
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  // to display the scanned barcode at bottom
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('QR Code Generator'),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // method to display the result
              buildQrView(context),
              // to display the result at bottom
              Positioned(bottom: 10, child: buildResult()),
              // to display flash and camera button at top
              // Positioned(top: 10, child: buildControlButtons()),
            ],
          ),
        ),
      );

  // buildControlButtons method
  Widget buildControlButtons() => Container(
        // decorations for icons buttons
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // flash icon button
            IconButton(
              // to show the qr code on flash status, according to which the flash will know its on or off
              icon: FutureBuilder<bool?>(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                          snapshot.data! ? Icons.flash_on : Icons.flash_off);
                    } else {
                      return Container();
                    }
                  }),
              onPressed: () async {
                // using controller variable to turn the flash on / off
                await controller?.toggleFlash();
                setState(() {});
              },
            ),
            // camera icon button
            IconButton(
              // if camera is working, then show the camera icon
              icon: FutureBuilder(
                  future: controller?.getCameraInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return const Icon(Icons.switch_camera);
                    } else {
                      return Container();
                    }
                  }),
              // using controller variable to switch camera
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
            ),
          ],
        ),
      );

  // method buildResult
  Widget buildResult() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Text(
          barcode != null ? 'Result : ${barcode!.code}' : 'Scan a Code!',
          maxLines: 3,
        ),
      );

  // creating a qr view widget
  Widget buildQrView(BuildContext context) => QRView(
        // A key to access qrview
        key: qrKey,
        // defining a method onQRViewCreated
        onQRViewCreated: onQRViewCreated,
        // property overlay
        overlay: QrScannerOverlayShape(
          // decorations for scanning area
          borderColor: Colors.cyan,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  // creating a onQRViewCreated method
  void onQRViewCreated(QRViewController controller) {
    // storing the viewed qr image inside the state
    setState(() => this.controller = controller);

    // if qr view created first time then listen to it
    controller.scannedDataStream.listen(
      // to get the barcode back if camera has detected the barcode
      (barcode) => setState(() => this.barcode = barcode),
    );
  }
}
