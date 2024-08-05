import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiCallDemo extends StatefulWidget {
  const ApiCallDemo({super.key});

  @override
  State<ApiCallDemo> createState() => _ApiCallDemoState();
}

class _ApiCallDemoState extends State<ApiCallDemo> {
  List dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$index ${dataList[index]['description']}"),
            ),
          )),
          ElevatedButton(
              onPressed: () {
                loginApi();
              },
              child: const Text("Login")),
          ElevatedButton(
              onPressed: () {
                signUpApi();
              },
              child: const Text("Signup")),
          ElevatedButton(
              onPressed: () {
                getAllTask();
              },
              child: const Text("getAllTask")),
          ElevatedButton(
              onPressed: () {
                addTask();
              },
              child: const Text("add task")),
          ElevatedButton(
              onPressed: () {
                addTask();
              },
              child: const Text("update task")),
        ],
      ),
    );
  }

  void loginApi() async {
    log("start login api call");
    http.Response response = await http.post(
        Uri.parse("https://todolist-1ldm.onrender.com/api/auth/signin"),
        body: {"username": "pranav02", "password": "demo@123"});
    log("Response status code == ${response.statusCode}");
    log("Response body == ${response.body}");
  }

  void signUpApi() async {
    log("start signup api call");
    http.Response response = await http.post(
        Uri.parse("https://todolist-1ldm.onrender.com/api/auth/signup"),
        body: {
          "username": "pranav023",
          "email": "pranav02@gmail.com",
          "password": "demo@123"
        });
    log("Response status code == ${response.statusCode}");
    log("Response body == ${response.body}");
    if (response.statusCode == 200) {
      //success
    } else {
      //error
      log("---  ${jsonDecode(response.body)['message']}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${jsonDecode(response.body)['message']}")));
    }
  }

  void getAllTask() async {
    log("start getAllTask api call");
    http.Response response = await http.get(
        Uri.parse("https://todolist-1ldm.onrender.com/api/tasks/"),
        headers: {
          "x-access-token":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMxOWFmZDY0LTU0MTktNDU3Yi1hYzlmLTkwYzNkOTk1MGY3MiIsImlhdCI6MTcyMjQwMzUzMSwiZXhwIjoxNzIyNDg5OTMxfQ.VEMV_x16QOF_ge-OoPVwopRpz2HFx1jF5QZI-nfahRE"
        });
    log("getAllTask Response status code == ${response.statusCode}");
    log("getAllTask Response body == ${response.body}");
    if (response.statusCode == 200) {
      //success
      log("new valuye  -- ${jsonDecode(response.body)[0]['description']}");
      dataList = jsonDecode(response.body);
      setState(() {});
    } else {
      //error
    }
  }

  void addTask() async {
    log("start getAllTask api call");
    http.Response response = await http.post(
        Uri.parse("https://todolist-1ldm.onrender.com/api/tasks/"),
        headers: {
          "x-access-token":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMxOWFmZDY0LTU0MTktNDU3Yi1hYzlmLTkwYzNkOTk1MGY3MiIsImlhdCI6MTcyMjQwMzUzMSwiZXhwIjoxNzIyNDg5OTMxfQ.VEMV_x16QOF_ge-OoPVwopRpz2HFx1jF5QZI-nfahRE"
        },
        body: {
          "description": "task num 4",
          "status": "false"
        });
    log("getAllTask Response status code == ${response.statusCode}");
    log("getAllTask Response body == ${response.body}");
    if (response.statusCode == 200) {
      //success
      getAllTask();
    } else {
      //error
    }
  }

  void updateTask() async {
    log("start getAllTask api call");
    http.Response response = await http.post(
        Uri.parse("https://todolist-1ldm.onrender.com/api/tasks/"),
        headers: {
          "x-access-token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMxOWFmZDY0LTU0MTktNDU3Yi1hYzlmLTkwYzNkOTk1MGY3MiIsImlhdCI6MTcyMjQwMzUzMSwiZXhwIjoxNzIyNDg5OTMxfQ.VEMV_x16QOF_ge-OoPVwopRpz2HFx1jF5QZI-nfahRE"
        },
        body: {
          "description": "task num 4",
          "status": "false"
        });
    log("getAllTask Response status code == ${response.statusCode}");
    log("getAllTask Response body == ${response.body}");
    if (response.statusCode == 200) {
      //success
      getAllTask();
    } else {
      //error
    }
  }}
