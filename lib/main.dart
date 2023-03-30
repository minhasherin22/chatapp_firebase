import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/pages/splashScreen.dart';
import 'package:chatapp_firebase/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'helper/helper_function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
      apiKey: Constants.apiKey,
      appId: Constants.appId,
      messagingSenderId: Constants.messagingSenderId,
      projectId: Constants.projectId
      )
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool _isSignedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserLoggedInStatus();
  }
  //  getUserLoggedInStatus() async{
  //   await HelperFunctions.getUserLoggedInStatus().then((value){
  //     if(value != null){
  //        setState(() {
  //          _isSignedIn = value;
  //        });
  //     }
  //   });
  //  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:SplashScreen(),
     
     
    );
  }
}
