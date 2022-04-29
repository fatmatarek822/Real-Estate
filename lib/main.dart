import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/layout/layout_screen.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/login/login_screen.dart';
import 'package:realestateapp/modules/onboarding_screen.dart';
import 'package:realestateapp/shared/components/constant.dart';
import 'package:realestateapp/shared/network/local/cache_helper.dart';
import 'package:realestateapp/shared/styles/themes.dart';

import 'modules/uploadimage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  uid = CacheHelper.getData(key: 'uid');
  bool? onboarding = CacheHelper.getData(key: 'onBoarding');

  // print(uid);

  if (onboarding != null)
  {
    if (uid != null)
    {
      widget = LayoutScreen();
    } else
    {
      widget = LoginScreen();
    }
  } else
  {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget: widget,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {

  bool? isDark;
  String? uid;
  Widget? startWidget;
  MyApp({this.startWidget, this.uid, this.isDark});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getUserData()..getAllUsers()..getYourPosts()..getPosts()..changeAppMode(
        themeMode: isDark,
      ),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            //themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: AnimatedSplashScreen(
              splash: Image(image: AssetImage('assets/images/11.png'),),
              nextScreen: OnBoardingScreen(),
              backgroundColor: Colors.brown,
              duration: 2500,
              centered: true,
              splashIconSize: 100,
              splashTransition: SplashTransition.fadeTransition,
            ),
          );
        },
      ),
    );
  }
}
