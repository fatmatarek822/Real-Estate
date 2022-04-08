/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';

class pickredimages extends StatelessWidget {
 const pickredimages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        return Scaffold(
          body: GridView.builder(
              itemCount: AppCubit.get(context).postimage.length + 1,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                  child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed : (){AppCubit.get(context).chooseImage();}
                  ),)
                    : Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(                        // run your app
                      image: DecorationImage(
                          image: FileImage(
                              AppCubit.get(context).postimage[index - 1]),
                          fit: BoxFit.cover)),
                );
              }),
        );
      },
    );
  }
}
*/

// var picker = ImagePicker();
  // List<File> postimage= [];
  // chooseImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     postimage.add(File(pickedFile!.path));
  //   });
  //   print('Successful');
  //   if (pickedFile!.path == null)
  //   {
  //     retrieveLostData();
  //     print(pickedFile.path);
  //   }
  // }
  // Future<void> retrieveLostData() async {
  //   final LostData response = await picker.getLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //
  //     setState(() {
  //       postimage.add(File(response.file!.path));
  //     });
  //   } else {
  //     print(response.file);
  //     print('Error');
  //   }
  // }
