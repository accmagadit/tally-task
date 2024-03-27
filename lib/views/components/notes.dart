import 'package:flutter/material.dart';
import 'package:tally_task/views/detailNotes.dart';

class Notes extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  final double width;
  final double height;

  const Notes(
      {required this.title,
      required this.description,
      required this.date,
      required this.width,
      required this.height});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return DetailNotes(
            title: widget.title,
            deskripsi: widget.description,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.all(widget.width / 100),
        width: widget.width / 6,
        height: widget.width / 6,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black.withOpacity(0.4),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(widget.width / 80)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title.length > 8 ? widget.title.substring(0,8) + '...' : widget.title,
              style: TextStyle(
                  fontSize: widget.width / 50, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.description.length > 14 ? widget.description.substring(0,15) + '...' : widget.description,
              style: TextStyle(fontSize: widget.width / 80),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.date,
                  style: TextStyle(
                      fontSize: widget.width / 80, fontWeight: FontWeight.w700),
                ),
                Icon(Icons.access_time_filled)
              ],
            )
          ],
        ),
      ),
    );
  }
}
