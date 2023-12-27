import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/services/api_services.dart';
import 'package:notes/utils/constants.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  List<Note> selectedNotes = [];
  bool isSelectionMode = false;
  bool isLoading = true;
  ApiService apiService = ApiService();
  bool animatedBorder = false;

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
    // Optimistic update: Add the note to the list immediately
    animatedBorder = true;
    notes.insert(0, note);
    notifyListeners();

    Note addedNote = await apiService.addNote(note: note);
    if (addedNote.id == '') {
      notes.remove(note);
      animatedBorder = false;
      notifyListeners();
      Fluttertoast.showToast(
          msg: 'Failed to add note',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Constants.yellowColor.withOpacity(0.2),
          textColor: Constants.redColor,
          fontSize: 18);
    } else {
      int indexOfNote = notes.indexOf(note);
      notes[indexOfNote] = addedNote;
      animatedBorder = false;
      notifyListeners();
      Fluttertoast.showToast(
        msg: 'Note Added successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Constants.yellowColor.withOpacity(0.2),
        textColor: Constants.greenColor,
      );
    }
  }

  void updateNoteOptimistically(
      {required Note note, required Note oldNote}) async {
    int indexOfNote = notes.indexWhere((element) => element.id == note.id);
    notes[indexOfNote] = note;
    notifyListeners();

    bool isUpdated = await apiService.updateNote(note: note);
    if (!isUpdated) {
      notes[indexOfNote] = oldNote;
      notifyListeners();
      Fluttertoast.showToast(
          msg: 'Failed to update note',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Constants.yellowColor.withOpacity(0.2),
          textColor: Constants.redColor,
          fontSize: 18);
    } else {
      Fluttertoast.showToast(
        msg: 'Note updated successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Constants.yellowColor.withOpacity(0.2),
        textColor: Constants.greenColor,
      );
    }
  }

  // void updateNote({required Note note}) {
  //   int indexOfNote = notes.indexWhere((element) => element.id == note.id);
  //   notes[indexOfNote] = note;
  //   notifyListeners();
  //   apiService.updateNote(note: note);
  // }

  void fetchNotes() async {
    notes = await apiService.fetchNotes();
    isLoading = false;
    notifyListeners();
  }
}
