import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tally_task/views/components/start.dart';
import 'components/checkboxTask.dart';
import 'package:firedart/firedart.dart';

const apiKey = 'AIzaSyAzJAwV4PEbtxKMBBg0uOCSqf6G7rPJ4-4';
const projectId = 'talllytask';

class Todo extends StatefulWidget {
  final String tanggal;

  const Todo({required this.tanggal});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  bool isVisibelForm = false;
  List<Widget> children = [];
  List<Widget> spChildren = [];
  List<Widget> pChildren = [];
  List<Widget> tpChildren = [];
  List<Widget> stpChildren = [];
  String username = '';
  bool isVisibelButton = true;

  String dropdownValue = 'Sangat Penting';
  TextEditingController _nilaiTitleTodo = TextEditingController();
  TextEditingController _nilaiDeskripsiTodo = TextEditingController();

  void initState() {
    super.initState();
    getUsername();
    getTodo(800, 600);
    setButton();
  }

  Future<void> setButton() async {
    String tanggal = widget.tanggal;
    DateTime tanggalNow = DateTime.now().subtract(Duration(days: 1));
    setState(() {
      if (DateTime.parse(tanggal).isBefore(tanggalNow)) {
        isVisibelButton = false;
      }
    });
  }

  Future<void> sendTodo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String tanggal = widget.tanggal;

    final todoCollection = Firestore.instance.collection('todo');

    final todoData = {
      'title': _nilaiTitleTodo.text,
      'deskripsi': _nilaiDeskripsiTodo.text,
      'tipe': dropdownValue,
      'username': storedUsername,
      'tanggal': tanggal,
      'value': "false"
    };

