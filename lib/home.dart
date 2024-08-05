import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/loader.dart';
import 'package:todo/login.dart';
import 'package:todo/task_modal.dart';


String url = "https://todolist-1ldm.onrender.com";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TextEditingController taskController = TextEditingController();
  List taskList = [];
  List<TaskModal> taskModalData = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        getAllTask();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Confirm Logout'),
                            content:
                                const Text('Are you sure want to logout ?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.pop(
                                      dialogContext);
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences.clear();

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.logout),
                        Text("Logout"),
                      ],
                    ),
                  )
                ];
              },
            )
          ],
          bottom: TabBar(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                color: const Color(0xFF0192ED),
                borderRadius: BorderRadius.circular(10)),
            labelStyle: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Pending"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: taskModalData.length,
              // itemCount: taskList.length,
              itemBuilder: (context, index) {
                // if(){}
                if (taskModalData[index].status == true) {
                  // if (taskList[index]['status'] == true) {
                  return trueTask(index);
                } else {
                  return falseTask(index);
                }
              },
            ),
            ListView.builder(
              itemCount: taskModalData.length,
              itemBuilder: (context, index) {
                if (taskModalData[index].status == false) {
                  return falseTask(index);
                } else {
                  return const SizedBox();
                }
              },
            ),
            // 3 rd
            ListView.builder(
              itemCount: taskModalData.length,
              itemBuilder: (context, index) {
                if (taskModalData[index].status == true) {
                  return trueTask(index);
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showForm();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void getAllTask() async {
    print("start getAllTask api call");
    showLoadingDialog(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString("token");
    http.Response response = await http.get(Uri.parse("$url/api/tasks/"),
        headers: {"x-access-token": accessToken!});

    print("getAllTask Response status code == ${response.statusCode}");
    hideLoadingDialog(context);
    print("getAllTask Response body == ${response.body}");

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      taskList = res;
      final taskModal = taskModalFromJson(response.body);
      taskModalData = taskModal;
      setState(() {});
    } else if (response.statusCode == 401) {
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      print("Failed to load tasks");
    }
  }

  void addTask(String taskDescription) async {
    print("--------------Adding task with description: $taskDescription");
    showLoadingDialog(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString("token");
    String timestamp = DateTime.now().toIso8601String();
    http.Response response = await http.post(
      Uri.parse("$url/api/tasks/"),
      body: {
        "description": taskDescription,
        "status": "false",
        "timestamp": timestamp
      },
      headers: {"x-access-token": accessToken!},
    );
    hideLoadingDialog(context);
    var res = jsonDecode(response.body);
    // taskList = res;
    log("==============$res");

    if (response.statusCode == 200) {
      getAllTask();
      setState(() {});
      // taskList.add(
      //     newTask); // Directly add the new task from the response to the state
    } else if (response.statusCode == 401) {
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add task')),
      );
    }
  }

  void deleteTask(id) async {
    print("=================start deleteTask api call");
    print("--------------$id");
    showLoadingDialog(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString("token");
    http.Response response = await http.delete(Uri.parse("$url/api/tasks/$id"),
        headers: {"x-access-token": accessToken!});
    print("getAllTask Response status code == ${response.statusCode}");
    print("getAllTask Response body == ${response.body}");
    /*var res = jsonDecode(response.body);
    taskList = res;
    print("----------------- $res");*/
    hideLoadingDialog(context);
    if (response.statusCode == 200) {
      getAllTask();
      // setState(() {});
    } else if (response.statusCode == 401) {
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      print("Failed to load tasks");
    }
  }

  void updateTask({id, task, index}) async {
    log("=================start updateTask api call");
    print("--------------$id");
    print("--------------$task");
    showLoadingDialog(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var accessToken = preferences.getString("token");
    String timestamp = DateTime.now().toIso8601String();

    http.Response response = await http.put(Uri.parse("$url/api/tasks/$id"),
        body: {"description": task, "status": "false", "timestamp": timestamp},
        headers: {"x-access-token": accessToken!});
    hideLoadingDialog(context);
    print("update task Response status code == ${response.statusCode}");
    print("update task Response body == ${response.body}");
    /*var res = jsonDecode(response.body);
    taskList = res;
    print("----------------- $res");*/
    if (response.statusCode == 200) {
      getAllTask();
      // setState(() {});
    } else if (response.statusCode == 401) {
      preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      print("Failed to load tasks");
    }
  }

  void showForm({Map<String, dynamic>? data, int? index}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddEditDialog(
          res: data,
          onTap: (v) {
            if (index == null) {
              addTask(v['description']);
            } else {
              updateTask(id: data!['id'], task: v['description']);
            }

            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget trueTask(index) {
    String timestamp =
        taskList[index]["created_at"] ?? DateTime.now().toIso8601String();
    return Card(
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
      color: const Color(0xFF0192ED),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              onPressed: (context) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  // false = user must tap button, true = tap outside dialog
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text('Are you sure want to delete ?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            setState(() {
                              deleteTask(taskList[index]['id']);
                            });
                            Navigator.pop(dialogContext);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                taskModalData[index].description ?? "task",
                // taskList[index]["description"] ?? "task",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  DateFormat('hh:mm aa')
                      .format(DateTime.parse(timestamp).toLocal()),
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
              // Text(DateFormat('kk:mm').format(DateTime.now()),)
            ],
          ),
          leading: Checkbox(
            checkColor: const Color(0xFF0192ED),
            activeColor: Colors.white,
            value: taskModalData[index].status,
            onChanged: (value) {
              if (value == true) {
                setState(() {
                  taskModalData[index].status = value;
                });
              }
            },
          ),
          onTap: () {
            showForm(data: taskList[index], index: index);
          },
        ),
      ),
    );
  }

  Widget falseTask(index) {
    String timestamp =
        taskList[index]['createdAt'] ?? DateTime.now().toIso8601String();
    return GestureDetector(
      onTap: () {
        setState(() {
          updateTask(
            id: taskModalData[index].id,
            task: taskModalData[index].description,
          );
        });
      },
      child: Card(
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        color: const Color(0xFF0192ED),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.4,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                onPressed: (context) {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text('Are you sure want to delete ?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              // deleteTask(index);
                              setState(() {
                                // taskList.removeAt(index);
                                // taskList.removeAt(index);
                                deleteTask(taskList[index]['id']);
                              });
                              // onUpdate(widget.taskList);
                              Navigator.pop(dialogContext);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  taskModalData[index].description ?? "task",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    DateFormat('hh:mm aa')
                        .format(DateTime.parse(timestamp).toLocal()),
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
            leading: Checkbox(
              checkColor: const Color(0xFF0192ED),
              activeColor: Colors.white,
              value: taskModalData[index].status,
              onChanged: (value) {
                setState(() {
                  taskModalData[index].status = value;
                });
              },
            ),
            onTap: () {
              showForm(
                  /*data: user, index: index*/
                  data: taskList[index],
                  index: index);
            },
          ),
        ),
      ),
    );
  }
}

class AddEditDialog extends StatefulWidget {
  final dynamic res;
  final Function(Map)? onTap;

  const AddEditDialog({super.key, this.res, this.onTap});

  @override
  State<AddEditDialog> createState() => _AddEditDialogState();
}

class _AddEditDialogState extends State<AddEditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController taskController = TextEditingController();

  bool value = false;

  @override
  void initState() {
    super.initState();
    if (widget.res != null) {
      taskController.text = widget.res!['description'] ?? '';
      value = widget.res!['status'] ?? false;
    } else {
      taskController.text = '';
      value = false;
    }
    /*taskController.text = widget.res['description'];
    value = widget.res['status'];
    setState(() {});*/
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    controller: taskController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Task',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    Switch(
                      value: value,
                      onChanged: (val) {
                        setState(() {
                          value = val;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          widget.onTap!({
                            "description": taskController.text,
                            "status": value
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Save',
                          style: TextStyle(color: Color(0xFF0192ED)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
