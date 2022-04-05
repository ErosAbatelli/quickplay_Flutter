import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickplay/pages/QrCode/QrCode_scan.dart';
import 'package:quickplay/utils/dialog_helper.dart';
import 'package:quickplay/utils/drawerMenu/drawerMenu/itemDrawerMenu.dart';
import 'package:quickplay/utils/drawerMenu/flutter_advanced_drawer.dart';



class HomeMenuClub extends StatefulWidget {


  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenuClub> {
  final _advancedDrawerController = AdvancedDrawerController();
  int _selectedIndex = -1;

  @override
  void dispose() {
    _selectedIndex = -1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = -1;
    return WillPopScope(
      child: AdvancedDrawer(
          backdropColor: Colors.blueGrey,
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                title: Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        text: TextSpan(
                            text: 'QUICK',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans-serif-thin",
                              fontSize: 20,
                            ),
                            children: [
                              TextSpan(
                                text: 'PLAY',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-medium",
                                  fontSize: 20,
                                ),
                              ),
                            ])
                    )
                ),
                backgroundColor: Colors.white,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu_sharp),
                    color: Colors.black,
                    onPressed: _handleMenuButtonPressed,
                  ),
                ),
              ),
            ),
            body: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/img/sportsBackground.jpg',
                          fit: BoxFit.contain,
                        ), //Colore in basso del drawer menu
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            //Distanza dalla top bar al "Benvenuto"
                            height: MediaQuery.of(context).size.height * 0.22,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            //Distanza tra il "Benvenuto" ed il blocco "Nome-Cognome"
                            child: Text(
                              "",
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Material(
                                elevation: 2.0,
                                color: Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                          text: TextSpan(
                                              text: "Circolo:\n",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    0, 136, 255, 1),
                                              ),
                                              children: [
                                                // TextSpan(
                                                //   text: Auth_Handler.CURRENT_USER.nome
                                                //       .capitalize() +
                                                //       " " +
                                                //       Auth_Handler
                                                //           .CURRENT_USER.cognome
                                                //           .capitalize(),
                                                //   style: TextStyle(
                                                //       fontSize: 24,
                                                //       fontWeight: FontWeight.bold,
                                                //       color: Colors.black),
                                                // )
                                              ])),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  getGridView()
                ],
              ),
            ),
          ),

          /** DRAWER MENU CONFIGURATION **/
          drawer: GlobalItemDrawer()
      ),
      onWillPop: _onBackPressed,
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  Future<bool> _onBackPressed() {
    _selectedIndex = -1;
    return DialogHelper.exit(context);
  }

  Widget getGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      //Numero di elementi nella riga
      primary: false,
      //Il primo ha il distanziamento a sinistra di default
      childAspectRatio: (MediaQuery.of(context).size.width - 60 / 2) / 280,
      children: <Widget>[
        //il "true" distanzia a destra
        //il "false" distanzia a sinistra
        createTile(0, _selectedIndex, false, 'Scannerizza QR CODE', Colors.purple, Icons.sports_football),
        createTile(1, _selectedIndex, true, 'Visualizza Prenotazioni', Colors.orange, Icons.local_activity),
        //createTile(2, _selectedIndex, false, 'Unisciti alla Prenotazione', Colors.red, Icons.app_settings_alt),
      ],
    );
  }

  Widget createTile(int index, int selectedIndex, bool isEven, String title,
      Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(
          left: isEven ? 10 : 20, right: isEven ? 20 : 15, top: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () async {
            _selectedIndex = index;

            /**
             * Scannerizza QR CODE
             */
            if (_selectedIndex == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QRScanPage()));
            }

            /**
             * VISUALIZZA PRENOTAZIONI
             */
            if (_selectedIndex == 1) //Visualizza prenotazioni
                {
            }

            /**
             * UNISCITI A  PRENOTAZIONE
             */
            if (_selectedIndex == 2) {

            }

            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            color: _selectedIndex == index ? Colors.orange : Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    icon,
                    color: _selectedIndex == index ? Colors.white : color,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Container(
                          height: 3.0,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color: _selectedIndex == index
                                ? Colors.orange
                                : color, //Colore quando attivi un bottone
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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


}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }



}
