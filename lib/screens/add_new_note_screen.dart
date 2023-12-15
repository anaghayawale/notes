import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class AddNewNoteScreen extends StatefulWidget {
  const AddNewNoteScreen({super.key});

  @override
  State<AddNewNoteScreen> createState() => _AddNewNoteScreenState();
}

class _AddNewNoteScreenState extends State<AddNewNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  FocusNode noteFocus = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void addNewNote(){
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showSnackBar(context, 'Title or content cannot be empty', Constants.redColor);
      return;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    User currentUser = userProvider.user;

    Note newNote = Note(
      id: const Uuid().v1(),
      userid: currentUser.id,
      title: _titleController.text,
      content: _contentController.text,
      dateadded: DateTime.now(),
    );
    Provider.of<NotesProvider>(context,listen: false).addNote(newNote);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Constants.yellowColor,
        title: Text("Add Note", style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Constants.yellowColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              addNewNote();
            }, 
            icon: Icon(Icons.check, color: Constants.yellowColor),
          ),],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                onSubmitted: (value) {
                  if(value.isNotEmpty) {
                    noteFocus.requestFocus();
                  }
                },
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w400,
                ),
                cursorColor: Constants.yellowColor,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
              ),
              Divider(
                thickness: 1.0,
                color: Constants.yellowColor,
              ),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  focusNode: noteFocus,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  cursorColor: Constants.yellowColor,
                  decoration: const InputDecoration(
                    hintText: "Start typing...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),),
    );
  }
}