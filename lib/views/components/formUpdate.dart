import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firedart/firedart.dart';

const apiKey = 'AIzaSyAzJAwV4PEbtxKMBBg0uOCSqf6G7rPJ4-4';
const projectId = 'talllytask';

class FormUpdate extends StatefulWidget {
  final String title;
  final String description;
  final String tipe;
  final String isVisibel;
  final double width;
  final double height;

  const FormUpdate(
      {required this.title,
      required this.description,
      required this.tipe,
      required this.isVisibel,
      required this.width,
      required this.height});

  @override
  State<FormUpdate> createState() => _FormUpdateState();
}

class _FormUpdateState extends State<FormUpdate> {
  TextEditingController _nilaiTitleTodo = TextEditingController();
  TextEditingController _nilaiDeskripsiTodo = TextEditingController();
  bool isVisibelForm = true;
  String dropDownValue = "Belum tau";

  bool toBoolean(String str, [bool strict = false]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  void main(List<String> args) {
    Firestore.initialize(projectId);
  }
  

  @override
  Widget build(BuildContext context) {
    return
        //form notes
        //form todo
        Center(
      child: Visibility(
        visible: isVisibelForm,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          width: widget.width / 1.3,
          height: widget.height / 1.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: widget.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: widget.width / 1.7,
                    height: widget.height / 9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: TextFormField(
                      controller: _nilaiTitleTodo,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          fontSize: widget.width / 30),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: widget.title,
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black87.withOpacity(0.3),
                              fontSize: widget.height / 20)),
                    ),
                  ),
                  DropdownButton(
                    value: widget.tipe,
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
                              color: Color.fromARGB(255, 128, 171, 195)),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Penting",
                        child: Text(
                          "Penting",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 154, 180, 204)),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Tidak Penting",
                        child: Text(
                          "Tidak Penting",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 210, 206, 223)),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Sangat Tidak Penting",
                        child: Text(
                          "Sangat Tidak Penting",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 241, 215, 216)),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        dropDownValue = value!;
                      });
                    },
                  )
                ],
              ),
              Container(
                height: widget.height / 9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: TextFormField(
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
                          fontSize: widget.height / 30)),
                ),
              ),
              SizedBox(
                height: widget.height / 2.3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isVisibelForm = !isVisibelForm;
                        });
                        //await updateTodo();
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
    );
  }
}
