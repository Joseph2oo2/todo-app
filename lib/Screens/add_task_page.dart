import 'package:firebase/models/task_model.dart';
import 'package:firebase/services/task_servie.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  final TaskModel? task;
  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TaskService _taskService = TaskService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  bool _edit = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  loadData() {
    if (widget.task != null) {
      setState(() {
        _titleController.text = widget.task!.title!;
        _descController.text = widget.task!.body!;
        _edit = true;
      });
    }
  }

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  final _taskKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _taskKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _edit == true
                  ? Text(
                      "Update Task",
                      style: themeData.textTheme.displayMedium,
                    )
                  : Text(
                      "Add New Task",
                      style: themeData.textTheme.displayMedium,
                    ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.teal,
                endIndent: 50,
                height: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: themeData.textTheme.displaySmall,
                controller: _titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title is mandatory";
                  }
                },
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  hintText: "Enter task title",
                  hintStyle: themeData.textTheme.displaySmall,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: themeData.textTheme.displaySmall,
                controller: _descController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Discription is mandatory";
                  }
                },
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  hintText: "Enter task discription",
                  hintStyle: themeData.textTheme.displaySmall,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (_taskKey.currentState!.validate()) {
                    if (_edit) {
                      TaskModel _taskmodel = TaskModel(
                        id: widget.task?.id,
                        title: _titleController.text,
                        body: _descController.text,
                      );
                      _taskService
                          .updateTask(_taskmodel)
                          .then((value) => Navigator.pop(context));
                    } else {
                      _addTask();
                    }
                  }
                },
                child: Center(
                  child: Container(
                    height: 48,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: _edit == true
                            ? Text(
                                "Update Task",
                                style: themeData.textTheme.displayMedium,
                              )
                            : Text(
                                "Add Task",
                                style: themeData.textTheme.displayMedium,
                              )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addTask() async {
    var id = Uuid().v1();
    TaskModel _taskModel = TaskModel(
        title: _titleController.text,
        body: _descController.text,
        id: id,
        status: 1,
        createdAt: DateTime.now());

    final task = await _taskService.createTask(_taskModel);

    if (task != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Task Created")));
    }
  }
}
