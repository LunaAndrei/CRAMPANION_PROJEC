import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onSave;

  EditTaskScreen({required this.task, required this.onSave});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late String updatedTitle;

  @override
  void initState() {
    super.initState();
    updatedTitle = widget.task.Subject; // Initialize with current title
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: updatedTitle),
              decoration: InputDecoration(
                labelText: 'Task Subject',
                hintText: 'Enter the Subject name or Course Code',
              ),
              onChanged: (value) {
                updatedTitle = value; // Update title as user types
              },
            ),
            SizedBox(height: 16),
            Text(
              'Current Date: ${DateFormat.yMd().add_jm().format(widget.task.submissionDateTimes.last)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.task.Subject = updatedTitle; // Update task object with new title
                widget.onSave(widget.task); // Pass back the updated task to TaskScreen
                Navigator.of(context).pop(); // Close edit screen
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
