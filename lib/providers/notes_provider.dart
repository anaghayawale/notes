import 'package:flutter/material.dart';
import 'package:notes/services/api_services.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  bool isLoading = true;
  ApiService apiService = ApiService();

  NotesProvider() {
    fetchNotes();
  }

  void addNote({required Note note}) {
    notes.add(note);
    notifyListeners();
    apiService.addNote(
      note: note,
    );
  }

  void updateNote({
    required Note note,
    required String userId
  }) {
    int indexOfNote = notes.indexWhere((element) => element.id == note.id);
    notes[indexOfNote] = note;
    notifyListeners();
    apiService.updateNote(
      note: note,
      userId: userId
    );
  }

  void deleteNote({required Note note}) {
    int indexOfNote = notes.indexWhere((element) => element.id == note.id);
    notes.removeAt(indexOfNote);
    notifyListeners();
    apiService.deleteNote(
      note: note,
    );
  }

  void fetchNotes() async {
    notes = await apiService.fetchNotes();
    isLoading = false;
    notifyListeners();
  }
}
