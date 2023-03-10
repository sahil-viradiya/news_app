// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors, empty_catches

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haveliapp/auth/auth_cubit.dart';
import 'package:haveliapp/auth/auth_state.dart';
import 'package:haveliapp/home/home_cubit.dart';
import 'package:haveliapp/home/home_screen.dart';
import 'package:haveliapp/phone/phone_cubit.dart';
import 'package:haveliapp/phone/phone_screen.dart';
import 'package:haveliapp/utils.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // mockResponseAdapter();

  try {
    await getToken();
  } catch (e) {
    // todo nothing
  }

  if (TOKEN != null) {
    await authCubit.loadUserDetails();
  }

  runApp(BlocProvider(
    create: (context) => authCubit,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is Authenticated) {
              return BlocProvider(
                create: (context) => HomeCubit(),
                child: HomeScreen(),
              );
            }
            if (state is Failed) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context).loadUserDetails();
                      },
                      child: Text("retry")),
                ),
              );
            }
            return BlocProvider(
              create: (context) => PhoneCubit(),
              child: PhoneScreen(),
            );
          },
        ));
  }
}
