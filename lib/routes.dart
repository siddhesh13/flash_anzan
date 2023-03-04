import 'dart:js';

import 'package:flash_anzan/screens/homepage.dart';
import 'package:flash_anzan/screens/login.dart';
import 'package:flash_anzan/screens/studentProfile.dart';
import 'package:flash_anzan/screens/aboutus.dart';
import 'package:flutter/material.dart';

final loginRoute = '/login';
final aboutRoute = '/aboutus';
final profileRoute = '/profile';
final homeRoute = '/home';
final dashboardRoute = '/dashboard';

Map<String, WidgetBuilder> routes = {
  loginRoute: (context) => LoginPage(),
  aboutRoute: (context) => FoodRatingScreen(),
  profileRoute: (context) => UserProfile(
        name: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["username"],
        email: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["email"],
        photoUrl: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["photo"],
      ),
  //dashboardRoute: (context) => Dashboard(),
  homeRoute: (context) => AbacusHomePage(
        username: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["username"],
        email: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["email"],
        photo: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["photo"],
      )
};
