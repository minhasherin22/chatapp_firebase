import 'package:flutter/material.dart';
import '../helper/helper_function.dart';
import 'auth/login_page.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSignedIn = false;
  @override
  void initState() {
    _navigatetohome();
    getUserLoggedInStatus();
    // TODO: implement initState
    super.initState();
  }

  _navigatetohome()async{
    await Future.delayed(Duration(seconds: 2),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> _isSignedIn ? HomePge() : LoginPage(),));
  }
   getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInStatus().then((value){
      if(value != null){
         setState(() {
           _isSignedIn = value;
         });
      }
    });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(image: AssetImage('assets_chatapp/assets/download-removebg-preview (1).png')),
      ),
    );
  }
}
