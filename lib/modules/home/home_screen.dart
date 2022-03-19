import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/models/post_model.dart';
import 'package:realestateapp/models/user_model.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/new_post/new_post.dart';
import 'package:realestateapp/shared/components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return ConditionalBuilder(
          condition: AppCubit.get(context).posts.length >0 ,
          builder: (context) => Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => BuildPost(AppCubit.get(context).posts[index], context),
                separatorBuilder: (context, index) => const SizedBox(height: 10,),
                itemCount: AppCubit.get(context).posts.length,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FloatingActionButton(onPressed: ()
                {
                  navigateTo(context, NewPost());
                }, child: const Icon(Icons.add),
                ),
              )
            ],
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget BuildPost(PostModel model, context) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child:   Padding(

      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage('${model.image}',
              ),
              ),

              const SizedBox(
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
                  ],
                ),
              ),

            ],
          ),

          Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),

          const SizedBox(
            height: 5,
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
                Image(image: NetworkImage('${model.postImage}'),),
                Row(
                  children: [
                    Text('${model.no_of_room}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.king_bed_outlined,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text('${model.no_of_bathroom}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.bathtub_outlined,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text('${model.area}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const Text('m',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
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
                              Icon(Icons.house_outlined),
                              Text('${model.namePost}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.description),
                              Text('${model.description}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.place),
                              Text('${model.place}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.price_change_outlined),
                              Text('${model.price}'),
                            ],
                          ),
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
