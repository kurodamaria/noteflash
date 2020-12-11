import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteflash/SqliteDbManagerWidget.dart';
import 'package:noteflash/NotebookManagerWidget.dart';

void main() => runApp(
  MaterialApp(
    home: SqliteDbManagerWidget(() => NotebookManagerState()),
  ),
);
