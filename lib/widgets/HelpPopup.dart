import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpPopup extends StatefulWidget {
  @override
  _HelpPopup createState() => _HelpPopup();
}

class _HelpPopup extends State<HelpPopup> {
  int slideNumber = 0;

  List<Container> contents = [
    Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 18),
              text:
                  ("Questa sezione dell'app serve a mostrare i campi sportivi che corrispondono alle tue necessità.\nCliccando sul tasto "),
              children: <TextSpan>[
                TextSpan(
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  text: "FILTRI ",
                ),
                TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    text:
                        "ti sarà permesso specificare quali caratteristiche dovranno avere i campi che poi saranno mostrati.")
              ]),
        )),
    Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 18),
            text:
                ("Sulla mappa i circoli nei quali sono presenti campi che rispettano i filtri applicati sono marcati in "),
            children: <TextSpan>[
              TextSpan(
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                text: "ROSSO \n\n",
              ),
              TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  text: "La tua posizione invece sarà marcata in "),
              TextSpan(
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                text: "BLU",
              ),
            ]
        ),
      ),
    ),
    Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 18),
              text: "Per accedere alla lista dei campi di uno specifico circolo bisognerà:\n\n",
            children: [
              TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                text: ("1) Cliccare sulla posizione del circolo sulla mappa.\n\n"
                    "2) Cliccare sul nome del circolo che verrà mostrato.")
              )
            ],
          )
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    String changeText;
    if(slideNumber == 0) changeText = "Chiudi";
      else if(slideNumber != 0) changeText = "Indietro";

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Card(
              elevation: 2.0,
              color: Colors.white, //Colore interno
              shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(children: [
                Expanded(
                  flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "GUIDA",
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: "sans-serif-medium",
                              fontSize: 25
                          ),
                        ),
                      )
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    alignment: Alignment.center,
                    child: contents[slideNumber],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(right: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              child: Text(changeText,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontSize: 18)),
                              onPressed: () {
                                slideNumber -= 1;
                                if (slideNumber == -1) {
                                  Navigator.pop(context);
                                } else {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text("Avanti",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontSize: 18)),
                              onPressed: () {
                                slideNumber += 1;
                                if (slideNumber == 3) {
                                  Navigator.pop(context);
                                } else {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ],
                      )
                  ),

                ),

              ])),
        ));
  }
}
