// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haveliapp/auth/auth_state.dart' as AuthState;
import 'package:haveliapp/auth/auth_cubit.dart';
import 'package:haveliapp/constant.dart';
import 'package:haveliapp/models/user_model.dart';
import 'package:haveliapp/profile/profile_cubit.dart';
import 'package:haveliapp/profile/profile_state.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  File? file;
  String username = "";
  late User userdata;
  bool showLogout = false;
  ProfileScreen({this.showLogout = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool enableButton = false;

  @override
  Widget build(BuildContext context) {
    widget.userdata =
        (BlocProvider.of<AuthCubit>(context).state as AuthState.Authenticated)
            .userdata;
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is Submited) {
            Navigator.pop(context);
          }
          if (state is Failed) {
            if (state.msg == UNAUTHENTICATED) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.msg!)));
          }
        },
        builder: (context, ProfileState state) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: widget.image == null && widget.userdata.image == null
                        ? Icon(
                            Icons.account_circle,
                            size: 150,
                            color: Colors.grey,
                          )
                        : widget.file != null
                            ? Image.file(
                                widget.file!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                BASE_URL + widget.userdata.image!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                TextFormField(
                  initialValue: widget.userdata.name,
                  onChanged: (value) {
                    setState(() {
                      enableButton = value.isNotEmpty;
                    });
                    widget.username = value;
                  },
                  decoration: InputDecoration(
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      )),
                ),
                SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: 80,
                  child: state is Submitting
                      ? LinearProgressIndicator(
                          color: Colors.black,
                        )
                      : null,
                ),
                SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: enableButton
                          ? () {
                              BlocProvider.of<ProfileCubit>(context)
                                  .updateProfile(widget.username, widget.file);
                            }
                          : null,
                      child: Text("DONE")),
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.showLogout)
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<ProfileCubit>(context).logout();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: Text("LOgout"),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    widget.image = await widget._picker.pickImage(source: ImageSource.gallery);
    widget.file = File(widget.image!.path);
    setState(() {});
  }
}
