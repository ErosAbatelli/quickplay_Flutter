import 'dart:async';
import 'dart:ui';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:quickplay/ViewModel/Auth_Handler.dart';
import 'package:quickplay/ViewModel/DB_Handler_Reservations.dart';
import 'package:quickplay/ViewModel/DB_Handler_Users.dart';
import 'package:quickplay/models/models.dart';
import 'package:quickplay/pages/QrCode/QrCode_generate.dart';
import 'package:quickplay/pages/SportDateSelection.dart';
import 'package:quickplay/pages/home_Menu.dart';
import 'package:quickplay/utils/skeletonLoading.dart';

import 'ClubSelection.dart';

class VisualizzaPrenotazioni extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<VisualizzaPrenotazioni> {
  var _direction = Axis.vertical;
  bool isLoading = false;
  double _itemExtend;
  static const double defaultPadding = 10.0;
  int tsNow = DateTime.now().millisecondsSinceEpoch;
  int tsFine;
  List<LayoutInfo> layoutInfo = [];

  @override
  void initState() {
    setState(() {
      isLoading = true;
      _checkReservetionList();
    });
  }

  _checkReservetionList() async {
    var prenotazioni = await DB_Handler_Users.getReservations(Auth_Handler.CURRENT_USER.email);
    await Future.forEach(prenotazioni, (element) async {
      LayoutInfo info =
          await DB_Handler_Reservations.getReservationLayoutInfo(element);
      layoutInfo.add(info);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          body: isLoading
              ? Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: isLoading,
                    child: ListView.builder(
                      itemBuilder: (_, __) => _getBody(),
                      itemCount: 6,
                    ),
                  )
              : _bodyContent()),
      onWillPop: onBackPressed,
    );
  }

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.32,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _bodyContent() {
    if (layoutInfo.isEmpty) {
      return Container(
          child: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
            child: Text(
              "Nessuna prenotazione ancora registrata",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "sans-serif-medium",
              ),
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange,
              textStyle: TextStyle(
                fontFamily: "sans-serif-medium",
              ),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Selezione1()));
            },
            child: Text("Effettua una prenotazione ora"),
          )
        ],
      ));
    }
    return ListView.builder(
      scrollDirection: _direction,
      itemCount: layoutInfo.length,
      itemExtent: _itemExtend,
      itemBuilder: (context, index) {
        return Container(
          alignment: AlignmentDirectional.center,
          color: Colors.white,
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * 0.9,
          child: _itemTitle(layoutInfo[index]),
        );
      },
    );
  }

  Widget _itemTitle(LayoutInfo prenotazione) {
    Color backgroung = getColor(prenotazione);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 7), // changes position of shadow
            ),
          ],
          color: backgroung,
          border: Border.all(color: Colors.black38, width: 2)),
      child: ListTile(
        title: Container(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 2,
              ),
              child: Text(
                prenotazione.circolo,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontFamily: "sans-serif-medium",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "sans-serif-thin",
                      ),
                      text: "Campo n°: ",
                      children: [
                    TextSpan(
                      text: prenotazione.campo,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "sans-serif-thin",
                      ),
                    )
                  ])),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 2,
              ),
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "sans-serif-thin",
                      ),
                      text: "Giorno: ",
                      children: [
                    TextSpan(
                      text: prenotazione.data,
                    ),
                  ])),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 2,
              ),
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "sans-serif-thin",
                      ),
                      text: "Dalle: ",
                      children: [
                    TextSpan(text: prenotazione.orainizio),
                    TextSpan(text: " alle: "),
                    TextSpan(text: prenotazione.oraFine),
                  ])),
            ),
            getRow(prenotazione),
            Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                  onPressed: () {
                    showCancelDialog(context, prenotazione);
                  },
                  child: Text(
                    "Cancella",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        fontFamily: 'WorkSansMedium'),
                  )),
              TextButton(
                  onPressed: () async {
                    showLoaderDialog(context);
                    DB_Handler_Reservations.getPartecipanti(
                      prenotazione.codice,
                    ).then((value) {
                      Navigator.of(context).pop();
                      showPartecipanti(value);
                    });
                  },
                  child: const Text(
                    'Partecipanti',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        fontFamily: 'WorkSansMedium'),
                  ))
            ])),
          ],
        )),
        //circle avatar
        dense: true,
      ),
    );
  }

  getRow(LayoutInfo pren) {
    tsFine = get_tsFine(pren);

    if (tsFine < tsNow) {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: 10,
          ),
          child: Column(
            children: [
              Text(
                "Prenotazione scaduta!".toUpperCase(),
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "sans-serif-medium",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRCreatePage(pren.codice,
                                    layoutInfo, pren.oraFine, pren.data)));
                      },
                      child: const Text('QR CODE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "sans-serif-medium",
                          ))),
                  IconButton(
                    icon: Icon(
                      Icons.qr_code_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRCreatePage(pren.codice,
                                  layoutInfo, pren.oraFine, pren.data)));
                    },
                  ),
                ],
              ),
            ],
          ));
    } else {
      if (pren.prenotatoreEmail == Auth_Handler.CURRENT_USER.email) {
        return Container(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Codice: ",
                  style: TextStyle(
                    fontFamily: "sans-serif-medium",
                  ),
                ),
                Text(
                  pren.codice,
                  style: TextStyle(
                    fontFamily: "sans-serif-medium",
                  ),
                ),
                getCopyBtn(pren)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRCreatePage(pren.codice,
                                  layoutInfo, pren.oraFine, pren.data)));
                    },
                    child: const Text('QR CODE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "sans-serif-medium",
                        ))),
                IconButton(
                  icon: Icon(
                    Icons.qr_code_outlined,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRCreatePage(pren.codice,
                                layoutInfo, pren.oraFine, pren.data)));
                  },
                ),
              ],
            )
          ],
        ));
      } else {
        return Container(
          child: Column(
            children: [
              Text("Organizzatore :"),
              Text(
                pren.prenotatoreNome,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
        );
      }
    }
  }

  Color getColor(LayoutInfo pren) {
    tsFine = get_tsFine(pren);

    if (tsFine < tsNow) {
      return Color.fromRGBO(255, 102, 102, 0.8);
    } else {
      _itemExtend = MediaQuery.of(context).size.height * 0.32;
      return Colors.white;
    }
  }

  Widget _item(Partecipante partecipante) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: ListTile(
            title: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Center(
                  child: Text(partecipante.nome.capitalize() +
                      " " +
                      partecipante.cognome.capitalize()),
                ))));
  }

  /** METODI SHOW **/

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return HomeMenu();
      },
    ), (route) => false);
  }

  int get_tsFine(LayoutInfo pren) {
    var giornoSplit = pren.data.split("-");
    String giornoFormatoAmericano =
        giornoSplit[2] + "-" + giornoSplit[1] + "-" + giornoSplit[0];
    return tsFine = DateTime.parse(giornoFormatoAmericano + " " + pren.oraFine)
        .millisecondsSinceEpoch;
  }

  TextButton getCopyBtn(LayoutInfo pren) {
    tsFine = get_tsFine(pren);

    if (tsFine < tsNow) {
      return TextButton(onPressed: () {}, child: null);
    }
    return TextButton(
      child: RichText(
        text: WidgetSpan(
          child: Icon(Icons.copy),
        ),
      ),
      onPressed: () {
        ClipboardManager.copyToClipBoard(pren.codice);
        final snackBar = SnackBar(
          content: Text('Copiato negli appunti'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }

  showCancelDialog(BuildContext context, LayoutInfo prenotazione) {
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Si"),
      onPressed: () {
        Navigator.of(context).pop();
        DB_Handler_Reservations.deleteReservation(prenotazione.codice);
        layoutInfo.remove(prenotazione);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ATTENZIONE"),
      content: Text("Cancellare la prenotazione?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showPartecipanti(List<Partecipante> partecipanti) {
    AlertDialog alert = AlertDialog(
        scrollable: true,
        contentPadding: EdgeInsets.only(left: 25, right: 25),
        title: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 5),
            child: Text("Partecipanti")),
        content: getAlertContent(partecipanti));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getAlertContent(List<Partecipante> partecipanti) {
    if (partecipanti.isEmpty) {
      return Container(
        margin: EdgeInsets.all(30),
        child: Text("Nessun partecipante oltre all'organizzatore"),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.width * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
          itemCount: partecipanti.length,
          itemBuilder: (context, index) {
            return _item(partecipanti[index]);
          },
        ),
      );
    }
  }
}
