import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huride_rider/AllScreens/searchScreen.dart';
import 'package:huride_rider/AllWidgets/Divider.dart';
import 'package:huride_rider/AllWidgets/progressDialog.dart';
import 'package:huride_rider/Assstants/assistanntMethods.dart';
import 'package:huride_rider/DataHandler/appData.dart';
import 'package:provider/provider.dart';






class MainScreen extends StatefulWidget {



  static const String idScreen = "mainScreen" ;






  @override
  _MainScreenState createState() => _MainScreenState();
}

// this is my new screen if you can see it you are too close soo be careful of the dangers of being too close too it .. thank you

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState> ();



Position currentPosition ;

var geoLocator = Geolocator();

double bottomPaddingOfMap = 0;


Set<Marker> markerSet = {};

Set<Circle> circleSet = {};

double rideDetailsContainerHeight = 0 ;

double searchContainerHeight = 300.0 ;

void displayRideDetailsContainer( ) async {

  await getPlaceDirection();

  setState(() {

    searchContainerHeight = 0.0 ;
    rideDetailsContainerHeight = 240.0 ;

    bottomPaddingOfMap = 230.0;

  });
}

void locatePosition () async {

  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  currentPosition = position;

  LatLng latLngPosition = LatLng(position.latitude, position.longitude);

  CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);

  newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  String address = await AssistantMethods.searchCoodinateAdress(position , context);

  print (" tis is your address" + address);

  String locas = position.latitude as String;


}
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      key: scaffoldkey,



      appBar: AppBar(

        title: Text(" Main Screen "
        ),


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

              Image.asset("images/user_icon.png" , height: 165.0, width: 165.0),
              SizedBox(width: 16.0),
              Column(

    mainAxisAlignment: MainAxisAlignment.center,

    children: [
              Text("Profile name " , style:  TextStyle (fontSize: 16.0 , fontFamily: "Brand-Bold")  ,),

              SizedBox(width: 16.0),

      Text("Visit profile") ,


    ],
  )
            ],
                  ),
                ),
              ),

DividerWidget(),
              SizedBox(height: 12.0,),

              ListTile(

                leading: Icon (Icons.history),
        title:   Text("History " , style:  TextStyle (fontSize: 15.0 ),),
              ),


              ListTile(

                leading: Icon (Icons.person),
                title:   Text("visit profile " , style:  TextStyle (fontSize: 15.0 ),),
              ),

              ListTile(

                leading: Icon (Icons.info),
                title:   Text("About " , style:  TextStyle (fontSize: 15.0 ),),
              ),



            ],
          ),
        ),
      ),


      body: Stack(
        children: [
          GoogleMap(

            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,

            initialCameraPosition: _kGooglePlex,

            myLocationEnabled: true,

            zoomGesturesEnabled: true,

            zoomControlsEnabled: true,



            onMapCreated: (GoogleMapController controller)
            {

              _controllerGoogleMap.complete(controller);

              newGoogleMapController = controller;

              setState(() {

                bottomPaddingOfMap= 300.0;
              });
              locatePosition();
            },

          ),



          Positioned(

            top: 45.0,
            left: 22.0,
            child: GestureDetector(

              onTap: (){

                scaffoldkey.currentState.openDrawer();

              },
              child: Container(

                decoration: BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0)  ,
                  boxShadow: [

                  BoxShadow(

                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7 , 0.7 ),

                ),
],
              ),
                child: CircleAvatar(

                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color: Colors.black,),
                  radius: 20.0,

                ),
    ),
            ),
          ),






          Positioned(

              left: 0.0,
              right: 0.0,
              bottom: 0.0,



              child: AnimatedSize(
                vsync: this,
              curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(

   height: searchContainerHeight,
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
    Text("hi there "  , style:  TextStyle (fontSize: 12.0)  ,),

    Text("where to " , style:  TextStyle (fontSize: 20.0 , fontFamily: "Brand-Bold")  ,),


 SizedBox(height: 20.0,),

 GestureDetector(


   onTap: () async {
     



   var res = await   Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));

   if( res == "obtainDirection") {

displayRideDetailsContainer();

   }

   },


   child: Container(

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
 ),




  SizedBox(height: 24.0,),

  Row(

    children: [
      Icon( Icons.home , color: Colors.green,),

      SizedBox(width: 12.0,),

      Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
           //   Provider.of(context).pickUpLocation != null ?

           //   Provider.of(context).pickUpLocation.placeName :


                "Add Home"



          ),

 SizedBox(height: 4.0,) ,

 Text("home adress here " , style:  TextStyle (

   color: Colors.black,
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
          
          ),
          
          
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            
            child: AnimatedSize(

              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container (
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),

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
                  padding: const EdgeInsets.symmetric(vertical : 17.0),
                  child: Column(

                    children: [

                      Container(

                        width: double.infinity,
                        color: Colors.tealAccent[100],

                        child: Padding(

                          padding: EdgeInsets.symmetric(horizontal: 16.0),

                          child: Row (
                            children: [
                              Image.asset("images/taxi.png" , height: 70.0 , width: 80.0,),

                              SizedBox(width: 16.0 ,),

                              Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Car" , style: TextStyle(fontSize: 18.0 , fontFamily: "Brand-Bold"),) ,

                                  Text("10km" , style: TextStyle(fontSize: 18.0 , color: Colors.grey),) ,

                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0,),

Padding(     padding: const EdgeInsets.symmetric(horizontal : 20.0),

  child: Row(

    children: [

      Icon(FontAwesomeIcons.moneyCheckAlt , size: 18.0, color: Colors.black,),
      SizedBox(width: 16.0,),
      Text("CASH"),
      SizedBox(width: 6.0,),
      Icon(Icons.keyboard_arrow_down , color: Colors.black, size: 16.0,),

    ],
  ),
    ),

                      SizedBox(height: 24.0,),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),

                      child: RaisedButton(


                        onPressed: () {

                          print("clickeeed");
                        },
                        color: Theme.of(context).accentColor ,

                        child: Padding(

                          padding: EdgeInsets.all(17.0),

                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [

                              Text("Request" , style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold , color: Colors.white),),
                              Icon(FontAwesomeIcons.taxi, color: Colors.white, size: 26.0,)
                            ],
                          ),

                        ),
                      ),)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context , listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context , listen: false).dropOffLoocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);

    var dropOffLatLng  = LatLng(finalPos.latitude, finalPos.longitude);


showDialog(context: context ,
builder: (BuildContext context ) => ProgressDialog(message: "Please wait ...",) ) ;

var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);

Navigator.pop(context);

print(details.encodedPoints);

  }
}
