import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:path/path.dart' as path;

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
    const HomeScreen(),
    const MapScreen(),
    const FavouriteScreen(),
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
      emit(AppGetYourPostsSuccessState());
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

/*
  List<XFile> addImages = [];
  List<String> addImagesUrl = [];
  var pickerimage = ImagePicker();

  Future<void> getAddStreamImage() async
  {
    emit(PostImagePickedSuccessState());
    final List<XFile>? pickedImages = await picker.pickMultiImage();
    if (pickedImages!.isNotEmpty) {
      addImages = [];
      addImagesUrl = [];
      addImages.addAll(pickedImages);
    } else
    {
      emit(PostImagePickedErrorState());
    }
  }
*/
  // final ImagePicker _picker = ImagePicker();
  // List<XFile>? imageFileList =[];
  //
  // void selectImages() async
  // {
  //   final List<XFile>? selectedImages = await _picker.pickMultiImage();
  //   if(selectedImages!.isNotEmpty)
  //   {
  //     imageFileList!.addAll(selectedImages);
  //     emit(PostImagePickedSuccessState());
  //   }
  // }


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

  // PostModel? postModel;

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
          //    postModel = PostModel.fromJson(element.data());
        }).catchError((error){

        });
      });
      emit(AppGetPostsSuccessState());
    })
        .catchError((error){
      emit(AppGetPostsErrorState(error.toString()));
      print(error.toString());
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
      emit(AppGetAllUserErrorState(error.toString()));
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


  List<PostModel> Yourposts =[];
  void getYourPosts()
  {
    emit(AppGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        print(element.data()['uid']);
        print(element.id);
        element.reference.collection('likes').get().then((value){
          postsId.add(element.id);
          if(element.data()['uid'] == uid)
            Yourposts.add(PostModel.fromJson(element.data()));
        }).catchError((error){

        });
      });
      emit(AppGetYourPostsSuccessState());
    })
        .catchError((error){
      emit(AppGetYourPostsErrorState(error.toString()));
      print(error.toString());
    });
  }


  void updatePostImage({
    required String name,
    required String uid,
    required String image,
    required String namePost,
    required String description,
    required String place,
    required String no_of_room,
    required String no_of_bathroom,
    required String area,
    required String price,
  })
  {
    emit(UpdatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value)
      {
        //   emit(UploadProfileImageSuccessState());
        print(value);
        updatePost(
          name: name,
          uid : uid,
          image: image,
          namePost: namePost,
          description: description,
          place: place,
          no_of_room: no_of_room,
          no_of_bathroom: no_of_bathroom,
          area: area,
          price: price,
          postImage: value,
        );
        // profileImageUrl = value;
      })
          .catchError((error){
        emit(UploadPostImageErrorState(error.toString()));
      });
    })
        .catchError((error){
      emit(UploadPostImageErrorState(error.toString()));
    });
  }


  void updatePost({
    required String name,
    required String uid,
    required String image,
    required String namePost,
    required String description,
    required String place,
    required String no_of_room,
    required String no_of_bathroom,
    required String area,
    required String price,
    String? postImage,

  })
  {
    emit(UpdatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      uid : userModel!.uid,
      image: userModel!.image,
      namePost: namePost,
      description: description,
      place: place,
      no_of_room : no_of_room,
      no_of_bathroom: no_of_bathroom,
      area: area,
      price: price,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(model.postid)
        .update(model.toMap())
        .then((value){

      emit(UpdatePostSuccessState());
      print('===========================================================================');
      print('uppdated successfuly ');
    })
        .catchError((error)
    {
      emit(UpdatePostErrorState(error.toString()));
      print(error.toString());
    });
  }

  void deletePost(String postid)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postid)
        .delete()
        .then((value)
    {
      // posts =[];
      // getPosts();
      // Yourposts =[];
      // getYourPosts();

      print('deleted');
      emit(DeletePostSuccessState());
      print('============================================================================================');
      print('============================================================================================');


    })
        .catchError((error)
    {
      emit(DeletePostErrorState(error.toString()));
    }
    );
  }


