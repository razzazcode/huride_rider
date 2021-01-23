import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huride_rider/AllScreens/loginScreen.dart';
import 'package:huride_rider/AllScreens/searchScreen.dart';
import 'package:huride_rider/AllWidgets/Divider.dart';
import 'package:huride_rider/AllWidgets/progressDialog.dart';
import 'package:huride_rider/Assstants/assistanntMethods.dart';
import 'package:huride_rider/DataHandler/appData.dart';
import 'package:huride_rider/Models/directionDetails.dart';
import 'package:huride_rider/configMaps.dart';
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

DirectionDetails tripDirectionDetails ;
List<LatLng> pLineCoordinate = [] ;

Set<Polyline> polyLineSet = {} ;

Position currentPosition ;

var geoLocator = Geolocator();

double bottomPaddingOfMap = 0;


Set<Marker> markerSet = {};

Set<Circle> circleSet = {};

double rideDetailsContainerHeight = 0 ;
double requestRideContainerHeight = 0 ;
double searchContainerHeight = 300.0 ;

bool drawerOpen = true ;

DatabaseReference rideRequestRef;

@override
initState() {

  super.initState();
  AssistantMethods.getCurrentOnlineUserInfo();


}

void saveRideRequest (){

  rideRequestRef = FirebaseDatabase.instance.reference().child("Ride Requests").push();

  var pickUp = Provider.of<AppData>(context , listen: false).pickUpLocation;

  var dropOff = Provider.of<AppData>(context , listen: false).dropOffLoocation;

  Map pichUpLocMap = {

    "latitude" : pickUp.latitude.toString(),
    "longitude" : pickUp.longitude.toString(),
  };

  Map dropOffUpLocMap = {

    "latitude" : dropOff.latitude.toString(),
    "longitude" : dropOff.longitude.toString(),
  };


  Map rideinfoMap = {
    "driver_id": "waiting",
    "payment_method": "cash",
    "pichup": pichUpLocMap,
    "dropoff": dropOffUpLocMap,
    "created_at": DateTime.now().toString(),
    "rider_name": userCurrentInfo.name,
    "rider_phone": userCurrentInfo.phone,
    "pickup_address": pickUp.placeName,
    "dropoff_address" : dropOff.placeName,
  };

  rideRequestRef.set(rideinfoMap);
}


void cancelRideRequest (){

rideRequestRef.remove();


}
void displayRequestRideContainer() {

  setState(() {

    requestRideContainerHeight = 250.0;
    rideDetailsContainerHeight = 0 ;
    bottomPaddingOfMap = 230.0;
    drawerOpen = true;
  });

  saveRideRequest();
}

resetApp(){

  setState(() {

    drawerOpen = true;

    searchContainerHeight = 300.0 ;
    rideDetailsContainerHeight = 0.0 ;
requestRideContainerHeight=0;
    bottomPaddingOfMap = 230.0;

polyLineSet.clear();
markerSet.clear();
circleSet.clear();
pLineCoordinate.clear();
  });


  locatePosition();
}

