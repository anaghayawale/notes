import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/screens/add_new_note_screen.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/components/custom_drawer.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../components/custom_dialog_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> loadingQuotes = [
    "Loading your notes...",
    "Hang tight! Your notes are on the way.",
    "Did you know? Patience is a virtue!",
    // Add more quotes as needed
  ];
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
        backgroundColor: Constants.appBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: Constants.yellowColor,
          title: (notesProvider.isSelectionMode == true)
              ? (notesProvider.selectedNotes.isEmpty)
                  ? Text("Select items",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.yellowColor,
                      ))
                  : (notesProvider.selectedNotes.length > 1)
                      ? Text(
                          "${notesProvider.selectedNotes.length} items selected",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.yellowColor,
                          ))
                      : Text(
                          "${notesProvider.selectedNotes.length} item selected",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.yellowColor,
                          ))
              : Text(
                  "Notes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.yellowColor,
                  ),
                ),
          backgroundColor: Constants.appBackgroundColor,
          actions: [
            if (notesProvider.selectedNotes.isNotEmpty)
              IconButton(
                  onPressed: () {
                    List<Note> selectedNotes = notesProvider.selectedNotes;

                    showDialog(
                        context: context,
                        builder: (context) => CustomDialogBox(
                              dialogType: DialogType.deleteNotes,
                              notes: selectedNotes,
                              title: "Delete notes",
                              content: (notesProvider.selectedNotes.length > 1)
                                  ? "Delete ${notesProvider.selectedNotes.length} items?"
                                  : "Delete ${notesProvider.selectedNotes.length} item?",
                              actionButtonText: "Delete",
                            ));
                  },
                  icon: Icon(Icons.delete, color: Constants.yellowColor))
          ],
          leading: Builder(
            builder: (context) {
              if (notesProvider.isSelectionMode == true) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      notesProvider.isSelectionMode = false;
                      notesProvider.clearSelection();
                    });
                  },
                  icon: Icon(Icons.close, color: Constants.yellowColor),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu, color: Constants.yellowColor),
                );
              }
            },
          ),
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
                            TextField(
                              scrollPhysics:
                                  const NeverScrollableScrollPhysics(),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Constants.greyColor,
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.greyTextColor,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Constants.yellowColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
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

                                return GestureDetector(
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
                                  child: AnimatedGradientBorder(
                                    gradientColors: [
                                      Constants.whiteColor,
                                      Constants.whiteColor,
                                      Constants.whiteColor,
                                      ((currentNote.id == null &&
                                                  notesProvider.animatedBorder ==
                                                      true) ||
                                              (currentNote.id ==
                                                      notesProvider
                                                          .updatingNoteId &&
                                                  notesProvider
                                                          .animatedBorder ==
                                                      true))
                                          ? Constants.yellowColor
                                              .withOpacity(0.1)
                                          : Constants.whiteColor,
                                    ],
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSize: 0.5,
                                    glowSize: 0.5,
                                    animationProgress: ((currentNote.id ==
                                                    null &&
                                                notesProvider.animatedBorder ==
                                                    true) ||
                                            (currentNote.id ==
                                                    notesProvider
                                                        .updatingNoteId &&
                                                notesProvider.animatedBorder ==
                                                    true))
                                        ? null
                                        : 0.1,
                                    child: Container(
                                      height: 220.0,
                                      width: 200.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 5.0),
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 12.0, 10.0, 12.0),
                                      decoration: BoxDecoration(
                                        color: Constants.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Stack(children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentNote.title,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                                color: Constants.blackColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 7.0,
                                            ),
                                            Text(
                                              currentNote.content,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Constants.greyTextColor,
                                              ),
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                          ],
                                        ),
                                        if (notesProvider.isSelectionMode ==
                                            true)
                                          Positioned(
                                              bottom: 1,
                                              right: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (currentNote
                                                                  .isSelected ==
                                                              true) {
                                                            notesProvider
                                                                .unSelectNotes(
                                                                    note:
                                                                        currentNote);
                                                          } else {
                                                            notesProvider
                                                                .selectNotes(
                                                                    note:
                                                                        currentNote);
                                                          }
                                                        });
                                                      },
                                                      child: (currentNote
                                                                  .isSelected ==
                                                              true)
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color: Constants
                                                                  .yellowColor)
                                                          : Icon(
                                                              Icons
                                                                  .circle_outlined,
                                                              color: Constants
                                                                  .yellowColor)),
                                                ],
                                              ))
                                      ]),
                                    ),
                                  ),
                                );
                              },
                            ),
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
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Constants.yellowColor,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    loadingQuotes[Random().nextInt(loadingQuotes.length)],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Constants.greyTextColor,
                    ),
                  ),
                ],
              )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Constants.yellowColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
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
          child: Icon(Icons.add, color: Constants.whiteColor),
        ));
  }
}
