// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialCubit.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Moldels/messageModel.dart';
import 'package:social_appl/Moldels/userModel.dart';
import 'package:social_appl/Shared/Styles/colors.dart';

class ChatDetail extends StatelessWidget {
  ChatDetail({super.key, required this.user});
  UserModel user;
  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMeessages(reciverId: user.uId!);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is SendMessageSuccessState) {
            textController.text = '';
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('${user.image}'),
                ),
                SizedBox(
                  width: 15,
                ),
                Text('${user.name}'),
              ],
            ),
          ),
          body: ConditionalBuilder(
            condition: SocialCubit.get(context).messages != [],
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          var message =
                              SocialCubit.get(context).messages[index];
                          if (message.senderId == user.uId) {
                            return buildRecive(message);
                          }
                          return buildSend(message);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 1,
                        ),
                        itemCount: SocialCubit.get(context).messages.length,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message here..'),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              SocialCubit.get(context).sendMessage(
                                  reciverId: user.uId!,
                                  text: textController.text,
                                  dateTime: DateTime.now().toString());
                            },
                            icon: Icon(
                              Icons.send,
                              size: 26,
                              color: defaultColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    });
  }
}

Widget buildSend(MessageModel message) {
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: defaultColor.withOpacity(.6),
          borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10)),
        ),
        child: Text(
          '${message.text}',
          style: TextStyle(fontSize: 24),
        )),
  );
}

Widget buildRecive(MessageModel message) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10)),
        ),
        child: Text(
          '${message.text}',
          style: TextStyle(fontSize: 24),
        )),
  );
}
