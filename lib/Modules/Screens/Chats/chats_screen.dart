import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialCubit.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Modules/Screens/Chats/chat_detailles.dart';
import 'package:social_appl/Moldels/userModel.dart';
import 'package:social_appl/Shared/Compenents/compenents.dart';
import 'package:social_appl/Shared/Compenents/constants.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var users = SocialCubit.get(context).users;
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users != [],
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                builChatItem(context, users[index]),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: users.length,
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Widget builChatItem(BuildContext context, UserModel user) {
  return InkWell(
    onTap: () {
      navigateTo(context: context, widget: ChatDetail(user: user));
    },
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundImage: NetworkImage('${user.image}'),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${user.name}  ',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.3,
                      ),
                    ),
                    Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 16,
                    )
                  ],
                ),
                Text(
                  'dateTime',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                size: 16,
              ))
        ],
      ),
    ),
  );
}
