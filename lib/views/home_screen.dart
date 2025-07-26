import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import '../models/task_model.dart';
import 'add_edit_task_screen.dart';

enum FilterType { all, completed, pending }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FilterType selectedFilter = FilterType.all;

  @override
  void initState() {
    super.initState();
    Provider.of<TaskViewModel>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context);

    // Filtered tasks
    final filteredTasks = taskVM.tasks.where((task) {
      switch (selectedFilter) {
        case FilterType.completed:
          return task.isCompleted;
        case FilterType.pending:
          return !task.isCompleted;
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Filter Chips
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: selectedFilter == FilterType.all,
                onSelected: (_) => setState(() => selectedFilter = FilterType.all),
              ),
              ChoiceChip(
                label: const Text('Completed'),
                selected: selectedFilter == FilterType.completed,
                onSelected: (_) => setState(() => selectedFilter = FilterType.completed),
              ),
              ChoiceChip(
                label: const Text('Pending'),
                selected: selectedFilter == FilterType.pending,
                onSelected: (_) => setState(() => selectedFilter = FilterType.pending),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: taskVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTasks.isEmpty
                ? const Center(child: Text("No tasks found"))
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final Task task = filteredTasks[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => taskVM.toggleTaskStatus(task),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditTaskScreen(task: task),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => taskVM.deleteTask(task.id!),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditTaskScreen(task: task),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
        ),
      ),
    );
  }
}
