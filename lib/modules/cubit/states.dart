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

class PostImagePickedErrorState extends AppStates{}

class AppRemovePostImageState extends AppStates{}

class AppGetPostsLoadingState extends AppStates{}

class AppGetPostsSuccessState extends AppStates{}

class AppGetPostsErrorState extends AppStates
{
  final String error;
  AppGetPostsErrorState(this.error);
}






