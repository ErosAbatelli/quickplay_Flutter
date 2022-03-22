import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickplay/ViewModel/Auth_Handler.dart';
import 'package:quickplay/ViewModel/DB_Handler_Users.dart';
import 'package:quickplay/pages/Register.dart';
import 'package:quickplay/utils/constants.dart';
import 'package:quickplay/widgets/snackbar.dart';
import 'Login.dart';

class FormCircoli extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<FormCircoli> {

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

  @override
  void dispose() {
    focusNodeTel.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }


  Widget _buildNome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
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
        SizedBox(height: 10.0),
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
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
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
            onSubmitted: (_) {
              _toggleSignUpButton();
            },
            textInputAction: TextInputAction.go,
          ),
        ),
      ],
    );
  }

  void _toggleSignUpButton() {
    if(signupNameController.text == "" || signupEmailController.text == "" ||
        signupConfirmTelController.text == "")
    {
      CustomSnackBar(context, const Text('Inserisci le credenziali'));
    }



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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: FlexColorScheme.themedSystemNavigationBar(
          context,
          opacity: opacity = 0.01,
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                //matchparent
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Inserisci le credenziali:",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans'),
                      ),
                      SizedBox(height: 30.0),
                      Card(
                          elevation: 2.0,
                          color: Colors.white, //Colore interno
                          shape: new RoundedRectangleBorder(
                            //Colore del bordo
                              side: new BorderSide(
                                  color: Colors.black26, width: 2.0),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Column(children: [
                            _buildNome(),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            _buildEmail(),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                            _buildCellulare(),
                            Container(
                              width: 250.0,
                              height: 1.0,
                              color: Colors.grey[400],
                            ),
                          ])),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return Register();
      },
    ), (route) => false);
  }
}