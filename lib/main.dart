import 'package:flash_anzan/routes.dart';
import 'package:flash_anzan/screens/homepage.dart';
import 'package:flash_anzan/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
        apiKey: "AIzaSyAnW6Oioh3KMw2fgjswnnu8yaiOeMDsyEA",
        authDomain: "abacusplusflash.firebaseapp.com",
        projectId: "abacusplusflash",
        storageBucket: "abacusplusflash.appspot.com",
        messagingSenderId: "778212284440",
        appId: "1:778212284440:web:591699dcbe467ac5c88b6d",
        measurementId: "G-XEJC61JFE5"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}

/*
<script type="module">
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.17.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.17.1/firebase-analytics.js";
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const firebaseConfig = {
    apiKey: "AIzaSyAnW6Oioh3KMw2fgjswnnu8yaiOeMDsyEA",
    authDomain: "abacusplusflash.firebaseapp.com",
    projectId: "abacusplusflash",
    storageBucket: "abacusplusflash.appspot.com",
    messagingSenderId: "778212284440",
    appId: "1:778212284440:web:591699dcbe467ac5c88b6d",
    measurementId: "G-XEJC61JFE5"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
</script>
*/