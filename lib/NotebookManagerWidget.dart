import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteflash/NoteManagerWidget.dart';
import 'package:noteflash/SQLiteDBManager.dart';
import 'package:noteflash/SqliteDbManagerWidget.dart';
import 'package:noteflash/utilities.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';

class NotebookManagerState extends SqliteDbManagerWidgetState {
  @override
  Future<Database> get database async => openDatabase(
        join(await getDatabasesPath(), 'notebooks.db'),
      );

  @override
  Widget buildItem(BuildContext context, SqliteTableRecord record) => Card(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(record.data['name']),
              PopupMenuButton<int>(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text("Rename"),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text("Delete"),
                        ),
                      ],
                onSelected: (value) {
                    if (value == 1) {
                      Alert(
                          context: context,
                          title: "Renaming ${record.data['name']}",
                          content: Column(
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.note),
                                  labelText: 'New name',
                                ),
                                controller: _controller,
                              ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              onPressed: () {
                                renameTableTo(record.data['name'], _controller.text).then((value) {
                                  setState((){_controller.text = "";});
                                  Navigator.pop(context);
                                }).catchError((e){
                                  alertError(context, e, 'Failed to reanem ${record.data['name']} to ${_controller.text}');
                                });
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            )
                          ]).show();
                    } else if (value == 2) {
                      Alert(
                        context: context,
                        title: "Are u sure?",
                        desc: "'${record.data['name']}' will be permanently removed.",
                        image: Image.asset("assets/images/akari-questioning.png"),
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Cancel",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          ),
                          DialogButton(
                            child: Text(
                              "OK",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              dropTable(record.data['name']).then((value) {
                                setState((){});
                                Navigator.pop(context);
                              }).catchError((e){
                                alertError(context, e, "Failed to create table ${_controller.text}");
                              });
                            },
                            width: 120,
                            color: Colors.redAccent,
                          )
                        ]
                      ).show();
                    }
                },
              ),
            ],
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SqliteDbManagerWidget(() => NoteManagerState(database, record.data['name']))));
          },
          onLongPress: () {},
        ),
      );

  @override
  Future<List<SqliteTableRecord>> get futureContent => tables;

  @override
  String get appBarTitle => 'notebooks.db';

  final _controller = TextEditingController();

  @override
  List<Widget> appBarActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Alert(
              context: context,
              title: "Create a new notebook",
              content: TextField(
                controller: _controller,
              ),
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    createTable(_controller.text)
                        .then((value){
                      setState((){});
                      Navigator.pop(context);
                    })
                        .catchError((e) {
                      alertError(context, e, "Failed to create table ${_controller.text}");
                    });
                  },
                  width: 120,
                ),
                DialogButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ).show();
          },
        ),
        IconButton(
          icon: Icon(Icons.sync),
          onPressed: () {
            // Todo onPress popup SyncWidget
            Alert(context: context, title: "Sorry", desc: "Coming soon", image: Image.asset("assets/images/sorry.gif"))
                .show();
          },
        )
      ];
}