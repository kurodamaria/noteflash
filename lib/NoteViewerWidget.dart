import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteflash/SQLiteDBManager.dart';

class NoteViewerWidget extends StatefulWidget {
  final Note note;

  NoteViewerWidget(this.note);

  @override
  _NoteViewerWidgetState createState() => _NoteViewerWidgetState();
}

class _NoteViewerWidgetState extends State<NoteViewerWidget> {
  bool _front = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        alignment: Alignment.center,
        color: _front ? Colors.yellowAccent : Colors.greenAccent,
        width: 300,
        height: 300,
        child: Text(
            _front ? widget.note.front : widget.note.back,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      onDoubleTap: () => setState((){ _front = !_front;}),
    );
  }
}
