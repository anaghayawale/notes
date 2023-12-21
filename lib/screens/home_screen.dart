import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/screens/add_new_note_screen.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/utils/custom_drawer.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/custom_dialog_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        backgroundColor: Constants.appBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: Constants.yellowColor,
          title: Text(
            "Notes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Constants.yellowColor,
            ),
          ),
          backgroundColor: Constants.appBackgroundColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Constants.yellowColor,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const CustomDrawer(),
        body: (notesProvider.isLoading == false)
            ? SafeArea(
                child: (notesProvider.notes.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: notesProvider.notes.length,
                          itemBuilder: (context, index) {
                            Note currentNote = notesProvider.notes[index];
                            User currentUser = userProvider.user;

                            return GestureDetector(
                              onTap: () {
                                //Update note
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => AddNewNoteScreen(
                                      isUpdating: true,
                                      note: currentNote,
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                //delete
                                //notesProvider.deleteNote(currentNote);
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomDialogBox(
                                          currentUser: currentUser,
                                          currentNote: currentNote,
                                          title: "Delete note",
                                          content:
                                              "Are you sure you want to delete this note?",
                                          negativeButtonText: "Cancel",
                                          positiveButtonText: "Delete",
                                        ));
                              },
                              child: Container(
                                height: 220.0,
                                width: 200.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 12.0, 10.0, 12.0),
                                decoration: BoxDecoration(
                                  color: Constants.whiteColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
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
                child: CircularProgressIndicator(
                color: Constants.yellowColor,
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