/*
    UploadNewPost({
    required String namePost,
    required String description,
    required String place,
    required String no_of_room,
    required String no_of_bathroom,
    required String area,
    required List? postImage,
  }) async {
    emit(UploadNewPostLoadingState());
    CollectionReference? imgRef;
    firebase_storage.Reference? ref;
    for (var images in postimage)
    {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(images.path).pathSegments.last}');
      await ref.putFile(images).whenComplete(() async
    {
    await ref!.getDownloadURL().then((value)
    {
      print(value);
    imgRef?.add({'url': value});
       }).then((value) {
         print('success');
         emit(UploadNewPostSuccessState());
         print(images.path);

    }).catchError((error)
    {
      emit(UploadNewPostErrorState(error.toString()));
      print(error.toString());
    });

    });
    }
    CreatePost(
      namePost: namePost,
      description: description,
      place: place,
      no_of_room: no_of_room,
      no_of_bathroom: no_of_bathroom,
      area: area,
      postImage: postImage!,
    );
    print('successful');

    imgRef = FirebaseFirestore.instance.collection('posts');
   // emit(UploadNewPostSuccessState());
  }

*/
/*
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  Future<void> UploadNewPost({
    required String namePost,
    required String description,
    required String place,
    required String no_of_room,
    required String no_of_bathroom,
    required String area,
    List? postImage ,
  })
  async {
    emit(AppCreatePostLoadingState());

    for(var images in postimage)
    {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${images.path}');
      await ref!.putFile(images).whenComplete(() async
    {
    await ref!.getDownloadURL().then((value)
    {
    imgRef?.add({'url': value});
    print(imgRef!.path);
    });
    });

      // firebase_storage.FirebaseStorage.instance
      //     .ref()
      //     .child('posts/${Uri.file(postimage[i].path).pathSegments.last}')
      //     .putFile(File(postimage[i].path))
      //     .then((value)
      // {
      //   print(value.toString());
      //   value.ref.getDownloadURL();
      //   print(value);
      // }).catchError((error)
      // {
      //
      // });
    }
    imgRef = FirebaseFirestore.instance.collection('posts');
    CreatePost(
        namePost: namePost,
        description: description,
        place: place,
        no_of_room: no_of_room,
        no_of_bathroom: no_of_bathroom,
        area: area,
       postImage: postimage,
    );
    emit(AppCreatePostSuccessState());
    }

*/
// void UploadNewPost({
//   required String namePost,
//   required String description,
//   required String place,
//   required String no_of_room,
//   required String no_of_bathroom,
//   required String area,
//    required List Images,
// })
// {
//   emit(AppCreatePostLoadingState());
//
//   int i=0;
//   for(i;i<Images.length;i++)
//   {
//     firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('posts/${Uri.file(Images[i].path).pathSegments.last}')
//         .putFile(File(Images[i].path))
//         .then((value)
//     {
//       Images.add({'url' : value});
//       print(value.toString());
//       value.ref.getDownloadURL();
//       emit(UploadNewPostSuccessState());
//       FirebaseFirestore.instance.collection('posts').doc(uid).path;
//     }).catchError((error)
//     {
//       emit(UploadNewPostErrorState(error.toString()));
//     });
//   }
//
//   CreatePost(
//       namePost: namePost,
//       description: description,
//       place: place,
//       no_of_room: no_of_room,
//       no_of_bathroom: no_of_bathroom,
//       area: area,
//      postImage: postimage,
//   );
//
//
//   }




