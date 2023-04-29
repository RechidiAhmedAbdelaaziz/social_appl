// ignore_for_file: must_be_immutable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialCubit.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';
import 'package:social_appl/Layout/homeScreen.dart';
import 'package:social_appl/Modules/Login/loginScreen.dart';
import 'package:social_appl/Shared/Compenents/blocobserver.dart';
import 'package:social_appl/Shared/Compenents/constants.dart';
import 'package:social_appl/Shared/Network/Local/cache_helper.dart';
import 'package:social_appl/Shared/Network/Remote/diohelper.dart';
import 'package:social_appl/Shared/Styles/Themes/themes.dart';
import 'package:social_appl/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  Widget startWidget = uId == null ? const LoginScreen() : const HomeScreen();

  runApp(MyApp(
    startWidget: startWidget,
  ));
}

class MyApp extends StatelessWidget {
  Widget startWidget;
  MyApp({super.key, required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SocialCubit()..getUserData())
        ],
        child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: startWidget,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.light,
              );
            }));
  }
}
