import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo(context, Widget) =>  Navigator.push(
  context,
  MaterialPageRoute(
      builder: (context) => Widget
  ),
);

void navigateAndFinish(context, Widget) =>  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
      builder: (context) => Widget
  ),
      (Route<dynamic> route) => false,
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  String? Function(String?)? onSubmit,
  String? Function(String?)? onChange,
//    String? Function(String?)? ontap,
//   Function? ontap,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword=false,
  bool isClickable= true,
  VoidCallback? suffixpressed,
  VoidCallback? ontap,


}) => TextFormField(
  validator:validate,
  obscureText:isPassword ,
  controller: controller,
  keyboardType:type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap: ontap,


  decoration: InputDecoration(
    labelText:label,
    prefixIcon:Icon(prefix,),
    suffixIcon: suffix !=null ?
    IconButton( onPressed: suffixpressed ,
        icon: Icon(suffix,)) :null ,
    border: const OutlineInputBorder(),
  ),

);


Widget defaultButton ({
  double width = double.infinity,
  Color background = Colors.blue,
  required VoidCallback function ,
  required String text,
  bool? isUpperCase ,
}) =>
    Container(
      width: width ,
      color: background, child: MaterialButton(
      onPressed:function,
      child:Text(
        text,
        style:const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    );


Widget defaultTextButton({
  required VoidCallback function,
  required String text,
})=> TextButton(
  onPressed: function,
  child: Text(text.toUpperCase()),
);


void showToast({
  required String text,
  required ToastStates state,
}) => Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: chooseToastColor(state),
  textColor: Colors.white,
  fontSize: 16.0,
);

//enum
enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color;
  switch(state)
  {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;

    case ToastStates.ERROR:
      color = Colors.red;
      break;

    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}


Widget myDivider() => Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);


// void signOut (context)
// {
//   AppCubit.get(context).currentIndex ==0;
//   CacheHelper.removeData(key: 'uid').then((value)
//   {
//     if(value)
//     {
//       navigateAndFinish(context, LoginScreen(),);
//     }
//   });
// }