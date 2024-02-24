import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pakettakip/controller/input_controller.dart';
import 'package:pakettakip/main.dart';
import 'package:pakettakip/route_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCameraPage extends StatelessWidget {
  const QrCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Qr kodunu taratın",
              style: GoogleFonts.openSans(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: SafeArea(child: QRView(key: qrKey, onQRViewCreated: onQRViewCreated)),
      ),
    );
  }

  void onQRViewCreated(QRViewController p1) {
    p1.scannedDataStream.listen((scanData) {
      container.read(inputProvider).qr.text = scanData.code ?? "";
      print("qr=>${scanData.code}");

      if (container.read(routeProvider).location != "/bagadd"&&container.read(routeProvider).location != "/cantateslimet"&&container.read(routeProvider).location != "/cantateslimal") {
        container.read(routeProvider).pop();
      }
    });
  }
}
