import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final Map<String, List<TodoItem>> _todos = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yearly Todo List'),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          String month = _todos.keys.elementAt(index);
          List<TodoItem> todos = _todos[month]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  month,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  TodoItem todo = todos[index];
                  return ListTile(
                    title: Text(todo.task),
                    subtitle: Text(todo.date),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteTodo(month, index);
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController taskController = TextEditingController();
        TextEditingController dateController = TextEditingController();

        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: taskController,
                decoration: const InputDecoration(hintText: "Enter your task"),
              ),
              TextField(
                controller: dateController,
                decoration:
                    const InputDecoration(hintText: "Enter date (e.g., Jan 1)"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  String month = dateController.text.split(" ")[0];
                  if (!_todos.containsKey(month)) {
                    _todos[month] = [];
                  }
                  _todos[month]!.add(TodoItem(
                    task: taskController.text,
                    date: dateController.text,
                  ));
                });
                Navigator.of(context).pop();
                taskController.clear();
                dateController.clear();
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                taskController.clear();
                dateController.clear();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(String month, int index) {
    setState(() {
      _todos[month]!.removeAt(index);
      if (_todos[month]!.isEmpty) {
        _todos.remove(month);
      }
    });
  }
}

class TodoItem {
  final String task;
  final String date;

  TodoItem({required this.task, required this.date});
}
