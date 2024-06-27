import 'package:firebase/Screens/add_task_page.dart';
import 'package:firebase/models/task_model.dart';
import 'package:firebase/services/auth_services.dart';
import 'package:firebase/services/task_servie.dart';
import 'package:flutter/material.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  TaskService _taskService = TaskService();
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.pushNamed(context, '/addtask');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        "Hi",
                        style: themeData.textTheme.displayMedium,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "",
                        style: themeData.textTheme.displayMedium,
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                      onPressed: () {
                        AuthServices().logOut().then((value) =>
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/", (route) => false));
                      },
                      icon: Icon(Icons.logout)),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Your To-dos",
              style: themeData.textTheme.displayMedium,
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<List<TaskModel>>(
              stream: _taskService.getAllTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Some error occured:${snapshot.error}",
                      style: themeData.textTheme.displaySmall,
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data!.length == 0) {
                  return Center(
                    child: Text(
                      "No _task added",
                      style: themeData.textTheme.displaySmall,
                    ),
                  );
                }
                if (snapshot.hasData && snapshot.data!.length != 0) {
                  List<TaskModel> tasks = snapshot.data ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final _task = tasks[index];
                      print(_task);
                      return Card(
                        elevation: 4.0,
                        color: themeData.scaffoldBackgroundColor,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.circle_outlined,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "${_task.title}",
                            style: themeData.textTheme.displaySmall,
                          ),
                          subtitle: Text(
                            "${_task.body}",
                            style: themeData.textTheme.displaySmall,
                          ),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddTaskPage(
                                              task: _task,
                                            ),
                                          ));
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.teal,
                                    )),
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      await _taskService.deleteTask(_task.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Task deleted successfully')),
                                      );
                                      // Refresh the task list after deletion
                                      setState(() {});
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to delete task: $e')),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
