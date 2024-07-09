import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_todoapp/database/database.dart';
import 'package:sqflite_todoapp/provider/provider.dart';

class MyhomePage extends StatefulWidget {
  const MyhomePage({super.key});

  @override
  State<MyhomePage> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  TextEditingController taskcontroller = TextEditingController();

  final DbHelper database = DbHelper.databaseService;

  @override
  Widget build(BuildContext context) {
    final notify = Provider.of<TaskProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqlite'),
        centerTitle: true,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.tasks?.length,
            itemBuilder: (context, index) {
              final task = value.tasks?[index];
              return ListTile(
                onLongPress: () {
                  notify.deleteTask(task?.id);
                },
                title: Text(task?.content ?? ''),
                leading: CircleAvatar(
                  child: Text(task?.id.toString() ?? ''),
                ),
                trailing: Checkbox(
                  onChanged: (value) {
                    notify.updateStatus(task?.id, value == true ? 1 : 0);
                  },
                  value: task?.status == 1,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: taskcontroller,
                            decoration: InputDecoration(hintText: 'Enter Task'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (taskcontroller.text.isNotEmpty) {
                                notify.addTask(taskcontroller.text);
                                taskcontroller.clear();

                                Navigator.pop(context);
                              }

                              // database.addTask(task!);
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ));
          }),
    );
  }
}



// ListView.builder(
//               itemCount: snapshot.data?.length,
//               itemBuilder: (context, index) {
//                 final task = snapshot.data?[index];
//                 print(task);
//                 return ListTile(
//                   onLongPress: () {
//                     Provider.of<TaskProvider>(context, listen: false)
//                         .deleteTask(task?.id);
//                     // database.deleteTask(task?.id);
//                     // setState(() {});
//                   },
//                   title: Text(task?.content ?? ''),
//                   leading: CircleAvatar(
//                     child: Text(task?.id.toString() ?? ''),
//                   ),
//                   trailing: Checkbox(
//                       value: task?.status == 1,
//                       onChanged: (value) {
//                         // database.updateStatus(task?.id, value == true ? 1 : 0);

//                         Provider.of<TaskProvider>(context, listen: false)
//                             .updateStatus(task?.id, value == true ? 1 : 0);
//                         // setState(() {});
//                       }),
//                 );
//               });