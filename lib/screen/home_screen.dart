import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xasuus_tus/models/note.dart';
import 'package:xasuus_tus/screen/screens.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Note>> getNotes() async {
    final notesRef = firestore.collection('notes');
    final data = await notesRef.get();
    // Note note = Note.fromJson(data.docs[1].data());
    // print(note.date);
    return data.docs.map((e) => Note.fromJson(e.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: TextStyle(
              color: Colors.black54, fontSize: 26, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_alt_outlined,
                color: Colors.black54,
              ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Note....',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder<List<Note>>(
              future: getNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final notes = snapshot.data!;
                // return Text(date[0].title);
                return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: ((context, index) {
                      return NoteCard(
                        note: notes[index],
                      );
                    }));
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  const NoteCard({Key? key, required this.note}) : super(key: key);
  final Note note;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> deleteNote(String id) async =>
      firestore.collection('notes').doc(id).delete();

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      key: ObjectKey(widget.note.id),
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "delete",
            onTap: (CompletionHandler handler) async {
              await handler(true);
              deleteNote(widget.note.id);
              setState(() {});
            },
            color: Colors.red),
        SwipeAction(
            widthSpace: 120,
            title: "popAlert",
            onTap: (CompletionHandler handler) async {
              /// false means that you just do nothing,it will close
              /// action buttons by default
              handler(false);
              showCupertinoDialog(
                  context: context,
                  builder: (c) {
                    return CupertinoAlertDialog(
                      title: Text('ok'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('confirm'),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
            color: Colors.orange),
      ],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => NoteScreen(
                          note: widget.note,
                        ))),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(),
              child: Row(children: [
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.note.title,
                        style: GoogleFonts.poppins(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.note.date.toIso8601String(),
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.note.description,
                        style: GoogleFonts.poppins(fontSize: 13),
                      )
                    ],
                  ),
                )),
                Container(
                  height: double.infinity,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Color(int.parse('0xff' + widget.note.color)),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
