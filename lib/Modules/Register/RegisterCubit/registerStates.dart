// ignore_for_file: file_names

import 'package:social_appl/Moldels/userModel.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterPassVisibilityState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String error;
  RegisterErrorState(this.error);
}

class RegisterSuccessState extends RegisterStates {}

class CreatUserLoadingState extends RegisterStates {}

class CreatUserErrorState extends RegisterStates {
  final String error;
  CreatUserErrorState(this.error);
}

class CreatUserSuccessState extends RegisterStates {
  UserModel user;
  CreatUserSuccessState(this.user);
}
