import 'package:flutter/material.dart';
import 'package:notes/Model.dart';
import 'package:notes/create_note.dart';
import 'package:notes/list_first.dart';
import 'package:notes/update.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swipe/swipe.dart';

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  Database? db;
  List<Map> l = [];
  bool status = false;
  TextEditingController search = TextEditingController();
  List<Map> temp = [];
  bool isSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Model().createDatabase().then((value) {
      db = value;

      String qry = "SELECT * FROM notes ORDER BY id DESC";
      db!.rawQuery(qry).then((value1) {
            l = value1;
        print(l);

        setState(() {
          status = true;
        });
      });
    });

    temp.addAll(l);
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Swipe(
        onSwipeLeft: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return list_first();
          },));
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return new_note();
                },
              ));
            },
            child: Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text(
                        greetingMessage(),
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                    IconButton(onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return SimpleDialog(
                          backgroundColor: Color(0xff363636),
                          children: [
                            ListTile(
                              title: Text("Listview",style: TextStyle(color: Colors.white,fontSize: 20),),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                  return list_first();
                                },));
                              },
                            )
                          ],
                        );
                      },);
                    }, icon: Icon(Icons.menu_rounded,color: Colors.white,),)
                  ],
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(top: 20,left: 10, right: 10,bottom: 20),
                  decoration: ShapeDecoration(
                    color: Color(0xff282828),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: TextField(
                    controller: search,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.orange,
                    autofocus: false,
                    onChanged: (value) {

                      String val = value;
                      temp.clear();

                      for(int i = 0; i < l.length; i++)
                        {
                          String qry = "SELECT * FROM notes where title IN('$search')";
                          db!.rawQuery(qry).then((value2) {
                            temp = value2;
                          });
                        }

                    },
                    decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Color(0xff343434)),
                        prefixIcon: Icon(Icons.search,color: Colors.white,),
                        prefixIconColor: Color(0xff343434),
                        border: InputBorder.none),
                  ),
                ),
                status
                    ? (l.length > 0)
                        ? isSearch ? Expanded(
                            child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                child: GridView.builder(
                                  itemCount: l.length,
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemBuilder: (context, index) {
                                    Map map = temp[index];
                                    String note_title = map['title'];
                                    String note = map['note'];
                                    int id = map['id'];

                                    return InkWell(
                                      onLongPress: () {
                                          showDialog(context: context, builder: (context) {
                                            return SimpleDialog(
                                              backgroundColor: Colors.black,
                                              children: [
                                                ListTile(
                                                  title: Text("Delete",style: TextStyle(color: Colors.white),),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    String qry = "DELETE from notes where id = '$id'";
                                                    db!.rawDelete(qry).then((value) {
                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                                        return first();
                                                      },));
                                                    });
                                                  },
                                                )
                                              ],
                                            );
                                          },);
                                      },
                                      onTap: () {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                          return update_note(map);
                                        },));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: ShapeDecoration(
                                            color: Color(0xff282828),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${note_title}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              "\n${note}",maxLines: 10,
                                              style: TextStyle(
                                                  color: Color(0xff797979),
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ) : Expanded(
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: l.length,
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          Map map = l[index];
                          String note_title = map['title'];
                          String note = map['note'];
                          int id = map['id'];

                          return InkWell(
                            onLongPress: () {
                              showDialog(context: context, builder: (context) {
                                return SimpleDialog(
                                  backgroundColor: Colors.black,
                                  children: [
                                    ListTile(
                                      title: Text("Delete",style: TextStyle(color: Colors.white),),
                                      onTap: () {
                                        Navigator.pop(context);
                                        String qry = "DELETE from notes where id = '$id'";
                                        db!.rawDelete(qry).then((value) {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                            return first();
                                          },));
                                        });
                                      },
                                    )
                                  ],
                                );
                              },);
                            },
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                return update_note(map);
                              },));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                  color: Color(0xff282828),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${note_title}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "\n${note}",maxLines: 10,
                                    style: TextStyle(
                                        color: Color(0xff797979),
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                )
                        : Center(
                            child: Text(
                              "No Notes",
                              style: TextStyle(color: Color(0xff6c6c6c)),
                            ),
                          )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
