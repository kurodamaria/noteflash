import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteflash/SQLiteDBManager.dart';

class SqliteDbManagerWidget extends StatefulWidget {
  final SqliteDbManagerWidgetState Function() newState;

  SqliteDbManagerWidget(this.newState);

  @override
  SqliteDbManagerWidgetState createState() => newState();
}

abstract class SqliteDbManagerWidgetState extends State<SqliteDbManagerWidget> with SqliteDbManager{

  List<Widget> appBarActions(BuildContext context);

  String get appBarTitle;

  Future<List<SqliteTableRecord>> get futureContent;


  Widget buildItem(BuildContext context, SqliteTableRecord record);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: appBarActions(context),
      ),
      body: FutureBuilder<List<SqliteTableRecord>>(
        future: futureContent,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('${snapshot.error}');
          if (snapshot.hasData) return Scrollbar(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => buildItem(context, snapshot.data[index]),
            ),
          );
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}