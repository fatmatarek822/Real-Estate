import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/models/message_model.dart';
import 'package:realestateapp/models/user_model.dart';
import 'package:realestateapp/modules/chat_details/chat_details_screen.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/shared/components/components.dart';

// class ChatScreen extends StatelessWidget {
//
//   UserModel? userModel;
//   ChatScreen({this.userModel});
//
//  // const ChatScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage(
//                   '${userModel!.image}',
//               ),
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             Text(
//                 '${userModel!.name}',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return ConditionalBuilder(
          condition: AppCubit.get(context).users.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildChatItem(AppCubit.get(context).users[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: AppCubit.get(context).users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }


  Widget buildChatItem(UserModel model, context) => InkWell(
    onTap: ()
    {
      navigateTo(context, ChatDetailsScreen(
        userModel: model,
      ));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: NetworkImage('${model.image}',
          ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        '${model.name}',
                      ),
                    ]
                ),

              ],
            ),
          ),

        ],
      ),
    ),
  );
}


