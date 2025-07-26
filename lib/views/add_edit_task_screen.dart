import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/task_view_model.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.task?.title ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskVM = Provider.of<TaskViewModel>(context, listen: false);

      if (widget.task == null) {
        // Add new task
        await taskVM.addTask(_titleController.text.trim());
      } else {
        // Update existing task
        final updatedTask = Task(
          id: widget.task!.id,
          title: _titleController.text.trim(),
          isCompleted: widget.task!.isCompleted,
        );
        await taskVM.updateTask(updatedTask);
      }
      Navigator.pop(context); // back to home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
