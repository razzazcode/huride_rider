
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:huride_rider/Assstants/requestAssistant.dart';
import 'package:huride_rider/DataHandler/appData.dart';
import 'package:huride_rider/Models/address.dart';
import 'package:provider/provider.dart';

class AssistantMethods
{

 static Future<String> searchCoodinateAdress (Position position,  context) async {

    String placeAddress = " " ;

    String st1 , st2 , st3 , st4 ;
    String url = " https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyDA1z4D80Tz2sbfGBsViMYVklDHrrvvtoE";

    var response = await RequestAssistant.getRequest(url);

    if ( response!= "failed") {

    //  placeAddress = response ["results"][0]["formatted_address"];


      st1 = response ["results"][0]["address_components"][0]["long_name"];
      st2 = response ["results"][0]["address_components"][1]["long_name"];
      st3 = response ["results"][0]["address_components"][3]["long_name"];
      st4 = response ["results"][0]["address_components"][3]["long_name"];

      placeAddress = st1 + ", " + st2 + ", " +st3 + ", " + st4 ;



      Address userPickUpAddress = new Address() ;
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude ;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData> (context , listen : false).updatePickUpLocationAddress(userPickUpAddress);


    }

    return placeAddress ;
  }
}