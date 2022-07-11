import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String qrResult = "Not yet Scanned";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Scan"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Result",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                qrResult,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                padding: EdgeInsets.all(10.0),
                child: Text("SCAN QR CODE"),
                onPressed: () async {
                  String scaning = (await BarcodeScanner.scan()) as String;
                  setState(
                    () {
                      qrResult = scaning;
                    },
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.blue, width: 3.0),
                ),
              ),
            ],
          ),
        ));
  }
}
