import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:tally_task/views/isiNotifikasi.dart';
import 'components/start.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Notifikasi(),
    );
  }
}

class Notifikasi extends StatefulWidget {
  const Notifikasi({super.key});

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  String username = '';
  List<Widget> notifikationChildren = [];

  void initState() {
    super.initState();
    getUsername();
    getValueForNotifikation(1500, 600);
  }

  Future<void> getValueForNotifikation(double width, double height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    final notifikasiCollection = Firestore.instance.collection('notifikasi');
    List<Widget> notifikationData = [];

    final querySnapshot = await notifikasiCollection
        .where('username', isEqualTo: storedUsername)
        .get();

    for (var i = 0; i < querySnapshot.length; i++) {
      String isiNotifikasi = querySnapshot[i].map['isi'];
      notifikationData.add(Column(
        children: [
          SizedBox(
            width: width / 100,
            height: height / 40,
          ),
          Container(
              width: width / 1.35,
              height: height / 6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 0.5,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              child: Row(children: [
                Icon(Icons.notifications_active, size: width / 25),
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jumlah Tugas",
                          style: TextStyle(
                              fontSize: width / 45, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          isiNotifikasi,
                          style: TextStyle(
                            fontSize: width / 60,
                          ),
                        ),
                      ],
                    ),
                  ),
              ])),
        ],
      ));
    }

    setState(() {
      notifikationChildren = notifikationData;
    });
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Start(),
            //search notifikasi
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
            //       hintText: 'Search Notifikasi',
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
                  username,
                  style: TextStyle(fontSize: width / 60),
                )
              ]),
            ),

            //list view notifikasi
            Container(
              width: width / 1.34,
              height: height / 1.35,
              margin: EdgeInsets.only(left: width / 4.6, top: height / 5),
              child: ListView.builder(
                itemCount: notifikationChildren.length,
                itemBuilder: (BuildContext context, int index) {
                  return notifikationChildren[index];
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
