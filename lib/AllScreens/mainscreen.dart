import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';






class MainScreen extends StatefulWidget {



  static const String idScreen = "mainScreen" ;






  @override
  _MainScreenState createState() => _MainScreenState();
}

// this is my new screen if you can see it you are too close soo be careful of the dangers of being too close too it .. thank you

class _MainScreenState extends State<MainScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text(" Main Screen "),


      ),
      
      
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,

            initialCameraPosition: _kGooglePlex,

            onMapCreated: (GoogleMapController controller)
            {

              _controllerGoogleMap.complete(controller);

              newGoogleMapController = controller;
            },

          ),

          Positioned(

              left: 0.0,
              right: 0.0,
              bottom: 0.0,



              child: Container(

                height: 245.0,
                decoration: BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0) , topRight:  Radius.circular(18.0) ) ,
                  boxShadow: [

                    BoxShadow(

                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7 , 0.7 ),
                      
                    ),

                  ],

                ),

                child: Column(
                  
                  children: [
                    SizedBox(height: 6.0,),
                    Text("hi there " , style:  TextStyle (fontSize: 12.0)  ,),

                    Text("where to " , style:  TextStyle (fontSize: 20.0 , fontFamily: "Brand-Bold")  ,),

                  ],
                  
                  
                ),
                
          ),
          
          ),
        ],
      ),
    );
  }
}
