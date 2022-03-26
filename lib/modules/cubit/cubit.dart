import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:realestateapp/models/message_model.dart';
import 'package:realestateapp/models/post_model.dart';
import 'package:realestateapp/models/user_model.dart';
import 'package:realestateapp/modules/chat/chat_screen.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/favourite/favourite_screen.dart';
import 'package:realestateapp/modules/home/home_screen.dart';
import 'package:realestateapp/modules/login/login_screen.dart';
import 'package:realestateapp/modules/map/map_screen.dart';
import 'package:realestateapp/modules/setting/setting_screen.dart';
import 'package:realestateapp/shared/components/components.dart';
import 'package:realestateapp/shared/components/constant.dart';
import 'package:realestateapp/shared/network/local/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(AppGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().
    then((value) {
       print(value.data());
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetUserSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  List<Widget> Screens = [
    HomeScreen(),
    MapScreen(),
    FavouriteScreen(),
    ChatScreen(),
    SettingScreen(),
  ];

  // List<String> titles = [
  //   'Home',
  //   'Map',
  //   'Favourite',
  //   'Chat',
  //   'Setting',
  // ];
  int currentIndex = 0;
  void ChangeBottomNav(int index)
  {
    if(index ==3)
    {
      getAllUsers();
    }
    if(index ==4)
    {
      emit(AppSettingState());
    } else
    {
      currentIndex = index;
      emit(AppChangeBottomNavState());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(ProfileImagePickedErrorState());
    }
  }

//  String profileImageUrl ='';

  void uploadProfileImage({
    required String name,
    required String phone,
})
  {
    emit(UserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
     //   emit(UploadProfileImageSuccessState());
        print(value);
        updateUser(
            name: name,
            phone: phone,
            image: value,
        );
       // profileImageUrl = value;
      })
          .catchError((error){
            emit(UploadProfileImageErrorState());
      });
    })
        .catchError((error){
      emit(UploadProfileImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    String? image,
})
  {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: userModel!.email,
      image: image?? userModel!.image,
      uid: userModel!.uid,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .update(model.toMap())
        .then((value)
    {
      getUserData();
    })
        .catchError((error)
    {
      emit(UserUpdateErrorState());
    });
  }

  void signOut (context)
  {
    CacheHelper.removeData(key: 'uid').then((value)
    {
      if(value)
      {
        navigateAndFinish(context, LoginScreen(),);
      }
    });
  }

  bool isDark = false;
  ThemeMode appMode = ThemeMode.dark;

  void changeAppMode({bool? themeMode})
  {
    if(themeMode !=null)
    {
      isDark =themeMode;
      emit(AppChangeModeState());
    }
    else
      {
        isDark = !isDark;
        CacheHelper.putBoolean(key: 'isDark', value: isDark)
            .then((value) {
          emit(AppChangeModeState());
        });
      }

  }


  File? postImage;

  Future<void> getPostImage() async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      postImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(PostImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(PostImagePickedErrorState());
    }
  }

  void UploadNewPost({
    required String namePost,
    required String description,
    required String place,
    required String no_of_room,
    required String no_of_bathroom,
    required String area,
    // required String postImage,
  })
  {
    emit(AppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        //   emit(SocialUploadCoverImageSuccessState());
        print(value);
//        coverImageUrl = value;
        CreatePost(
          namePost: namePost,
          description: description,
          area: area,
         place: place,
          no_of_room: no_of_room,
          no_of_bathroom: no_of_bathroom,
          postImage: value,
        );
      }).catchError((error)
      {
        emit(AppCreatePostErrorState(error.toString()));
      });
    }).catchError((error)
    {
      emit(AppCreatePostErrorState(error.toString()));
    });
  }


  void CreatePost({
    required String namePost,
    required String description,
    required String place,
    required String no_of_room,
    required String no_of_bathroom,
    required String area,
    required String postImage,
  })
  {
    emit(AppCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      uid : userModel!.uid,
      image: userModel!.image,
      namePost: namePost,
      description: description,
      place: place,
      no_of_room: no_of_room,
      no_of_bathroom: no_of_bathroom,
      area: area,
      postImage: postImage,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      emit(AppCreatePostSuccessState());
    })
        .catchError((error){
      emit(AppCreatePostErrorState(error.toString()));
    });
  }

  void removePostImage()
  {
    postImage = null;
    emit(AppRemovePostImageState());
  }

  List<PostModel> posts =[];
  List<String> postsId =[];

  void getPosts()
  {
    emit(AppGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        print(element.id);
        element.reference.collection('likes').get().then((value){
          postsId.add(element.id);

          //  comments.add(SocialCommentPostModel.fromJson(element.data()));
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error){

        });
      });
      emit(AppGetPostsSuccessState());
    })
        .catchError((error){
      emit(AppGetPostsErrorState(error.toString()));
    });
  }


  List<UserModel> users=[] ;

  getAllUsers()
  {
    emit(AppGetAllUserLoadingState());
    users =[];
      FirebaseFirestore.instance
          .collection('users')
          .get().then((value) {
        value.docs.forEach((element) {
          if(element.data()['uid'] != userModel!.uid)
            users.add(UserModel.fromJson (element.data()));
        });
        emit(AppGetAllUserSuccessState());
      }).catchError((error){
        emit(AppGetAllUserErrorState(error));
      });
  }


  void sendMessage({
    required String receiverId,
    required String text,
    required String dateTime,
  })
  {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      senderId: userModel!.uid,
      text: text,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    })
        .catchError((error){
      emit(AppSendMessageErrorState(error.toString()));
    });


    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uid)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    })
        .catchError((error){
      emit(AppSendMessageErrorState(error.toString()));
    });


  }

  List<MessageModel> Messages =[];

  void getMessages({
    required String receiverId,
  })
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {

      Messages =[];

      event.docs.forEach((element) {
        Messages.add(MessageModel.fromJson(element.data()));
      });
      emit(AppGetMessagesSuccessState());
    });

  }

}