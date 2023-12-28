import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/custom_app_bar.dart';
import 'package:notes/components/custom_dialog_box.dart';
import 'package:notes/components/custom_fab.dart';
import 'package:notes/components/custom_grid_item.dart';
import 'package:notes/components/custom_loading_indicator.dart';
import 'package:notes/components/custom_search_bar.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/screens/add_new_note_screen.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/components/custom_drawer.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class HomeScreen extends StatefulWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
        key: HomeScreen.scaffoldKey,
        backgroundColor: Constants.whiteColor,
        appBar: CustomAppBar(
          isSelectionMode: notesProvider.isSelectionMode,
          selectedNotes: notesProvider.selectedNotes,
          onSelectionClose: () {
            setState(() {
              notesProvider.isSelectionMode = false;
              notesProvider.clearSelection();
            });
          },
          onMenuPressed: () {
            HomeScreen.scaffoldKey.currentState?.openDrawer();
          },
          onDeletePressed: () {
            List<Note> selectedNotes = notesProvider.selectedNotes;
            showDialog(
              context: context,
              builder: (context) => CustomDialogBox(
                dialogType: DialogType.deleteNotes,
                notes: selectedNotes,
                title: "Delete notes",
                content: (selectedNotes.length > 1)
                    ? "Delete ${selectedNotes.length} items?"
                    : "Delete ${selectedNotes.length} item?",
                actionButtonText: "Delete",
              ),
            );
          },
        ),
        drawer: const CustomDrawer(),
        body: (notesProvider.isLoading == false)
            ? SafeArea(
                child: (notesProvider.notes.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: ListView(
                          children: [
                            CustomSearchBar(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: notesProvider
                                    .getFilteredNotes(searchQuery)
                                    .length,
                                itemBuilder: (context, index) {
                                  Note currentNote = notesProvider
                                      .getFilteredNotes(searchQuery)[index];

                                  // int noteIndex =
                                  //     notesProvider.notes.indexOf(currentNote);

                                  // Color decorationColor = Constants.noteColors[
                                  //     noteIndex % Constants.noteColors.length];

                                  return CustomGridItem(
                                    currentNote: currentNote,
                                    onTap: () {
                                      //Update note
                                      if (notesProvider.isSelectionMode ==
                                          false) {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) =>
                                                AddNewNoteScreen(
                                              isUpdating: true,
                                              currentNote: currentNote,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        notesProvider.isSelectionMode = true;
                                        currentNote.isSelected = true;
                                        notesProvider.selectedNotes
                                            .add(currentNote);
                                      });
                                    },
                                    inkwellOnTap: () {
                                      setState(() {
                                        if (currentNote.isSelected == true) {
                                          notesProvider.unSelectNotes(
                                              note: currentNote);
                                        } else {
                                          notesProvider.selectNotes(
                                              note: currentNote);
                                        }
                                      });
                                    },
                                  );
                                })
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          "No notes yet",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                      ))
            : const Center(child: CustomLoadingIndicator()),
        floatingActionButton: CustomFAB(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => const AddNewNoteScreen(
                  isUpdating: false,
                ),
              ),
            );
          },
        ));
  }
}