    final newTodo = await todoCollection.add(todoData);
    _nilaiTitleTodo.clear();
    _nilaiDeskripsiTodo.clear();
  }

  Future<void> getTodo(double height, double width) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String tanggal = widget.tanggal;

    final todoCollection = Firestore.instance.collection('todo');

    final querySnapshot =
        await todoCollection.where('username', isEqualTo: storedUsername).get();

    List<Widget> newTodoSp = [];
    List<Widget> newTodop = [];
    List<Widget> newTodotp = [];
    List<Widget> newTodoStp = [];
    List<Widget> newTodoBt = [];

    for (var i = 0; i < querySnapshot.length; i++) {
      String title = querySnapshot[i].map['title'];
      String deskripsi = querySnapshot[i].map['deskripsi'];
      String tanggalTodo = querySnapshot[i].map['tanggal'];
      String value = querySnapshot[i].map['value'];
      String tipe = querySnapshot[i].map['tipe'];

      if (tanggal == tanggalTodo) {
        if (tipe == "Sangat Penting") {
          newTodoSp.add(CheckBoxTask(
            title: title,
            description: deskripsi,
            width: width,
            height: height,
            color: [255, 128, 171, 195],
            value: value,
            tipe: tipe,
          ));
        } else if (tipe == "Penting") {
          newTodop.add(CheckBoxTask(
            title: title,
            description: deskripsi,
            width: width,
            height: height,
            color: [255, 154, 180, 204],
            value: value,
            tipe: tipe,
          ));
        } else if (tipe == "Tidak Penting") {
          newTodotp.add(CheckBoxTask(
            title: title,
            description: deskripsi,
            width: width,
            height: height,
            color: [255, 210, 206, 223],
            value: value,
            tipe: tipe,
          ));
        } else if (tipe == "Sangat Tidak Penting") {
          newTodoStp.add(CheckBoxTask(
            title: title,
            description: deskripsi,
            width: width,
            height: height,
            color: [255, 241, 215, 216],
            value: value,
            tipe: tipe,
          ));
        } else if (tipe == "Belum Tau") {
          newTodoBt.add(CheckBoxTask(
            title: title,
            description: deskripsi,
            width: width,
            height: height,
            color: [255, 21, 23, 42],
            value: value,
            tipe: tipe,
          ));
        }

        setState(() {
          spChildren = newTodoSp;
          pChildren = newTodop;
          tpChildren = newTodotp;
          stpChildren = newTodoStp;
          children = newTodoBt;
        });
      }

      // spChildren.clear();
      // pChildren.clear();
      // tpChildren.clear();
      // stpChildren.clear();
      // children.clear();
    }
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    setState(() {
      username = storedUsername ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Start startPage = Start();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            startPage,
            //search fill
            // Container(
            //   height: height / 15,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(width / 10),
            //   ),
            //   width: width / 4,
            //   margin: EdgeInsets.only(left: width / 4.6, top: height / 15),
            //   child: TextFormField(
            //     style: TextStyle(fontSize: width / 60),
            //     decoration: InputDecoration(
            //       prefixIcon: Icon(Icons.search, size: width / 35),
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(width / 10),
            //           borderSide: BorderSide(color: Colors.black)),
            //       contentPadding: EdgeInsets.all(width / 90),
            //       hintText: 'Search Task',
            //       hintStyle: TextStyle(
            //           fontWeight: FontWeight.w400,
            //           color: Colors.black87.withOpacity(0.3),
            //           fontSize: width / 60),
            //     ),
            //   ),
            // ),

            //Gambar User
            Container(
              margin: EdgeInsets.only(left: width / 1.11, top: height / 11),
              child: Row(children: [
                Icon(Icons.rocket),
                Text(
                  username.isNotEmpty ? username : "User",
                  style: TextStyle(fontSize: width / 60),
                )
              ]),
            ),

            //sangat penting
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: height / 15),
                  margin: EdgeInsets.only(left: width / 4.7, top: height / 5),
                  width: width / 4,
                  height: height / 3,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.3), width: 0.5),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListView.builder(
                    itemCount: spChildren.length,
                    itemBuilder: (BuildContext context, int index) {
                      return spChildren[index];
                    },
                  ),
                ),
              ],
            ),

            //penting
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: height / 15),
                  margin: EdgeInsets.only(left: width / 2, top: height / 5),
                  width: width / 4,
                  height: height / 3,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.3), width: 0.5),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListView.builder(
                    itemCount: pChildren.length,
                    itemBuilder: (BuildContext context, int index) {
                      return pChildren[index];
                    },
                  ),
                ),
              ],
            ),

            //tidak penting
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: height / 15),
                  margin: EdgeInsets.only(left: width / 4.7, top: height / 1.7),
                  width: width / 4,
                  height: height / 3,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.3), width: 0.5),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListView.builder(
                    itemCount: tpChildren.length,
                    itemBuilder: (BuildContext context, int index) {
                      return tpChildren[index];
                    },
                  ),
                )
              ],
            ),

            //sangat tidak penting
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: height / 15),
                  margin: EdgeInsets.only(left: width / 2, top: height / 1.7),
                  width: width / 4,
                  height: height / 3,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.3), width: 0.5),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListView.builder(
                    itemCount: stpChildren.length,
                    itemBuilder: (BuildContext context, int index) {
                      return stpChildren[index];
                    },
                  ),
                )
              ],
            ),

            //to do list
            Container(
              margin: EdgeInsets.only(left: width / 1.3, top: height / 5),
              width: width / 4.9,
              height: height / 1.39,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black.withOpacity(0.3), width: 0.5),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      height: height / 1.9,
                      width: width / 6,
                      child: ListView.builder(
                        itemCount: children.length,
                        itemBuilder: (BuildContext context, int index) {
                          return children[index];
                        },
                      )),
                  //add button
                  Visibility(
                    visible: isVisibelButton,
                    child: Container(
                      margin:
                          EdgeInsets.only(bottom: height / 40, top: height / 40),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isVisibelForm = !isVisibelForm;
                            print("visible $isVisibelForm");
                          });
                        },
                        child: Icon(
                          Icons.add_circle_rounded,
                          color: Color.fromARGB(255, 158, 158, 158),
                          size: height / 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //label label judul
            Container(
              margin: EdgeInsets.only(left: width / 1.3, top: height / 5.5),
              padding: EdgeInsets.all(8),
              width: width / 4.9,
              height: height / 12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width / 70),
                  color: Color.fromARGB(255, 128, 171, 195)),
              child: Center(
                child: Text(
                  "To Do List",
                  style: TextStyle(
                    fontSize: width / 60,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            //sangat penting
            Container(
              margin: EdgeInsets.only(left: width / 4.7, top: height / 5.5),
              padding: EdgeInsets.all(8),
              width: width / 4,
              height: height / 12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width / 70),
                  color: Color.fromARGB(255, 128, 171, 195)),
              child: Center(
                  child: Text(
                "Sangat Penting",
                style: TextStyle(
                  fontSize: width / 60,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              )),
            ),

            //label penting
            Container(
              margin: EdgeInsets.only(left: width / 2, top: height / 5.5),
              padding: EdgeInsets.all(8),
              width: width / 4,
              height: height / 12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width / 70),
                  color: Color.fromARGB(255, 154, 180, 204)),
              child: Center(
                child: Text(
                  "Penting",
                  style: TextStyle(
                    fontSize: width / 60,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            //label tidak penting
            Container(
              margin: EdgeInsets.only(left: width / 4.7, top: height / 1.75),
              padding: EdgeInsets.all(8),
              width: width / 4,
              height: height / 12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width / 70),
                  color: Color.fromARGB(255, 210, 206, 223)),
              child: Center(
                child: Text(
                  "Tidak Penting",
                  style: TextStyle(
                    fontSize: width / 60,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            //label sangat tidak penting
            Container(
              margin: EdgeInsets.only(left: width / 2, top: height / 1.75),
              padding: EdgeInsets.all(8),
              width: width / 4,
              height: height / 12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width / 70),
                  color: Color.fromARGB(255, 241, 215, 216)),
              child: Center(
                child: Text(
                  "Sangat Tidak Penting",
                  style: TextStyle(
                    fontSize: width / 60,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            //form todo
            Center(
              child: Visibility(
                visible: isVisibelForm,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  width: width / 1.3,
                  height: height / 1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: width / 1.7,
                            height: height / 9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: TextFormField(
                              controller: _nilaiTitleTodo,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  fontSize: width / 30),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 20),
                                  hintText: 'Enter Todo Title',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87.withOpacity(0.3),
                                      fontSize: height / 20)),
                            ),
                          ),
                          DropdownButton(
                            value: dropdownValue,
                            items: const [
                              DropdownMenuItem(
                                child: Text("Belum Tau"),
                                value: "Belum Tau",
                              ),
                              DropdownMenuItem(
                                value: "Sangat Penting",
                                child: Text(
                                  "Sangat Penting",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color:
                                          Color.fromARGB(255, 128, 171, 195)),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Penting",
                                child: Text(
                                  "Penting",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color:
                                          Color.fromARGB(255, 154, 180, 204)),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Tidak Penting",
                                child: Text(
                                  "Tidak Penting",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color:
                                          Color.fromARGB(255, 210, 206, 223)),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "Sangat Tidak Penting",
                                child: Text(
                                  "Sangat Tidak Penting",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color:
                                          Color.fromARGB(255, 241, 215, 216)),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                          )
                        ],
                      ),
                      Container(
                        height: height / 1.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: TextFormField(
                          maxLines: null,
                          controller: _nilaiDeskripsiTodo,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 20),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: 'Enter Todo Description',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87.withOpacity(0.3),
                                  fontSize: height / 30)),
                        ),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isVisibelForm = !isVisibelForm;
                                });
                                await sendTodo();
                                await getTodo(800, 600);
                              },
                              child: Text("Simpan")),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isVisibelForm = !isVisibelForm;
                                print("isVisibelForm false");
                              });
                            },
                            child: Text("Cancel"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
