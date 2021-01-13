import 'package:flutter/material.dart';
import 'package:huride_rider/Assstants/requestAssistant.dart';
import 'package:huride_rider/DataHandler/appData.dart';
import 'package:huride_rider/configMaps.dart';
import 'package:provider/provider.dart';



class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {



  TextEditingController pickUpTextEditingController = TextEditingController();

  TextEditingController dropOffTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {





    String placeAddress = "adres" ; // Provider.of<AppData>(context).pickUpLocation.placeName ??  "" ;

    pickUpTextEditingController.text = placeAddress;


    return Scaffold(

      body: Column (
        children: [

        Container(

    height : 215.0,

          decoration: BoxDecoration (

            color: Colors.white ,
            boxShadow: [

              BoxShadow(
                color: Colors.black,
                blurRadius: 6.0,
                spreadRadius: 0.5,
                offset: Offset(0.7 , 0.7),

              ),


            ]
          ),

          child: Padding(

            padding: EdgeInsets.only(left: 25.0 ,top: 25.0 , right: 25.0 , bottom: 20.0),

            child: Column (

              children: [
                SizedBox(height: 5.0) ,
                Stack(

                  children: [

                    GestureDetector(
                        onTap:()
              {

                Navigator.pop(context);
              },


                        child: Icon(Icons.arrow_back),
                    ),
                    Center(
                      child: Text(" Set Drop OF " , style: TextStyle (fontSize: 18.0 , fontFamily: "Brand_Bold"),),
                    ),
                  ],
                ),

                SizedBox(height: 16.0) ,
                
                Row(
                  children: [
                    Image.asset("images/pickicon.png" , height: 16.0 , width: 16.0,),

                    SizedBox(width: 18.0) ,

                    Expanded(child: Container (

                      decoration: BoxDecoration (

                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5.0),

                      ),

                      child: Padding (

                        padding: EdgeInsets.all(3.0),

                        child: TextField(

                          controller: pickUpTextEditingController,
                          decoration: InputDecoration(
                            hintText: "PickUp location",
                            fillColor: Colors.grey,
                            filled: true,
                            border: InputBorder.none,
                            isDense: true ,
                            contentPadding: EdgeInsets.only(left: 11.0 , top: 8.0 , bottom: 8.0),
                          ),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),

                SizedBox(height: 10.0) ,

                Row(
                  children: [
                    Image.asset("images/desticon.png" , height: 16.0 , width: 16.0,),

                    SizedBox(width: 18.0) ,

                    Expanded(child: Container (

                      decoration: BoxDecoration (

                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5.0),

                      ),

                      child: Padding (

                        padding: EdgeInsets.all(3.0),

                        child: TextField(


                          onChanged: (val) {

                            findPlace(val);
                          },


                          controller: dropOffTextEditingController,
                          decoration: InputDecoration(
                            hintText: "where to  location",
                            fillColor: Colors.grey,
                            filled: true,
                            border: InputBorder.none,
                            isDense: true ,
                            contentPadding: EdgeInsets.only(left: 11.0 , top: 8.0 , bottom: 8.0),
                          ),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    ),

        ],
      ),
    );
  }

  void findPlace(String placeName) async {

    if(placeName.length > 1){

      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&component=country:eg" ;


  var res = await RequestAssistant.getRequest(autoCompleteUrl);

  if(res == "failed"){

    return;
  }

  print("Places predictions Response :: ");
  print(res);
    }
  }
}
