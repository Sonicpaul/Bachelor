import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:plens_app/models/project.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/constants.dart';
import 'package:plens_app/shared/loading.dart';
import 'package:plens_app/view/home/home.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:uuid/uuid.dart';

import '../wrapper.dart';

class TimeRegistration extends StatefulWidget {
  @override
  _TimeRegistrationState createState() => _TimeRegistrationState();
}

// creating the Time Registration widget
class _TimeRegistrationState extends State<TimeRegistration> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  // Form values
  double _time;
  String _userUid;
  String _projectUid;
  String _message;
  var uuid = Uuid();

  // a datepicker to set the date the user wants to set his worktime
  Future<void> _selectDate(BuildContext context) async {
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

  // the main Widget builder
  // setting a form the evaluate the values from the user
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _userUid = user.uid;
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
        title: Text('Time Registration'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateFormat('dd-MM-yyyy')
                          .format(selectedDate)
                          .toString()
                          .replaceAll('-', '.'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        child:
                            Text('Choose Date', style: TextStyle(fontSize: 18)),
                        onPressed: () => _selectDate(context)),
                  ],
                ),
                SizedBox(height: 20),
                projectSelection(),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter the number of hours you worked'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.0-9]')),
                  ],
                  onChanged: (val) => setState(() => _time = double.parse(val)),
                  validator: (val) => val.isEmpty
                      ? 'Enter the number of hours you worked'
                      : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Optional: What have you done?'),
                  onChanged: (val) => setState(() => _message = val),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Add', style: TextStyle(fontSize: 18)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await DatabaseService(uid: uuid.v1()).updateworkTime(
                          DateFormat('dd-MM-yyyy')
                              .format(selectedDate)
                              .toString(),
                          _time,
                          _userUid,
                          _projectUid,
                          _message);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // building a Dropdownmenu with a list of all possible projects
  Widget projectSelection() {
    return FutureBuilder<List<Project>>(
        future: DatabaseService().getProjectList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Project> projects = snapshot.data;
            final List<DropdownMenuItem<String>> dropdownItem = projects
                .map((entry) => DropdownMenuItem<String>(
                      child: Text(entry.name),
                      value: entry.uid,
                    ))
                .toList();
            return SearchableDropdown.single(
                items: dropdownItem,
                hint: 'Select the Project you worked on today',
                searchHint: '',
                value: _projectUid,
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _projectUid = value;
                  });
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Loading();
          }
        });
  }
}
