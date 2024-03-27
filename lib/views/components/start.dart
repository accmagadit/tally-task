import 'package:flutter/material.dart';
import 'package:tally_task/views/components/sidebar.dart';

class Start extends StatelessWidget {
  const Start({super.key});
  @override
  Widget build(BuildContext context) {
    SidebarWidget sidebar = new SidebarWidget();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: [
        sidebar,
        Container(
          margin: EdgeInsets.only(left: width/20, top: height/20),
          height: height / 8,
          child: Image.asset('assets/images/logo.png'),
          color: Colors.white,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: width * 0.8,
            height: height * 0.98,
            margin: EdgeInsets.only(
              right: 10,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
          ),
        )
      ],
    ));
  }
}
