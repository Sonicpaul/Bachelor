import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/models/work_time.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../wrapper.dart';

class MonthlyOverview extends StatefulWidget {
  @override
  _MOnthlyOverviewState createState() => _MOnthlyOverviewState();
}

// this widget is the Main widget for the Monthly overview
class _MOnthlyOverviewState extends State<MonthlyOverview> {
  DateTime selectedDate = DateTime.now();
  double totalWorkTime = 0.0;

  // building a Datepicker to sleect the month the user wants to know his worktime
  Future<void> _selectMonth(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        totalWorkTime = 0;
      });
  }

  // the main widget is build here
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.house,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Wrapper())),
        ),
        title: Text('Monthly Overview'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat('MM-yyyy')
                    .format(selectedDate)
                    .toString()
                    .replaceAll('-', '.'),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  child: Text(
                    'Choose Date',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    _selectMonth(context);
                  }),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          showMonthlyOverview(user.uid)
        ],
      ),
    );
  }

  // this widget builds a list of all worktime objects in the database
  // it also checks for the month the user selcted
  Widget showMonthlyOverview(String userUid) {
    String monthAndYear;
    List<WorkTime> workTimes;
    String monthAndYearDatabase;

    return FutureBuilder<List<WorkTime>>(
        future: DatabaseService().getWorkTimeFromUser(userUid),
        builder: (context, snapshot) {
          workTimes = [];
          if (snapshot.hasData) {
            monthAndYear =
                DateFormat('MM-yyyy').format(selectedDate).toString();
            final List<WorkTime> worktimeList = snapshot.data;
            for (WorkTime workTimeMonthly in worktimeList) {
              monthAndYearDatabase = workTimeMonthly.date.substring(3);
              if (monthAndYear == monthAndYearDatabase) {
                workTimes.add(workTimeMonthly);
                totalWorkTime += workTimeMonthly.time;
              }
            }
            return Column(
              children: <Widget>[
                Text(
                  'Total worktime this month: ' +
                      totalWorkTime.toString() +
                      'h',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: workTimes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Card(
                        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                        child: ListTile(
                          title: Text(
                            workTimes[index].date.replaceAll('-', '.') +
                                ' - ' +
                                workTimes[index].time.toString() +
                                'h',
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            workTimes[index].message,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Loading();
          }
        });
  }
}
