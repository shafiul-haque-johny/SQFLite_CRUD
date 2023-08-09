import 'package:flutter/material.dart';
import 'package:sqflite_crud/sql_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> journals = [];

  bool isLoading = true;

  void refreshJournal() async {
    final data = await SQLHelper.getItems();
    setState(() {
      journals = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshJournal();
    print(' Number of items ${journals.length}');
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        titleController.text, descriptionController.text);
    refreshJournal();
    print(' Number of items ${journals.length}');
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, titleController.text, descriptionController.text);
    refreshJournal();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    refreshJournal();
  }

  void showForm(int? id) async {
    if (id != null) {
      final exitingJournal =
          journals.firstWhere((element) => element['id'] == id);
      titleController.text = exitingJournal['title'];
      descriptionController.text = exitingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItem();
                      }
                      if (id != null) {
                        await _updateItem(id);
                      }

                      //clear the text field
                      titleController.text = '';
                      descriptionController.text = '';

                      // close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15.0),
          child: ListTile(
            title: Text(journals[index]['title']),
            subtitle: Text(journals[index]['description']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => showForm(journals[index]['id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteItem(journals[index]['id']),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showForm(null),
      ),
    );
  }
}
