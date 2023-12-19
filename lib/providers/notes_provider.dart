import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/user.dart';

class NotesProvider with ChangeNotifier{

  List<Note> notes = []; 

  void addNote({
    required Note note,
    required User user,}){
    notes.add(note);
    notifyListeners();
  }

  void updateNote({
    required Note note,
    required User user,}){
      int indexOfNote = notes.indexWhere((element) => element.id == note.id);
      notes[indexOfNote] = note;
      notifyListeners();
  }

  void deleteNote({
    required Note note,
    required User user,}){
      int indexOfNote = notes.indexWhere((element) => element.id == note.id);
      notes.removeAt(indexOfNote);
      notifyListeners();
  
  }
}