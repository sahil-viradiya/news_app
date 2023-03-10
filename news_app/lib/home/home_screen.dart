// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haveliapp/auth/auth_cubit.dart';
import 'package:haveliapp/auth/auth_state.dart' as AuthState;
import 'package:haveliapp/constant.dart';
import 'package:haveliapp/home/home_cubit.dart';
import 'package:haveliapp/models/user_model.dart';
import 'package:haveliapp/myWidget/news_widget.dart';
import 'package:haveliapp/profile/profile_cubit.dart';
import 'package:haveliapp/profile/profile_screen.dart';

import 'home_state.dart';

class HomeScreen extends StatelessWidget {
  late User userdata;
  @override
  Widget build(BuildContext context) {
    userdata =
        (BlocProvider.of<AuthCubit>(context).state as AuthState.Authenticated)
            .userdata;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ProfileCubit(),
                        child: ProfileScreen(showLogout: true,),
                      ),
                    ));
              },
              icon: userdata.image == null
                  ? Icon(Icons.account_circle)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        BASE_URL+userdata.image!,
                        height: 30,
                        width: 30,
                      ),
                    ))
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/logo.png",
            height: 34,
            width: 34,
          ),
        ),
        title: Center(child: Text("NEWS")),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is Failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.msg!),
              ),
            );
          }
        },
        builder: (context, HomeState state) {
          if (state is Init) {
            BlocProvider.of<HomeCubit>(context).loadNews();
          }

          if (state is Loaded) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) => NewsWidget(state.list[index]),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
