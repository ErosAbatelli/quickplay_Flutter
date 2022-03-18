
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quickplay/utils/drawerMenu/flutter_advanced_drawer.dart';

import 'home_Menu.dart';

class InfoApp extends StatefulWidget {
  @override
  _InfoAppState createState() => _InfoAppState();
}

class _InfoAppState extends State<InfoApp> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
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
        body: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20, top: 20, bottom: 20),
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: Text("Guida all'utilizzo dell'App!",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "sans-serif-medium",
                        fontSize: 23,
                      ),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: RichText(
                        text: TextSpan(
                            text: '- Effettua Prenotazione: ',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans-serif-thin",
                              fontSize: 17,
                            ),
                            children: [
                              TextSpan(
                                text: 'specifica lo sport e la data in cui vuoi praticarlo.\nSuccessivamente ti comparirà '
                                    'una mappa dove poter scegliere il circolo più adatto a te!\n'
                                    'Non ti basta? Facendo swipe-up puoi scegliere i filtri che vuoi!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: '\n\n- Visualizza prenotazioni: ',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: 'non ti ricordi dove e per quando hai prenotato? Non ci sono problemi! In questa sezione puoi controllare\n'
                                    'tutte le informazioni necessarie. Inoltre non dimenticarti di mostrare il QR CODE per confermare la partecipazione'
                                    'al circolo, altrimenti.. STRIKE. ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: '\n\n- Unisciti alla prenotazione: ',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: 'puoi partecipare alle prenotazioni dei tuoi amici, in modo tale da semplificare il lavoro '
                                    'al circolo e a te!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "sans-serif-thin",
                                  fontSize: 17,
                                ),
                              ),

                            ])
                    ),
                  ),
                ),

              ],
            ),
          ),

      ),
    );
  }


  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return HomeMenu();
      },
    ), (route) => false);
  }


}