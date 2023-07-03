import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagementApp());
}

class Task {
  String title;
  String description;
  DateTime deadline;

  Task({required this.title, required this.description, required this.deadline});
}

class TaskManagementApp extends StatelessWidget {
  final List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskListScreen(tasks: tasks),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;

  TaskListScreen({required this.tasks});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();

    // Adding sample tasks to the task list
    _addTask(Task(
      title: 'Assignment',
      description: 'Task Management app',
      deadline: DateTime(2023, 7, 3),
    ));

    _addTask(Task(
      title: 'Quiz',
      description: 'Before 3 July 11:59PM',
      deadline: DateTime(2023, 7, 3),
    ));

    _addTask(Task(
      title: 'Live test',
      description: 'Will start at 11:00 AM, 3 July',
      deadline: DateTime(2023, 7, 3),
    ));

    _addTask(Task(
      title: 'Resources',
      description: 'Module 8 resources',
      deadline: DateTime(2023, 7, 3),
    ));
  }

  void _addTask(Task task) {
    setState(() {
      widget.tasks.add(task);
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      widget.tasks.remove(task);
    });
  }

  void _openAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String description = '';
        DateTime deadline = DateTime.now();

        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 5),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      deadline = selectedDate;
                    });
                  }
                },
                child: Text('Select Deadline'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Task newTask = Task(
                  title: title,
                  description: description,
                  deadline: deadline,
                );

                _addTask(newTask);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _openTaskDetailsBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${task.title}'),
                SizedBox(height: 8),
                Text('Description: ${task.description}'),
                SizedBox(height: 8),
                Text('Deadline: ${task.deadline.toString()}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _deleteTask(task);
                    Navigator.pop(context);
                  },
                  child: Text('Delete Task'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Task Management'),
      ),
      body: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          Task task = widget.tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            onTap: () => _openTaskDetailsBottomSheet(context, task),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTaskDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
