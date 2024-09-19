
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/presentation/pages/detail_page.dart';
import 'package:notes_app/presentation/theme/app_asset.dart';

import '../../data/database/database_helper.dart';
import '../../data/model/notes_model.dart';
import 'add_notes.dart';


class CustomCalendar extends StatefulWidget {
  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}
class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _selectedDate = DateTime.now();
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;

  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Map<int, Color> idToColorMap = {
    1: Colors.red,
    2: Colors.green,
    3: Colors.blue,
    4: Colors.yellow,
    5: Colors.orange,
  };

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
  ];
  Map<Color, int> colorToIdMap = {
    Colors.red: 1,
    Colors.green: 2,
    Colors.blue: 3,
    Colors.yellow: 4,
    Colors.orange: 5,
  };
  void fetchNotes() async {
    final dbHelper = DatabaseHelper.instance;
    DateTime queryDate = _selectedDate;
    try {
      List<Note> notes = await dbHelper.getNotesByDate(queryDate);
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              DateFormat('EEEE').format(_selectedDate),
              style: TextStyle(fontSize: 14, color: Color(0xFF292929)),
            ),
            Text(
              DateFormat('d MMMM y').format(_selectedDate),
              style: TextStyle(fontSize: 10, color: Color(0xFF292929)),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          children: [
            _buildHeader(), // Month and year navigation
            _buildDaysOfWeek(), // Day labels (Sun, Mon, etc.)
            SizedBox(height: 250, child: _buildCalendarGrid()), // Calendar grid
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Schedule",
                  style: TextStyle(color: Color(0xFF292929), fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return EventForm(selectedtime: _selectedDate);
                      }));
                    },
                    child: Text("+ Add Event", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF009FEE)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 18),
            Expanded(child: _buildNotesList()), // Notes list
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${_getMonthName(_currentMonth)} $_currentYear",
          style: TextStyle(fontSize: 20),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (_currentMonth > 1) {
                    _currentMonth--;
                  } else {
                    _currentMonth = 12;
                    _currentYear--;
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFFEFEFEF),
                ),
                child: SvgPicture.asset(Assets.arrowLeft, height: 23, width: 23),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                setState(() {
                  if (_currentMonth < 12) {
                    _currentMonth++;
                  } else {
                    _currentMonth = 1;
                    _currentYear++;
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFFEFEFEF),
                ),
                child: SvgPicture.asset(Assets.arrowRight, height: 23, width: 23),
              ),
            ),
            ],
        ),
      ],
    );
  }

  Widget _buildDaysOfWeek() {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: TextStyle(
                color: Color(0xFF969696),
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        ),
      ))
          .toList(),
    );
  }
  Widget _buildCalendarGrid() {
    final daysInMonth = _daysInMonth(_currentYear, _currentMonth);
    final firstWeekday = DateTime(_currentYear, _currentMonth, 1).weekday;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < (firstWeekday - 1); i++) {
      dayWidgets.add(_buildEmptyDayCell()); // Use a custom method to create empty cells
    }

    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(_buildDayCell(day));
    }

    return GridView.count(
      crossAxisCount: 7,
      children: dayWidgets,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }


  Widget _buildEmptyDayCell() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: SizedBox(), // Empty cell
    );
  }

  // Widget _buildCalendarGrid() {
  //   final daysInMonth = _daysInMonth(_currentYear, _currentMonth);
  //   final firstWeekday = DateTime(_currentYear, _currentMonth, 1).weekday;
  //
  //   List<Widget> dayWidgets = [];
  //
  //   // Add empty cells for days before the first day of the month
  //   for (int i = 0; i < firstWeekday % 7; i++) {
  //     dayWidgets.add(Expanded(child: SizedBox()));
  //   }
  //
  //   // Add day cells for each day of the month
  //   for (int day = 1; day <= daysInMonth; day++) {
  //     dayWidgets.add(_buildDayCell(day));
  //   }
  //
  //   return GridView.count(
  //     crossAxisCount: 7,
  //     children: dayWidgets,
  //     physics: NeverScrollableScrollPhysics(),
  //   );
  // }

  Widget _buildDayCell(int day) {
    final isSelected = _selectedDate.year == _currentYear &&
        _selectedDate.month == _currentMonth &&
        _selectedDate.day == day;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = DateTime(_currentYear, _currentMonth, day);
          fetchNotes();
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return StreamBuilder<void>(
      stream: DatabaseHelper.instance.updateStream,
      builder: (context, snapshot) {
        return FutureBuilder<List<Note>>(
          future: DatabaseHelper.instance.getNotesByDate(_selectedDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(''));
            }

            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                Note note = notes[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsPage(note: note)));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: idToColorMap[note.color]?.withOpacity(0.2),
                    ),
                    child:  Column(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                            color: idToColorMap[note.color] ,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              Text(note.name, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 8)),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SvgPicture.asset(Assets.time, height: 16, width: 16, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text(note.event, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10)),
                                  SizedBox(width: 10),
                                  SvgPicture.asset(Assets.location, height: 15, width: 13, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text(note.location, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    return DateFormat.MMMM().format(DateTime(0, month));
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}



