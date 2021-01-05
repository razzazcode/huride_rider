
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huride_rider/AllScreens/loginScreen.dart';
import 'package:huride_rider/AllScreens/mainscreen.dart';
import 'package:huride_rider/AllWidgets/progressDialog.dart';
import 'package:huride_rider/main.dart';

class RegisterationScreen extends StatelessWidget {


  static const String idScreen = "register" ;

TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column (

            children: [
              SizedBox(height: 20.0,),

              Image(

                image: AssetImage("images/logo.png"),


                width : 390.0 ,
                height: 250.0 ,
                alignment: Alignment.center,
              ) ,

              SizedBox(height: 1.0,),

              Text(

                " register as a Rider" ,

                style: TextStyle( fontSize: 24.0 , fontFamily: "Brand Bold"),

                textAlign: TextAlign.center,


              ),


              Padding(padding: EdgeInsets.all(20.0),

                child: Column(

                  children: [



                    SizedBox(height: 1.0,),

                    TextField(

                      controller: nameTextEditingController,

                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(

                        labelText: "Name" ,
                        labelStyle: TextStyle(

                          fontSize: 14.0,


                        ),

                        hintStyle: TextStyle (
                          fontSize: 10.0 ,

                          color: Colors.grey,
                        ),

                      ),


                      style:  TextStyle(
                        fontSize: 14.0,),

                    ),





                    SizedBox(height: 1.0,),

                    TextField(

                      controller : emailTextEditingController,

                      keyboardType: TextInputType.emailAddress,

                      decoration: InputDecoration(

                        labelText: "Email" ,
                        labelStyle: TextStyle(

                          fontSize: 14.0,

                        ),

                        hintStyle: TextStyle (
                          fontSize: 10.0 ,

                          color: Colors.grey,
                        ),

                      ),


                      style:  TextStyle(
                        fontSize: 14.0,),

                    ),




                    SizedBox(height: 1.0,),

                    TextField(

                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,

                      decoration: InputDecoration(

                        labelText: "Phone" ,
                        labelStyle: TextStyle(

                          fontSize: 14.0,


                        ),

                        hintStyle: TextStyle (
                          fontSize: 10.0 ,

                          color: Colors.grey,
                        ),

                      ),


                      style:  TextStyle(
                        fontSize: 14.0,),

                    ),










                    SizedBox(height: 1.0,),

                    TextField(

                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(

                        labelText: "Password" ,
                        labelStyle: TextStyle(

                          fontSize: 14.0,


                        ),

                        hintStyle: TextStyle (
                          fontSize: 10.0 ,

                          color: Colors.grey,
                        ),

                      ),




                      style:  TextStyle(
                        fontSize: 14.0,),

                    ),



                    SizedBox(height: 20.0,),

                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(

                        height: 50.0 ,
                        child: Center(

                          child: Text(
                            "create new account",
                            style: TextStyle( fontSize: 18.0 , fontFamily: "Brand Bold"),

                          ),
                        ),
                      ),

                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),

                      onPressed: ()  {

                        if( nameTextEditingController.text.length < 4){

displayToastMessage("name should be at least 4 charachters", context);
                        }
                        else if( !emailTextEditingController.text.contains("@")) 
                          {
                            displayToastMessage("Email is not valid", context);
                          }
                        else if (phoneTextEditingController.text.length < 10) {

                          displayToastMessage(" phone number is not valid", context);
                        }
                        else if (passwordTextEditingController.text.length < 6){

                          displayToastMessage("paswword is very short", context);
                        }

                        else {
                          registerNewUser(context);

                        }

                      },
                    ),





                  ],


                ),
              ),

              FlatButton(


                onPressed: ()  {

                  Navigator.pushNamedAndRemoveUntil(context, loginScreen.idScreen, (route) => false);

                },

                child:  Text(

                  " already have account  ? login here" ,
                ),

              ),



            ],
          ),
        ),
      ),

    );
  }



  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {


    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return      ProgressDialog(message: " Registering new User , please wait .. ",);
        }


    );

    final User firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword
      (email: emailTextEditingController.text,
        password: passwordTextEditingController.text)

        .catchError((errMsg) {

      Navigator.pop(context);

      displayToastMessage("Error" + errMsg.toString() , context);
    }

    )).user;

    if( firebaseUser != null) {

      //save info to databse
      userRef.child(firebaseUser.uid);

      Map userDataMap = {

        "name" : nameTextEditingController.text.trim(),
        "email" : emailTextEditingController.text.trim(),
        "phonr" : phoneTextEditingController.text.trim(),
        "password" : passwordTextEditingController.text.trim(),
      };

      userRef.child(firebaseUser.uid).set(userDataMap);

      displayToastMessage(" Congratulation user has been created", context);

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    }
    else
    {
      //tell him

      Navigator.pop(context);

      displayToastMessage("New user has not been created ", context);
    }

   }
}

displayToastMessage(String message , BuildContext context) {

  Fluttertoast.showToast(msg: message);
}