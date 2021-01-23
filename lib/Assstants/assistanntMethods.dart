
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huride_rider/Assstants/requestAssistant.dart';
import 'package:huride_rider/DataHandler/appData.dart';
import 'package:huride_rider/Models/address.dart';
import 'package:huride_rider/Models/directionDetails.dart';
import 'package:huride_rider/configMaps.dart';
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

  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition , LatLng finalosition ) async {

   String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalosition.latitude},${finalosition.longitude}&key=$mapKey";

 var res= await RequestAssistant.getRequest(directionUrl);

 if(res == "failed"){

   return null;
 }



 DirectionDetails directionDetails = DirectionDetails();
 directionDetails.encodedPoints = res["routes"]['0']["over_polyline"]['points'];

   directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];

   directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

   directionDetails.durationText = res["routes"][0]["legs"][0]["distance"]["text"];

   directionDetails.durationValue = res["routes"][0]["legs"][0]["distance"]["value"];

   return directionDetails;


  }


  static int calculateFare(DirectionDetails directionDetails) {

   double timeTravelFare = (directionDetails.durationValue / 60 ) * 0.20 ;

   double distanceTravelFare = (directionDetails.distanceValue / 1000 ) * 0.20 ;

   double totalFareAmount = timeTravelFare + distanceTravelFare ;

   //totalFare = amount in dollar * local currency

    return totalFareAmount.truncate();

  }
}