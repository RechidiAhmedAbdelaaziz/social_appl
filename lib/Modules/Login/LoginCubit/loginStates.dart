// ignore_for_file: file_names



abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginPassVisibilityState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {
  final String error;
  LoginErrorState(this.error);
}

class LoginSuccessState extends LoginStates {
  
}
