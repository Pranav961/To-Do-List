import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    log("start login api call");
    http.Response response = await http.post(
        Uri.parse("https://todolist-1ldm.onrender.com/api/auth/signup"),
        body: {
          "username": usernameController.text,
          "password": passwordController.text,
          "confirmPassword": confirmPasswordController.text,
          "email": emailController.text
        });
    log("Response status code == ${response.statusCode}");
    log("Response body == ${response.body}");
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      final snackBar = SnackBar(
        content: Text("Error: ${response.body}"),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 35, top: 59),
            child: Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 34, top: 30, right: 33),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Username",
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
                    borderRadius: BorderRadius.circular(30)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 34, top: 30, right: 33),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
                    borderRadius: BorderRadius.circular(30)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 34, top: 30, right: 33),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
                    borderRadius: BorderRadius.circular(30)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
                    borderRadius: BorderRadius.circular(30)),
              ),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 34, top: 30, right: 33),
            child: TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
                    borderRadius: BorderRadius.circular(30)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
                    borderRadius: BorderRadius.circular(30)),
              ),
              obscureText: true,
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 34, right: 33, top: 22),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xff0192ED)),
            child: TextButton(
              onPressed: () async {
                if (usernameController.text.isEmpty ||
                    emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter details"),
                    ),
                  );
                  return;
                }
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match"),
                    ),
                  );
                  return;
                }
                signUp();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 11),
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Color(0xffFFFFFF)),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: RichText(
                text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                        text: "Login",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                        style: const TextStyle(
                            color: Color(0xFF0192ED), fontSize: 18),
                      )
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
