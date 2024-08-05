import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/home.dart';
import 'package:todo/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int groupValue = 0;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 35, top: 59),
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 50),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 59, right: 32.69),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      "https://i.pinimg.com/originals/42/ef/c4/42efc4a15f2a9ea86cab71364e12737d.jpg",
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 17, left: 35),
              child: Text(
                "Welcome to",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 35),
              child: const Text(
                "ToDo List",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF0192ED)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 34, top: 35, right: 33),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Enter username or email",
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.5, color: Color(0xFFB9B9B9)),
                      borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.5, color: Color(0xFFB9B9B9)),
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 34, top: 20, right: 33),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.5, color: Color(0xFFB9B9B9)),
                      borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.5, color: Color(0xFFB9B9B9)),
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 34, right: 33, top: 22),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xff0192ED)),
              child: TextButton(
                onPressed: () {
                  loginApi();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 11),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Color(0xffFFFFFF)),
                  ),
                ),
              ),
            ),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const SignUpScreen();
                      },
                    ));
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: Color(0xff0376BC)),
                  ),
                )
              ],
            ),*/
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: RichText(
                    text: TextSpan(
                        text: "Don't have an account? ",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        children: [
                      TextSpan(
                        text: "Sign Up",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              /*MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ));*/
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const SignUpScreen();
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                        style: const TextStyle(
                            color: Color(0xFF0192ED), fontSize: 18),
                      )
                    ])),
              ),
            )
          ],
        ),
      ]),
    );
  }

  void loginApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both username and password."),
        ),
      );
      return;
    }
    print("start login api call");
    http.Response response = await http.post(
        Uri.parse("https://todolist-1ldm.onrender.com/api/auth/signin"),
        body: {
          "username": usernameController.text,
          "password": passwordController.text
        });
    print("Response status code == ${response.statusCode}");
    print("Response body == ${response.body}");
    print("Login access token : ${jsonDecode(response.body)["accessToken"]}");
    if (response.statusCode == 200) {
      preferences.setString("token", jsonDecode(response.body)["accessToken"]);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Credentials"),
        ),
      );
    }
  }
}
