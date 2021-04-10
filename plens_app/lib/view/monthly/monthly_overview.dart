import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/models/work_time.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/loading.dart';
import 'package:provider/provider.dart';

class MonthlyOverview extends StatefulWidget {
  @override
  _MOnthlyOverviewState createState() => _MOnthlyOverviewState();
}

class _MOnthlyOverviewState extends State<MonthlyOverview> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Overview'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat('MM-yyyy').format(selectedDate).toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  child: Text('Choose Date'),
                  onPressed: () {
                    _selectMonth(context);
                  }),
            ],
          ),
          showMonthlyOverview(user.uid)
        ],
      ),
    );
  }

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
              }
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: workTimes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Card(
                    margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: ListTile(
                      title: Text(workTimes[index].date +
                          ' - ' +
                          workTimes[index].time.toString()),
                      subtitle: Text(workTimes[index].message),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Loading();
          }
        });
  }
}
