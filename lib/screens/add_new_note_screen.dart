import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AddNewNoteScreen extends StatefulWidget {
  const AddNewNoteScreen({super.key});

  @override
  State<AddNewNoteScreen> createState() => _AddNewNoteScreenState();
}

class _AddNewNoteScreenState extends State<AddNewNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  FocusNode noteFocus = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
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
                  controller: _noteController,
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