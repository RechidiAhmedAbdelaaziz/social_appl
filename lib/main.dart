// ignore_for_file: must_be_immutable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Modules/Login/LoginCubit/loginCubit.dart';
import 'package:social_appl/Modules/Login/LoginCubit/loginStates.dart';
import 'package:social_appl/Modules/Login/loginScreen.dart';
import 'package:social_appl/Shared/Compenents/blocobserver.dart';
import 'package:social_appl/Shared/Network/Local/cache_helper.dart';
import 'package:social_appl/Shared/Network/Remote/diohelper.dart';
import 'package:social_appl/Shared/Styles/Themes/themes.dart';
import 'package:social_appl/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    print('objllllllllect');
  }).catchError((error) {
    print('Error is ${error.toString()}');
  });
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await CacheHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [BlocProvider(create: (context) => LoginCubit())],
        child: BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: const LoginScreen(),
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.light,
              );
            }));
  }
}
