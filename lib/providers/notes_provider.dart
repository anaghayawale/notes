import 'package:flutter/material.dart';

import '../models/note.dart';

class NotesProvider with ChangeNotifier{

  List<Note> notes = [];

  void addNote(Note note){
    notes.add(note);
    notifyListeners();
  }

  void updateNote(){

  }

  void deleteNote(){

  }
}