// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:social_appl/Layout/SocialApp/socialCubit.dart';
import 'package:social_appl/Modules/Screens/Feeds/feeds_screen.dart';
import 'package:social_appl/Moldels/postModel.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key, required this.post});
  PostModel post;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPostItem(context, post),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Comments :',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(
                            bottom: 4, start: 8),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(
                                    '${SocialCubit.get(context).user?.image}'),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(child: Text('${post.comments?[index]}')),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        margin:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                        width: double.infinity,
                        height: 1.2,
                        color: Colors.grey[300],
                      );
                    },
                    itemCount: post.comments!.length),
              )
            ],
          ),
        ),
      ),
    );
  }
}
