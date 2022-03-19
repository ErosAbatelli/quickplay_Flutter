import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FiltersPopup extends StatefulWidget {

  //VALORI INIZIALI
  //COSI VEDIAMO COME SONO STATI IMPOSTATI I FILTRI IN PRECEDENZA
  final String Superficie;
  final String prezzo;
  final String distanza;
  final bool coperto;
  final bool docce;
  final bool riscaldamento;

  FiltersPopup(this.Superficie, this.prezzo, this.distanza, this.coperto,
      this.docce, this.riscaldamento);

  @override
  _FilterPopupState createState() => _FilterPopupState(Superficie,prezzo,distanza,coperto,docce,riscaldamento);

}

class _FilterPopupState extends State<FiltersPopup> {

  bool coperto = false;
  bool riscaldamento = false;
  bool docce = false;

  TextEditingController maxDistance = TextEditingController();
  TextEditingController maxPrice = TextEditingController();
  final FocusNode maxDistanceNode = FocusNode();
  final FocusNode maxPriceNode = FocusNode();

  List<String> _surfaces = [
    'Tutte',
    'Erba',
    'Cemento',
    'Terra rossa',
    'Erba sintetica',
    "Altro"
  ]; // Option 2
  String _selectedSurface = "Tutte";

  _FilterPopupState(this._selectedSurface, prezzo, distanza, this.coperto,
      this.docce, this.riscaldamento) {
    maxPrice.text = prezzo;
    maxDistance.text = distanza;
  }

  @override
  void dispose() {
    maxDistanceNode.dispose();
    maxPriceNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(

        padding: EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 15,
          right: 15,
        ),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                child: Text(
                  "FILTRI DI RICERCA",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "sans-serif-medium",
                      fontSize: 25
                  ),
                ),
              )
            ),
            Flexible(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: CheckboxListTile(
                            title: Text("Coperto",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),),
                            value: coperto,
                            onChanged: (value) {
                              setState(() {
                                coperto = value;
                              });
                            },
                          ))
                    ],
                  ),
                )
            ),
            Flexible(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: CheckboxListTile(
                            title: Text("Riscaldamento",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),),
                            value: riscaldamento,
                            onChanged: (value) {
                              setState(() {
                                riscaldamento = value;
                              });
                            },
                          )),
                    ],
                  ),
                )
            ),
            Flexible(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: CheckboxListTile(
                            title: Text("Docce",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),
                            ),
                            value: docce,
                            onChanged: (value) {
                              setState(() {
                                docce = value;
                              });
                            },
                          ))
                    ],
                  ),
                )
            ),
            Flexible(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                          child: Container(
                            child: Text("Distanza massima:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),),
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.white,
                              child: TextField(
                                focusNode: maxDistanceNode,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "sans-serif-thin",
                                    fontSize: 20
                                ),
                                onSubmitted: (_) {
                                  getFilter();
                                },
                                controller: maxDistance,
                                keyboardType: TextInputType.number,
                              ),
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: Text("Km",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),),
                          )
                      ),
                    ],
                  ),
                )
            ),
            Flexible(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          flex: 6,
                          child: Container(
                            child: Text("Prezzo massimo:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),),
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),
                              focusNode: maxPriceNode,
                              controller: maxPrice,
                              keyboardType: TextInputType.number,
                              onSubmitted: (_) {
                                getFilter();
                              },
                            ),
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: Text("€/h",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),),
                          )
                      ),
                    ],
                  ),
                )
            ),
            Flexible(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            child: Text("Superficie:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),),
                          )
                      ),
                      Expanded(
                          child: Container(
                            child: DropdownButton(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20
                              ),
                              value: _selectedSurface,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedSurface = newValue;
                                });
                              },
                              items: _surfaces.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          )
                      ),

                    ],
                  ),
                )
            ),
            Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () async {
                        getFilter();
                      },
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Colors.black26, width: 1.0)),
                      color: Colors.white,
                      child: Text(
                        "AGGIORNA",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sans-serif-thin",
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      )
    );
  }


  //Ritorno i filtri aggiornati alla pagina di partenza
  // aggiornaFiltri();
  getFilter(){
    Navigator.pop(context,{
      "coperto" : coperto,
      "docce" : docce,
      "riscaldamento" : riscaldamento,
      "distanza" : maxDistance.text,
      "prezzo" : maxPrice.text,
      "superficie" : _selectedSurface
    });
  }






}