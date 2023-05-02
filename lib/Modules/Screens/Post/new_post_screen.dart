// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialCubit.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Shared/Compenents/compenents.dart';

class NewPostScreen extends StatelessWidget {
  var textController = TextEditingController();
  bool onProgress = false;

  NewPostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is CreatPostLoadingState) {
          onProgress = true;
        }
        if (state is CreatPostSuccessState || state is CreatPostErrorState) {
          onProgress = false;
          textController.text = '';
          SocialCubit.get(context).disappearPic();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var user = SocialCubit.get(context).user;
        return Scaffold(
          appBar: defaultAppBar(
            context,
            title: 'Create post',
            actions: [
              TextButton(
                  onPressed: () {
                    SocialCubit.get(context).creatPost(
                      dateTime: DateTime.now().toString(),
                      text: textController.text,
                      tags: '',
                    );
                  },
                  child: const Text('POST'))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                if (onProgress)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: LinearProgressIndicator(),
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(user!.image!),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        '${user.name!}  ',
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText:
                            'What are you thinking about , ${user.name!} ',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                if (SocialCubit.get(context).currentPostFile != null)
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(
                                  SocialCubit.get(context).currentPostFile!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            SocialCubit.get(context).disappearPic();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 20,
                          ))
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            SocialCubit.get(context).getImage('post');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Add photo'),
                              ],
                            ),
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.tag),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Tags'),
                              ],
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
