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







