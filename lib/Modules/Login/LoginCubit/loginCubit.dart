// ignore_for_file: file_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_appl/Modules/Login/LoginCubit/loginStates.dart';
import 'package:social_appl/Moldels/login_model.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isShown = true;
  void showPass() {
    isShown = !isShown;
    emit(LoginPassVisibilityState());
  }

  late LoginModel loginModel;
  void userLogin({required String email, required String password}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginErrorState(value.user!.uid));
      emit(LoginSuccessState());
    }).catchError((error) {
      print('Error is ${error.toString()}');
      emit(LoginErrorState(error.toString()));
    });
  }
}
