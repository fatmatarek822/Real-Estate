

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/layout/layout_screen.dart';
import 'package:realestateapp/models/post_model.dart';
import 'package:realestateapp/models/user_model.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/home/home_screen.dart';
import 'package:realestateapp/shared/components/components.dart';

class EditPost extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var NamePostController = TextEditingController();
  var DescriptionController = TextEditingController();
  var PlaceController = TextEditingController();
  var no_of_roomsController = TextEditingController();
  var no_of_bathroomController = TextEditingController();
  var AreaController = TextEditingController();
  var PriceController = TextEditingController();

  PostModel? postmodel;
  EditPost({this.postmodel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        var profileImage = AppCubit.get(context).postImage;
      },
      builder: (context, state)
      {

       NamePostController.text = postmodel!.namePost!;
       DescriptionController.text = postmodel!.description!;
       PlaceController.text = postmodel!.place!;
       no_of_roomsController.text = postmodel!.no_of_room!;
       no_of_bathroomController.text = postmodel!.no_of_bathroom!;
       AreaController.text = postmodel!.area!;
     //  PriceController.text = postmodel!.price!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Post'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is UpdatePostLoadingState)
                      const LinearProgressIndicator(),
                    if(state is UpdatePostLoadingState)
                      const SizedBox(
                        height: 10,
                      ),
                    Text('Update Post'),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                            controller: NamePostController,
                            type: TextInputType.text,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Please Enter Name of Advertisment' ;
                              }
                            },
                            label: 'Name',
                            prefix: Icons.drive_file_rename_outline,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            controller: DescriptionController,
                            type: TextInputType.text,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Please Enter Description' ;
                              }
                            },
                            label: 'Description',
                            prefix: Icons.description,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            controller: PlaceController,
                            type: TextInputType.text,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Please Enter place' ;
                              }
                            },
                            label: 'Place',
                            prefix: Icons.place,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            controller: no_of_roomsController,
                            type: TextInputType.text,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Please Enter no_of_rooms' ;
                              }
                            },
                            label: 'Number of Rooms',
                            prefix: Icons.king_bed_outlined,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            controller: no_of_bathroomController,
                            type: TextInputType.text,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Please Enter no_of_bathrooms' ;
                              }
                            },
                            label: 'Number of Bathrooms',
                            prefix: Icons.bathtub_outlined,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            controller: AreaController,
                            type: TextInputType.text,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Please Enter Area' ;
                              }
                            },
                            label: 'Area',
                            prefix: Icons.space_bar_outlined,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultFormField(
                            controller: PriceController,
                            type: TextInputType.text,
                            validate: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Please Enter Price' ;
                              }
                            },
                            label: 'Price',
                            prefix: Icons.price_change_outlined,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          TextButton(onPressed: ()
                          {
                            AppCubit.get(context).getPostImage();
                          }, child:
                          Row(
                            children: const [
                              Icon(Icons.photo_library_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Add Photo',
                              ),
                            ],
                          ),
                          ),
                          /*
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              if(AppCubit.get(context).postImage !=null)
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      //  fit: BoxFit.cover,
                                      image:FileImage(AppCubit.get(context).postImage!),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                              if(AppCubit.get(context).postImage !=null)
                                CircleAvatar(child:
                                IconButton(icon: Icon(Icons.close),
                                  onPressed: ()
                                  {
                                    AppCubit.get(context).removePostImage();
                                  },
                                ),
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          */
                        ],
                      ),
                    ),

                    OutlinedButton(
                      onPressed: ()
                      {
                        if(formKey.currentState!.validate())
                        {
                            AppCubit.get(context).updatePost(
                              name: AppCubit.get(context).userModel!.name!,
                              uid: AppCubit.get(context).userModel!.uid!,
                              image: AppCubit.get(context).userModel!.image!,
                              namePost: NamePostController.text,
                              description: DescriptionController.text,
                              place: PlaceController.text,
                              no_of_room: no_of_bathroomController.text,
                              no_of_bathroom: no_of_bathroomController.text,
                              area: AreaController.text,
                              price: PriceController.text,
                            );
                            AppCubit.get(context).posts =[];
                            AppCubit.get(context).getPosts();

                            navigateTo(context, LayoutScreen());
                        }
                      },
                      child: const Text(
                        'Update Post',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
