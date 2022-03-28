import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:quickplay/pages/Register.dart';
import 'package:map_picker/map_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/constants.dart';
import '../widgets/snackbar.dart';
import 'ClubSelection.dart';

class FormCircoli extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<FormCircoli> {
  GoogleMapController mapController; //contrller for Google map
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  CameraPosition cameraPosition;
  MapPickerController mapPickerController = MapPickerController();

  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeCognome = FocusNode();
  final FocusNode focusNodeTel = FocusNode();

  double opacity;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupConfirmTelController = TextEditingController();
  Position initialPos = Position(longitude: 45.586751779797915, latitude: 13.51659500105265);

  getPos() async {
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
            initialPos =  await Geolocator.getLastKnownPosition();
            mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(bearing: 0.0,target: LatLng(initialPos.latitude,initialPos.longitude),tilt: 45,zoom: 10)));
            Navigator.pop(context);
            setState(() {});          }
        });
      }
    });

  }

  @override
  void initState() {
    getPos();
    super.initState();

  }

  @override
  void dispose() {
    focusNodeTel.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return Register();
      },
    ), (route) => false);
  }

  Widget _buildNome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            focusNode: focusNodeName,
            controller: signupNameController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              hintText: 'Nome',
              hintStyle: kHintTextStyle,
            ),
            onSubmitted: (_) {
              focusNodeEmail.requestFocus();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            focusNode: focusNodeEmail,
            controller: signupEmailController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              hintText: 'E-mail',
              hintStyle: kHintTextStyle,
            ),
            onSubmitted: (_) {
              focusNodeTel.requestFocus();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCellulare() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: MediaQuery.of(context).size.height*0.1,
          child: TextField(
            focusNode: focusNodeTel,
            controller: signupConfirmTelController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.black,
              ),
              hintText: 'Cellulare',
              hintStyle: kHintTextStyle,
            ),
            textInputAction: TextInputAction.go,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width*0.7,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _toggleSignUpButton();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.black26, width: 2)),
        color: Colors.white,
        child: Text(
          'Invia richiesta',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    if(initialPos != null){

      cameraPosition = CameraPosition(target: LatLng(initialPos.latitude,initialPos.longitude));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
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
      body: Column(
        children: [
          _buildNome(),
          Container(
            width: 300.0,
            height: 1.0,
            color: Colors.grey[400],
          ),
          _buildEmail(),
          Container(
            width: 300.0,
            height: 1.0,
            color: Colors.grey[400],
          ),
          _buildCellulare(),
            Container(
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              child: MapPicker(
                // pass icon widget
                iconWidget: Icon(
                  Icons.add_location_alt,
                  color: Colors.pink,
                  size: 40.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                //add map picker controller
                mapPickerController: mapPickerController,
                child: GoogleMap(
                  myLocationEnabled: false,
                  zoomControlsEnabled: true,
                  // hide location button
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  //  camera position
                  initialCameraPosition: cameraPosition,
                  onMapCreated: _onMapCreated,
                  onCameraIdle: () async {
                    // notify map stopped moving
                    mapPickerController.mapFinishedMoving();
                    //get address name from camera position
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude,
                    );
                  },
                ),
              ),
            ),
            _buildRegisterBtn()
        ],
      ),
    );
  }

  void _toggleSignUpButton() {
    if(signupNameController.text == "" || signupEmailController.text == "" ||
        signupConfirmTelController.text == "")
    {
      CustomSnackBar(context, const Text('Inserisci le credenziali'));
    }
  }


}