import 'package:flutter/material.dart';
import 'package:notes/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/notes_provider.dart';

class CustomDialogBox extends StatefulWidget {
  final BuildContext context;
  final Note? currentNote;
  final String title;
  final String content;
  final String positiveButtonText;
  final String negativeButtonText;
  const CustomDialogBox({super.key, required this.title, required this.content, required this.positiveButtonText, required this.negativeButtonText, this.currentNote, required this.context});

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Constants.noteCardBackgroundColor,
      surfaceTintColor: Constants.yellowColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        height: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: Constants.blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 10.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Constants.whiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if(widget.currentNote != null)
                      {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context, false);
                      }
                    },
                    child: Text(
                      widget.negativeButtonText,
                      style: TextStyle(
                        color: Constants.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Constants.whiteColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if(widget.currentNote != null)
                      {
                        if(widget.positiveButtonText == "Update")
                        {
                          notesProvider.updateNote(widget.currentNote!);
                          Navigator.pop(context);
                        }
                        else if(widget.positiveButtonText == "Delete")
                        {
                          notesProvider.deleteNote(widget.currentNote!);
                          Navigator.pop(context);
                        }
                        
                      }
                      else{
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      widget.positiveButtonText,
                      style: TextStyle(
                        color: Constants.redColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
