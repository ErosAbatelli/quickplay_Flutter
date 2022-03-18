import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:ui';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:quickplay/ViewModel/Auth_Handler.dart';
import 'package:quickplay/ViewModel/DB_Handler_Reservations.dart';
import 'package:quickplay/models/models.dart';
import 'package:quickplay/pages/QrCode/QrCode_generate.dart';
import 'package:quickplay/pages/SportDateSelection.dart';
import 'package:quickplay/pages/home_Menu.dart';


class VisualizzaPrenotazioni extends StatefulWidget {
  VisualizzaPrenotazioni(this.layoutInfo, {Key key, this.group}) : super(key: key);

  final GroupType group;
  final List<LayoutInfo> layoutInfo;

  @override
  _ListState createState() => _ListState(layoutInfo);
}

enum GroupType {
  simple,
  scroll,
}

class _ListState extends State<VisualizzaPrenotazioni> {
  var _direction = Axis.vertical;
  bool timeCountdown;
  double _itemExtend;

  List<LayoutInfo> layoutInfo = [];
  Map<String, dynamic> map;


  _ListState(List<LayoutInfo> prenotazioni) {
    layoutInfo = prenotazioni;
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
                        TextSpan(text: prenotazione.data,),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          )
                      ),
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
                    ])
            ),

          ],
        )),
        //circle avatar
        dense: true,
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
                            )
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
        body: Container(
          constraints: _direction == Axis.vertical
              ? null
              : BoxConstraints.tightForFinite(height: 100.0),
          child: Center(
            child: _bodyContent(),
          ),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() {

    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return HomeMenu();
      },
    ), (route) => false);
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
        setState(() {
        });
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


  Color getColor(LayoutInfo pren) {

    map = { pren.codice: timeCountdown, };

    map.keys.forEach((k) {
      print(k);
    });
    map.values.forEach((v) {
      print(v);
    });




    var giornoSplit = pren.data.split("-");
    String giornoFormatoAmericano = giornoSplit[2] + "-" + giornoSplit[1] + "-" + giornoSplit[0];

    int tsFine = DateTime.parse(giornoFormatoAmericano + " " + pren.oraFine).millisecondsSinceEpoch;
    int tsNow = DateTime.now().millisecondsSinceEpoch;

    if (tsFine < tsNow)
    {
      //Se quindi è scaduta parte il timer (timeCountdown = true;)
      timeCountdown = true;

      var splitOra = pren.oraFine.split(":");
      int oraInteger = int.parse(splitOra[0]);
      int scadenza = oraInteger + 2;


      if(oraInteger <= 21 )
        {
          print("Scadenza alle:" + scadenza.toString());
          if(scadenza >= (oraInteger + 2) )
            {
              map.update(pren.codice, (value) => timeCountdown);
              print(map);
            }

        }

      return Color.fromRGBO(255, 102, 102, 0.8);
    }
    else{
        timeCountdown = false;
        map.update(pren.codice, (value) => timeCountdown);
        print(map);


        _itemExtend = MediaQuery.of(context).size.height * 0.32;
        return Colors.white;
    }
  }

  TextButton getCopyBtn(LayoutInfo pren) {
    var giornoSplit = pren.data.split("-");
    String giornoFormatoAmericano =
        giornoSplit[2] + "-" + giornoSplit[1] + "-" + giornoSplit[0];
    int tsFine = DateTime.parse(giornoFormatoAmericano + " " + pren.oraFine)
        .millisecondsSinceEpoch;
    int tsNow = DateTime.now().millisecondsSinceEpoch;
    if (tsFine < tsNow) {
      return TextButton(onPressed: () {}, child: null);
    }
    return TextButton(
      child: RichText(
        text: WidgetSpan(child: Icon(Icons.copy), ),
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


  getRow(LayoutInfo pren) {
    var giornoSplit = pren.data.split("-");
    String giornoFormatoAmericano =
        giornoSplit[2] + "-" + giornoSplit[1] + "-" + giornoSplit[0];
    int tsFine = DateTime.parse(giornoFormatoAmericano + " " + pren.oraFine)
        .millisecondsSinceEpoch;
    int tsNow = DateTime.now().millisecondsSinceEpoch;

    if (tsFine < tsNow)
    {
      return Container(
            alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10,),
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
                          print(map);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QRCreatePage(map, layoutInfo)));
                        },
                        child: const Text(
                            'QR CODE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "sans-serif-medium",
                            )
                        )
                    ),
                    IconButton(
                      icon: Icon(Icons.qr_code_outlined,),

                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => QRCreatePage(map, layoutInfo)));
                      },
                    ),
                  ],
                ),
              ],
            )

          );
    } else {
      if (pren.prenotatoreEmail == Auth_Handler.CURRENT_USER.email) {
        return
          Container(
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => QRCreatePage(map, layoutInfo)));
                        },
                        child: const Text(
                            'QR CODE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "sans-serif-medium",
                            )
                        )
                    ),
                    IconButton(
                        icon: Icon(Icons.qr_code_outlined,),

                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => QRCreatePage(map, layoutInfo)));
                      },
                    ),
                  ],
                )
              ],
            )
          );

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

  Widget _item(Partecipante partecipante) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1),),
        child: ListTile(
            title: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Center(
                  child: Text(partecipante.nome.capitalize() +
                      " " +
                      partecipante.cognome.capitalize()),
                ))));
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Caricamento..")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

