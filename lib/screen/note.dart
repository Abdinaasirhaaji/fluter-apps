import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key, required this.note});
  final Note note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.note.title),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          width: 300,
          height: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xffeaeff2)),
          child: Center(child: Text(widget.note.description)),
        ),
      ),
    );
  }
}
