import 'package:flutter/material.dart';
import 'package:notes/services/api_services.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/components/custom_toast.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  List<Note> selectedNotes = [];
  bool isSelectionMode = false;
  bool isLoading = true;
  ApiService apiService = ApiService();
  bool animatedBorder = false;
  String? animatedNoteId = '';
  List<String?> animatedDeleteNoteIds = [];

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

  void addNoteOptimistically({required Note note}) async {
    animatedBorder = true;
    animatedNoteId = note.id;
    notes.insert(0, note);
    notifyListeners();

    Note addedNote = await apiService.addNote(note: note);
    if (addedNote.id == '') {
      notes.remove(note);
      animatedBorder = false;
      animatedNoteId = '';
      notifyListeners();
      CustomToast.showToast(
        message: 'Failed to Add Note',
        textColor: Constants.redColor,
      );
    } else {
      int indexOfNote = notes.indexOf(note);
      notes[indexOfNote] = addedNote;
      animatedBorder = false;
      animatedNoteId = '';
      notifyListeners();
      CustomToast.showToast(
        message: 'Note added successfully',
        textColor: Constants.greenColor,
      );
    }
  }

  void updateNoteOptimistically(
      {required Note note, required Note oldNote}) async {
    animatedBorder = true;
    animatedNoteId = note.id!;
    int indexOfNote = notes.indexWhere((element) => element.id == note.id);
    notes[indexOfNote] = note;
    notifyListeners();

    bool isUpdated = await apiService.updateNote(note: note);
    if (!isUpdated) {
      notes[indexOfNote] = oldNote;
      animatedBorder = false;
      animatedNoteId = '';
      notifyListeners();
      CustomToast.showToast(
        message: 'Failed to Update Note',
        textColor: Constants.redColor,
      );
    } else {
      animatedBorder = false;
      animatedNoteId = '';
      notifyListeners();
      CustomToast.showToast(
        message: 'Note updated successfully',
        textColor: Constants.greenColor,
      );
    }
  }

  void deleteSelectedNotesOptimistically(
      {required List<Note> notesToBeDeleted}) async {
    List<String?> ids = notesToBeDeleted.map((e) => e.id).toList();
    for (var note in notesToBeDeleted) {
      notes.remove(note);
    }
    animatedBorder = true;
    animatedDeleteNoteIds = ids;
    selectedNotes.clear();
    if (notes.isEmpty) {
      isSelectionMode = false;
    }
    notifyListeners();

    bool isDeleted = await apiService.deleteNotes(ids: ids);
    if (!isDeleted) {
      for (var note in notesToBeDeleted) {
        notes.add(note);
      }
      animatedBorder = false;
      animatedDeleteNoteIds = [];
      notifyListeners();
      CustomToast.showToast(
        message: 'Failed to Delete Notes',
        textColor: Constants.redColor,
      );
    } else {
      animatedBorder = false;
      animatedDeleteNoteIds = [];
      CustomToast.showToast(
        message: 'Notes deleted successfully',
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
