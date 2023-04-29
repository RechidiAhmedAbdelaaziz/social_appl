// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Modules/Register/RegisterCubit/registerStates.dart';
import 'package:social_appl/Moldels/userModel.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isShown = true;
  void showPass() {
    isShown = !isShown;
    emit(RegisterPassVisibilityState());
  }

  void creatUser({
    required String email,
    required String phone,
    required String name,
    required String uId,
  }) {
    emit(CreatUserLoadingState());
    var userModel = UserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      isEmailVerfied: false,
      bio: 'my bio ...',
      cover: 'https://img.freepik.com/free-photo/galaxy-nature-aesthetic-background-starry-sky-mountain-remixed-media_53876-126761.jpg?t=st=1682758831~exp=1682759431~hmac=b3bc11f87225eb03b7a4a2720ca1b883d9d65c8ef3f95f979dc21a9972b0ecd3',
      image: 'https://i.pinimg.com/564x/1f/47/de/1f47de7568f6234db6e482f573cd3665.jpg',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(CreatUserSuccessState(userModel));
    }).catchError((error) {
      emit(CreatUserErrorState(error.toString()));
    });
  }

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
      creatUser(email: email, phone: phone, name: name, uId: value.user!.uid);
    }).catchError((error) {
      // ignore: avoid_print
      print('Error is ${error.toString()}');
      emit(RegisterErrorState(error.toString()));
    });
  }
}