// List<File> postimage= [];
// chooseImage() async {
//   final pickedFile = await picker.getImage(source: ImageSource.gallery);
//    postimage.add(File(pickedFile!.path));
//
//   print('Successful');
//   emit(AppPickAddImageSuccessState());
//   if (pickedFile.path == null)
//   {
//     retrieveLostData();
//     print(pickedFile.path);
//     emit(AppUploadAddImageErrorState(Error.safeToString(Error)));
//     print('Error');
//   }
// }
// Future<void> retrieveLostData() async {
//   final LostData response = await picker.getLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   if (response.file != null) {
//       postimage.add(File(response.file!.path));
//       emit(AppPickAddImageSuccessState());
//   } else {
//     print(response.file);
//     print('Error');
//   }
// }
/*
  List<File> postimage= [];
  dynamic chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
      postimage.add(File(pickedFile!.path));
      emit(UploadNewImageSuccessState());
      print('Successful');

    if (pickedFile.path == null)
    {
      retrieveLostData();
      print('No image selected');
      emit(UploadNewImageErrorState(Error.safeToString(Error)));
    }
  }
  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file == null) {
        postimage.add(File(response.file!.path));
        emit(UploadNewImageSuccessState());
    } else {
      print(response.file);
      emit(UploadNewImageErrorState(Error.safeToString(Error)));
      print('Error');
    }
  }
*/
/*
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  Future uploadNewPost()async
  {
    for(var images in postimage)
    {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${images.path}');
      await ref!.putFile(images).whenComplete(() async
      {
        await ref!.getDownloadURL().then((value)
        {
          imgRef!.add({'url': value});
        });
      });
    }
    CreatePost(
        namePost: namePost,
        description: description,
        place: place,
        no_of_room: no_of_room,
        no_of_bathroom: no_of_bathroom,
        area: area,
        postImage: postImage,
    );
 //   imgRef = FirebaseFirestore.instance.collection('posts').doc(uid).set(imgRef);
  }

*/
// Future<void> retrieveLostData() async {
//   final LostData response = await picker.getLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   if (response.file != null) {
//     postimage.add(File(response.file!.path));
//     emit(PostImagePickedSuccessState());
//     print('Successful......');
//   } else {
//     print(response.file);
//     emit(PostImagePickedErrorState(Error.safeToString(Error)));
//     print('Error');
//   }
// }

// int i=0;
// for(i;i<addStreamImage.length;i++)
// {
//   firebase_storage.FirebaseStorage.instance
//       .ref()
//       .child('users/${Uri.file(addStreamImage[i].path).pathSegments.last}')
//       .putFile(File(addStreamImageUrl[i]))
//       .then((value)
//   {
//     print(value.toString());
//     value.ref.getDownloadURL();
//   }).catchError((error)
//   {
//
//   });
// }
/*
    CreatePost(
      namePost: namePost,
      description: description,
      place: place,
      no_of_room: no_of_room,
      no_of_bathroom: no_of_bathroom,
      area: area,
      postImage: addImages,
    );
*/
//  }
//     firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('users/${Uri.file(imageFileList!.toString()).pathSegments.last}')
//         .putString(imageFileList!.toString())
//         .then((value)
//     {
//       value.ref.getDownloadURL().then((value)
//       {
//         //   emit(SocialUploadCoverImageSuccessState());
//         print(value);
// //        coverImageUrl = value;
//         CreatePost(
//           namePost: namePost,
//           description: description,
//           area: area,
//          place: place,
//           no_of_room: no_of_room,
//           no_of_bathroom: no_of_bathroom,
//           postImage: value,
//         );
//       }).catchError((error)
//       {
//         emit(AppCreatePostErrorState(error.toString()));
//       });
//     }).catchError((error)
//     {
//       emit(AppCreatePostErrorState(error.toString()));
//     });
//   };
/*
  void CreatePost({
    required String namePost,
    required String description,
    required String place,
    required String no_of_room,
    required String no_of_bathroom,
    required String area,
    required String? postImage,
  })
  {
    emit(UploadNewPostLoadingState());
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
      emit(UploadNewPostSuccessState());
    })
        .catchError((error){
      emit(UploadNewPostErrorState (error.toString()));
      print(error.toString());
    });
  }

*/
/*

  Future<LocationData> getLocation() async
  {
    Location location = new Location();
    bool _servicesEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _servicesEnabled = await location.serviceEnabled();
    if(!_servicesEnabled){
      _servicesEnabled = await location.requestService();
      if(!_servicesEnabled){
        throw Exception();
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied)
    {
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        throw Exception();
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

*/
// Future<String> getPlaceId(String  input) async
// {
//   final String url ='';
// }
//
// Future<Map<String, dynamic>> getPlace(String  input) async{}


}