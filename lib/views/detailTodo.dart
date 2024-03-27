import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tally_task/views/components/start.dart';
import 'package:tally_task/views/home.dart';
import 'components/checkboxTask.dart';
import 'package:firedart/firedart.dart';

const apiKey = 'AIzaSyAzJAwV4PEbtxKMBBg0uOCSqf6G7rPJ4-4';
const projectId = 'talllytask';

class DetailTodo extends StatefulWidget {
  final String title;
  final String deskripsi;
  final String tipe;

  const DetailTodo(
      {required this.title, required this.deskripsi, required this.tipe});

  @override
  State<DetailTodo> createState() => _DetailTodoState();
}

class _DetailTodoState extends State<DetailTodo> {
  bool isVisibelForm = true;
  List<Widget> children = [];
  List<Widget> spChildren = [];
  List<Widget> pChildren = [];
  List<Widget> tpChildren = [];
  List<Widget> stpChildren = [];
  String username = '';
  String dropdownValue = '';

  bool isPopUpDelete = false;

  String getTipe() {
    return widget.tipe;
  }

  void initState() {
    super.initState();
    getUsername();
    dropdownValue = widget.tipe;
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    setState(() {
      username = storedUsername ?? '';
    });
  }

  Future<void> updateTodo(String title, String deskripsi, String tipe) async {
    final todoCollection = Firestore.instance.collection('todo');

    final querySnapshot = await todoCollection
        .where('title', isEqualTo: widget.title)
        .where('deskripsi', isEqualTo: widget.deskripsi)
        .where('username', isEqualTo: username)
        .get();

    print(querySnapshot);

    if (querySnapshot.length > 0) {
      final document = querySnapshot.first;
      final docId = document.id;
      await todoCollection
          .document(docId)
          .update({'title': title, 'deskripsi': deskripsi, 'tipe': tipe});
      print('todo sudah terupdate');
    }
  }

  Future<void> deleteTodo(String title, String deskripsi) async {
    final todoCollection = Firestore.instance.collection('todo');

    final querySnapshot = await todoCollection
        .where('title', isEqualTo: widget.title)
        .where('deskripsi', isEqualTo: widget.deskripsi)
        .where('username', isEqualTo: username)
        .get();

    print(querySnapshot);

    if (querySnapshot.length > 0) {
      final document = querySnapshot.first;
      final docId = document.id;
      await todoCollection.document(docId).delete();
      print('todo sudah terhapus');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Start startPage = Start();
    TextEditingController _nilaiTitleTodo =
        TextEditingController(text: widget.title);
    TextEditingController _nilaiDeskripsiTodo =
        TextEditingController(text: widget.deskripsi);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            startPage,

            //form todo
            Container(
              margin: EdgeInsets.only(left: width / 4.8, top: height / 10),
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
                              updateTodo(_nilaiTitleTodo.text,
                                  _nilaiDeskripsiTodo.text, dropdownValue);

                              await Future.delayed(Duration(seconds: 1));

                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return Home();
                              }));
                            },
                            child: Text("Update"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isPopUpDelete = !isPopUpDelete;
                                });
                              },
                              child: Text("Hapus"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              )),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Home();
                                }));
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
            ),

            //pop up delete
            Center(
              child: Container(
                child: Visibility(
                  visible: isPopUpDelete,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    width: width / 5,
                    height: height / 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height / 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Anda Yakin Menghapus Todo Ini?"),
                          ],
                        ),
                        SizedBox(
                          height: height / 9,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                deleteTodo(_nilaiTitleTodo.text,
                                    _nilaiDeskripsiTodo.text);

                                await Future.delayed(Duration(seconds: 1));

                                await Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Home();
                                }));
                              },
                              child: Text("Hapus"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isPopUpDelete = !isPopUpDelete;
                                  });
                                },
                                child: Text("Cancel"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
