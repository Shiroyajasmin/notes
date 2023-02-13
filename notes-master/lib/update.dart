import 'package:flutter/material.dart';
import 'package:notes/Model.dart';
import 'package:notes/first.dart';
import 'package:sqflite/sqflite.dart';

class update_note extends StatefulWidget {

  Map map;

  update_note(this.map);


  @override
  State<update_note> createState() => _update_noteState();
}

class _update_noteState extends State<update_note> {
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  Database? db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    title.text = widget.map['title'];
    note.text = widget.map['note'];

    Model().createDatabase().then((value) {
      db = value;
    });
  }

  Future<bool> goBack() {
    String title_note = title.text;
    String note_text = note.text;
    int id = widget.map['id'];

    if(title_note.isEmpty && note_text.isEmpty)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return first();
        },
      ));
    }
    else
    {

      String qry =
          "UPDATE notes SET title = '$title_note',note = '$note_text' WHERE id = '$id'";
      db!.rawInsert(qry).then((value) {
        print(value);
      });
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return first();
        },
      ));
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        String title_note = title.text;
                        String note_text = note.text;

                        if(title_note.isEmpty && note_text.isEmpty)
                        {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return first();
                            },
                          ));
                        }
                        else
                        {

                          String qry =
                              "INSERT INTO notes (title,note) values ('$title_note','$note_text')";
                          db!.rawInsert(qry).then((value) {
                            print(value);
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return first();
                            },
                          ));
                        }

                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: TextFormField(
                    cursorColor: Colors.orange,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                    controller: title,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0xff343434)),
                      hintText: "Title",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: TextField(
                      cursorColor: Colors.orange,
                      autofocus: true,
                      controller: note,
                      scrollPadding: EdgeInsets.all(20.0),
                      keyboardType: TextInputType.multiline,
                      maxLines: 99999,
                      style: TextStyle(color: Color(0xff797979), fontSize: 20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Start Typing",
                        hintStyle: TextStyle(color: Color(0xff343434)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: goBack);
  }
}
