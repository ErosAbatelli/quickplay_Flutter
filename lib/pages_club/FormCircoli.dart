import 'dart:async';
import 'dart:io';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickplay/ViewModel/DB_Handler_Clubs.dart';
import 'package:email_validator/email_validator.dart';
import 'package:quickplay/pages/Register.dart';
import 'package:map_picker/map_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/constants.dart';
import '../widgets/snackbar.dart';
import '../pages/ClubSelection.dart';

class FormCircoli extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<FormCircoli> {
  GoogleMapController mapController; //contrller for Google map

  CameraPosition cameraPosition;
  MapPickerController mapPickerController = MapPickerController();





  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeCognome = FocusNode();
  final FocusNode focusNodeTel = FocusNode();
  bool checkedValue = false;
  double opacity;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupConfirmTelController = TextEditingController();
  Position initialPos = Position(latitude: 50.586751779797915, longitude: 13.51659500105265);


  @override
  void initState() {
    getPos();
    super.initState();
  }

  getPos() async {
    initialPos = await getLocation();
    mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(bearing: 0.0,target: LatLng(initialPos.latitude,initialPos.longitude),tilt: 45,zoom: 10)));
    setState(() {});
  }

  Future<Position> getLocation() async {
    Position pos;
    try {
      pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 5));
    } catch (err) {
      pos = await Geolocator.getLastKnownPosition();
    }
    return pos;
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
          //decoration: kBoxDecorationStyle,
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
        onPressed: () async {
          if(signupNameController.text.isEmpty || signupEmailController.text.isEmpty || signupConfirmTelController.text.isEmpty){
            CustomSnackBar(context, const Text('Inserire tutti i campi'));
          }else{
            String emailSafe = signupEmailController.text.replaceAll(" ","");
            if(!EmailValidator.validate(emailSafe)){
              CustomSnackBar(context, const Text("Ricontrollare l'email"));
            }else{
              String telSafe = signupConfirmTelController.text.replaceAll(" ", "");
              if(signupConfirmTelController.text.length==10){
                bool result = await InternetConnectionChecker().hasConnection;
                if(result == true) {
                  showLoaderDialog(context);
                  bool esito = await DB_Handler_Clubs.newRequest(
                      signupNameController.text,
                      emailSafe,
                      telSafe,
                      checkedValue,
                      initialPos.latitude,
                      initialPos.longitude
                  );

                  Navigator.pop(context);
                  if(esito){
                    showAlertDialog(context);
                  }else{
                    CustomSnackBar(context, const Text("Errore nell'invio della richiesta"));
                  }
                } else {
                  CustomSnackBar(context, const Text('Connessione ad internet assente'));
                }
              }else{
                CustomSnackBar(context, const Text('Ricontrollare il numero di telefono'));
              }
            }
          }
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
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildNome(),
                _buildEmail(),
                _buildCellulare(),
                Expanded(
                  flex: 1,
                  child: CheckboxListTile(
                    title: Text("Docce"),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),
                )
              ],
            ),
          ),
            Expanded(
              flex: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                  child:MapPicker(
                    iconWidget: Icon(
                      Icons.add_location_alt,
                      color: Colors.pink,
                      size: 40.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    //add map picker controller
                    mapPickerController: mapPickerController,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(initialPos.latitude, initialPos.longitude),
                        zoom: 10,
                      ),
                      onCameraMove: ((_position) => updateLocation(_position)),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    ),
                  ),

              )
            ),
          Expanded(
            flex: 1,
            child: _buildRegisterBtn(),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Operazione conclusa"),
      content: Text("Richiesta inviata con successo."),
      actions: [
        okButton,
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


  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Inviando la richiesta...")),
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

  void updateLocation(CameraPosition _position) {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    initialPos = Position(latitude: _position.target.latitude, longitude: _position.target.longitude);
  }


}