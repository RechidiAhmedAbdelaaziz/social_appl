import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Moldels/userModel.dart';
import 'package:social_appl/Shared/Compenents/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(InitialStates());
  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? user;
  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      user = UserModel.fromJson(value.data());
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState(error.toString()));
    });
  }
}
