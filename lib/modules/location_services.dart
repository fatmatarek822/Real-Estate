/*

import 'package:location/location.dart';

class LocationServices
{
  Future<LocationData> getLocation() async
  {
    Location location = new Location();
    bool _servicesEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _servicesEnabled = await location.serviceEnabled();
    if(!_servicesEnabled){
      _servicesEnabled = await location.requestService();
      if(!_servicesEnabled){
        throw Exception();
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied)
    {
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        throw Exception();
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }
}


 */