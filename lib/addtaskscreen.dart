import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class AddTaskScreen extends StatefulWidget {
  final Function(String, String, DateTime) onAddTask;

  AddTaskScreen({required this.onAddTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  DateTime? _selectedDateTime; // Use DateTime? to allow null

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Center(
          child: Container(
            width: 400, // Adjust the width as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: TextStyle(color: Colors.black), // Label text color
                  ),
                  style: TextStyle(color: Colors.black), // Input text color
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _detailsController,
                  decoration: InputDecoration(
                    labelText: 'Task',
                    labelStyle: TextStyle(color: Colors.black), // Label text color
                  ),
                  style: TextStyle(color: Colors.black), // Input text color
                  maxLines: null,
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDateTime ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedDateTime != null
                            ? TimeOfDay.fromDateTime(_selectedDateTime!)
                            : TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
                    }
                  },
                  child: _selectedDateTime != null
                      ? Text('Selected Date and Time: ${DateFormat('yyyy-MM-dd hh:mm a').format(_selectedDateTime!)}')
                      : Text(
                          'Select Date and Time of the Submission',
                          style: TextStyle(color: Colors.blue), // Text color
                        ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Custom back button
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Back',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Check if title and task are not empty before adding task
                        if (_titleController.text.isNotEmpty &&
                            _detailsController.text.isNotEmpty &&
                            _selectedDateTime != null) {
                          widget.onAddTask(
                            _titleController.text,
                            _detailsController.text,
                            _selectedDateTime!,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 157, 8),
                      ),
                      child: Text('Add Subject',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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

void main() {
  runApp(MaterialApp(
    home: AddTaskScreen(
      onAddTask: (title, details, dateTime) {
        print('Task Added: $title, $details, $dateTime');
      },
    ),
  ));
}
