import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/data/model/notes_model.dart';
import 'package:notes_app/presentation/theme/app_asset.dart';

import '../blocs/note_bloc.dart';
import '../blocs/note_event.dart';


class EventForm extends StatefulWidget {
   final DateTime selectedtime;
  EventForm( { required this.selectedtime});

  @override
  _EventFormState createState() => _EventFormState();
}



class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _eventTimeController = TextEditingController();
  Color selectedColor = Colors.red; // Boshlang'ich rang


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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _eventLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int selectedColorId = colorToIdMap[selectedColor]!; // Retrieve the ID of the selected color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:Color(0xFFFFFFFF),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomInset: true, // Adjust size when the keyboard is open
      appBar: AppBar(
        backgroundColor:Color(0xFFFFFFFF) ,
      ),
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

                    final note = Note(
                      title: _eventNameController.text,
                      date: widget.selectedtime,
                      location: _eventLocationController.text,
                      name: _eventNameController.text,
                      color: selectedColorId,
                      event: _eventTimeController.text,
                    );

                    print("notes qo'shildi");
                    print(_eventDescriptionController.text);
                    print(_eventNameController.text);
                    print(_eventLocationController.text);
                    print(_eventTimeController.text);
                    print("clor $selectedColorId");
                    print(widget.selectedtime);

                    // Add to database
                    BlocProvider.of<NoteBloc>(context).add(AddEvent(note));

                    // Close the page on successful addition
                    Navigator.pop(context);
                  }, child: Text(
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
