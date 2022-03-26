// import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:realestateapp/modules/cubit/cubit.dart';
// import 'package:realestateapp/modules/cubit/states.dart';
// import 'package:realestateapp/shared/components/components.dart';
//
// class SettingScreen extends StatelessWidget {
//    SettingScreen({Key? key}) : super(key: key);
//
//    var formKey = GlobalKey<FormState>();
//    var nameController = TextEditingController();
//    var phoneController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AppCubit, AppStates>(
//       listener: (context, state) {},
//       builder: (context, state)
//       {
//         var userModel = AppCubit.get(context).userModel;
//         var profileImage = AppCubit.get(context).profileImage;
//
//         nameController.text = userModel!.name!;
//         phoneController.text = userModel.phone!;
//
//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   if(state is UserUpdateLoadingState)
//                     const LinearProgressIndicator(),
//                   if(state is UserUpdateLoadingState)
//                     const SizedBox(
//                       height: 5,
//                     ),
//                   Center(
//                     child: Stack(
//                       alignment: AlignmentDirectional.bottomEnd,
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: profileImage == null ? NetworkImage(
//                               '${userModel.image}'
//                           ) :FileImage(profileImage) as ImageProvider,
//                           maxRadius: 100,
//                         ),
//                         CircleAvatar(
//                           backgroundColor: Colors.white,
//                           child: IconButton(
//                             onPressed: ()
//                             {
//                               AppCubit.get(context).getProfileImage();
//                             },
//                             icon: Icon(Icons.camera_alt),
//                             color: Colors.black,
//                             iconSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   defaultFormField(
//                     controller: nameController,
//                     type: TextInputType.name,
//                     validate: (value)
//                     {
//                       if(value!.isEmpty)
//                       {
//                         return 'Please Enter Your Name';
//                       }
//                     },
//                     label: 'Name',
//                     prefix: Icons.person,
//                   ),
//
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   defaultFormField(
//                     controller: phoneController,
//                     type: TextInputType.phone,
//                     validate: (value)
//                     {
//                       if(value!.isEmpty)
//                       {
//                         return 'Please Enter Your phone';
//                       }
//                     },
//                     label: 'Phone',
//                     prefix: Icons.phone,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: ()
//                           {
//                             AppCubit.get(context).updateUser(name: nameController.text, phone: phoneController.text);
//                           },
//                           child: const Text(
//                             'Upload Profile Data',
//                           ),
//                         ),
//                       ),
//
//                     ],
//                   ),
//                   if(AppCubit.get(context).profileImage != null)
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: ()
//                             {
//                               AppCubit.get(context).uploadProfileImage(name: nameController.text, phone: phoneController.text);
//                             },
//                             child: const Text(
//                               'Upload Profile Image',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                   const SizedBox(
//                     height: 20,
//                   ),
//
//                   defaultButton(
//                     function: ()
//                     {
//                       AppCubit.get(context).currentIndex =0;
//                       AppCubit.get(context).signOut(context);
//                     },
//                     text: 'Logout',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/profile/profile_screen.dart';
import 'package:realestateapp/shared/components/components.dart';

class SettingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var userModel = AppCubit.get(context).userModel;
        var profileImage = AppCubit.get(context).profileImage;

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Text(
              'Setting',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: ()
                {
                  AppCubit.get(context).changeAppMode();
                },
                icon: Icon(Icons.brightness_4_outlined),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage: profileImage == null ? NetworkImage(
                      '${userModel!.image}'
                  ) :FileImage(profileImage) as ImageProvider,
                  maxRadius: 80,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                  '${userModel!.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${userModel.email}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              InkWell(
                onTap: ()
                {
                  navigateTo(context, ProfileScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadiusDirectional.circular(30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(
                              width: 10,
                            ),
                            Text('My Profile'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: ()
                {

                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadiusDirectional.circular(30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.help),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Help & Support'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: ()
                {

                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadiusDirectional.circular(30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.language),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                                'Language',),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: ()
                {
                  AppCubit.get(context).currentIndex =0;
                  AppCubit.get(context).signOut(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadiusDirectional.circular(30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Logout'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

