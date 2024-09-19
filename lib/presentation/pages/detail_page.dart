import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/presentation/pages/edit_page.dart';
import 'package:notes_app/presentation/theme/app_asset.dart';

import '../../data/database/database_helper.dart';
import '../../data/model/notes_model.dart';
class DetailsPage extends StatefulWidget {
  final Note note;

  DetailsPage({required this.note});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {





  @override
  Widget build(BuildContext context) {


  Map<int, Color> idToColorMap = {
    1: Colors.red,
    2: Colors.green,
    3: Colors.blue,
    4: Colors.yellow,
    5: Colors.orange,
  };
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: idToColorMap[widget.note.color],
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: idToColorMap[widget.note.color],
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 28.0, top: 18),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(Assets.back, height: 50, width: 50)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (contex)=>EditPage(note: widget.note)));
              },
              child: Row(
                children: [
                  SvgPicture.asset(Assets.editIcon, height: 14, width: 14),
                  SizedBox(width: 4),
                  Text(
                    "Edit",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
                  ),
                  SizedBox(width: 28),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: idToColorMap[widget.note.color],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.note.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Manchester United vs Arsenal (Premier League)",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "17:00 - 18:30",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      widget.note.location,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reminder",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 8),
                Text("15 minutes before", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF7C7B7B))),
                SizedBox(height: 20),
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.note.title,
                  style: TextStyle(color: Color(0xFF999999), fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFEE8E9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(
                  Icons.delete,
                  color: Color(0xFFEE2B00),
                ),
                label: Text(
                  "Delete Event",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF292929),
                  ),
                ),
                onPressed: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Delete Confirmation"),
                        content: Text("Are you sure you want to delete this event?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text("Delete"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldDelete == true) {
                    await DatabaseHelper.instance.deleteNote(widget.note.id ?? 0);
                    print('Note deleted successfully');
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
