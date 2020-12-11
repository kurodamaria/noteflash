import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteflash/SQLiteDBManager.dart';
import 'package:noteflash/utilities.dart';
import 'package:sqflite/sqflite.dart';

class AddNewNoteWidget extends StatefulWidget with SqliteDbManager {
  final Future<Database> _database;
  final String _tableName;

  AddNewNoteWidget(this._database, this._tableName);

  @override
  Future<Database> get database => _database;

  @override
  String get tableName => _tableName;

  @override
  _AddNewNoteWidgetState createState() => _AddNewNoteWidgetState();
}

class _AddNewNoteWidgetState extends State<AddNewNoteWidget> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new note'),
        actions: [
          IconButton(icon: Icon(Icons.check), onPressed: () async {
            widget.insert(Note.frontBack(await widget.newId, _frontController.text, _backController.text)).then((value) {
              Navigator.pop(context);
            }).catchError((e) {
              alertError(context, e, "Failed to add new note");
            });
          })
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.note),
                  labelText: 'Front',
                ),
                controller: _frontController,
                expands: true,
                maxLines: null,
                minLines: null,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.note),
                  labelText: 'Back',
                ),
                controller: _backController,
                expands: true,
                maxLines: null,
                minLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
