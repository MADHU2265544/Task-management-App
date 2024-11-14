Main.dart :
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',

      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.purpleAccent,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: _themeMode,
      home: LoginScreen(toggleTheme: _toggleTheme),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  LoginScreen({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TASK MANAGEMENT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade700,

              ),
            ),


            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListScreen(toggleTheme: toggleTheme)),
                );
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to login after signup
              },
              child: Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  TaskListScreen({required this.toggleTheme});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _showTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskDialog(onAddTask: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          _DateHeader(),
          Expanded(
            child: tasks.isEmpty
                ? Center(child: Text('You do not have any tasks yet!'))
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (ctx, i) => _TaskItem(task: tasks[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}

class Task {
  final String title;
  final String note;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Color color;

  Task({required this.title, required this.note, required this.date, required this.startTime, required this.endTime, required this.color});
}

class _TaskItem extends StatelessWidget {
  final Task task;

  _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: task.color,
      child: ListTile(
        title: Text(task.title),
        subtitle: Text('${DateFormat('hh:mm a').format(DateTime(0, 0, 0, task.startTime.hour, task.startTime.minute))} - ${DateFormat('hh:mm a').format(DateTime(0, 0, 0, task.endTime.hour, task.endTime.minute))}'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(value: 'complete', child: Text('Task Completed')),
            PopupMenuItem(value: 'delete', child: Text('Delete Task')),
          ],
        ),
      ),
    );
  }
}

class TaskDialog extends StatefulWidget {
  final Function(Task) onAddTask;

  TaskDialog({required this.onAddTask});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  Color _selectedColor = Colors.purpleAccent;

  void _submitTask() {
    final task = Task(
      title: _titleController.text,
      note: _noteController.text,
      date: _selectedDate,
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
    );
    widget.onAddTask(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Task Description'),
              ),
              ListTile(
                title: Text('Date: ${DateFormat.yMd().format(_selectedDate)}'),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Start Time: ${_startTime.format(context)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _startTime,
                          );
                          if (pickedTime != null && pickedTime != _startTime) {
                            setState(() {
                              _startTime = pickedTime;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('End Time: ${_endTime.format(context)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _endTime,
                          );
                          if (pickedTime != null && pickedTime != _endTime) {
                            setState(() {
                              _endTime = pickedTime;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              DropdownButton<Color>(
                value: _selectedColor,
                onChanged: (newColor) {
                  setState(() {
                    _selectedColor = newColor!;
                  });
                },
                items: [
                  DropdownMenuItem(value: Colors.purpleAccent, child: Text("Purple")),
                  DropdownMenuItem(value: Colors.orange, child: Text("Orange")),
                  DropdownMenuItem(value: Colors.red, child: Text("Red")),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitTask,
                child: Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            DateFormat('MMMM d, yyyy').format(DateTime.now()),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}


