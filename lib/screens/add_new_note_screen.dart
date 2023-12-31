import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../components/custom_dialog_box.dart';
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
  String typing = "";

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
    Provider.of<NotesProvider>(context, listen: false)
        .addNoteOptimistically(note: newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showSnackBar(
          context, 'Title or content cannot be empty', Constants.redColor);
      return;
    }
    FocusScope.of(context).unfocus();

    (widget.currentNote!.title);
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

  void shareNote() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showSnackBar(
          context, 'Title or content cannot be empty', Constants.redColor);
      return;
    }
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (context) => CustomDialogBox(
        dialogType: DialogType.shareNote,
        updatedNoteTitle: _titleController.text,
        updatedNoteContent: _contentController.text,
        currentNote: widget.currentNote,
        title: "Share note",
        content: "",
        actionButtonText: "Share",
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
        surfaceTintColor: Constants.blackColor,
        actions: [
          if (widget.isUpdating &&
              (_titleController.text.trim().isNotEmpty ||
                  _contentController.text.trim().isNotEmpty))
            IconButton(
                onPressed: () {
                  shareNote();
                },
                icon: (_titleController.text.isNotEmpty ||
                        _contentController.text.isNotEmpty)
                    ? Icon(Icons.ios_share, color: Constants.blackColor)
                    : Icon(Icons.ios_share, color: Constants.greyColor)),
          IconButton(
            onPressed: () async {
              widget.isUpdating ? updateNote() : addNewNote();
            },
            icon: widget.isUpdating
                ? Icon(Icons.edit, color: Constants.greenColor)
                : Icon(Icons.check, color: Constants.greenColor),
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
                cursorColor: Constants.blackColor,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
              ),
              // Divider(
              //   thickness: 1.0,
              //   color: Constants.blackColor,
              // ),
              //display date and time and characters
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (widget.isUpdating == true)
                        ? (widget.currentNote!.updatedAt != null)
                            ? DateFormat('d MMMM h:mm a')
                                .format(widget.currentNote!.updatedAt!)
                            : DateFormat('d MMMM h:mm a')
                                .format(widget.currentNote!.createdAt!)
                        : DateFormat('d MMMM h:mm a').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    "| ${_contentController.text.length} characters",
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  focusNode: noteFocus,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  cursorColor: Constants.blackColor,
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
