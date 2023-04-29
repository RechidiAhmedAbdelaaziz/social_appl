// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Modules/Screens/Chats/chats_screen.dart';
import 'package:social_appl/Modules/Screens/Feeds/feeds_screen.dart';
import 'package:social_appl/Modules/Screens/Settings/setting_screen.dart';
import 'package:social_appl/Modules/Screens/Users/users_screen.dart';
import 'package:social_appl/Moldels/userModel.dart';
import 'package:social_appl/Shared/Compenents/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(InitialStates());
  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Text> titles = [
    const Text('Home Feed'),
    const Text('Chats'),
    const Text('Users'),
    const Text('Settings'),
  ];
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingScreen(),
  ];
  
  void changeBottomNavScreen(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }



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
