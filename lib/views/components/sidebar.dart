import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tally_task/views/historyPage.dart';
import 'package:tally_task/views/home.dart';
import '../../login.dart';
import '../notifikasi.dart';
import '../socialPage.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  State<SidebarWidget> createState() => _SidebarState();
}

class _SidebarState extends State<SidebarWidget> {
  Future<void> _logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    print('Logged out');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 128, 171, 195),
        body: Container(
          margin: EdgeInsets.only(top: height / 10, left: height / 40),
          child: Column(
            children: [
              SizedBox(
                height: height / 16,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Home();
                  }));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: height / 30,
                    ),
                    Text(" Home",
                        style: TextStyle(
                            color: Colors.white, fontSize: height / 60))
                  ],
                ),
              ),
              SizedBox(
                height: height / 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const NotifikasiPage();
                  }));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: height / 30,
                    ),
                    Text(
                      " Notifikasi",
                      style:
                          TextStyle(color: Colors.white, fontSize: height / 60),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height / 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const SocialPage();
                  }));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.computer,
                      color: Colors.white,
                      size: height / 30,
                    ),
                    Text(
                      " Social",
                      style:
                          TextStyle(color: Colors.white, fontSize: height / 60),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height / 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const HistoryPage();
                  }));
                },
                child: Row(
                  children: [
                    Icon(Icons.history_toggle_off,
                        color: Colors.white, size: height / 30),
                    Text(" History",
                        style: TextStyle(
                            color: Colors.white, fontSize: height / 60))
                  ],
                ),
              ),
              SizedBox(
                height: height / 10,
              ),
              InkWell(
                onTap: () async {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return const NotifikasiPage();
                  // }));

                  await _logOut(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: height / 30),
                    Text(" Log Out",
                        style:
                            TextStyle(color: Colors.red, fontSize: height / 60))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
