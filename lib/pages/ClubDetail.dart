import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickplay/models/models.dart';
import 'package:quickplay/pages/home_Menu.dart';

import 'TimeSelection.dart';

class ClubDetail extends StatefulWidget {
  const ClubDetail({Key key, this.campi, this.circolo, this.data})
      : super(key: key);
  @override
  final List<Court> campi;
  final Club circolo;
  final DateTime data;

  _ClubDetails createState() => _ClubDetails(campi, circolo, data);
}

class _ClubDetails extends State<ClubDetail> {
  List<Court> campi = [];
  Club circolo;
  DateTime data;
  bool auth = false;
  int pageIndex = 0;
  PageController pageController;

  _ClubDetails(this.campi, this.circolo, this.data);

  Future<bool> onBackPressed() {
    Navigator.pop(context, false);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: this.pageIndex);
  }


  buildAuthScreen() {
    return
      WillPopScope(
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
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                      child: Container(
                        child: Text(circolo.nome,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "sans-serif-medium",
                            fontWeight: FontWeight.normal,),
                        ),
                      ),
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: PageView(
                      controller: pageController,
                      children: [
                        getList(),
                        getInfo(),
                      ],
                      physics: NeverScrollableScrollPhysics(),
                    ),
                ),
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: this.pageIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: (index) {
                setState(() {
                  this.pageIndex = index;
                });
                pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Campi'),
                BottomNavigationBarItem(icon: Icon(Icons.perm_device_info), label: 'Info Club'),
              ],
            ),
          ),
      );
  }

  getList(){
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: campi.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelezioneOrario(
                          campo: campi[index],
                          circolo: circolo,
                          data: data,
                        )));
              },
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 15, top: 10, right: 15),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "sans-serif-medium"
                              ),
                              text: "Campo n°: ",
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "sans-serif-medium"
                                    ),
                                    text: campi[index].n_c.toString())
                              ]),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 8),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "sans-serif-medium"
                              ),
                              text: "Superficie : ",
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                      fontFamily: "sans-serif-medium",
                                        fontSize: 15),
                                    text: campi[index]
                                        .superficie
                                        .capitalize())
                              ]),
                        ),
                      )
                    ],
                  ),
                  Row(children: [
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 8),
                        child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "sans-serif-medium",
                                fontSize: 15,
                              ),
                              text: "Coperto : ",
                              children: [getIcon(campi[index].coperto)],
                            )))
                  ]),
                  Row(children: [
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 8),
                        child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "sans-serif-medium",
                                fontSize: 15,
                              ),
                              text: "Riscaldamento: ",
                              children: [
                                getIcon(campi[index].riscaldamento)
                              ],
                            ))),
                  ]),
                  Row(
                      children: [
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 8),
                        child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "sans-serif-medium"
                              ),
                              text: "Prezzo: ",
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: "sans-serif-medium"),
                                    text: campi[index].prezzo.toString()),
                                TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "sans-serif-medium"
                                    ),
                                    text: " €/h")
                              ],
                            ))),
                  ]),
                  Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                            child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "sans-serif-medium"
                                  ),
                                  text: "Docce: ",
                                  children: [getIcon(circolo.docce)],
                                ))),
                      ]),

                ]),
              ));
        });
  }

  getIcon(bool value) {
    switch (value) {
      case true:
        return TextSpan(
            style: TextStyle(
                color: Colors.black, fontFamily: "sans-serif-medium", fontSize: 15),
            text: "Sì",);
      case false:
        return TextSpan(
            style: TextStyle(
                color: Colors.black, fontFamily: "sans-serif-medium", fontSize: 15),
            text: "No");
    }
  }

  getInfo()
  {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                    child: Container(
                      child: Text("email: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "sans-serif-medium",
                          fontSize: 15,
                        ),),
                    ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    child: Text(circolo.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "sans-serif-medium",
                        fontSize: 15,
                      ),),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Text("cellulare: ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "sans-serif-medium",
                        fontSize: 15,
                      ),),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    child: Text(circolo.telefono,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "sans-serif-medium",
                        fontSize: 15,
                      ),),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildAuthScreen(),
    );
  }








}