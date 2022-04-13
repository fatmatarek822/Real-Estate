/*

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:realestateapp/models/location.dart';
import 'package:realestateapp/modules/search/search_screen.dart';
import 'package:realestateapp/shared/components/components.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
//  const MapScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();
  DetailsResult? startPosition;
  DetailsResult? endPosition;

  late FocusNode startFocusNode;
  late FocusNode endFocusNode;
//FloatingSearchBarController controller = FloatingSearchBarController();

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions =[];
  Timer? _debounce ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String apikey = 'AIzaSyCc48pLqiM7rD1Ms7-miTv7_aZfhcOOidw';
    googlePlace = GooglePlace(apikey);

    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
  }
/*
  void autoCompleteSearch(String value)async{
    var result = await googlePlace.autocomplete.get(value);
    if(result !=null && result.predictions !=null && mounted)
    {
      print(result);
      print(result.predictions);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
        ),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.grey[100],
                child: TextFormField(
                  controller: searchController,
                  autofocus: false,
                  focusNode: startFocusNode,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: ' Search',
                  prefix: IconButton(onPressed: ()
                  {

                  }, icon: Icon(Icons.search),),
                  ),

                  onChanged: (value)
                  {
                    // if(_debounce?.isActive ?? false) _debounce!.cancel();
                    // _debounce = Timer(const Duration(milliseconds: 1000), ()
                    // {
                    //   if(value.isNotEmpty)
                    //   {
                    //     autoCompleteSearch(value);
                    //     // places api
                    //   }else
                    //   {
                    //     //clear out the results
                    //   }
                    // });

                  },
                 // onChanged : (value){},
                ),
              ),
            ),
            /*
            ListView.builder(
              shrinkWrap: true,
              itemCount: predictions.length,
                itemBuilder: (context, index)
                {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.pin_drop, color: Colors.white,),
                    ),
                    title: Text(predictions[index].description.toString()
                    ),
                    onTap: () async
                    {
                      final placeId = predictions[index].placeId!;
                      final details = await googlePlace.details.get(placeId);
                      if(details!=null && details.result!=null && mounted)
                      {
                        if(startFocusNode.hasFocus)
                        {
                          setState(() {
                            startPosition = details.result;
                            searchController.text = details.result!.name!;
                          });
                        }
                      }
                    },
                  );
                }
            ),
            */

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                height: 400,
                child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(30.00944, 31.20861),
                      zoom: 14.4746,
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildFloatingSearchBar(context)
  // {
  //   final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  //   return FloatingSearchBar(
  //     controller: controller,
  //     elevation: 6,
  //     hintStyle: TextStyle(fontSize: 18),
  //     queryStyle: TextStyle(fontSize: 18),
  //     hint: 'Find a Place',
  //     border: BorderSide(
  //       style: BorderStyle.none,
  //     ),
  //     margins: EdgeInsets.fromLTRB(20, 70, 20, 0),
  //     padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
  //     height: 52,
  //     iconColor: Colors.lightBlue,
  //     scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
  //     transitionDuration: const Duration(milliseconds: 600),
  //     transitionCurve: Curves.easeInOut,
  //     physics: const BouncingScrollPhysics(),
  //     axisAlignment: isPortrait ? 0.0 : -1.0,
  //     openAxisAlignment: 0.0,
  //     width: isPortrait ? 600 : 500,
  //     debounceDelay: const Duration(milliseconds: 500),
  //     onQueryChanged: (query)
  //     {
  //
  //     },
  //     onFocusChanged: (_){},
  //     transition: CircularFloatingSearchBarTransition(),
  //     actions: [
  //       FloatingSearchBarAction(
  //         showIfOpened: false,
  //         child: CircularButton(icon: Icon(Icons.place, color: Colors.black.withOpacity(0.6),), onPressed: (){}),
  //
  //       ),
  //     ],
  //     builder: (context, transition)
  //   {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(8),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //
  //         ],
  //       ),
  //     );
  //   },
  //   );
  // }
}
*/