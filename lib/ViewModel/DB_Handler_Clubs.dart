

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickplay/ViewModel/DB_Handler_Users.dart';
import 'package:quickplay/models/models.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickplay/widgets/snackbar.dart';


class DB_Handler_Clubs{

  static Firestore myRef = Firestore.instance;


  static Future<List<Club>> getAllClubs() async {
    List<Club> clubs = [];

    var data = await myRef.collection("clubs").getDocuments();
    data.documents.forEach((element) {
      double lat = element.data["posizione"].latitude;
      double lng = element.data["posizione"].longitude;
      clubs.add(Club(
          element.data["id_circolo"],
          element.data["nome"],
          element.data["telefono"],
          element.data["email"],
          element.data["docce"],
          lat,
          lng));
    });
    return clubs;
  }

  static Future<String> newRequest(String nomeC, String email, String telC,bool docce,double lat, double lng) async {
    var location = GeoPoint(lat, lng);
    String outputString = "";
    DocumentSnapshot returnedData = await myRef.collection("users").document(email).get();
    if(returnedData.data==null){
      try{
        await myRef.collection("richieste_circoli").document(email).setData({
          'email':email,
          'nome':nomeC.toLowerCase(),
          'posizione':location,
          'telefono' : telC,
          'docce' : docce
        });
        outputString = "Richiesta inviata con successo.";
      }catch (e) {
        outputString = "Errore nell'invio della richiesta.";
      }
    }else{
      outputString = "E-mail già in uso.";
    }

    return outputString;
  }

  static Future<List<Club>> getAllClubsInRange(int range,LatLng position) async{
    List<Club> clubsInRange = [];
    var data = await myRef.collection("clubs").getDocuments();
    data.documents.forEach((element) {
      double lat = element.data["posizione"].latitude;
      double lng = element.data["posizione"].longitude;
      if(Geolocator.distanceBetween(lat, lng, position.latitude, position.longitude)<=(range*1000)){
        clubsInRange.add(Club(
            element.data["id_circolo"],
            element.data["nome"],
            element.data["telefono"],
            element.data["email"],
            element.data["docce"],
            lat,lng));
      }
    });
    return clubsInRange;
  }

  static Future<Club> getClubById(String id) async{
    var data;
    data = await myRef.collection("clubs").document(id).get();
    var record = data.data;
    return Club(record["id_circolo"], record["nome"], record["telefono"], record["email"], record["docce"],record["posizione"].latitude, record["posizione"].longitude);
  }

  static Future<Club> getClubByEmail(String email) async{
    var data;
    QuerySnapshot clubs = await myRef.collection("clubs").getDocuments();
    Club returnedClub = null;
    clubs.documents.forEach((record) {
        if(record.data["email"]==email){
          returnedClub = Club(record["id_circolo"], record["nome"], record["telefono"], record["email"], record["docce"],record["posizione"].latitude, record["posizione"].longitude);
        }
    });
    return returnedClub;
  }





  static Future<void> getFilteredClubsAndCourt(int distanza,int prezzo,bool docce, bool riscaldamento, bool coperto, String superficie , List<Court>campiPerSportNonFiltrati , callback(List<Club> circoli, List<Court> campi)) async {
    Position myPosition;
    List<Court> campiPerSportFiltrati = [];
    campiPerSportNonFiltrati.forEach((element) {
      campiPerSportFiltrati.add(element);
    });

    List<Club> filteredClubs = [];


    myPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);


    List<Club> clubsInRange = await getAllClubsInRange(distanza, LatLng(myPosition.latitude, myPosition.longitude));
    clubsInRange.forEach((element) {
      filteredClubs.add(element);
    });


    //Filtraggio sui campi trovati
    if(superficie!="Tutte") {
      if(superficie=="Altro"){
        campiPerSportNonFiltrati.forEach((element) {
          if (element.superficie=="erba" || element.superficie=="terra rossa" || element.superficie=="cemento" || element.superficie=="erba sintetica"){
            campiPerSportFiltrati.remove(element);
          }
        });
      }else{
        campiPerSportNonFiltrati.forEach((element) {
          if (element.superficie != superficie.toLowerCase()) {
            campiPerSportFiltrati.remove(element);
          }
        });
      }
    }
      if(coperto==true){
        campiPerSportNonFiltrati.forEach((element) {
          if(!element.coperto){
            campiPerSportFiltrati.remove(element);
          }
        });
      }
      if(riscaldamento==true){
        campiPerSportNonFiltrati.forEach((element) {
          if(!element.riscaldamento){
            campiPerSportFiltrati.remove(element);
          }
        });
      }
      campiPerSportNonFiltrati.forEach((element) {
        if(element.prezzo>prezzo){
          campiPerSportFiltrati.remove(element);
        }
      });

      //Filtro i club
      if(docce) {
        clubsInRange.forEach((element) {
          if (!element.docce) {
            filteredClubs.remove(element);
          }
        });
      }
        //troviamo gli id dei club corrispondenti ai campi filtrati
        List<int> filteredClubIDs = [];
        campiPerSportFiltrati.forEach((element) {
          filteredClubIDs.add(element.codClub);
        });
        clubsInRange.forEach((element) {
          if(!filteredClubIDs.contains(element.id)){
            filteredClubs.remove(element);
          }
        });

        filteredClubIDs.clear();
        //filtriamo i campi che fanno riferimento a campi o fuori range (o senza docce)

        filteredClubs.forEach((element) {
          filteredClubIDs.add(element.id);
        });
        campiPerSportNonFiltrati.forEach((element) {
          if(!filteredClubIDs.contains(element.codClub)){
            campiPerSportFiltrati.remove(element);
          }
        });

        callback(filteredClubs,campiPerSportFiltrati);
  }

}