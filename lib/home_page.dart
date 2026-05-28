import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box notesBox = Hive.box('notesBox');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // ADD NOTE
  void addNote() {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      notesBox.add({
        'title': titleController.text,
        'description': descriptionController.text,
      });

      titleController.clear();
      descriptionController.clear();

      Navigator.pop(context);

      setState(() {});
    }
  }

  // UPDATE NOTE
  void updateNote(int index) {
    notesBox.putAt(index, {
      'title': titleController.text,
      'description': descriptionController.text,
    });

    titleController.clear();
    descriptionController.clear();

    Navigator.pop(context);

    setState(() {});
  }

  // DELETE NOTE
  void deleteNote(int index) {
    notesBox.deleteAt(index);

    setState(() {});
  }

  // DIALOG BOX
  void showDialogBox({bool isEdit = false, int? index}) {
    if (isEdit) {
      var note = notesBox.getAt(index!);

      titleController.text = note['title'];
      descriptionController.text = note['description'];
    } else {
      titleController.clear();
      descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          title: Text(isEdit ? "Update Note" : "Add Note"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Enter Title",
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter Description",
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                if (isEdit) {
                  updateNote(index!);
                } else {
                  addNote();
                }
              },
              child: Text(
                isEdit ? "Update" : "Save",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,

        centerTitle: true,

        title: const Text(
          "Student Notes App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [
            // TOP CARD
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                ),

                borderRadius: BorderRadius.circular(25),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: const [
                      Text(
                        "My Notes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Save your important notes",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,

                    child: Text(
                      "${notesBox.length}",
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // NOTES LIST
            Expanded(
              child: notesBox.isEmpty
                  ? const Center(
                      child: Text(
                        "No Notes Added",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notesBox.length,

                      itemBuilder: (context, index) {
                        var note = notesBox.getAt(index);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(20),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),

                                blurRadius: 10,

                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(18),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Expanded(
                                      child: Text(
                                        note['title'],

                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: const Text("Edit"),

                                          onTap: () {
                                            Future.delayed(Duration.zero, () {
                                              showDialogBox(
                                                isEdit: true,
                                                index: index,
                                              );
                                            });
                                          },
                                        ),

                                        PopupMenuItem(
                                          child: const Text("Delete"),

                                          onTap: () {
                                            Future.delayed(Duration.zero, () {
                                              deleteNote(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  note['description'],

                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.deepPurple,
                                      size: 18,
                                    ),

                                    const SizedBox(width: 5),

                                    const Text(
                                      "Gujarat, India",
                                      style: TextStyle(color: Colors.grey),
                                    ),

                                    const Spacer(),

                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.deepPurple,
                                      size: 18,
                                    ),

                                    const SizedBox(width: 5),

                                    Text(
                                      DateTime.now().toString().substring(
                                        0,
                                        10,
                                      ),

                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,

        onPressed: () {
          showDialogBox();
        },

        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
