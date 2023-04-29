// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
    const Text(''),
    const Text('Users'),
    const Text('Settings'),
  ];
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    const ChatsScreen(),
    const UsersScreen(),
    const SettingScreen(),
  ];

  void changeBottomNavScreen(int index) {
    if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavState());
    }
  }

  UserModel? user;
  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      user = UserModel.fromJson(value.data());
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }

  File? profileFile;
  File? coverFile;
  var picker = ImagePicker();
  Future getImage(String type) async {
    emit(GetPicLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (type == 'profile') {
        profileFile = File(pickedFile.path);
      } else {
        coverFile = File(pickedFile.path);
      }

      emit(GetPicSuccessState());
    } else {
      emit(GetPicErrorState());
    }
  }

  void uplaodFile(File? imageFile, String type) async {
    void updatePics({
      String? cover,
      String? image,
    }) {
      cover = cover ?? user?.cover;
      image = image ?? user?.image;

      var update = {
        'image': image,
        'cover': cover,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update(update)
          .then((value) {
            getUserData();
        emit(UpdatePicsSuccessState());
      }).catchError((error) {
        emit(UpdatePicsErrorState());
      });
    }

    emit(UploadPicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${user?.uId}/${Uri.file(imageFile!.path).pathSegments.last}')
        .putFile(imageFile)
        .then((value) {
      emit(UploadPicSuccessState());
      value.ref.getDownloadURL().then((value) {
        if (type == 'profile') {
          updatePics(image: value);
        } else {
          updatePics(cover: value);
        }
        emit(GetUrlPicSuccessState());
      }).catchError((error) {
        emit(GetUrlPicErrorState());
      });
    }).catchError((error) {
      emit(UploadPicErrorState());
    });
  }

  void updateData(Map<String, dynamic> update) {
    emit(UpdateDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(update)
        .then((value) {
      if (profileFile != null) {
        uplaodFile(profileFile, 'profile');
      }
      if (coverFile != null) {
        uplaodFile(coverFile, 'cover');
      }else {
        getUserData();
      }
      emit(UpdateDataSuccessState());
    }).catchError((error) {
      emit(UpdateDataErrorState());
    });
  }
}
