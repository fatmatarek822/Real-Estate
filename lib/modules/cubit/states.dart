abstract class AppStates {}

class AppInitialState extends AppStates{}

class AppGetUserLoadingState extends AppStates{}

class AppGetUserSuccessState extends AppStates{}

class AppGetUserErrorState extends AppStates {
  final String error;
  AppGetUserErrorState(this.error);
}

class AppChangeBottomNavState extends AppStates{}

class ProfileImagePickedSuccessState extends AppStates{}

class ProfileImagePickedErrorState extends AppStates{}

class UploadProfileImageSuccessState extends AppStates{}

class UploadProfileImageErrorState extends AppStates{}

class UserUpdateErrorState extends AppStates{}

class UserUpdateLoadingState extends AppStates{}

class AppChangeModeState extends AppStates{}

class AppCreatePostLoadingState extends AppStates{}

class AppCreatePostSuccessState extends AppStates{}

class AppCreatePostErrorState extends AppStates {
  final String error;
  AppCreatePostErrorState(this.error);
}

class PostImagePickedSuccessState extends AppStates {}

class PostImagePickedErrorState extends AppStates
{

}

class AppRemovePostImageState extends AppStates{}

class AppGetPostsLoadingState extends AppStates{}

class AppGetPostsSuccessState extends AppStates{}

class AppGetPostsErrorState extends AppStates
{
  final String error;
  AppGetPostsErrorState(this.error);
}

class AppGetAllUserLoadingState extends AppStates{}

class AppGetAllUserSuccessState extends AppStates{}

class AppGetAllUserErrorState extends AppStates
{
  final String error;
  AppGetAllUserErrorState(this.error);
}

class AppSendMessageSuccessState extends AppStates{}

class AppSendMessageErrorState extends AppStates{

  final String error;
  AppSendMessageErrorState(this.error);

}

class AppGetMessagesLoadingState extends AppStates{}

class AppGetMessagesSuccessState extends AppStates{}

class AppGetMessagesErrorState extends AppStates{}

class AppSettingState extends AppStates{}

class PostUpdateErrorState extends AppStates{}

// class AppPickAddImageSuccessState extends AppStates
// {
// }
//
// class AppUploadAddImageErrorState extends AppStates
// {
//   final String error;
//   AppUploadAddImageErrorState(this.error);
// }

class UploadNewImageSuccessState extends AppStates{}

class UploadNewImageErrorState extends AppStates
{
  final String error;
  UploadNewImageErrorState(this.error);

}

class UploadNewPostLoadingState extends AppStates{}

class UploadNewPostSuccessState extends AppStates{}

class UploadNewPostErrorState extends AppStates
{
  final String error;
  UploadNewPostErrorState(this.error);
}




