import 'package:flutter/material.dart';
import 'package:quickplay/ViewModel/Auth_Handler.dart';
import 'package:quickplay/pages/ClubSearch.dart';
import 'package:quickplay/pages/InfoApp.dart';
import 'package:quickplay/pages/home_Menu.dart';
import 'package:quickplay/pages/home_profile.dart';

import '../../dialog_helper.dart';

class GlobalItemDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 10,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(Auth_Handler.profileImg),
                ),
              ),
              Text(
                Auth_Handler.CURRENT_USER.nome.capitalize()+" "+Auth_Handler.CURRENT_USER.cognome.capitalize(),
                style: TextStyle(color: Colors.white, fontSize: 18,),
              ),
              Padding(
                padding: EdgeInsets.only(bottom:60),
                child: Text(
                  'Utente',
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeMenu()));
                },
                leading: Icon(Icons.home),
                title: Text('Home'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Profile();
                  }));
                },
                leading: Icon(Icons.account_circle_rounded),
                title: Text('Profilo'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Circoli()));
                },
                leading: Icon(Icons.location_on_sharp),
                title: Text('Circoli'),
              ),
              ListTile(
                title: Text("_________________________________________________________",
                    style: TextStyle(color: Colors.white, fontSize: 4)),

              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InfoApp()));
                },
                leading: Icon(Icons.perm_device_info),
                title: Text('Info App'),
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    margin: const EdgeInsets.only(
                      bottom: 30.0,
                    ),
                    child: ListTile(
                      onTap: () {
                        return DialogHelper.exit(context);
                      },
                      leading: Icon(Icons.logout_outlined),
                      title: Text('Logout'),
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

}

