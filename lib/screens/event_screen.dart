import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/backends/database.dart';
import 'package:journal/themes/dark_theme.dart';

class EventScreen extends StatefulWidget {
  final bool add;
  final int index;
  final JournalEdit journalEdit;

  const EventScreen(
      {Key? key,
      required this.add,
      required this.index,
      required this.journalEdit})
      : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  JournalEdit _journalEdit = JournalEdit(
      action: "Action",
      journal: Journal(
          id: "id", date: "date", mood: "mood", note: "note", color: 0));
  String _title = "Something";
  DateTime _selectedDate = DateTime(1);
  TextEditingController _moodController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  FocusNode _moodFocus = FocusNode();
  FocusNode _noteFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _journalEdit =
        JournalEdit(action: 'Cancel', journal: widget.journalEdit.journal);
    _title = widget.add ? 'Add' : 'Edit';
    _journalEdit.journal = widget.journalEdit.journal;
    if (widget.add) {
      _selectedDate = DateTime.now();
      _moodController.text = '';
      _noteController.text = '';
    } else {
      _selectedDate = DateTime.parse(_journalEdit.journal.date);
      _moodController.text = _journalEdit.journal.mood;
      _noteController.text = _journalEdit.journal.note;
    }
  }

  @override
  dispose() {
    _moodController.dispose();
    _noteController.dispose();
    _moodFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  // Date Picker
  Future<DateTime> _selectDate(DateTime selectedDate) async {
    DateTime _initialDate = selectedDate;
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (_pickedDate != null) {
      selectedDate = DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
          _initialDate.hour,
          _initialDate.minute,
          _initialDate.second,
          _initialDate.millisecond,
          _initialDate.microsecond);
    }
    return selectedDate;
  }

  //Get random element from a list:
  int randomColor(List lst) {
    final _random = new Random();
    return lst[_random.nextInt(lst.length)];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(8.0)),
                  Text(
                    "$_title entry",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 22,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          DateFormat.yMMMEd().format(_selectedDate),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime _pickerDate = await _selectDate(_selectedDate);
                      setState(() {
                        _selectedDate = _pickerDate;
                      });
                    },
                  ),
                  TextField(
                    controller: _moodController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    focusNode: _moodFocus,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Mood',
                      icon: Icon(Icons.mood),
                    ),
                    onSubmitted: (submitted) {
                      FocusScope.of(context).requestFocus(_noteFocus);
                    },
                  ),
                  TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    focusNode: _noteFocus,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      icon: Icon(Icons.subject),
                    ),
                    maxLines: null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _journalEdit.action = 'Cancel';
                          Navigator.pop(context, _journalEdit);
                        },
                      ),
                      SizedBox(width: 16.0),
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        onPressed: () {
                          _journalEdit.action = 'Save';
                          String _id = widget.add
                              ? Random().nextInt(9999999).toString()
                              : _journalEdit.journal.id;
                          _journalEdit.journal = Journal(
                              id: _id,
                              date: _selectedDate.toString(),
                              mood: _moodController.text,
                              note: _noteController.text,
                              color: randomColor(darkCardColors()));
                          Navigator.pop(context, _journalEdit);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
