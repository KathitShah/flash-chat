import 'package:flash_chat/components/rounded-button.dart';
import 'chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final focus = FocusNode();
  final _auth = auth.FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                    ),
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: showPassword,
                    focusNode: focus,
                    onSubmitted: (v) async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    onChanged: (value) {
                      password = value;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword ? Icons.lock : Icons.remove_red_eye,
                        ),
                        onPressed: () {
                          setState(() {
                            if (showPassword == true) {
                              showPassword = false;
                            } else if (showPassword == false) {
                              showPassword = true;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    colour: Colors.blueAccent,
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    title: 'Register',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
