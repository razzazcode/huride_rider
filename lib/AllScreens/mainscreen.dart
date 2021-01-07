import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huride_rider/AllWidgets/Divider.dart';






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
      

      drawer: Container (

        color: Colors.lightGreenAccent,

        width: 255.0,
        child: Drawer(

          child: ListView(

            children: [
              Container(

                height: 165.0,
                child: DrawerHeader (

                  decoration: BoxDecoration( color: Colors.white),

                  child: Row(

                    children: [

                      Image.asset("name"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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

                height: 320.0,
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

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 18.0),
                  child: Column(


                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: 6.0,),
                      Text("hi there " , style:  TextStyle (fontSize: 12.0)  ,),

                      Text("where to " , style:  TextStyle (fontSize: 20.0 , fontFamily: "Brand-Bold")  ,),


                      SizedBox(height: 6.0,),

                      Container(

                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0) ,
                          boxShadow: [

                            BoxShadow(

                              color: Colors.black,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7 , 0.7 ),

                            ),

                          ],

                        ),


                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(

                            children: [
                              Icon( Icons.search , color: Colors.blue,),

                              SizedBox(width: 10.0,),
                              Text(" search dropp off there "),

                            ],
                          ),
                        ),



                      ),




                      SizedBox(height: 24.0,),

                      Row(

                        children: [
                          Icon( Icons.home , color: Colors.green,),

                          SizedBox(width: 12.0,),

                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(" Add home "),

                              SizedBox(height: 4.0,) ,

                              Text("home adress here " , style:  TextStyle (

                                color: Colors.grey[200],
                                  fontSize: 12.0 ,
                                  fontFamily: "Brand-Bold")  ,

                              ),


                            ],
                          ),

                        ],
                      ),




                      SizedBox(height: 10.0,),






                      DividerWidget(),

                      SizedBox(height: 16.0,),


                      Row(

                        children: [
                          Icon( Icons.work , color: Colors.green,),

                          SizedBox(width: 12.0,),

                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(" Add work "),

                              SizedBox(height: 4.0,) ,

                              Text("office adress here " , style:  TextStyle (

                                  color: Colors.blueGrey,
                                  fontSize: 12.0 ,
                                  fontFamily: "Brand-Bold")  ,

                              ),



                            ],
                          ),



                        ],
                      ),






                    ],


                  ),
                ),
                
          ),
          
          ),
        ],
      ),
    );
  }
}
