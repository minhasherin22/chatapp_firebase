import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  bool  passwordShow = true;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Color(0xffee7b64)),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        'Groupie',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Login now to see what they are talking!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      Image.asset('assets_chatapp/assets/register.png'),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Fullname',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xffee7b64),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Name cannot be empty';
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            fullName = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xffee7b64),
                            )),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: passwordShow?true:false,
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xffee7b64),
                          ),
                          suffixIcon: IconButton(onPressed: (() {
                            setState(() {
                              passwordShow = !passwordShow;
                            });
                          }),
                          icon: Icon(Icons.remove_red_eye,color: passwordShow?Colors.grey:Colors.blue,), )
                        ),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              register();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffee7b64),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                            child: Text(
                              'Register ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                                text: 'Login Now',
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, LoginPage());
                                  })
                          ]))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value)async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePge());
        } else {
          showSnackbar(
            context,
            Colors.red,
            value,
          );

          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
