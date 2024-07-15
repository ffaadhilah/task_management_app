import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(child: Text('No tasks yet, add some!'))
          : AnimatedList(
              initialItemCount: tasks.length,
              itemBuilder: (context, index, animation) {
                final task = tasks[index];
                return buildTaskItem(task, context, animation);
              },
            ),
    );
  }

  Widget buildTaskItem(
      Task task, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          final taskProvider =
              Provider.of<TaskProvider>(context, listen: false);
          taskProvider.deleteTask(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task deleted'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  taskProvider.undoDeleteTask();
                },
              ),
            ),
          );
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: TaskItem(task),
      ),
    );
  }
}
