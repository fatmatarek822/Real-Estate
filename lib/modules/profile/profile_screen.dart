import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/layout/layout_screen.dart';
import 'package:realestateapp/models/post_model.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/edit_post/edit_post.dart';
import 'package:realestateapp/shared/components/components.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var userModel = AppCubit.get(context).userModel;
        var profileImage = AppCubit.get(context).profileImage;


        nameController.text = userModel!.name!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if(state is UserUpdateLoadingState)
                          const LinearProgressIndicator(),
                        if(state is UserUpdateLoadingState)
                          const SizedBox(
                            height: 5,
                          ),
                        Center(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                backgroundImage: profileImage == null ? NetworkImage(
                                    '${userModel.image}'
                                ) :FileImage(profileImage) as ImageProvider,
                                maxRadius: 100,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: ()
                                  {
                                    AppCubit.get(context).getProfileImage();
                                  },
                                  icon: Icon(Icons.camera_alt),
                                  color: Colors.black,
                                  iconSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'Please Enter Your Name';
                            }
                          },
                          label: 'Name',
                          prefix: Icons.person,
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'Please Enter Your phone';
                            }
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: ()
                                {
                                  AppCubit.get(context).updateUser(name: nameController.text, phone: phoneController.text);
                                },
                                child: const Text(
                                  'Upload Profile Data',
                                ),
                              ),
                            ),

                          ],
                        ),
                        if(AppCubit.get(context).profileImage != null)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: ()
                                  {
                                    AppCubit.get(context).uploadProfileImage(name: nameController.text, phone: phoneController.text);
                                  },
                                  child: const Text(
                                    'Upload Profile Image',
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(
                          height: 20,
                        ),

                        // defaultButton(
                        //   function: ()
                        //   {
                        //     AppCubit.get(context).currentIndex =0;
                        //     AppCubit.get(context).signOut(context);
                        //   },
                        //   text: 'Logout',
                        // ),
                      ],
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition: AppCubit.get(context).Yourposts.isNotEmpty,
                  builder: (context) => ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => BuildYourPost(AppCubit.get(context).Yourposts[index], context),
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 10,),
                    itemCount: AppCubit
                        .get(context)
                        .Yourposts
                        .length,
                  ),
                  fallback: (context) => const Center(
                    child: Center(child: Text('No Posts yet')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget BuildYourPost(PostModel model, context) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Padding(

      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage:
              NetworkImage('${model.image}',
              ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model.name}',
                        ),
                        const Icon(Icons.check_circle,
                          size: 14,
                          color: Colors.blue,
                        ),
                      ]
                  ),

                  const Text(
                    'Broker',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ], //
              ),
              const Spacer(),
              IconButton(
                  onPressed: ()
                  {
                    showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        builder: (context) => Container(
                            height: 170,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.edit,),
                                  title: Text('Edit'),
                                  onTap: ()
                                  {
                                    navigateTo(context, EditPost(postmodel: model,));
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete,),
                                  title: Text('Delete'),
                                  onTap: ()
                                  {
                                    AppCubit.get(context).deletePost();
                                    navigateTo(context, LayoutScreen());
                                    print('Deleted');

                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.close,),
                                  title: Text('Close'),
                                  onTap: ()
                                  {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),

                    );
                  },
                  icon: const Icon(
                      Icons.more_horiz,
                  ),
              ),
            ],


          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: double.infinity,
            ),
          ),

          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Image(image: NetworkImage('${model.postImage}',

                  ),

                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.favorite),
                    color: Colors.black.withOpacity(0.5),
                    iconSize: 25,
                  ),
                ],
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
                child: (
                    Row(
                      children:
                      [
                        Text('${model.no_of_room}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const Icon(Icons.king_bed_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text('${model.no_of_bathroom}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const Icon(Icons.bathtub_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox (
                          width: 50,
                        ),
                        Text('${model.area}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const Text(' m',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),

                      ],
                    )
                ),
              ),

            ],
          ),
          Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.house_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('${model.namePost}'),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.description),
                        //     Text('${model.description}'),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.place),
                        //     Text('${model.place}'),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.price_change_outlined),
                        //     Text('${model.price}'),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ],
      ),
    ),
  );

}