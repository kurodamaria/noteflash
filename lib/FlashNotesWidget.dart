import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteflash/NoteViewerWidget.dart';
import 'package:noteflash/SQLiteDBManager.dart';

class FlashNotesWidget extends StatelessWidget {
  final String tableName;
  final List<Note> notes;

  FlashNotesWidget(this.tableName, this.notes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tableName),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemBuilder: (context, index) => Container(
              margin: EdgeInsets.all(10), child: NoteViewerWidget(notes[index])),
          itemCount: notes.length,
        ),
      ),
    );
  }
}
