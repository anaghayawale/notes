import 'package:flutter/material.dart';
import 'package:notes/providers/user_provider.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/notes_provider.dart';

enum DialogType { deleteNotes, updateNote, logout, shareNote }

class CustomDialogBox extends StatefulWidget {
  final DialogType dialogType;
  final List<Note>? notes;
  final String? updatedNoteTitle;
  final String? updatedNoteContent;
  final Note? currentNote;
  final String title;
  final String content;
  final String actionButtonText;

  const CustomDialogBox(
      {super.key,
      required this.title,
      required this.content,
      required this.actionButtonText,
      this.currentNote,
      this.updatedNoteTitle,
      this.updatedNoteContent,
      this.notes,
      required this.dialogType});

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  NotesProvider notesProvider = NotesProvider();

  @override
  void initState() {
    super.initState();
    notesProvider = Provider.of<NotesProvider>(context, listen: false);
  }

  void handleAction() {
    switch (widget.dialogType) {
      case DialogType.deleteNotes:
        if (widget.notes != null) {
          notesProvider.deleteSelectedNotesOptimistically(
              notesToBeDeleted: widget.notes!);
        }
        break;
      case DialogType.updateNote:
        if (widget.currentNote != null &&
            widget.updatedNoteTitle != null &&
            widget.updatedNoteContent != null) {
          Note oldNote = Note(
            id: widget.currentNote!.id,
            userid: widget.currentNote!.userid,
            title: widget.currentNote!.title,
            content: widget.currentNote!.content,
          );
          widget.currentNote!.title = widget.updatedNoteTitle!;
          widget.currentNote!.content = widget.updatedNoteContent!;

          notesProvider.updateNoteOptimistically(
              note: widget.currentNote!, oldNote: oldNote);
        }
        break;
      case DialogType.shareNote:
        break;
      case DialogType.logout:
        Provider.of<UserProvider>(context, listen: false).logoutUser();
        break;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Constants.noteCardBackgroundColor,
      surfaceTintColor: Constants.blackColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        height: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title of the note
            Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Constants.blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            //description of the note
            if (widget.dialogType != DialogType.shareNote)
              Text(
                widget.content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.greyTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                ),
              ),
            const SizedBox(height: 10.0),
            if (widget.dialogType == DialogType.shareNote)
              InkWell(
                onTap: () {
                  shareNoteAsText(note: widget.currentNote!);
                },
                child: Text(
                  'Share note as text',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Constants.greyTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
              ),
            const SizedBox(height: 10.0),
            if (widget.dialogType == DialogType.shareNote)
              Text(
                'Share note as picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.greyTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                ),
              ),
            const SizedBox(height: 20.0),
            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButtom(
                  'Cancel',
                  () => Navigator.pop(context),
                  Constants.blackColor,
                ),
                if (widget.dialogType != DialogType.shareNote)
                  _buildButtom(
                    widget.actionButtonText,
                    handleAction,
                    Constants.redColor,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildButtom(String text, VoidCallback onPressed, Color color) {
  return Container(
    width: 100.0,
    height: 40.0,
    decoration: BoxDecoration(
      color: Constants.whiteColor,
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
