
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/layout/layout_screen.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/login/cubit/cubit.dart';
import 'package:realestateapp/modules/login/cubit/states.dart';
import 'package:realestateapp/modules/register/register_screen.dart';
import 'package:realestateapp/shared/components/components.dart';
import 'package:realestateapp/shared/components/constant.dart';
import 'package:realestateapp/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state)
        {
          if(state is LoginErrorState)
          {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }if(state is LoginSuccessState)
          {
              CacheHelper.saveData(
                key: 'uid',
                value: state.uid,
              ).then((value) =>
              {
                uid = state.uid,
                navigateAndFinish(context, LayoutScreen(),),
                AppCubit.get(context).getUserData(),
                AppCubit.get(context).Yourposts =[],
                AppCubit.get(context).getYourPosts(),
              });
          }
        },
        builder: (context, state)
        {
          return Scaffold(
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                 Image(image: AssetImage('assets/images/Background.jpg'),
                   height: double.infinity,
                   width: double.infinity,
                   fit: BoxFit.fill,
                 ),
                Container(
                  alignment: AlignmentDirectional.center,
                     width: 310,
                     height: 500,
             color: Colors.black54.withOpacity(0.5),
             //     decoration: BoxDecoration(backgroundBlendMode: BlendMode.darken),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              'Login now to buy or rent any real estste easily',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.black45),
                              child: defaultFormField(

                                style: TextStyle(color: Colors.white),
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
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                ),
                                prefix: Icons.email,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.black45,),

                              child: defaultFormField(
                                  style: TextStyle(color: Colors.white),
                                  isPassword: LoginCubit.get(context).isPassword,
                                  controller: passwordController,
                                  type: TextInputType.visiblePassword,
                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return 'Please Enter Your Password' ;
                                    }
                                  },
                                  onSubmit: (value)
                                  {
                                    if(formKey.currentState!.validate())
                                    {
                                      LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  label: 'Password',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  prefix: Icons.lock,
                                  color: Colors.white,
                                  suffix: LoginCubit.get(context).suffix,
                                  suffixpressed: ()
                                  {
                                    LoginCubit.get(context).ChangePasswordVisibility();
                                  }
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (context) => defaultButton(
                                function: ()
                                {
                                  if(formKey.currentState!.validate())
                                  {
                                    LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text
                                    );
                                  }

                                },
                                text: 'Login',
                              ),
                              fallback: (context) => const Center(child: CircularProgressIndicator()),
                            ),

                            const SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Text(
                                    'Don\'t have an account ?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),

                                TextButton(
                                    onPressed: ()
                                    {
                                      navigateTo(context, RegisterScreen(),);
                                    },
                                  child:
                                  Text('Register',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

