// ignore_for_file: file_names

abstract class SocialStates {}

class InitialStates extends SocialStates {}

class ChangeBottomNavState extends SocialStates{}
class NewPostState extends SocialStates{}

class GetUserLoadingState extends SocialStates {}
class GetUserSuccessState extends SocialStates {}
class GetUserErrorState extends SocialStates {
  String error;
  GetUserErrorState(this.error);
}

class GetPicLoadingState extends SocialStates{}
class GetPicSuccessState extends SocialStates{}
class GetPicErrorState extends SocialStates{}


class UploadPicLoadingState extends SocialStates{}
class UploadPicSuccessState extends SocialStates{}
class UploadPicErrorState extends SocialStates{}


class GetUrlPicSuccessState extends SocialStates{}
class GetUrlPicErrorState extends SocialStates{}

class UpdateDataLoadingState extends SocialStates{}
class UpdateDataSuccessState extends SocialStates{}
class UpdateDataErrorState extends SocialStates{}

class UpdatePicsSuccessState extends SocialStates{}
class UpdatePicsErrorState extends SocialStates{}


class CreatPostLoadingState extends SocialStates{}
class CreatPostSuccessState extends SocialStates{}
class CreatPostErrorState extends SocialStates{}

class PostImagesState extends SocialStates{}