void displayRideDetailsContainer( ) async {

  await getPlaceDirection();

  setState(() {

    searchContainerHeight = 0.0 ;
    rideDetailsContainerHeight = 240.0 ;

    bottomPaddingOfMap = 230.0;

    drawerOpen = false;

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

              GestureDetector(

                onTap: () {

                  FirebaseAuth.instance.signOut();

                  Navigator.pushNamedAndRemoveUntil(context, loginScreen.idScreen, (route) => false);
                },
                child: ListTile(

                  leading: Icon (Icons.info),
                  title:   Text("Sign Out " , style:  TextStyle (fontSize: 15.0 ),),
                ),
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


            polylines: polyLineSet,

            markers: markerSet,
            circles: circleSet,

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

            top: 38.0,
            left: 22.0,
            child: GestureDetector(

              onTap: (){

if(drawerOpen) {

  scaffoldkey.currentState.openDrawer();

}
else{

  resetApp();

}
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
                  child: Icon((drawerOpen) ? Icons.menu : Icons.close, color: Colors.black,),
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

                                  Text(
                                    (( tripDirectionDetails != null) ?  tripDirectionDetails.distanceText : '') , style: TextStyle(fontSize: 18.0 , color: Colors.grey),

                                  ) ,

                                ],
                              ),
                              
                              Expanded(child: Container()),

                              Text(

                                (  ( tripDirectionDetails != null)  ? '\$${AssistantMethods.calculateFare(tripDirectionDetails)}' : ''), style: TextStyle(fontFamily: "Brand-Bold"),

                              ) ,

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

                          displayRequestRideContainer();

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
          ),

          Positioned(

            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(

              decoration: BoxDecoration(

                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0) , topRight: Radius.circular(16.0),),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    color: Colors.black45,
                    offset: Offset(0.7 , 0.7),
                  ),
                ],
              ),
              height: requestRideContainerHeight,
              child: Padding(

                padding: const EdgeInsets.all(30.0),
                child: Column (

                  children: [

                    SizedBox(
                      height: 12.0,

                    ),

    SizedBox(
    width: double.infinity,
    child: ColorizeAnimatedTextKit(
    onTap: () {
    print("Tap Event");
    },
    text: [
    "Requesting a ride",
    "Please wait",
    "Finding a driver",
    ],
    textStyle: TextStyle(
    fontSize: 55.0,
    fontFamily: "Signatra"
    ),
    colors: [
      Colors.green,
    Colors.purple,
      Colors.pink,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    ],
    textAlign: TextAlign.center,
   //   alignment: AlignmentDirectional.topStart,
    ),
    ),

                    SizedBox(height: 22.0,),

                    GestureDetector(

                      onTap: () {

                        cancelRideRequest();

                        resetApp();

                      },
                      child: Container(

                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.0),
                          border: Border.all(width: 2.0 , color: Colors.grey[300]),
                        ),
                        child: Icon(Icons.close , size: 26.0,),

                      ),
                    ),

                    SizedBox(height: 10.0,),

                    Container(

                      width: double.infinity,
                      child: Text("Cancel ride ", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0),),
                    )
                  ],
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



setState(() {

  tripDirectionDetails = details;
});


Navigator.pop(context);
print("this is Encoded points");
print(details.encodedPoints);


PolylinePoints polylinePoints = PolylinePoints();

List<PointLatLng> decodedPolylinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);

pLineCoordinate.clear();

if ( decodedPolylinePointsResult.isNotEmpty){

  decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {

pLineCoordinate.add(    LatLng(pointLatLng.latitude , pointLatLng.longitude));

  });
}
polyLineSet.clear();

setState(() {

  Polyline polyline = Polyline(
    color: Colors.pink,
    polylineId: PolylineId("PolylineId"),
    jointType: JointType.round,
    points: pLineCoordinate,
    width: 5,
    startCap: Cap.roundCap,
    endCap: Cap.roundCap,
    geodesic: true ,
  );


  polyLineSet.add(polyline);

});

LatLngBounds latLngBounds;

if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude) {

  latLngBounds = LatLngBounds(southwest: dropOffLatLng , northeast: pickUpLatLng);

}


else if(pickUpLatLng.longitude > dropOffLatLng.longitude ) {

  latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude , dropOffLatLng.longitude) , northeast: LatLng(dropOffLatLng.latitude , pickUpLatLng.longitude));

}

else if(pickUpLatLng.latitude > dropOffLatLng.latitude ) {

  latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude , pickUpLatLng.longitude) , northeast: LatLng(pickUpLatLng.latitude , dropOffLatLng.longitude));

}


else{

  latLngBounds = LatLngBounds(southwest: pickUpLatLng , northeast: dropOffLatLng);
}

newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));


Marker pickUpLocMarker = Marker(
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    infoWindow: InfoWindow(title: initialPos.placeName , snippet: " my Location"),

    position: pickUpLatLng,

    markerId: MarkerId("pickUpId"),
);

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: initialPos.placeName , snippet: " dropOffLocMarker Location"),

      position: dropOffLatLng,

      markerId: MarkerId("dropOffId"),
    );

    setState(() {

      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);

    });

    Circle pickUpLocCircle = Circle(

        fillColor: Colors.blue,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent,
        circleId: CircleId("pickUpCircleId"),
    );


    Circle dropOffCircle = Circle(

      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.purple,
      circleId: CircleId("dropOffCircleId"),
    );
    
    setState(() {
      
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffCircle);
    });
  }
}
