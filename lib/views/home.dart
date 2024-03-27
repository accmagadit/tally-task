import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tally_task/views/components/start.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:tally_task/views/todo.dart';
import 'components/checkboxTask.dart';
import 'components/notes.dart';
import 'dart:core';
import 'package:firedart/firedart.dart';

const apiKey = 'AIzaSyAzJAwV4PEbtxKMBBg0uOCSqf6G7rPJ4-4';
const projectId = 'talllytask';

void main(List<String> args) {
  Firestore.initialize(projectId);
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVisibelForm = false;
  List<Widget> notesChildren = [];
  List<Widget> todoChildren = [];
  List<Widget> searchResults = [];
  TextEditingController _titleNotes = TextEditingController();
  TextEditingController _descriptionNotes = TextEditingController();
  TextEditingController _dateNotes = TextEditingController();
  String username = '';
  int count = 0;

  @override
  void initState() {
    super.initState();
    getUsername();
    getNotesByUsername(5000, 1280);
    getTodo(800, 600);
    sendNotifikasi();
    sendHistory();
  }

  Future<void> sendNotifikasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    final todoCollection = Firestore.instance.collection('todo');
    final querySnapshot = await todoCollection
        .where('username', isEqualTo: storedUsername)
        .where('tanggal',
            isEqualTo: (DateTime.now().toString()).substring(0, 10))
        .get();

    final notifikasiData = {
      'judul': "Jumlah Tugas",
      'isi': "Hari ini kamu mempunyai tugas sebanyak " +
          querySnapshot.length.toString(),
      'tanggal': (DateTime.now().toString()).substring(0, 10),
      'username': storedUsername
    };

    final notifikasiCollection = Firestore.instance.collection('notifikasi');
    final queryNotifikasi = await notifikasiCollection
        .where('tanggal', isEqualTo: notifikasiData['tanggal'])
        .where('username', isEqualTo: storedUsername)
        .get();
    if (queryNotifikasi.toString() == "[]") {
      final newNotifikasi = await notifikasiCollection.add(notifikasiData);
      print("berhasil kirim data");
    } else {
      print(queryNotifikasi);
      print("kok gagal di user 3?");
    }
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    setState(() {
      username = storedUsername ?? '';
    });
  }

  Future<void> getTodo(double height, double width) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    final todoCollection = Firestore.instance.collection('todo');
    List<Widget> newTodo = [];
    List<int> color = [];

    final querySnapshot =
        await todoCollection.where('username', isEqualTo: storedUsername).get();

    for (var i = 0; i < querySnapshot.length; i++) {
      String title = querySnapshot[i].map['title'];
      String deskripsi = querySnapshot[i].map['deskripsi'];
      String tanggalTodo = querySnapshot[i].map['tanggal'];
      String value = querySnapshot[i].map['value'];
      String tipe = querySnapshot[i].map['tipe'];
      String tanggal = (DateTime.now().toString()).substring(0, 10);

      if (tipe == "Sangat Penting") {
        color = [255, 128, 171, 195];
      } else if (tipe == "Penting") {
        color = [255, 154, 180, 204];
      } else if (tipe == "Tidak Penting") {
        color = [255, 210, 206, 223];
      } else if (tipe == "Sangat Tidak Penting") {
        color = [255, 241, 215, 216];
      } else {
        color = [255, 21, 23, 42];
      }

      if (tanggal == tanggalTodo) {
        setState(() {
          newTodo.add(CheckBoxTask(
            title: title,
            description: deskripsi,
            width: width,
            height: height,
            color: color,
            value: value,
            tipe: tipe,
          ));
        });
      }

      setState(() {
        todoChildren = newTodo;
      });
    }
  }

  Future<void> sendNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    final notesCollection = Firestore.instance.collection('notes');

    final notesData = {
      'title': _titleNotes.text,
      'description': _descriptionNotes.text,
      'username': storedUsername,
      'tanggal': (DateTime.now().toString()).substring(0, 10)
    };

    final newNotes = await notesCollection.add(notesData);
    _titleNotes.clear();
    _descriptionNotes.clear();
    print("berhasil kirim data");
  }

  Future<void> getNotesByUsername(double height, double width) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    final notesCollection = Firestore.instance.collection('notes');
    final querySnapshot = await notesCollection
        .where('username', isEqualTo: storedUsername)
        .get();
    List<Widget> newNotesChildren = [];

    print(querySnapshot.length);
    for (var i = 0; i < querySnapshot.length; i++) {
      String title = querySnapshot[i].map['title'];
      String description = querySnapshot[i].map['description'];
      String tanggal = querySnapshot[i].map['tanggal'];

      newNotesChildren.add(Notes(
          title: title,
          description: description,
          date: tanggal,
          width: width,
          height: height));

      setState(() {
        notesChildren = newNotesChildren;
      });
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = todoChildren;
      });
    } else {
      List<Widget> result = [];
      for (var i = 0; i < todoChildren.length; i++) {
        CheckBoxTask task = todoChildren[i] as CheckBoxTask;
        if (task.title.toLowerCase().contains(query.toLowerCase())) {
          result.add(task);
        }
      }
      setState(() {
        searchResults = result;
      });
    }
  }

  Future<int> getTotalProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    final todoCollection = Firestore.instance.collection('todo');

    final querySnapshot =
        await todoCollection.where('username', isEqualTo: storedUsername).get();

    final int jumlahTodo = querySnapshot.length;

    return jumlahTodo;
  }

  Future<int> getCompletedProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    final todoCollection = Firestore.instance.collection('todo');

    final querySnapshot = await todoCollection
        .where('username', isEqualTo: storedUsername)
        .where('value', isEqualTo: "true")
        .get();

    final int jumlahTodo = querySnapshot.length;

    return jumlahTodo;
  }

  Future<int> getProgressProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    final todoCollection = Firestore.instance.collection('todo');

    final querySnapshot = await todoCollection
        .where('username', isEqualTo: storedUsername)
        .where('value', isEqualTo: "false")
        .where('tanggal',
            isEqualTo: (DateTime.now().toString()).substring(0, 10))
        .get();

    final int jumlahTodo = querySnapshot.length;

    return jumlahTodo;
  }

  Future<int> getOutScheduleProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    final todoCollection = Firestore.instance.collection('todo');

    final querySnapshot = await todoCollection
        .where('username', isEqualTo: storedUsername)
        .where('value', isEqualTo: "false")
        .where('tanggal',
            isEqualTo: (DateTime.now().toString()).substring(0, 10))
        .get();

    final int jumlahTodo = querySnapshot.length;

    return jumlahTodo;
  }

  Future<List<MapEntry<String, int>>> getLeaderboard() async {
    final todoCollection = Firestore.instance.collection('todo');
    final querySnapshot =
        await todoCollection.where('value', isEqualTo: "true").get();

    // Ambil data
    Map<String, int> usernameCountMap = {};
    for (var document in querySnapshot) {
      String username = document['username'];
      String tanggalTodo = document['tanggal'];
      if (tanggalTodo.substring(0, 7) ==
          (DateTime.now()).toString().substring(0, 7)) {
        if (usernameCountMap.containsKey(username)) {
          usernameCountMap[username] = usernameCountMap[username]! + 1;
        } else {
          usernameCountMap[username] = 1;
        }
      }
    }

    // Mengurutkan
    List<MapEntry<String, int>> sortedUsername = usernameCountMap.entries
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Mengambil 10 teratas
    List<MapEntry<String, int>> topUsername = sortedUsername.take(10).toList();

    return topUsername;
  }

  Future<void> sendHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    final historyCollection = Firestore.instance.collection('history');

    DateTime getLastDayOfMonth(int month) {
      return DateTime(DateTime.now().year, month + 1, 0);
    }

    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    int currentDay = now.day;
    DateTime lastDay = getLastDayOfMonth(currentMonth);

    //ambil peringkat
    List<MapEntry<String, int>> leaderboard = await getLeaderboard();
    int userRank = 0;
    for (int i = 0; i < leaderboard.length; i++) {
      if (leaderboard[i].key == username) {
        userRank = i + 1;
        break;
      }
    }
    final historyData = {
      'pesan':
          "Pada bulan ${currentMonth} , tahun ${currentYear} kamu mendapat peringkat ${userRank}, tingkatkan!",
      'username': username,
      'tanggal': DateTime.now().toString().substring(0, 10)
    };

    final queryHistory = await historyCollection
        .where('pesan',
            isEqualTo:
                "Pada bulan ${currentMonth} , tahun ${currentYear} kamu mendapat peringkat ${userRank}, tingkatkan!")
        .where('username', isEqualTo: username)
        .get();
    print(queryHistory);
    if (queryHistory.toString() == "[]") {
      if (currentDay != lastDay) {
        print("berhasil ngirim pas akhir bulan");
        final newHistory = await historyCollection.add(historyData);
      }
    } else {
      // print("diluar akhir bulan");
      // final newHistory = await historyCollection.add(historyData);
    }
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
            Container(
              height: height / 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(width / 10),
              ),
              width: width / 4,
              margin: EdgeInsets.only(left: width / 4.6, top: height / 15),
              child: TextFormField(
                style: TextStyle(fontSize: width / 60),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: width / 35),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width / 10),
                      borderSide: BorderSide(color: Colors.black)),
                  contentPadding: EdgeInsets.all(width / 90),
                  hintText: 'Search Task',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black87.withOpacity(0.3),
                      fontSize: width / 60),
                ),
                onChanged: (value) {
                  _performSearch(value);
                },
              ),
            ),

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

            //todo dan calender
            Container(
              margin: EdgeInsets.only(left: width / 4.7, top: height / 5),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            right: width / 5.5, bottom: width / 70),
                        child: Text(
                          "To do",
                          style: TextStyle(
                              fontSize: width / 40,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                          width: width / 4,
                          height: height / 3,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.3),
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            margin: EdgeInsets.all(width / 90),
                            child: ListView.builder(
                              itemCount: searchResults.isNotEmpty
                                  ? searchResults.length
                                  : todoChildren.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (searchResults.isNotEmpty) {
                                  return searchResults[index];
                                } else {
                                  return todoChildren[index];
                                }
                              },
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    width: width / 700,
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            right: width / 5.5, bottom: width / 70),
                        child: Text(
                          "Calender",
                          style: TextStyle(
                              fontSize: width / 44,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                          width: width / 4,
                          height: height / 3,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.3),
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: CalendarCarousel(
                            headerMargin: EdgeInsets.all(height / 500),
                            onDayPressed: (DateTime date, List<Event> events) {
                              print('selected day : $date');
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return Todo(
                                    tanggal: date.toString().substring(0, 10));
                              }));
                            },
                          ))
                    ],
                  )
                ],
              ),
            ),

            //notes
            Container(
              margin: EdgeInsets.only(left: width / 4.7, top: height / 1.55),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: width / 1.4),
                    child: Text(
                      "Notes",
                      style: TextStyle(
                          fontSize: width / 44, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: height / 90,
                  ),
                  Row(
                    children: [
                      Container(
                        width: width / 2.2,
                        height: width / 9,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: notesChildren.length,
                          itemBuilder: (BuildContext context, int index) {
                            return notesChildren[index];
                          },
                        ),
                      ),

                      //add button
                      Container(
                          margin: EdgeInsets.only(left: width / 60),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                print("object");
                                isVisibelForm = !isVisibelForm;
                              });
                              getNotesByUsername(height, width);
                            },
                            child: Icon(
                              Icons.control_point_duplicate_sharp,
                              size: width / 30,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),

            //User Information
            Container(
              width: width / 4.4,
              height: height / 3,
              margin: EdgeInsets.only(left: width / 1.34, top: height / 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.3)),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                children: [
                  //hello user
                  Container(
                    margin: EdgeInsets.only(
                        top: width / 150,
                        right: width / 150,
                        left: width / 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Hello,",
                              style: TextStyle(
                                  fontSize: width / 50,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              username,
                              style: TextStyle(
                                  fontSize: width / 50,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                        Container(
                          width: width / 20,
                          height: width / 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.amber),
                        )
                      ],
                    ),
                  ),

                  //ringkasan tugas
                  Container(
                    margin: EdgeInsets.only(top: width / 80, left: width / 150),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Projek",
                                    style: TextStyle(
                                        fontSize: width / 90,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Container(
                                    child: FutureBuilder(
                                      future: getTotalProject(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text('Error');
                                        }
                                        return Row(
                                          children: [
                                            Container(
                                              height: height / 20,
                                              width: width / 400,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: width / 150,
                                            ),
                                            Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                  fontSize: width / 60,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width / 20,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Completed",
                                    style: TextStyle(
                                        fontSize: width / 90,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Container(
                                    child: FutureBuilder(
                                      future: getCompletedProject(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text('Error');
                                        }
                                        return Row(
                                          children: [
                                            Container(
                                              height: height / 20,
                                              width: width / 400,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: width / 150,
                                            ),
                                            Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                  fontSize: width / 60,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height / 80,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "In Progress",
                                    style: TextStyle(
                                        fontSize: width / 90,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Container(
                                    child: FutureBuilder(
                                      future: getProgressProject(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text('Error');
                                        }
                                        return Row(
                                          children: [
                                            Container(
                                              height: height / 20,
                                              width: width / 400,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: width / 150,
                                            ),
                                            Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                  fontSize: width / 60,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width / 20,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Out Of Schedule",
                                    style: TextStyle(
                                        fontSize: width / 90,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Container(
                                    child: FutureBuilder(
                                      future: getOutScheduleProject(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text('Error');
                                        }
                                        return Row(
                                          children: [
                                            Container(
                                              height: height / 20,
                                              width: width / 400,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: width / 150,
                                            ),
                                            Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                  fontSize: width / 60,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //leader board
            Container(
              width: width / 4.4,
              height: height / 2.4,
              margin: EdgeInsets.only(left: width / 1.34, top: height / 1.8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.3)),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 50,
                  ),
                  Text(
                    "Leaderboard",
                    style: TextStyle(
                        fontSize: width / 60, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Container(
                      width: width / 2.2,
                      height: width / 6,
                      child: FutureBuilder(
                        future: getLeaderboard(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<MapEntry<String, int>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                String username = snapshot.data![index].key;
                                int count = snapshot.data![index].value;

                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  margin: EdgeInsets.only(top: height / 350),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            color: Colors.amber),
                                        height: width / 40,
                                        width: width / 40,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: height / 120,
                                            top: height / 120,
                                            bottom: height / 120),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              username,
                                              style: TextStyle(
                                                  fontSize: width / 70,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(count.toString() + " Point")
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                      //Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       decoration: BoxDecoration(
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(100)),
                      //           color: Colors.amber),
                      //       height: width / 40,
                      //       width: width / 40,
                      //     ),
                      //     Container(
                      //       margin: EdgeInsets.only(
                      //           left: height / 120,
                      //           top: height / 120,
                      //           bottom: height / 120),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             "User",
                      //             style: TextStyle(
                      //                 fontSize: width / 70,
                      //                 fontWeight: FontWeight.w600),
                      //           ),
                      //           Text("90 Point")
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),
                      )
                ],
              ),
            ),

            //form notes
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
                      Container(
                        width: width / 1.7,
                        height: height / 9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: TextFormField(
                          controller: _titleNotes,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: width / 30),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: 'Enter Notes Title',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black87.withOpacity(0.3),
                                  fontSize: height / 20)),
                        ),
                      ),
                      Container(
                        height: height / 1.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: _descriptionNotes,
                          maxLines: null,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 20),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: 'Enter Notes Description',
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
                                  // isVisibelForm = !isVisibelForm;
                                  // print("visible $isVisibelForm");
                                  // notesChildren.add(
                                  //   Row(
                                  //     children: [
                                  //       SizedBox(
                                  //         width: width / 80,
                                  //       ),
                                  //       Notes(
                                  //         date: (DateTime.now().toString())
                                  //             .substring(0, 10),
                                  //         description: _descriptionNotes.text,
                                  //         height: width,
                                  //         width: width,
                                  //         title: _titleNotes.text,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                  isVisibelForm = !isVisibelForm;
                                });
                                await sendNotes();
                                await getNotesByUsername(height, width);
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
            ),
          ],
        ),
      ),
    );
  }
}
