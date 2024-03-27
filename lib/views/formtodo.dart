import 'package:flutter/material.dart';

class FormTodo extends StatefulWidget {
  const FormTodo({super.key});

  @override
  State<FormTodo> createState() => _FormTodoState();
}

class _FormTodoState extends State<FormTodo> {
  bool nampak = true;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: nampak,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        width: width / 1.3,
        height: height / 1.3,
        child: Column(
          children: [
            Container(
              height: height / 9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: TextFormField(
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
            Container(
              height: height / 1.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: TextFormField(
                maxLines: null,
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
                    onPressed: () {
                      setState(() {
                        nampak = !nampak;
                      });
                    },
                    child: Text("Simpan")),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      nampak = !nampak;
                      print("nampak false");
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
    );
  }
}
