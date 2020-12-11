import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:noteflash/AddNewNoteWidget.dart';
import 'package:noteflash/FlashNotesWidget.dart';
import 'package:noteflash/SQLiteDBManager.dart';
import 'package:noteflash/SqliteDbManagerWidget.dart';
import 'package:noteflash/utilities.dart';
import 'package:noteflash/NoteViewerWidget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';

class NoteManagerState extends SqliteDbManagerWidgetState {
  Future<Database> _database;
  String _tableName;

  NoteManagerState(this._database, this._tableName);

  @override
  Future<Database> get database => _database;

  @override
  String get tableName => _tableName;

  @override
  Widget buildItem(BuildContext context, covariant Note record) => Card(
        child: ListTile(
          title: Text(title(record.data['front'])),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () {
              areUSure(
                context: context,
                desc: 'It will be permanently deleted.',
                sure: () {
                  delete(record).then((value) {
                    setState(() {});
                    Navigator.pop(context);
                  }).catchError((e) {
                    alertError(context, e, title);
                  });
                },
                cancel: () {
                  Navigator.pop(context);
                },
                image: Image.asset('assets/images/areusure-kuro.jpg'),
              );
            },
          ),
          onTap: () {
            Alert(
                context: context,
                title: "Card View",
                content: NoteViewerWidget(record),
                buttons: [
                  DialogButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          },
          onLongPress: () {
            // TODO onLongPress navigate to NoteModifierWidget (which is basically a AddNewNoteWidget with few tweaks)
          },
        ),
      );

  @override
  Future<List<Note>> get futureContent => getAllRecords();

  @override
  String get appBarTitle => tableName;

  final _frontController = TextEditingController();
  final _backController = TextEditingController();

  @override
  List<Widget> appBarActions(BuildContext context) => [
        GestureDetector(
          child: IconButton(
              icon: Icon(Icons.note_add_outlined),
              onPressed: () {
                Alert(
                    context: context,
                    title: "New Note",
                    content: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.note),
                            labelText: 'Front',
                          ),
                          controller: _frontController,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.note),
                            labelText: 'Back',
                          ),
                          controller: _backController,
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () async {
                          final id = await newId;
                          insert(Note.frontBack(id, _frontController.text,
                                  _backController.text))
                              .then((value) {
                            setState(() {});
                            Navigator.pop(context);
                            _frontController.text = "";
                            _backController.text = "";
                          }).catchError((e) {
                            alertError(context, e, "Failed to add new note");
                          });
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]).show();
              }),
          onLongPress: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddNewNoteWidget(database, tableName)))
                .then((_) => setState(() {}));
          },
        ),
        IconButton(
            icon: Icon(Icons.play_arrow_outlined),
            onPressed: () async {
              final notes = await getAllRecords();
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FlashNotesWidget(tableName, notes)))
                  .catchError((e) {
                alertError(context, e, "ERROR!");
              });
            }),
      ];
}
