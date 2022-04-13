import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/models/post_model.dart';
import 'package:realestateapp/models/user_model.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/new_post/new_post.dart';
import 'package:realestateapp/shared/components/components.dart';
import 'package:realestateapp/shared/components/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: BuildCarusal(context),
                        ),
                      ),
                      ConditionalBuilder(
                        condition: AppCubit.get(context).posts.isNotEmpty,
                        builder: (context) => Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) => BuildPost(AppCubit.get(context).posts[index], context),
                                  separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10,),
                                  itemCount: AppCubit
                                      .get(context)
                                      .posts
                                      .length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FloatingActionButton(onPressed: () {
                                    navigateTo(context, NewPost());
                                  }, child: const Icon(Icons.add),
                                  ),
                                )
                              ],
                            ),
                        fallback: (context) => const Center(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                      ),
                    ],
                  ),
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
                                    style: TextStyle(
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
                                      style: TextStyle(
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
                                     style: TextStyle(
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
                                    Icon(Icons.house_outlined),
                                    SizedBox(
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


  Widget BuildCarusal (BuildContext context) => ListView(

    children: [
      SizedBox(
        height: 200,
        width: double.infinity,
        child: CarouselSlider(
          items: const [
            Image(image: NetworkImage('https://img.freepik.com/free-photo/3d-rendering-large-modern-contemporary-house-wood-concrete-early-evening_190619-1492.jpg?w=1380',),),
            Image(image: NetworkImage('https://img.freepik.com/free-photo/3d-rendering-large-modern-contemporary-house-wood-concrete_190619-1484.jpg?w=1380',),),
            Image(image: NetworkImage('https://img.freepik.com/free-photo/business-man-create-design-modern-building-real-estate_35761-316.jpg?w=1380',),),
            Image(image: NetworkImage('https://img.freepik.com/free-photo/making-money-with-property-real-estate-investment_35761-380.jpg?w=1380',),),
          ],
          options: CarouselOptions(
            height: 250.0,
            initialPage: 0,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            enlargeCenterPage: true,

          ),
        ),
      ),
    ],
  );


}