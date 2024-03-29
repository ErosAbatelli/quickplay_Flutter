import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:quickplay/models/models.dart';
import 'package:quickplay/pages/ReservationList.dart';

class QRCreatePage extends StatefulWidget {
  String codice;
  String oraFine;
  String data;
  List<LayoutInfo> layoutInfo = [];

  QRCreatePage(this.codice, this.layoutInfo, this.oraFine, this.data, {Key key})
      : super(key: key);

  @override
  _QRCreatePageState createState() =>
      _QRCreatePageState(codice, layoutInfo, oraFine, data);
}

class _QRCreatePageState extends State<QRCreatePage> {
  String data;
  String oraFine;
  String codice;
  List<LayoutInfo> layoutInfo = [];

  _QRCreatePageState(this.codice, this.layoutInfo, this.oraFine, this.data);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: AppBar(
              backgroundColor: Colors.white,
            ).preferredSize,
            child: SafeArea(
              child: PreferredSize(
                  preferredSize: Size.fromHeight(100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
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
                    ],
                  )),
            ),
          ),
          body: getQRCODE(),
        ),
      );

  getQRCODE() {
    DateTime oggi = DateTime.now();
    String formattedDateToday = DateFormat('dd-MM-yyyy').format(oggi);
    TimeOfDay oraScadenzaTime;
    TimeOfDay _oraFineSplit = TimeOfDay(
        hour: int.parse(oraFine.split(":")[0]),
        minute: int.parse(oraFine.split(":")[1]));

    TimeOfDay _timenow = TimeOfDay.now();
    if (_timenow.hour < 22) {
      oraScadenzaTime =
          _timenow.replacing(hour: _timenow.hour + 2, minute: _timenow.minute);
    }
    if (_timenow.hour == 22) {
      oraScadenzaTime = _timenow.replacing(
          hour: _timenow.hour + 1, minute: _timenow.minute);
    }
    if (_timenow.hour == 23) {
      oraScadenzaTime =
          _timenow.replacing(hour: _timenow.hour, minute: _timenow.minute + 59);
    }
    if (_timenow.hour == 24) {
      oraScadenzaTime =
          _timenow.replacing(hour: _timenow.hour, minute: _timenow.minute);
    }


    int oraFineSplit = _oraFineSplit.hour * 60 + _oraFineSplit.minute;
    int oraScadenza = oraScadenzaTime.hour * 60 + oraScadenzaTime.minute;

    print(oraScadenzaTime);
    print(oraScadenza);

    print(_oraFineSplit);
    print(oraFineSplit);

    if (formattedDateToday.compareTo(data) > 0) {
      return getBodyQrCode();
    } else if (formattedDateToday.compareTo(data) < 0) {
      return getBody();
    } else if (formattedDateToday.compareTo(data) == 0 && oraScadenza < oraFineSplit) {
      return getBody();
    } else if (formattedDateToday.compareTo(data) == 0 && oraScadenza > oraFineSplit) {
      return getBodyQrCode();
    }
  }

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return VisualizzaPrenotazioni();
      },
    ), (route) => false);
  }

  Widget getBodyQrCode() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              child: Text(
                "QR CODE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "sans-serif-thin",
                  fontSize: 40,
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(24),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              alignment: Alignment.center,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                color: Colors.black,
                data: codice,
                width: 200,
                height: 200,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            child: Text(
              "PRENOTAZIONE SCADUTA",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "sans-serif-thin",
                fontSize: 30,
              ),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(24),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Il tempo limite per confermare la presenza nel circolo è di 2 ore!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "sans-serif-thin",
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(),
        ),
      ],
    );
  }
}
