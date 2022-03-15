import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/layout/layout_screen.dart';
import 'package:realestateapp/modules/register/cubit/cubit.dart';
import 'package:realestateapp/modules/register/cubit/states.dart';
import 'package:realestateapp/shared/components/components.dart';
import 'package:realestateapp/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state)
        {
          if(state is CreateUserSuccessState)
          {
            CacheHelper.saveData(
              key: 'uid',
              value: state.uid,
            ).then((value) =>
            {
              navigateAndFinish(context, LayoutScreen(),)
            });
          }
        },
        builder: (context, state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height:15.0,
                      ),
                      const Text(
                        'Register Now To Choose your Property',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),

                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'Please Enter Your name' ;
                          }
                        },
                        label: 'Name',
                        prefix: Icons.person,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),


                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'Please Enter Your Email Address' ;
                          }
                        },
                        label: 'Email Address',
                        prefix: Icons.email,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      defaultFormField(
                          isPassword: RegisterCubit.get(context).isPassword,
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'Please Enter Your Password' ;
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock,
                          suffix: RegisterCubit.get(context).suffix,
                          suffixpressed: ()
                          {
                            RegisterCubit.get(context).ChangePasswordVisibility();
                          }

                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'Please Enter Your Phone' ;
                          }
                        },
                        label: 'Phone',
                        prefix: Icons.phone,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => defaultButton(
                          function: ()
                          {
                            if(formKey.currentState!.validate())
                            {
                              RegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone : phoneController.text,
                              );

                            }

                          },
                          text: 'Register',
                        ),
                        fallback: (context) => const Center(child: CircularProgressIndicator()),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}