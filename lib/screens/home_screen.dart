import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/backends/database.dart';
import 'package:journal/screens/event_screen.dart';
import 'package:journal/screens/info_screen.dart';
import 'package:journal/screens/onboarding_screen.dart';
import 'package:journal/themes/dark_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Database _database = Database(journal: [
    Journal(id: "id", date: "date", mood: "mood", note: "note", color: 0)
  ]);

  Future<List<Journal>> _loadJournals() async {
    await DatabaseFileRoutines().readJournals().then((journalsJson) {
      _database = databaseFromJson(journalsJson);
      _database.journal
          .sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
    });
    return _database.journal;
  }

  void _addOrEditJournal(
      {required bool add, required int index, required Journal journal}) async {
    JournalEdit _journalEdit = JournalEdit(action: '', journal: journal);
    _journalEdit = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EventScreen(
                add: add,
                index: index,
                journalEdit: _journalEdit,
              ),
          fullscreenDialog: true),
    );
    switch (_journalEdit.action) {
      case 'Save':
        if (add) {
          setState(() {
            _database.journal.add(_journalEdit.journal);
          });
        } else {
          setState(() {
            _database.journal[index] = _journalEdit.journal;
          });
        }
        DatabaseFileRoutines().writeJournals(databaseToJson(_database));
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  // Build the ListView with Separator
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _titleDate = DateFormat.yMMMd()
            .format(DateTime.parse(snapshot.data[index].date));
        String _subtitle =
            snapshot.data[index].mood + "\n" + snapshot.data[index].note;
        int _color = snapshot.data[index].color;
        return Dismissible(
          key: Key(snapshot.data[index].id),
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Card(
            color: Color(_color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Column(
                  children: <Widget>[
                    Text(
                      DateFormat.d()
                          .format(DateTime.parse(snapshot.data[index].date)),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                          color: Colors.grey[800]),
                    ),
                    Text(
                      DateFormat.E()
                          .format(DateTime.parse(snapshot.data[index].date)),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                title: Text(
                  _titleDate,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: Text(
                  _subtitle,
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  _addOrEditJournal(
                    add: false,
                    index: index,
                    journal: snapshot.data[index],
                  );
                },
              ),
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              _database.journal.removeAt(index);
            });
            DatabaseFileRoutines().writeJournals(databaseToJson(_database));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(padding: EdgeInsets.all(4));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Journal app"),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Journals",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InfoScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.info),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  child: FutureBuilder(
                      initialData: [],
                      future: _loadJournals(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return !snapshot.hasData
                            ? Center(child: CircularProgressIndicator())
                            : _buildListViewSeparated(snapshot);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        onPressed: () {
          _addOrEditJournal(
            add: true,
            index: -1,
            journal: Journal(
                id: "id", date: "date", mood: "mood", note: "note", color: 0),
          );
        },
        child: Icon(Icons.add),
        tooltip: "Add a Journal entry",
        backgroundColor: Colors.blueGrey[300],
        elevation: 15,
      ),
    );
  }
}
