import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/services/api_services.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/components/cusotm_toast.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  List<Note> selectedNotes = [];
  bool isSelectionMode = false;
  bool isLoading = true;
  ApiService apiService = ApiService();
  bool animatedBorder = false;
  String updatingNoteId = '';

  NotesProvider() {
    fetchNotes();
  }

  List<Note> getFilteredNotes(String searchQuery) {
    List<Note> filteredNotes = notes
        .where((element) =>
            element.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            element.content.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return filteredNotes;
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

  void addNoteOptimistically({required Note note}) async {
    animatedBorder = true;
    notes.insert(0, note);
    notifyListeners();

    Note addedNote = await apiService.addNote(note: note);
    if (addedNote.id == '') {
      notes.remove(note);
      animatedBorder = false;
      notifyListeners();
      CustomToast(
        message: 'Failed to Add Note',
        textColor: Constants.redColor,
      );
    } else {
      int indexOfNote = notes.indexOf(note);
      notes[indexOfNote] = addedNote;
      animatedBorder = false;
      notifyListeners();
      CustomToast(
        message: 'Note added successfully',
        textColor: Constants.greenColor,
      );
    }
  }

  void updateNoteOptimistically(
      {required Note note, required Note oldNote}) async {
    int indexOfNote = notes.indexWhere((element) => element.id == note.id);
    notes[indexOfNote] = note;
    animatedBorder = true;
    updatingNoteId = note.id!;
    notifyListeners();

    bool isUpdated = await apiService.updateNote(note: note);
    if (!isUpdated) {
      notes[indexOfNote] = oldNote;
      animatedBorder = false;
      notifyListeners();
      CustomToast(
        message: 'Failed to Update Note',
        textColor: Constants.redColor,
      );
    } else {
      animatedBorder = false;
      notifyListeners();
      CustomToast(
        message: 'Note updated successfully',
        textColor: Constants.greenColor,
      );
    }
  }


  void fetchNotes() async {
    notes = await apiService.fetchNotes();
    isLoading = false;
    notifyListeners();
  }
}
