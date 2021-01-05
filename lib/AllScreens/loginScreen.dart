


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:huride_rider/AllScreens/mainscreen.dart';
import 'package:huride_rider/AllScreens/registerationScreen.dart';
import 'package:huride_rider/AllWidgets/progressDialog.dart';
import 'package:huride_rider/main.dart';

class loginScreen extends StatelessWidget {

  static const String idScreen = "login" ;


  TextEditingController emailTextEditingController = TextEditingController();
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
              SizedBox(height: 35.0,),

              Image(

                  image: AssetImage("images/logo.png"),


          width : 390.0 ,
          height: 250.0 ,
          alignment: Alignment.center,
              ) ,

              SizedBox(height: 1.0,),

Text(

  " Login as a Rider" ,

  style: TextStyle( fontSize: 24.0 , fontFamily: "Brand Bold"),

  textAlign: TextAlign.center,


),


          Padding(padding: EdgeInsets.all(20.0),

          child: Column(

            children: [


              SizedBox(height: 35.0,),

              TextField(


                controller: emailTextEditingController,


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
                "Login",
                style: TextStyle( fontSize: 18.0 , fontFamily: "Brand Bold"),

              ),
            ),
    ),

    shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(24.0),
    ),

    onPressed: ()  {

      if( !emailTextEditingController.text.contains("@"))
      {
        displayToastMessage("Email is not valid", context);
      }

      else if( passwordTextEditingController.text.isEmpty)
      {
        displayToastMessage("password is too short , must be at least 6 characters", context);
      }

else
  {

    loginAndAuthinticateUser(context);

  }
},
),





            ],


          ),
          ),

FlatButton(


  onPressed: ()  {

    Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);

  },

    child:  Text(

  " Do not have ccount please register" ,
),

),



            ],
          ),
        ),
      ),

    );
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  void loginAndAuthinticateUser(BuildContext context) async {


    showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext context){

    return      ProgressDialog(message: " Authinticating , please wait .. ",);
      }


    );

    final User firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword
      (email: emailTextEditingController.text,
        password: passwordTextEditingController.text)

        .catchError((errMsg) {

          Navigator.pop(context);
      displayToastMessage("Error" + errMsg.toString() , context);

    }

    )).user;



    if( firebaseUser != null) {

      //save info to databse



      userRef.child(firebaseUser.uid).once().then(( DataSnapshot snap) {

        if(snap.value != null)  {

          displayToastMessage(" Congratulation You are Logged In", context);

          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
        }

        else
          {

            Navigator.pop(context);

            _firebaseAuth.signOut();
            displayToastMessage("No record for this , please create account", context);
          }

      });



    }
    else
    {
      //tell him
      Navigator.pop(context);

      displayToastMessage("Cannot be signed in ", context);
    }





  }
}