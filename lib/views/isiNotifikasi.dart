import 'package:flutter/material.dart';
import 'components/start.dart';

class IsiNotifikasiPage extends StatefulWidget {
  const IsiNotifikasiPage({super.key});

  @override
  State<IsiNotifikasiPage> createState() => _IsiNotifikasiPageState();
}

class _IsiNotifikasiPageState extends State<IsiNotifikasiPage> {
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
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(children: [
          Start(),

          //search notifikasi
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
                hintText: 'Search Notifikasi',
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black87.withOpacity(0.3),
                    fontSize: width / 60),
              ),
            ),
          ),

          //Gambar User
          Container(
            margin: EdgeInsets.only(left: width / 1.11, top: height / 11),
            child: Row(children: [
              Icon(Icons.rocket),
              Text(
                "User",
                style: TextStyle(fontSize: width / 60),
              )
            ]),
          ),

          //list isi notifikasi
          Container(
            width: width / 1.34,
            height: height / 1.6,
            margin: EdgeInsets.only(left: width / 4.6, top: height / 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 0.5,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),

          //teks judul
          Container(
            margin: EdgeInsets.only(left: width / 4, top: height / 4),
            child: Text(
              "Judul Notifikasi",
              style:
                  TextStyle(fontSize: width / 40, fontWeight: FontWeight.w600),
            ),
          ),

          //teks isi notifikasi
          Container(
            margin: EdgeInsets.only(left: width / 4, top: height / 3),
            child: Text(
              "Isi Notifikasi",
              style: TextStyle(
                fontSize: width / 50,
              ),
            ),
          ),

          //tombol back dan delete
          Container(
            margin: EdgeInsets.only(left: width/3,top: height / 1.14),
            child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Back",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: width / 50, vertical: height / 40),
                  backgroundColor: Colors.white,
                )),
          ),

          Container(
            margin: EdgeInsets.only(left: width/1.5,top: height/1.14),
            child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: width / 50, vertical: height / 40),
                  backgroundColor: Colors.white,
                )),
          ),
        ]),
      ),
    );
  }
}
