
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realestateapp/shared/components/constant.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _intitialCameraPosition = CameraPosition(
    target: LatLng(30.00944, 31.20861),
    zoom: 14.0,
  );





  // Future<void> _showSearchDialog() async {
  //   var p = await PlacesAutocomplete.show(
  //       context: context,
  //       apiKey: API_KEY,
  //       mode: Mode.fullscreen,
  //       language: "ar",
  //       region: "ar",
  //       offset: 0,
  //       hint: "Type here",
  //       radius: 1000,
  //       types: [],
  //       strictbounds: false,
  //       components: [Component(Component.country, "ar")]);
  //   _getLocationFromPlaceId(p!.placeId);
  // }
  //
  // Future<void> _getLocationFromPlaceId(String placeId) async{
  //   GoogleMapPlaces _places =GoogleMapPlaces(
  //     apiKey: API_KEY,
  //     apiHeader: await GoogleApiHeaders().getHeaders(),
  //   );
  //
  //
  // }





  //LatLng currentLocation = _intitialCameraPosition.target;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
    //      IconButton(onPressed: _showSearchDialog, icon: Icon(Icons.search),),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _intitialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller)
        {
          _controller.complete(controller);
        },
     //   onCameraMove: (CameraPosition newPos){
        // setState((){
        //   currentLocation = newPos.target;
        // });
        //   },
      ),

    );
  }
}
