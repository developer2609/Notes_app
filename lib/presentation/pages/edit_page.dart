import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/database/database_helper.dart';
import '../../data/model/notes_model.dart';
import '../theme/app_asset.dart';
import 'home_page.dart';

class EditPage extends StatefulWidget {
  final Note note;
  EditPage({required this.note});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _eventNameController;
  late final TextEditingController _eventDescriptionController;
  late final TextEditingController _eventLocationController;
  late final TextEditingController _eventTimeController;

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
  ];

  Color? selectedColor;
  Map<int, Color> idToColorMap = {
    1: Colors.red,
    2: Colors.green,
    3: Colors.blue,
    4: Colors.yellow,
    5: Colors.orange,
  };

  Map<Color, int> colorToIdMap = {
    Colors.red: 1,
    Colors.green: 2,
    Colors.blue: 3,
    Colors.yellow: 4,
    Colors.orange: 5,
  };

  @override
  void initState() {
    super.initState();
    // Initialize controllers with note values
    _eventNameController = TextEditingController(text: widget.note.name);
    _eventDescriptionController = TextEditingController(text: widget.note.title);
    _eventLocationController = TextEditingController(text: widget.note.location);
    _eventTimeController = TextEditingController(text: widget.note.event); // Assuming `event` is a time string

    // Initialize selected color
    selectedColor = idToColorMap[widget.note.color];
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _eventLocationController.dispose();
    _eventTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int selectedColorId = colorToIdMap[selectedColor!]!; // Retrieve the ID of the selected color

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomInset: true, // Adjust size when the keyboard is open
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16.0),
              Text("Event name"),
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: "",
                  fillColor: Color(0xFFF3F4F6),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text("Event description"),
              SizedBox(
                height: 110,
                child: TextFormField(
                  expands: true,
                  autofocus: false,
                  maxLines: null,
                  controller: _eventDescriptionController,
                  decoration: InputDecoration(
                    labelText: "",
                    fillColor: Color(0xFFF3F4F6),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text("Event location"),
              TextFormField(
                controller: _eventLocationController,
                decoration: InputDecoration(
                  labelText: "",
                  fillColor: Color(0xFFF3F4F6),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text("Priority color"),
              Container(
                height: 32,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF3F4F6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
                      child: DropdownButton<Color>(
                        value: selectedColor,
                        items: colors.map((Color color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Container(
                              width: 24,
                              height: 24,
                              color: color,
                              child: Text(""),
                            ),
                          );
                        }).toList(),
                        onChanged: (Color? newColor) {
                          setState(() {
                            selectedColor = newColor!;
                          });
                        },
                        underline: Container(),
                        icon: SvgPicture.asset(Assets.dropdown),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text("Event time"),
              TextFormField(
                controller: _eventTimeController,
                decoration: InputDecoration(
                  labelText: "",
                  fillColor: Color(0xFFF3F4F6),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_eventNameController.text.isEmpty ||
                        _eventTimeController.text.isEmpty ||
                        _eventLocationController.text.isEmpty ||
                        _eventDescriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter all fields')),
                      );
                      return;
                    }

                    Note updatedNote = Note(
                      id: widget.note.id,
                      title: _eventDescriptionController.text,
                      name: _eventNameController.text,
                      location: _eventLocationController.text,
                      date: widget.note.date,
                      color: selectedColorId, event: _eventTimeController.text,
                    );

                    // Update the note in the database
                    DatabaseHelper.instance.updateNote(updatedNote);

                    // Pop the page and navigate to another page
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomCalendar()));
                  },
                  child: Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
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
        ),
      ),
    );
  }
}
