// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialCubit.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Modules/Login/loginScreen.dart';
import 'package:social_appl/Shared/Compenents/compenents.dart';
import 'package:social_appl/erorrr.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        var user = SocialCubit.get(context).user;
        nameController.text = user!.name!;
        bioController.text = user.bio!;
        phoneController.text = user.phone!;
        var profileFile = SocialCubit.get(context).profileFile;
        ImageProvider<Object>? profileImage;
        if (profileFile != null) {
          profileImage = FileImage(profileFile);
        } else {
          profileImage = NetworkImage('${user.image}');
        }
        var coverFile = SocialCubit.get(context).coverFile;
        ImageProvider<Object>? coverImage;
        if (coverFile != null) {
          coverImage = FileImage(coverFile);
        } else {
          coverImage = NetworkImage('${user.cover}');
        }
        return Scaffold(
          appBar: defaultAppBar(context, title: 'Edit Profile', actions: [
            TextButton.icon(
                onPressed: () {
                  SocialCubit.get(context).updateData(
                    {
                      'name': nameController.text,
                      'phone': phoneController.text,
                      'bio': bioController.text,
                    },
                  );
                  if (profileFile != null)
                    SocialCubit.get(context).uplaodFile(profileFile, 'profile');
                  if (coverFile != null)
                    SocialCubit.get(context).uplaodFile(coverFile, 'cover');
                },
                icon: const Icon(Icons.save),
                label: const Text('update')),
            const SizedBox(
              width: 15,
            ),
          ]),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 260,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                image: DecorationImage(
                                  image: coverImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getImage(
                                      'cover');
                                },
                                icon: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
                                  child: Icon(Icons.camera_alt),
                                )),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: profileImage,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getImage(
                                    'profile');
                              },
                              icon: const CircleAvatar(
                                radius: 13,
                                backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
                                child: Icon(Icons.camera_alt, size: 20,),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultFromFiled(
                  control: nameController,
                  lable: 'User Name',
                  type: TextInputType.name,
                  prefix: const Icon(Icons.person),
                  valid: (value) {
                    if (value?.isEmpty == true) {
                      return "name must not be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                defaultFromFiled(
                  control: bioController,
                  lable: 'Bio',
                  type: TextInputType.text,
                  prefix: const Icon(Icons.newspaper),
                  valid: (value) {
                    if (value!.length > 200) {
                      return "This bio is too big";
                    }
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                defaultFromFiled(
                  control: phoneController,
                  lable: 'Phone number',
                  type: TextInputType.phone,
                  prefix: const Icon(Icons.phone),
                  valid: (value) {
                    if (value?.isEmpty == true) {
                      return "phone number can't be empty";
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
