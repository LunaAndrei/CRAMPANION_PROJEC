import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'taskprovider.dart';
import 'taskdetailscreen.dart';
import 'addtaskscreen.dart';
import 'EditTaskScreen.dart'; // Import EditTaskScreen

class TaskScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  TaskScreen({required this.onToggleTheme});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCrampanionDialog(context));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCrampanionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome to Crampanion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Crampanion is your task management companion designed to help you stay organized and productive. Here are some features:'),
                SizedBox(height: 10),
                Text('1. Add new tasks using the "+" button.'),
                Text('2. Tap on a task to view details.'),
                Text('3. Edit or delete tasks using the icons.'),
                Text('4. Toggle between light and dark mode using the sun/moon icon.'),
                Text('5. Stay on top of your tasks with due date highlights.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showGetStartedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Get Started with Crampanion',
            style: TextStyle(
              fontSize: 24, // Make the text larger
              fontWeight: FontWeight.bold, // Make the text bold
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(3.0, 3.0),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Welcome to Crampanion! Here\'s how to get started:'),
                SizedBox(height: 10),
                Text('1. Add new tasks using the "+" button.'),
                Text('2. Tap on a task to view details.'),
                Text('3. Edit or delete tasks using the icons.'),
                Text('4. Toggle between light and dark mode using the sun/moon icon.'),
                Text('5. Enjoy staying organized and productive!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Sort tasks based on the nearest submission date
    taskProvider.tasks.sort((a, b) {
      DateTime? aNearestDate = a.submissionDateTimes.isNotEmpty
          ? a.submissionDateTimes.reduce((a, b) => a.isBefore(b) ? a : b)
          : null;
      DateTime? bNearestDate = b.submissionDateTimes.isNotEmpty
          ? b.submissionDateTimes.reduce((a, b) => a.isBefore(b) ? a : b)
          : null;

      if (aNearestDate == null) return 1;
      if (bNearestDate == null) return -1;
      return aNearestDate.compareTo(bNearestDate);
    });

    final tasksDueSoon = taskProvider.tasks.where((task) {
      final nearestDate = task.submissionDateTimes.isNotEmpty
          ? task.submissionDateTimes.reduce((a, b) => a.isBefore(b) ? a : b)
          : null;
      return nearestDate != null && nearestDate.isBefore(DateTime.now().add(Duration(hours: 24)));
    }).toList();

    final tasksNotDueSoon = taskProvider.tasks.where((task) {
      final nearestDate = task.submissionDateTimes.isNotEmpty
          ? task.submissionDateTimes.reduce((a, b) => a.isBefore(b) ? a : b)
          : null;
      return nearestDate == null || nearestDate.isAfter(DateTime.now().add(Duration(hours: 24)));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center align the title
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0), // Add padding at the top of the logo
          child: Image.asset(
            'assets/splash_image.png',
            height: 851, // Adjust the height as needed
            width: 100, // Adjust the width as needed
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showGetStartedDialog(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.task), text: "All Tasks (${tasksNotDueSoon.length})"),
            Tab(icon: Icon(Icons.notifications), text: "Due Soon (${tasksDueSoon.length})"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(tasksNotDueSoon),
          _buildTaskList(tasksDueSoon),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, taskProvider);
        },
        backgroundColor: Color(0xFFDEB887), // Whitish brown color
        child: Icon(
          Icons.add,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        DateTime? nearestDate = task.submissionDateTimes.isNotEmpty
            ? task.submissionDateTimes.reduce((a, b) => a.isBefore(b) ? a : b)
            : null;
        return TaskListItem(
          title: task.Subject,
          date: nearestDate,
          onDelete: () {
            _showDeleteDialog(context, Provider.of<TaskProvider>(context, listen: false), task);
          },
          onEdit: () {
            _navigateToEditTaskScreen(context, Provider.of<TaskProvider>(context, listen: false), task);
          },
          onEditTitle: (newTitle) {
            setState(() {
              task.Subject = newTitle; // Update the title locally in the list item
            });
          },
          onTap: () async {
            // Navigate to TaskDetailsScreen and handle updates
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(
                  task: task,
                  onToggleTheme: widget.onToggleTheme,
                ),
              ),
            ).then((updatedTask) {
              if (updatedTask != null) {
                // Handle updated task, if needed
                Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
              }
            });
          },
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: AddTaskScreen(
            onAddTask: (title, details, dateTime) {
              taskProvider.addTask(title, details, dateTime);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, TaskProvider taskProvider, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                taskProvider.deleteTask(task.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditTaskScreen(BuildContext context, TaskProvider taskProvider, Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          task: task,
          onSave: (updatedTask) {
            taskProvider.updateTask(updatedTask);
          },
        ),
      ),
    );
  }
}

class TaskListItem extends StatefulWidget {
  final String title;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final Function(String) onEditTitle; // Callback to edit title

  TaskListItem({
    required this.title,
    required this.date,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.onEditTitle,
  });

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  late Timer _timer;
  bool _showRed = true;

  @override
  void initState() {
    super.initState();
    // Start the timer to toggle the red color
    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        _showRed = !_showRed;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate due today or tomorrow
    bool isDueToday = widget.date != null && _isSameDay(widget.date!, DateTime.now());
    bool isDueTomorrow = widget.date != null && _isSameDay(widget.date!, DateTime.now().add(Duration(days: 1)));
    bool isDueWithin24Hours = widget.date != null && widget.date!.isBefore(DateTime.now().add(Duration(hours: 24)));

    // Calculate the remaining hours until the submission date
    int? remainingHours;
    if (widget.date != null) {
      remainingHours = widget.date!.difference(DateTime.now()).inHours;
      // If the remaining hours are negative, it means the task is overdue
      if (remainingHours < 0) remainingHours = 0;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: widget.onTap,
        leading: Icon(Icons.task, size: 40.0, color: Colors.yellow), // Add the icon here with yellow color
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            if (isDueWithin24Hours)
              Text(
                'Due now',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (remainingHours != null && remainingHours > 24) // Display remaining days if more than 24 hours
              Text(
                '(${(remainingHours / 24).ceil()}d left)',
                style: TextStyle(
                  color: (remainingHours <= 24) ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editTitle(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        subtitle: widget.date != null
            ? Text(
                DateFormat('MMMM dd, yyyy – hh:mm a').format(widget.date!),
                style: TextStyle(
                  color: isDueToday
                      ? (_showRed ? Colors.red : Colors.transparent)
                      : isDueTomorrow
                          ? Colors.orange
                          : Colors.green,
                  fontWeight: isDueToday || isDueTomorrow ? FontWeight.bold : FontWeight.normal,
                ),
              )
            : null,
      ),
    );
  }

  void _editTitle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController(text: widget.title);

        return AlertDialog(
          title: Text('Edit Title'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new title'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                widget.onEditTitle(_controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
