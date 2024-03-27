import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:tally_task/views/isiNotifikasi.dart';
import 'components/start.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Social(),
    );
  }
}

class Social extends StatefulWidget {
  const Social({super.key});

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  bool isVisibelForm = false;
  String username = '';
  List<Widget> notifikationChildren = [];
  TextEditingController _titlePost = TextEditingController();
  TextEditingController _descriptionPost = TextEditingController();

  void initState() {
    super.initState();
    getUsername();
    getValueForPost(1500, 600);
  }

  Future<void> sendPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    final postCollection = Firestore.instance.collection('postingan');

    final postData = {
      'title': _titlePost.text,
      'description': _descriptionPost.text,
      'username': storedUsername,
      'tanggal': (DateTime.now().toString()).substring(0, 10)
    };

    final newPost = await postCollection.add(postData);
    _titlePost.clear();
    _descriptionPost.clear();
    print("berhasil kirim data");
  }

  
Future<void> getValueForPost(double width, double height) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedUsername = prefs.getString('username');
  final notifikasiCollection = Firestore.instance.collection('postingan');
  List<Widget> notifikationData = [];

  final querySnapshot = await notifikasiCollection.get();

  for (var i = 0; i < querySnapshot.length; i++) {
    String isiPostingan = querySnapshot[i].map['description'];
    String judulPostingan = querySnapshot[i].map['title'];

    // Menghitung jumlah baris teks pada judulPostingan
    final titleTextSpan = TextSpan(
      text: judulPostingan,
      style: TextStyle(fontSize: width / 45, fontWeight: FontWeight.w700),
    );
    final titleTextPainter = TextPainter(
      text: titleTextSpan,
      textDirection: TextDirection.ltr,
      maxLines: 2, // Jumlah maksimum baris yang ingin ditampilkan
    );
    titleTextPainter.layout(maxWidth: width / 1.8);
    final titleLineCount = titleTextPainter.computeLineMetrics().length;

    // Menghitung jumlah baris teks pada querySnapshot[i].map['username']
    final usernameTextSpan = TextSpan(
      text: querySnapshot[i].map['username'],
      style: TextStyle(fontSize: width / 100, fontWeight: FontWeight.w700),
    );
    final usernameTextPainter = TextPainter(
      text: usernameTextSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1, // Jumlah maksimum baris yang ingin ditampilkan
    );
    usernameTextPainter.layout(maxWidth: width / 1.8);
    final usernameLineCount = usernameTextPainter.computeLineMetrics().length;

    // Menghitung jumlah baris teks pada isiPostingan
    final descriptionTextSpan = TextSpan(
      text: isiPostingan,
      style: TextStyle(fontSize: width / 60),
    );
    final descriptionTextPainter = TextPainter(
      text: descriptionTextSpan,
      textDirection: TextDirection.ltr,
      maxLines: 3, // Jumlah maksimum baris yang ingin ditampilkan
    );
    descriptionTextPainter.layout(maxWidth: width / 1.8);
    final descriptionLineCount =
        descriptionTextPainter.computeLineMetrics().length;

    notifikationData.add(Column(
      children: [
        SizedBox(
          width: width / 100,
          height: height / 40,
        ),
        Container(
          width: width / 1.35,
          height: (height / 6) +
              (titleLineCount * titleTextPainter.preferredLineHeight) +
              (usernameLineCount * usernameTextPainter.preferredLineHeight) +
              (descriptionLineCount *
                  descriptionTextPainter.preferredLineHeight),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 0.5,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.account_circle_sharp, size: width / 25),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            judulPostingan,
                            style: TextStyle(
                                fontSize: width / 45,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            querySnapshot[i].map['username'],
                            style: TextStyle(
                                fontSize: width / 100,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Text(
                        isiPostingan,
                        style: TextStyle(
                          fontSize: width / 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

            //add button
            Container(
              margin: EdgeInsets.only(top: height / 10, left: width / 5),
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
            ),

            //form post
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
                              controller: _titlePost,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  fontSize: width / 30),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Post Title',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87.withOpacity(0.3),
                                      fontSize: height / 20)),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: height / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: TextFormField(
                          maxLines: null,
                          controller: _descriptionPost,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 20),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: 'Enter Post Description',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87.withOpacity(0.3),
                                  fontSize: height / 30)),
                        ),
                      ),
                      SizedBox(
                        height: height / 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isVisibelForm = !isVisibelForm;
                                });
                                await sendPost();
                                await getValueForPost(1500, 600);
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
                      ),
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
