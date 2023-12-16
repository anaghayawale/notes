import 'package:flutter/material.dart';
import 'package:notes/services/api_services.dart';

import '../models/note.dart';
import '../models/user.dart';

class NotesProvider with ChangeNotifier{

  List<Note> notes = [];
  ApiService apiService = ApiService(); 

  void addNote({
    required BuildContext context,
    required Note note,
    required User user
  }){
    apiService.addNewNote(context: context, note: note, user: user);
    notifyListeners();
  }

  // void updateNote({
  //   required BuildContext context,
  //   required Note note,
  //   required User user
  // }){
  //   apiService.addNewNote(context: context, note: note, user: user);
  //   notifyListeners();
  // }

  void deleteNote({
    required BuildContext context,
    required Note note,
    required User user
  }){
    apiService.deleteNote(context: context, note: note, user: user);
    notifyListeners();
  }
}