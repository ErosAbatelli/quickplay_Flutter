import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:quickplay/pages_club/Home_Menu_Club.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new GestureDetector(
                      onTap: onBackPressed,
                      child: SizedBox(
                        width: 30,
                        child: Container(
                            margin: EdgeInsets.only(
                              left: 10,
                              top: 5,
                            ),
                            child: IconButton(
                              color: Colors.black,
                              icon: Icon(
                                Icons.arrow_back_ios,
                              ),
                              onPressed: onBackPressed,
                            )),
                      ),
                    )
                  ],
                )),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Text("Scannerizza prenotazione",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    fontFamily: "sans-serif-thin",
                  ),),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  color: Colors.blue,
                  child: Text(
                    '$qrCode',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  child: RaisedButton(
                    child: Text(
                      "SCAN",
                      style: TextStyle(fontSize: 17),
                    ),
                    shape: StadiumBorder(),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () => scanQRCode(),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              )
            ],
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return HomeMenuClub();
      },
    ), (route) => false);
  }
}
