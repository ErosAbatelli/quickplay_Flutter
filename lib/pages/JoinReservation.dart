import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickplay/ViewModel/DB_Handler_Reservations.dart';
import 'package:quickplay/pages/home_Menu.dart';
import 'package:quickplay/utils/constants.dart';


class Partecipa extends StatefulWidget {
  Partecipa({Key key}) : super(key: key);

  @override
  _Partecipa createState() => _Partecipa();
}

class _Partecipa extends State<Partecipa> {
  TextEditingController codPren = TextEditingController();
  double opacity = 0.01;

  final FocusNode focusCodice = FocusNode();
  final FocusNode focusBtn = FocusNode();

  @override
  void dispose() {
    focusCodice.dispose();
    super.dispose();
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

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
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
                            )),
                      ),
                    )
                  ],
                )),
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: FlexColorScheme.themedSystemNavigationBar(
              context,
              opacity: opacity,
            ),
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(children: <Widget>[
                  Container(
                    //matchparent
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                  ),
                  Container(
                      alignment: Alignment.topCenter,
                      child: Column(children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30.0),
                          height: MediaQuery.of(context).size.height * 0.20,
                          alignment: Alignment.topCenter,
                          child: Text(
                            "INSERISCI CODICE PRENOTAZIONE",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Wrap(children: [
                          Card(
                              margin: const EdgeInsets.only(
                                  left: 30.0, right: 30.0),
                              elevation: 2.0,
                              color: Colors.white,
                              //Colore interno
                              shape: new RoundedRectangleBorder(
                                  //Colore del bordo
                                  side: new BorderSide(
                                      color: Colors.black26, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(children: [
                                SizedBox(
                                  height: 50,
                                ),
                                TextField(
                                  focusNode: focusCodice,
                                  controller: codPren,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'OpenSans',
                                    fontSize: 20,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14.0),
                                    prefixIcon: Icon(
                                      Icons.qr_code_outlined,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Codice',
                                    hintStyle: kHintTextStyle,
                                  ),
                                  onSubmitted: (_) async {
                                    showCheckProgress(context);
                                    String msg = await DB_Handler_Reservations
                                        .newPartecipazione(codPren.text);
                                    Navigator.of(context).pop();
                                    final snackBar = SnackBar(
                                      content: Text(msg),
                                      backgroundColor: Colors.red,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.20,
                                      right: MediaQuery.of(context).size.width *
                                          0.20),
                                  padding: EdgeInsets.symmetric(vertical: 25.0),
                                  width: double.infinity,
                                  child: TextButton(
                                    child: Text(
                                      "Partecipa",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.all(15)),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black26),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.black)))),
                                    onPressed: () async {
                                      showCheckProgress(context);
                                      String msg = await DB_Handler_Reservations
                                          .newPartecipazione(codPren.text);
                                      Navigator.of(context).pop();
                                      final snackBar = SnackBar(
                                        content: Text(msg),
                                        backgroundColor: Colors.red,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                  ),
                                ),
                              ]))
                        ])
                      ]))
                ]))));
  }

  showCheckProgress(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Verifica del codice...")),
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
