import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/custom_dialog_box.dart';
import '../utils/utils.dart';

class AddNewNoteScreen extends StatefulWidget {
  final bool isUpdating;
  final Note? currentNote;
  const AddNewNoteScreen(
      {super.key, required this.isUpdating, this.currentNote});

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

  void addNewNote() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showSnackBar(
          context, 'Title or content cannot be empty', Constants.redColor);
      return;
    }
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    User currentUser = userProvider.user;

    Note newNote = Note(
      userid: currentUser.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
    );
    Provider.of<NotesProvider>(context, listen: false).addNote(note: newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showSnackBar(
          context, 'Title or content cannot be empty', Constants.redColor);
      return;
    }
    FocusScope.of(context).unfocus();

    print(widget.currentNote!.id);
    showDialog(
      context: context,
      builder: (context) => CustomDialogBox(
        dialogType: DialogType.updateNote,
        updatedNoteTitle: _titleController.text,
        updatedNoteContent: _contentController.text,
        currentNote: widget.currentNote,
        title: "Update note",
        content: "Are you sure you want to update this note?",
        actionButtonText: "Update",
      ),
    ).then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdating) {
      _titleController.text = widget.currentNote!.title;
      _contentController.text = widget.currentNote!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Constants.yellowColor,
        actions: [
          if (widget.isUpdating)
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.ios_share, color: Constants.yellowColor),
            ),
          IconButton(
            onPressed: () async {
              widget.isUpdating ? updateNote() : addNewNote();
            },
            icon: widget.isUpdating
                ? Icon(Icons.edit, color: Constants.yellowColor)
                : Icon(Icons.check, color: Constants.yellowColor),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                autofocus: (widget.isUpdating == true) ? false : true,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
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
        ),
      ),
    );
  }
}
