import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tally_task/views/home.dart';
import 'main.dart';
import 'package:firedart/firedart.dart';

const apiKey = 'AIzaSyAzJAwV4PEbtxKMBBg0uOCSqf6G7rPJ4-4';
const projectId = 'talllytask';

void main(List<String> args) {
  Firestore.initialize(projectId);
  runApp(DaftarPage());
}

class DaftarPage extends StatelessWidget {
  DaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyFormPage(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  CollectionReference pengguna = Firestore.instance.collection("pengguna");

  Future<void> loginUser() async {
    String username = _controllerEmail.text;
    String password = _controllerPassword.text;

    // cek apakah username sudah ada atau belum
    final usersCollection = Firestore.instance.collection('pengguna');
    final querySnapshot =
        await usersCollection.where('username', isEqualTo: username).get();

    if (querySnapshot.isNotEmpty) {
      if (querySnapshot.first['password'] == password) {
        // Save username to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        //pindah halaman
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        setState(() {
          _errorText = 'Password Salah';
        });
      }
    } else {
      setState(() {
        _errorText = 'username tidak ditemukan';
      });
    }
  }

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Row(
        children: [
          Expanded(
              child: Container(
            child: Image.asset('assets/images/login.png'),
            height: height,
            color: Colors.white,
          )),
          Expanded(
              child: Container(
            color: Color.fromARGB(80, 96, 150, 180),
            height: height,
            child: Container(
              padding: EdgeInsets.only(left: height / 20,right: height/20),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 5,
                  ),
                  const Text(
                    "Masuk",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: height / 15),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white),
                    child: TextFormField(
                      controller: _controllerEmail,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 24.0),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: 'Enter Username',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87.withOpacity(0.3),
                              fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: height / 15),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white),
                    child: TextFormField(
                      controller: _controllerPassword,
                      obscureText: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 24.0),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87.withOpacity(0.3),
                              fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: height / 15),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                _errorText = null;
                              });
                              await loginUser();
                              // final penggunas = await pengguna.get();
                              // print(penggunas.first['password']);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Home()));
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DaftarPage();
                              }));
                            },
                            child: Text(
                              "Daftar",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_errorText != null)
                    Text(
                      _errorText!,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ),
          )),
        ],
      )),
    );
  }
}
