// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialCubit.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Modules/Screens/Post/new_post_screen.dart';
import 'package:social_appl/Shared/Compenents/compenents.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is NewPostState) {
          navigateTo(context: context, widget: const NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: cubit.titles[cubit.currentIndex],
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: true ,//cubit.user != null,
            builder: (context) {
              return Column(
                children: [
                  // if (FirebaseAuth.instance.currentUser?.emailVerified == false)
                  //   Container(
                  //     height: 50,
                  //     color: Colors.amber.withOpacity(.6),
                  //     padding: const EdgeInsets.symmetric(horizontal: 20),
                  //     child: Row(
                  //       children: [
                  //         const Icon(
                  //           Icons.info_outline,
                  //           color: Colors.black,
                  //         ),
                  //         const Expanded(
                  //             child: Text('  please verify your email')),
                  //         const SizedBox(
                  //           width: 50,
                  //         ),
                  //         defaultTextButton(
                  //             function: () {
                  //               FirebaseAuth.instance.currentUser
                  //                   ?.sendEmailVerification()
                  //                   .then((value) {})
                  //                   .catchError((error) {});
                  //             },
                  //             text: 'Verify')
                  //       ],
                  //     ),
                  //   ),
                 
                  Expanded(child: cubit.screens[cubit.currentIndex]),
                ],
              );
            },
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavScreen(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upload_file),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              )
            ],
          ),
        );
      },
    );
  }
}
