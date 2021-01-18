import 'package:flutter/cupertino.dart';
import 'package:huride_rider/Models/address.dart';

class AppData extends ChangeNotifier {

Address pickUpLocation , dropOffLoocation ;

void updatePickUpLocationAddress ( Address pickUpAddress) {

  pickUpLocation = pickUpAddress ;
  notifyListeners();
}



void dropOffLoocationAddress ( Address dropOffAddress) {

  dropOffLoocation = dropOffAddress ;
  notifyListeners();
}

}