import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:quickplay/ViewModel/DB_Handler_Clubs.dart';
import 'package:quickplay/pages/home_Menu.dart';
import 'package:quickplay/widgets/snackbar.dart';



class Circoli extends KFDrawerContent {
  Circoli({
    Key key,
  });

  @override
  _Circoli createState() => _Circoli();
}

class _Circoli extends State<Circoli> with SingleTickerProviderStateMixin {
  Set<Marker> clubMarkers = Set();
  LatLng _center = LatLng(42.413951448997125, 12.436653926777424);
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return HomeMenu();
      },
    ), (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    if (clubMarkers.isEmpty) {
      loadMap();
    }

    return WillPopScope(
      onWillPop: onBackPressed,
      child:Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                    text: TextSpan(
                        text: 'Circoli Affiliati',
                        style: TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                          fontFamily: "sans-serif-medium",
                          fontSize: 20,
                        ),
                    )
                )
            ),
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.arrow_back_ios,),
                color: Colors.black,
                onPressed: onBackPressed,
              ),
            ),
          ),
        ),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          markers: clubMarkers,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 6.0,
          ),
        ),
      ]),
    ));
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset("assets/loading.json",
              repeat: false),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Caricando le prenotazioni..",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "sans-serif-thin",
                    fontSize: 20
                ),)),
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

  Future<void> loadMap() async {

    var circoli = await DB_Handler_Clubs.getAllClubs();
    circoli.forEach((element) {
      clubMarkers.add(Marker (
          markerId: MarkerId(element.id.toString()),
          infoWindow: InfoWindow(
            title: element.nome,
          ),
          position: LatLng(element.lat, element.lng)));
    });

    if (circoli.isEmpty) {
      CustomSnackBar(context, const Text("Nessun campo trovato."));
    }
    setState(() {

    });
  }
}
