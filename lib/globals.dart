library e_pluto.globals;
import 'package:flutter/material.dart';

bool isLoggedIn = false;
String username, password;
String trainingId;
String universityUrl;
String uniJson = "";
List universities; //await DefaultAssetBundle.of(context).loadString("assets/data.json");
GlobalKey<FormState> loginFormKey;
TextEditingController usernameController;
TextEditingController passwordController;
List messages=[];
