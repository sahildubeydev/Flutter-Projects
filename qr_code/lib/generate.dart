import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Generate extends StatefulWidget {
  const Generate({Key? key}) : super(key: key);

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  String qrData = "https://github.com";
  final qrText = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            QrImage(data: qrData),
            SizedBox(height: 10),
            Text("Get your data/link to the QR CODE"),
            TextField(
              controller: qrText,
              decoration: InputDecoration(
                hintText: "Enter the Data/Link",
              ),
            ),
            SizedBox(height: 20.0),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              child: Text("GENERATE QR CODE"),
              onPressed: () {
                if (qrText.text.isEmpty) {
                  setState(() {
                    qrData = "https://flutter.dev";
                  });
                } else {
                  setState(() {
                    qrData = qrText.text;
                  });
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.blue, width: 3.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
