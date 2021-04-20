import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/constants.dart';
import 'package:plens_app/shared/loading.dart';
import 'package:plens_app/view/projects/project_Widget.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class EditProject extends StatefulWidget {
  final Project project;
  EditProject({this.project});

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  final _formKey = GlobalKey<FormState>();
  List<int> selectedItems = [];
  bool save = false;

  static String uid;
  static String _currentName;
  static String _currentAbbreviation;
  static String _currentLeader;
  static String _currentAddressStreetAndNumber;
  static String _currentAddressPostcodeAndCity;
  static String _currentCustomer;
  static String _currentContact;
  List<String> _currentEmployees = <String>[];

  @override
  Widget build(BuildContext context) {
    uid = widget.project.uid;

    return ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Edit this project', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.project.name,
                  decoration: textInputDecoration,
                  validator: (val) =>
                      val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.project.abbreviation,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty
                      ? 'Please enter an abbreviation for the Project'
                      : null,
                  onChanged: (val) =>
                      setState(() => _currentAbbreviation = val),
                ),
                SizedBox(height: 20),
                newLeader(),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.project.addressStreetAndNumber,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty
                      ? 'Please enter an abbreviation for the Project'
                      : null,
                  onChanged: (val) =>
                      setState(() => _currentAddressStreetAndNumber = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.project.addressPostcodeAndCity,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty
                      ? 'Please enter an abbreviation for the Project'
                      : null,
                  onChanged: (val) =>
                      setState(() => _currentAddressPostcodeAndCity = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.project.customer,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty
                      ? 'Please enter an abbreviation for the Project'
                      : null,
                  onChanged: (val) => setState(() => _currentCustomer = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.project.contact,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty
                      ? 'Please enter an abbreviation for the Project'
                      : null,
                  onChanged: (val) => setState(() => _currentContact = val),
                ),
                SizedBox(height: 20),
                Text(
                  'Please pick the members of this Project.',
                  style: TextStyle(color: Colors.red),
                ),
                newEmployees(),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Update'),
                  onPressed: () async {
                    if (_formKey.currentState.validate() && save) {
                      await DatabaseService(uid: uid).updateProjectData(
                          _currentName ?? widget.project.name,
                          _currentAbbreviation ?? widget.project.abbreviation,
                          _currentLeader ?? widget.project.leader,
                          _currentAddressStreetAndNumber ??
                              widget.project.addressStreetAndNumber,
                          _currentAddressPostcodeAndCity ??
                              widget.project.addressPostcodeAndCity,
                          _currentCustomer ?? widget.project.customer,
                          _currentContact ?? widget.project.contact,
                          _currentEmployees ?? widget.project.employees);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProjectWidget()));
                    }
                  },
                ),
              ],
            )),
      ],
    );
  }

  Widget newLeader() {
    return FutureBuilder<List<User>>(
        future: DatabaseService().getUserList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<User> users = snapshot.data;
            final List<DropdownMenuItem<String>> dropdownItem = users
                .map((entry) => DropdownMenuItem<String>(
                      child: Text(entry.name),
                      value: entry.uid,
                    ))
                .toList();
            return SearchableDropdown.single(
                items: dropdownItem,
                hint: 'Select the leader of this Project',
                searchHint: '',
                value: _currentLeader,
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _currentLeader = value;
                  });
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Loading();
          }
        });
  }

  Widget newEmployees() {
    return FutureBuilder<List<User>>(
        future: DatabaseService().getUserList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<User> users = snapshot.data;
            final List<DropdownMenuItem<String>> dropdownItem = users
                .map((entry) => DropdownMenuItem<String>(
                      child: Text(entry.name),
                      value: entry.uid,
                    ))
                .toList();
            return SearchableDropdown.multiple(
              items: dropdownItem,
              selectedItems: selectedItems,
              hint: 'Select the employees you want to assign to the Project.',
              searchHint: '',
              doneButton: "Apply",
              closeButton: SizedBox.shrink(),
              onChanged: (value) {
                setState(() {
                  selectedItems = value;
                });
                for (int i in value) {
                  _currentEmployees.add(users[i].uid);
                }
                save = true;
              },
              dialogBox: false,
              isExpanded: true,
              menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Loading();
          }
        });
  }
}
