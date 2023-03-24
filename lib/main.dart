import 'package:flash_anzan/routes.dart';
import 'package:flash_anzan/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flash_anzan/provider/userProvider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: LoginPage(),
        routes: routes,
      ),
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