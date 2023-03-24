import 'dart:js';

import 'package:flash_anzan/screens/editProfile.dart';
import 'package:flash_anzan/screens/homepage.dart';
import 'package:flash_anzan/screens/leaderboard.dart';
import 'package:flash_anzan/screens/login.dart';
import 'package:flash_anzan/screens/practiceHistory.dart';
import 'package:flash_anzan/screens/quiz/addSetting.dart';
import 'package:flash_anzan/screens/quiz/addition.dart';
import 'package:flash_anzan/screens/quiz/divSetting.dart';
import 'package:flash_anzan/screens/quiz/division.dart';
import 'package:flash_anzan/screens/quiz/flashcardSettings.dart';
import 'package:flash_anzan/screens/quiz/flashcards.dart';
import 'package:flash_anzan/screens/quiz/multiplication.dart';
import 'package:flash_anzan/screens/quiz/multiplySetting.dart';
import 'package:flash_anzan/screens/quiz/noFormula.dart';
import 'package:flash_anzan/screens/quiz/noFormulaSetting.dart';
import 'package:flash_anzan/screens/quiz/percentSetting.dart';
import 'package:flash_anzan/screens/quiz/percentage.dart';
import 'package:flash_anzan/screens/quiz/root.dart';
import 'package:flash_anzan/screens/quiz/rootSetting.dart';
import 'package:flash_anzan/screens/quiz/tableSetting.dart';
import 'package:flash_anzan/screens/quiz/tables.dart';
import 'package:flash_anzan/screens/studentProfile.dart';
import 'package:flash_anzan/screens/aboutus.dart';
import 'package:flutter/material.dart';

const loginRoute = '/login';
const aboutRoute = '/aboutus';
const profileRoute = '/profile';
const homeRoute = '/home';
const dashboardRoute = '/dashboard';
const leaderboardRoute = '/leaderboard';
const addSettingRoute = '/addSetting';
const additionQuizRoute = '/additionQuiz';
const multSettingRoute = '/multSetting';
const multiplicationQuizRoute = "/multiplicationQuiz";
const divSettingRoute = "/divSetting";
const divisionQuizRoute = "/divisionQuiz";
const tablesSettingRoute = "/tablesSetting";
const tablesQuizRoute = "/tablesQuiz";
const rootSettingRoute = "/rootSetting";
const rootQuizRoute = "/rootQuiz";
const percentSettingRoute = "/percentSetting";
const percentageQuizRoute = "/perecentageQuiz";
const practiceHistoryRoute = "/practiceDetails";
const editProfileRoute = "/editProfile";
const flashcardSettingRoute = '/flashcardSetting';
const flashcardQuizRoute = '/flashcardQuiz';
const noFormulaSettingRote = '/noFormulaSetting';
const noFormulaQuizRoute = '/noFormulaQuiz';
Map<String, WidgetBuilder> routes = {
  loginRoute: (context) => LoginPage(),
  aboutRoute: (context) => AboutUsPage(),
  leaderboardRoute: (context) => LeaderboardPage(),
  addSettingRoute: (context) => AdditionSettingsPage(),
  additionQuizRoute: (context) => Addition(),
  multSettingRoute: (context) => MultiplicationSettingsPage(),
  multiplicationQuizRoute: (context) => Multiplication(),
  divSettingRoute: (context) => DivisionSettingsPage(),
  divisionQuizRoute: (context) => Division(),
  tablesSettingRoute: (context) => TableSettingsPage(),
  tablesQuizRoute: (context) => Tables(),
  rootSettingRoute: (context) => RootSettingsPage(),
  rootQuizRoute: (context) => Root(),
  percentSettingRoute: (context) => PercentageSettingsPage(),
  percentageQuizRoute: (context) => Percentage(),
  flashcardSettingRoute: (context) => FlashcardSetting(),
  flashcardQuizRoute: (context) => Flashcard(),
  practiceHistoryRoute: (context) => PracticeDetailsPage(),
  editProfileRoute: (context) => EditProfilePage(),
  noFormulaSettingRote: (context) => NoFormulaSettingsPage(),
  noFormulaQuizRoute: (context) => NoFormula(),
  // userId: ModalRoute.of(context)!.settings.arguments as String),
  profileRoute: (context) => UserProfile(
      /* name: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["username"],
        email: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["email"],
        photoUrl: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["photo"],
        level: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["level"],*/
      ),
  //dashboardRoute: (context) => Dashboard(),
  leaderboardRoute: (context) => LeaderboardPage(),
  homeRoute: (context) => AbacusHomePage(
      /*  username: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["username"],
        email: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["email"],
        photo: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["photo"],
        level: (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["level"],*/
      )
};
