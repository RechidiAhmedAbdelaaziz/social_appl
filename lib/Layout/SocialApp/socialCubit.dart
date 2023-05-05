// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Modules/Screens/Chats/chats_screen.dart';
import 'package:social_appl/Modules/Screens/Feeds/feeds_screen.dart';
import 'package:social_appl/Modules/Screens/Settings/setting_screen.dart';
import 'package:social_appl/Modules/Screens/Users/users_screen.dart';
import 'package:social_appl/Moldels/messageModel.dart';
import 'package:social_appl/Moldels/postModel.dart';
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
  File? currentPostFile;

  var picker = ImagePicker();
  void getImage(String type) async {
    emit(GetPicLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (type == 'profile') {
        profileFile = File(pickedFile.path);
      } else if (type == 'post') {
        currentPostFile = File(pickedFile.path);
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
      } else {
        getAllUsers();
      }
      emit(UpdateDataSuccessState());
    }).catchError((error) {
      emit(UpdateDataErrorState());
    });
  }

  void creatPost({
    required String dateTime,
    required String text,
    required String? tags,
  }) {
    emit(CreatPostLoadingState());
    PostModel post = PostModel(
      name: user?.name,
      uId: uId,
      image: user?.image,
      postImage: '',
      dateTime: dateTime,
      tags: tags,
      text: text,
    );
    if (currentPostFile != null) {
      emit(UploadPicLoadingState());
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(currentPostFile!.path).pathSegments.last}')
          .putFile(currentPostFile!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          post = PostModel(
            name: user?.name,
            uId: uId,
            image: user?.image,
            postImage: value,
            dateTime: dateTime,
            tags: tags,
            text: text,
          );
          FirebaseFirestore.instance
              .collection('posts')
              .add(post.toMap())
              .then((value) {
            FirebaseFirestore.instance
                .collection('posts')
                .doc(value.id)
                .update({'id': value.id}).then((value) {
              getPosts();
              emit(CreatPostSuccessState());
            }).catchError((error) {
              emit(CreatPostErrorState());
            });
          }).catchError((error) {
            emit(CreatPostErrorState());
          });
          emit(UploadPicSuccessState());
        }).catchError((error) {
          emit(UploadPicErrorState());
        });
      }).catchError((error) {
        emit(UploadPicErrorState());
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .add(post.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(value.id)
            .update({'id': value.id}).then((value) {
          getPosts();
          emit(CreatPostSuccessState());
        }).catchError((error) {
          emit(CreatPostErrorState());
        });
      }).catchError((error) {
        emit(CreatPostErrorState());
      });
    }
  }

  void disappearPic() {
    currentPostFile = null;
    emit(PostImagesState());
  }

  List<PostModel> posts = [];
  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      posts = [];
      for (var element in value.docs) {
        var currentPost = element.data();
        currentPost.addAll({'id': element.id});
        posts.add(PostModel.fromJson(currentPost));
      }
      emit(GetPostsSuccessState());
    }).catchError((error) {
      print('error is >>> ${error.toString()}');
      emit(GetPostsErrorState(error.toString()));
    });
  }

  void likePost({required String postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Likes')
        .doc(user?.uId)
        .set({
      'like': false,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('Likes')
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({'likes': value.docs.length}).then((value) {
          getPosts();
          emit(GetLikesSuccessState());
        });
      });
    }).catchError((error) {
      emit(GetLikesErrorState());
    });
  }

  void putComment(String comment, String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(user?.uId)
        .set({'comment': comment}).then((value) {
      var comments = [];
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get()
          .then((value) {
        for (var element in value.docs) {
          comments.add(element.get('comment'));
        }
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({'comments': comments});
        emit(PutCommentSuccessState());
      });
    });
  }

  List<UserModel> users = [];
  void getAllUsers() {
    emit(GetAllUserLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      users = [];
      value.docs.forEach((element) {
        if (element.data()['uId'] == uId) {
          getUserData();
        } else {
          users.add(UserModel.fromJson(element.data()));
        }
      });
      emit(GetAllUserSuccessState());
    }).catchError((error) {
      emit(GetAllUserErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String reciverId,
    required String text,
    required String dateTime,
  }) {
    MessageModel message = MessageModel(
      senderId: user?.uId,
      reciverId: reciverId,
      dateTime: dateTime,
      text: text,
    );
    emit(SendMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(reciverId)
        .collection('chats')
        .doc(user?.uId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(ReciveMessageSuccessState());
    }).catchError((error) {
      emit(ReciveMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMeessages({required String reciverId}) {
    
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages').orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessagesSuccessState());
    });
  }
}
