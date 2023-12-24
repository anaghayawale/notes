import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/services/api_services.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  List<Note> selectedNotes = [];
  bool isSelectionMode = false;
  bool isLoading = true;
  ApiService apiService = ApiService();

  NotesProvider() {
    fetchNotes();
  }

  void selectNotes({required Note note}) {
    note.isSelected = true;
    selectedNotes.add(note);
    notifyListeners();
  }

  void unSelectNotes({required Note note}) {
    note.isSelected = false;
    selectedNotes.remove(note);
    notifyListeners();
  }

  void clearSelection() {
    for (var note in selectedNotes) {
      note.isSelected = false;
    }
    selectedNotes.clear();
    notifyListeners();
  }

  void deleteSelectedNotes({required List<Note> notesToBeDeleted}) {
    List<String?> ids = notesToBeDeleted.map((e) => e.id).toList();
    print(jsonEncode(ids));
    apiService.deleteNotes(ids: ids);
    for (var note in notesToBeDeleted) {
      notes.remove(note);
    }
    selectedNotes.clear();
    notifyListeners();
  }

  void addNote({required Note note}) async {
    bool result = await apiService.addNote(
      note: note,
    );
    if (result) {
      print(note.toJson());
      notes.add(note);
      notifyListeners();
    }
  }

  void updateNote({required Note note}) {
    int indexOfNote = notes.indexWhere((element) => element.id == note.id);
    notes[indexOfNote] = note;
    notifyListeners();
    apiService.updateNote(note: note);
  }

  void fetchNotes() async {
    notes = await apiService.fetchNotes();
    isLoading = false;
    notifyListeners();
  }
}
