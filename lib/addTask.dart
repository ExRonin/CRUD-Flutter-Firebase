import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  AddTask({this.email});
  final String email;
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _dueDate = DateTime.now();
  String _dateText = '';

  String newTask = '';
  String note = '';

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

  void _addData() {
    Firestore.instance.runTransaction((Transaction transsaction) async {
      //Fungsi Sebagai Table input Ke Task
      CollectionReference reference = Firestore.instance.collection("task");
      await reference.add({
        "email": widget.email,
        "title": newTask,
        "duedate": _dueDate,
        "note": note,
        //Input Besar Kecil Berpengaruh
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
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
                  "Input",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      letterSpacing: 2.0,
                      fontFamily: "Pacifico"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Add",
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
              onChanged: (String str) {
                setState(() {
                  newTask = str;
                });
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.dashboard),
                  hintText: "Input task",
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
                    _addData();
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
