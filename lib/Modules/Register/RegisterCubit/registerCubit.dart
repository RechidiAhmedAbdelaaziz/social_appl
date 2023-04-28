// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Modules/Register/RegisterCubit/registerStates.dart';
import 'package:social_appl/Moldels/login_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isShown = true;
  void showPass() {
    isShown = !isShown;
    emit(RegisterPassVisibilityState());
  }

  late LoginModel registerModel;
  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(RegisterErrorState(value.user!.uid.toString()));
      emit(RegisterSuccessState());
    }).catchError((error) {
      // ignore: avoid_print
      print('Error is ${error.toString()}');
      emit(RegisterErrorState(error.toString()));
    });
  }
}
