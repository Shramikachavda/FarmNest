
import 'package:google_maps_flutter/google_maps_flutter.dart';

class  FarmDetail {
  final String name ;
  final String addressLine1;
  final String addressLine2;
  final LatLng? LandMark;
  final int phoneNum;

  FarmDetail({required this.name, required this.addressLine1, required this.addressLine2,  this.LandMark, required this.phoneNum});

}