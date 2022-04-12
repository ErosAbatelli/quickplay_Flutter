import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:quickplay/pages_club/Home_Menu_Club.dart';

import '../ViewModel/Auth_Handler.dart';
import '../pages/ClubSelection.dart';
import '../widgets/snackbar.dart';


class ClubProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ClubProfile();



}

class _ClubProfile extends State<ClubProfile> {

  GoogleMapController mapController; //contrller for Google map

  CameraPosition cameraPosition;
  MapPickerController mapPickerController = MapPickerController();


  bool _status = true;

  TextEditingController nomeController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passConfController = TextEditingController();
  bool checkedValue;
  TextEditingController cognomeController = TextEditingController();
  TextEditingController cellulareController = TextEditingController();

  final FocusNode focusNodeNome = FocusNode();
  final FocusNode focusNodeCellulare = FocusNode();
  final FocusNode focusNodePassWord = FocusNode();
  final FocusNode focusNodeConfPassWord = FocusNode();

  Position initialPos;


  @override
  void initState() {
    super.initState();
    getPos();
  }

  getPos() async {
    await Geolocator.isLocationServiceEnabled().then((value) async {
      if (!value) {
        showDialog(context: context, builder: buildGeolocatorAlert1)
            .then((value) {
          Navigator.pop(context);
        });
      } else {
        await Geolocator.checkPermission().then((value) async {
          if (value == LocationPermission.denied) {
            showDialog(context: context, builder: buildGeolocatorAlert2);
          } else {
            Geolocator.getCurrentPosition().then((value) {
              setState(() {
                initialPos = value;
              });
            }
            );
          }
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    passController.text = Auth_Handler.passwordCU;
    passConfController.text = Auth_Handler.passwordCU;
    checkedValue = Auth_Handler.CURRENT_CLUB.docce;
    if(initialPos != null){

      cameraPosition = CameraPosition(target: LatLng(initialPos.latitude,initialPos.longitude));
    }

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: AppBar(backgroundColor: Colors.white,).preferredSize,
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
          children: <Widget>[
            Container(
              height: 800,
              color: Color(0xffFFFFFF),
              child: Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Informazioni Circolo',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            new Column(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                _status
                                    ? _getEditIcon()
                                    : new Container(),
                              ],
                            )
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Nome Circolo',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                controller: nomeController,
                                decoration: InputDecoration(
                                  hintText: Auth_Handler.CURRENT_CLUB.nome.capitalize(),
                                ),
                                enabled: !_status,
                                focusNode: focusNodeNome,
                                onSubmitted: (_) {
                                  focusNodeCellulare.requestFocus();
                                },
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Cellulare',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                controller: cellulareController,
                                decoration: InputDecoration(
                                    hintText: Auth_Handler
                                        .CURRENT_CLUB.telefono),
                                enabled: !_status,
                                focusNode: focusNodeCellulare,
                                onSubmitted: (_){
                                  focusNodePassWord.requestFocus();
                                },
                              ),
                            ),
                          ],
                        )),
                    //-------------------------------------INIZIO campo temporaneo password
                    Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 2.0),
                      child: Switch(
                        value: checkedValue,
                        onChanged: null,
                      ),
                    ),
                    Visibility(
                      visible: !_status,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: new Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                    ),
                    Visibility(
                      visible: !_status,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  obscureText: true,
                                  controller: passController,
                                  focusNode: focusNodePassWord,
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          )),
                    ),

                    Visibility(
                      visible: !_status,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: new Text(
                                    'Conferma password',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                    ),
                    Visibility(
                      visible: !_status,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  obscureText: true,
                                  controller: passConfController,
                                  focusNode: focusNodeConfPassWord,
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          )),
                    ),
                    //-------------------------------------fine campo temporaneo password
                    Visibility(
                      visible: _status,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: new Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )
                      ),
                    ),
                    Visibility(
                      visible: _status,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: new TextField(
                                    decoration: InputDecoration(
                                        hintText: Auth_Handler
                                            .CURRENT_CLUB.email),
                                    enabled: false,
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child:MapPicker(
                            iconWidget: initialPos == null
                                ? null
                                :
                            Icon(
                              Icons.add_location_alt,
                              color: Colors.pink,
                              size: 40.0,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),

                            //add map picker controller
                            mapPickerController: mapPickerController,
                            child: initialPos == null
                                ? CircularProgressIndicator()
                                : GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(initialPos.latitude, initialPos.longitude),
                                zoom: 10,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                              },
                            ),
                          ),

                        )
                    ),
                    !_status ? _getActionButtons() : new Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(

      child: RaisedButton(
          elevation: 5.0,
          onPressed: (){
            setState(() {
              _status = false;
            });
          },
          padding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                  color: Colors.black26, width: 1.0)),
          color: Colors.red,
          child: RichText(
            text: TextSpan(
                text:
                'Modifica  ',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 13.0,
                  fontFamily: 'sans-serif-medium',
                ),
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16.0,
                    ),
                  )
                ]
            ),
          )


      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }


  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Salva"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      showModificheDialog(context);
                      if(passConfController.text != passController.text){
                        CustomSnackBar(context,const Text("Le due password non coincidono"));
                        Navigator.pop(context);

                      }else{
                        if (passController.text.toString() == "" ) {
                          CustomSnackBar(context,const Text("Inserire una password"));
                          Navigator.pop(context);
                        }else{
                         /* DB_Handler_Users.applyMod(
                              nomeController.text,
                              cognomeController.text,
                              cellulareController.text,
                              passController.text, () {
                            Navigator.pop(context);
                            setState(() {
                              _status = true;
                              FocusScope.of(context).requestFocus(new FocusNode());
                            });
                          });

                          */
                        }
                      }
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Annulla"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  showModificheDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Salvando le modifiche...")),
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

  imgLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Caricando l'immagine...")),
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



  Future<bool> onBackPressed() {
    if(_status){
      return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return HomeMenuClub();
        },
      ), (route) => false);
    }else{
      setState(() {
        _status = true;
      });
    }
  }

}

