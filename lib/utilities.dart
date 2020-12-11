import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void alertError(context, e, title) {
  Alert(
    context: context,
    type: AlertType.error,
    title: title,
    desc: e.toString(),
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style:
          TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

void areUSure({context, desc, Function sure, Function cancel, Image image}) {
  Alert(
      context: context,
      title: "Are u sure?",
      desc: desc,
      image: image,
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style:
            TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: cancel,
          width: 120,
        ),
        DialogButton(
          child: Text(
            "OK",
            style:
            TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: sure,
          width: 120,
          color: Colors.redAccent,
        )
      ]
  ).show();
}

// title is the first line in front
String title(String front) {
  int i = front.indexOf('\n');
  if (i == -1) i = front.length;
  final title = front.substring(0, i);
  return title.replaceFirst(RegExp("#+\\s+"), "");
}