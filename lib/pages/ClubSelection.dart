import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:quickplay/ViewModel/DB_Handler_Clubs.dart';
import 'package:quickplay/models/models.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickplay/widgets/snackbar.dart';
import 'package:quickplay/widgets/HelpPopup.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'ClubDetail.dart';

class EffettuaPrenotazione extends StatefulWidget {
  const EffettuaPrenotazione({Key key, this.campiPerSport, this.data})
      : super(key: key);
  @override
  final List<Court> campiPerSport;
  final DateTime data;

  _EffettuaPrenotazione createState() =>
      _EffettuaPrenotazione(campiPerSport, data);
}

class _EffettuaPrenotazione extends State<EffettuaPrenotazione> {
  _EffettuaPrenotazione(this.campiPerSport, this.data);
  List<Court> campiPerSport = [];

  List<String> _surfaces = [
    'Tutte',
    'Erba',
    'Cemento',
    'Terra rossa',
    'Erba sintetica',
    "Altro"
  ]; // Option 2

  DateTime data;
  TextEditingController maxDistance = TextEditingController();
  TextEditingController maxPrice = TextEditingController();
  final FocusNode maxDistanceNode = FocusNode();
  final FocusNode maxPriceNode = FocusNode();
  final panelController = PanelController();
  final double tabBarHeight = 70;
  bool coperto = false;
  bool riscaldamento = false;
  bool docce = false;
  String distanza;
  String prezzo;
  String _selectedSurface = "Tutte";
  Set<Marker> clubMarkers = Set();
  LatLng _center = LatLng(43.586751779797915, 13.51659500105265);
  ScrollController scrollController;
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    distanza = "70";
    prezzo = "";
    super.initState();
  }

  Future<bool> onBackPressed() {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    if (clubMarkers.isEmpty) {
      aggiornaFiltri();
    }

    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              markers: clubMarkers,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.7,
              right: MediaQuery.of(context).size.width * 0.65,
              child: FloatingActionButton.extended(
                heroTag: "btn2",
                backgroundColor: const Color.fromRGBO(114, 180, 71, 1),
                foregroundColor: Colors.black,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => HelpPopup());
                },
                icon: Icon(Icons.help),
                label: Text('AIUTO'),
              ),
            ),
            SlidingUpPanel(
              onPanelClosed: () => FocusScope.of(context).unfocus(),
              controller: panelController,
              backdropEnabled: true,
              minHeight: 85,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              collapsed: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.topCenter,
                        child: buildDragIcon(),
                      )),
                      Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.topCenter,
                            child: Text(
                              "FILTRI",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: "sans-serif-medium",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                    ],
                  )),
              panel: getPanel(),
            ),
          ],
        ),
      ),
    );
  }

  //legge i filtri e chiama il metodo che restituisce i circoli corrispondenti
  void aggiornaFiltri() async {
    await Geolocator.isLocationServiceEnabled().then((value) async {
      if (!value) {
        showDialog(context: context, builder: buildGeolocatorAlert1)
            .then((value) {
          Navigator.pop(context);
        });
      } else {
        await Geolocator.checkPermission().then((value) async {
          showLoaderDialog(context);
          if (value == LocationPermission.denied) {
            showDialog(context: context, builder: buildGeolocatorAlert2)
                .then((value) {
              Navigator.pop(context);
            });
          } else {
            var myPos = await Geolocator.getCurrentPosition();
            //Usiamo una callback in quanto dobbiamo ritornare sia i circoli che i campi corrispondenti
            // ( Per ogni circolo non è detto che tutti i campi siano accettabili )
            var prezzoInt;
            var distanzaInt;
            clubMarkers.clear();
            try {
              if (prezzo != "") {
                prezzoInt = int.parse(prezzo);
              } else {
                prezzoInt = 100000000;
              }
              if (distanza != "") {
                distanzaInt = int.parse(distanza);
              } else {
                distanzaInt = 100000000;
              }
            } catch (e) {
              CustomSnackBar(context, const Text("Filtri non validi"));
              return null;
            }
            await DB_Handler_Clubs.getFilteredClubsAndCourt(
                distanzaInt,
                prezzoInt,
                docce,
                riscaldamento,
                coperto,
                _selectedSurface,
                campiPerSport, (circoli, campi) async {
              Position clubPos;
              circoli.forEach((element) {
                clubMarkers.add(Marker(
                    markerId: MarkerId(element.id.toString()),
                    infoWindow: InfoWindow(
                        title: element.nome,
                        onTap: () {
                          //CAMBIO SCREEN sul campo element.id.toString

                          //Seleziono i campi da inviare alla schermata di scelta del campo
                          List<Court> campiDaInviare = [];
                          campi.forEach((campo) {
                            if (campo.codClub == element.id) {
                              campiDaInviare.add(campo);
                            }
                          });
                          //Invio i campi
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClubDetail(
                                      campi: campiDaInviare,
                                      circolo: element,
                                      data: data)));
                        }),
                    position: LatLng(element.lat, element.lng)));
              });

              Navigator.pop(context);
              _center = LatLng(myPos.latitude, myPos.longitude);
              clubMarkers.add(Marker(
                markerId: MarkerId("tu"),
                infoWindow: InfoWindow(title: "Tu"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                position: _center,
              ));

              if (circoli.isEmpty) {
                CustomSnackBar(context, const Text("Nessun campo trovato."));
              }
              mapController.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      bearing: 0.0, target: _center, tilt: 45, zoom: 10)));
              setState(() {});
            });
          }
        });
      }
    });
  }


  Widget buildDragIcon() => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 40,
        height: 8,
      );

  Widget getPanel() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Center(
                  child: Text(
                    "FILTRI",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "sans-serif-medium",
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                )),
            Flexible(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              "Coperto",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
                            ),
                            value: coperto,
                            onChanged: (value) {
                              setState(() {
                                coperto = value;
                              });
                            },
                          ))
                    ],
                  ),
                )),
            Flexible(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              "Riscaldamento",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
                            ),
                            value: riscaldamento,
                            onChanged: (value) {
                              setState(() {
                                riscaldamento = value;
                              });
                            },
                          )),
                    ],
                  ),
                )),
            Flexible(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              "Docce",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
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
                )),
            Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 6,
                          child: Container(
                            child: Text(
                              "Distanza massima:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
                            ),
                          )),
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
                                  fontSize: 20),
                              onSubmitted: (_) {
                                distanza = maxDistance.text;
                                maxDistanceNode.unfocus();
                              },
                              controller: maxDistance,
                              keyboardType: TextInputType.number,
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: Text(
                              "Km",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 6,
                          child: Container(
                            child: Text(
                              "Prezzo massimo:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
                              focusNode: maxPriceNode,
                              controller: maxPrice,
                              keyboardType: TextInputType.number,
                              onSubmitted: (_) {
                                prezzo = maxPrice.text;
                                maxPriceNode.unfocus();
                              },
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: Text(
                              "€/h",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            child: Text(
                              "Superficie:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
                            ),
                          )),
                      Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: DropdownButton(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 20),
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
                          )),
                    ],
                  ),
                )),
            Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () async {
                        panelController.close();
                        aggiornaFiltri();
                      },
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.black26, width: 1.0)),
                      color: Colors.white,
                      child: Text(
                        "AGGIORNA",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sans-serif-thin",
                            fontSize: 20),
                      ),
                    ),
                  ),
                )),
          ],
        ),
    );

  }
}

Widget buildGeolocatorAlert1(BuildContext context) {
  return new AlertDialog(
    title: const Text('Avviso'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Per visualizzare i campi sulla mappa è necessario abilitare la geolocalizzazione del dispositivo."),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          //Apre le impostazioni della geolocalizzazione
          Geolocator.openLocationSettings();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Impostazioni'),
      ),
    ],
  );
}

Widget buildGeolocatorAlert2(BuildContext context) {
  return new AlertDialog(
    title: const Text('Avviso'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Affinche l'app funzioni bisogna consentire l'accesso alla geolocalizzazione del dispositivo"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          //Apre le impostazioni della geolocalizzazione
          Geolocator.openAppSettings();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Impostazioni'),
      ),
    ],
  );
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7),
            child: Text("Cercando i campi...")),
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
