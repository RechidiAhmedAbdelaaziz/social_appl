// ignore_for_file: file_names



abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterPassVisibilityState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String error;
  RegisterErrorState(this.error);
}

class RegisterSuccessState extends RegisterStates {
  
}
