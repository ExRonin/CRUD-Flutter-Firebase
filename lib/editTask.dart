import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTask extends StatefulWidget {
  EditTask({this.title, this.note, this.dueDate, this.index});
  final index;
  final String title;
  final DateTime dueDate;
  final String note;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController controllerTitle;
  TextEditingController controllernote;

  DateTime _dueDate;
  String _dateText = '';

  String newTask;
  String note;
//Edit
  void _editTask() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference,
          {"title": newTask, "note": note, "duedate": _dueDate});
    });
    Navigator.pop(context);
  }

  Future<Null> _selectdueDate(BuildContext) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dueDate = widget.dueDate;
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";

    newTask = widget.title;
    note = widget.note;

    controllerTitle = TextEditingController(text: widget.title);
    controllernote = TextEditingController(text: widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("img/header-bg.jpg"), fit: BoxFit.cover),
              color: Colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Edit",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      letterSpacing: 2.0,
                      fontFamily: "Pacifico"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Edit",
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
                Icon(
                  Icons.list,
                  color: Colors.white,
                  size: 30.0,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllerTitle,
              onChanged: (String str) {
                setState(() {
                  newTask = str;
                });
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.dashboard),
                  hintText: "Edit task",
                  border: InputBorder.none),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.date_range),
                ),
                Expanded(
                  child: Text(
                    "Date",
                    style: TextStyle(fontSize: 22.0, color: Colors.black54),
                  ),
                ),
                FlatButton(
                  onPressed: () => _selectdueDate(context),
                  child: Text(
                    _dateText,
                    style: TextStyle(fontSize: 22.0, color: Colors.black54),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllernote,
              onChanged: (String str) {
                setState(() {
                  note = str;
                });
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.note_add),
                  hintText: "Note",
                  border: InputBorder.none),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 40.0,
                  ),
                  onPressed: () {
                    _editTask();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 40.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
