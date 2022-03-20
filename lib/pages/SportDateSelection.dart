import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:quickplay/ViewModel/DB_Handler_Courts.dart';
import 'package:quickplay/models/models.dart';
import 'package:quickplay/pages/home_Menu.dart';
import 'package:quickplay/utils/constants.dart';
import 'package:quickplay/utils/customDropDownMenu/awesome_dropdown.dart';
import 'package:quickplay/widgets/snackbar.dart';

import 'ClubSelection.dart';

class Selezione1 extends StatefulWidget {
  const Selezione1({Key key}) : super(key: key);

  @override
  _createSelezione1 createState() => _createSelezione1();
}

class _createSelezione1 extends State<Selezione1> {
  List<String> _sports = [
    "Atletica",
    "Badminton",
    "Basket",
    "Bocce",
    "Calcetto",
    "Golf",
    "Nuoto",
    "Padel",
    "Paintball",
    "Squash",
    "Tennis",
    "Touchtennis"
  ];

  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;
  String _selectedItem = '';
  DateTime date;

  String getText() {
    if (date == null) {
      return "Seleziona";
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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
    return GestureDetector(
        onTap: _removeFocus,
        onPanDown: (focus) {
          _isPanDown = true;
          _removeFocus();
        },
        child: Scaffold(
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
            children: [
              Text(
                'Seleziona uno sport',
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 16, right: 20),
                          child: AwesomeDropDown(
                            isPanDown: _isPanDown,
                            dropDownList: _sports,
                            isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide,
                            selectedItem: _selectedItem,
                            onDropDownItemClick: (selectedItem)
                            {
                              _selectedItem = selectedItem;
                            },
                            dropStateChanged: (isOpened)
                            {
                              _isDropDownOpened = isOpened;
                              if (!isOpened) {
                                _isBackPressedOrTouchedOutSide = false;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  'Inserisci una data',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans'),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: ButtonHeaderWidget(
                    title: "",
                    text: getText(),
                    onClicked: () => pickDate(context),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: 150,
                  height: 65,
                  child: TextButton(
                    child: Text(
                      "CONFERMA".toUpperCase(),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black26),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)))),
                    onPressed: () async {
                      if (date == null || _selectedItem == null) {
                        //Errore
                        CustomSnackBar(
                            context, const Text("Inserisci tutti i campi"));
                      } else {
                        //Trova i campi per quello sport
                        List<Court> campiPerSport = await DB_Handler_Courts.getCourtsBySport(_selectedItem.toLowerCase());


                        //cambia page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EffettuaPrenotazione(
                                      campiPerSport: campiPerSport,
                                      data: date,
                                    )));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _removeFocus() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
    }
  }

  Future pickDate(BuildContext context) async
  {
    final initialDate = DateTime.now();
    final lastDate = DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day);
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      lastDate: lastDate,
      firstDate: DateTime.now(),
    );

    if (newDate == null) return;

    setState(() {
      date = newDate;
    });
  }

}

class ButtonHeaderWidget extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onClicked;

  const ButtonHeaderWidget({
    Key key,
    @required this.title,
    @required this.text,
    @required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => HeaderWidget(
        title: title,
        child: ButtonWidget(
          text: text,
          onClicked: onClicked,
        ),
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key key,
    @required this.text,
    @required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          right: MediaQuery.of(context).size.width * 0.15),
      child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(),
          child: new GestureDetector(
              onTap: onClicked,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                  ),
                  hintText: "",
                  labelText: text,
                  suffixIcon: IconButton(
                    onPressed: onClicked,
                    icon: Icon(Icons.date_range_rounded)
                  )
                ),
          ),
          )
      )
  );
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const HeaderWidget({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}
