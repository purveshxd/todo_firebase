import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstore_trial/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T O D O - Firebase'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      endActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(15),
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            setState(() {
                              snapshot.data!.docs
                                  .elementAt(index)
                                  .reference
                                  .delete();
                            });
                          },
                        )
                      ]),
                      child: CheckboxListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        tileColor: Colors.teal.shade400,
                        checkColor: Colors.teal.shade900,
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(snapshot.data!.docs
                            .elementAt(index)
                            .get('title')
                            .toString()),
                        onChanged: (value) {
                          FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                            setState(() {
                              transaction.update(
                                  snapshot.data!.docs
                                      .elementAt(index)
                                      .reference,
                                  TodoModel()
                                      .copyWith(
                                          isCompleted: value,
                                          title: snapshot.data!.docs
                                              .elementAt(index)
                                              .get('title'))
                                      .toMap());
                            });
                          });
                        },
                        value: snapshot.data!.docs
                            .elementAt(index)
                            .get('isCompleted'),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                SimpleDialog(title: const Text('Add Task'), children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "Enter Tasks"),
                  controller: titleController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      FirebaseFirestore.instance.collection('tasks').doc().set(
                          TodoModel(
                                  title: titleController.text,
                                  isCompleted: false)
                              .toMap());
                      Navigator.pop(context);
                      titleController.clear();
                    },
                    child: const Text('Add')),
              )
            ]),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
