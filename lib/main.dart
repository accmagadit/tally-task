import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tally_task/login.dart';
import 'package:firedart/firedart.dart';
import 'package:tally_task/views/home.dart';

const apiKey = 'AIzaSyAzJAwV4PEbtxKMBBg0uOCSqf6G7rPJ4-4';
const projectId = 'talllytask';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');

  if (username != null) {
    runApp(HomePage());
  } else {
    runApp(DaftarPage());
  }

  Firestore.initialize(projectId);
}

class DaftarPage extends StatefulWidget {
  DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyFormPage(),
    );
  }
}

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  CollectionReference pengguna = Firestore.instance.collection("pengguna");

  Future<void> registerUser() async {
  String email = _controllerEmail.text;
  String password = _controllerPassword.text;
  String confirmPassword = _controllerConfirmPassword.text;

  // kondisi password dan confirm password tidak sama
  if (password != confirmPassword) {
    setState(() {
      _errorText = 'Password and confirm password tidak sama';
    });
    return;
  }

  // cek apakah username sudah ada atau belum
  final usersCollection = Firestore.instance.collection('pengguna');
  final querySnapshot =
      await usersCollection.where('username', isEqualTo: email).get();

  if (querySnapshot.isNotEmpty) {
    setState(() {
      _errorText = 'Username sudah ada';
    });
    return;
  }

  // Add user data to Firestore
  final userData = {'username': email, 'password': password};
  final newUserDocument = await usersCollection.add(userData);

  print('User registered successfully with ID: ${newUserDocument.id}');
  setState(() {
    _errorText = 'Pendaftaran Berhasil';
  });

  // Tunggu 0,5 detik
  await Future.delayed(Duration(milliseconds: 500));

  // Pindah halaman di sini
  // Contoh: menggunakan Navigator untuk pindah ke halaman lain
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyApp()),
  );
}


  String? _errorText;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Color.fromARGB(80, 96, 150, 180),
              height: height,
              child: Container(
                padding: EdgeInsets.only(left: height / 20, right: height / 20),
                child: Column(
                  children: [
                    SizedBox(height: height / 5),
                    const Text(
                      "Daftar",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: height / 30),
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
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: height / 20),
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
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: height / 20),
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white),
                      child: TextFormField(
                        controller: _controllerConfirmPassword,
                        obscureText: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 24.0),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: 'Enter Confirm Password',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87.withOpacity(0.3),
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: height / 20),
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
                                await registerUser();
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
                                  'Daftar',
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
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MyApp();
                                }));
                              },
                              child: Text(
                                "Masuk",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_errorText != null)
                      Text(
                        _errorText!,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Image.asset('assets/images/login.png'),
              height: 2500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
