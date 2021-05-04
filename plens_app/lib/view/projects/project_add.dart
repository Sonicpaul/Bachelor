import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/constants.dart';
import 'package:plens_app/shared/loading.dart';
import 'package:uuid/uuid.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddAProject extends StatefulWidget {
  @override
  _AddAProjectState createState() => _AddAProjectState();
}

class _AddAProjectState extends State<AddAProject> {
  final _formKey = GlobalKey<FormState>();
  List<int> selectedItems = [];
  bool save = false;

  var uuid = Uuid();

  // form values
  String _name;
  String _abbreviation;
  String _leader = '';
  String _addressStreetAndNumber;
  String _addressPostcodeAndCity;
  String _customer;
  String _contact;
  List<String> _employees = <String>[];

  String error = '';

  // this widget is used to create a new project
  // form is used to evaluate the input of the user
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Add a new project', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter a name for the new Project'),
                  validator: (val) => val.isEmpty
                      ? 'Please enter a name for the Project'
                      : null,
                  onChanged: (val) => setState(() => _name = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Give the Project an abbreviation'),
                  validator: (val) => val.isEmpty
                      ? 'Please enter an abbreviation for the Project'
                      : null,
                  onChanged: (val) => setState(() => _abbreviation = val),
                ),
                SizedBox(height: 20),
                leaderSelection(),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter the Street and number of the address'),
                  validator: (val) => val.isEmpty
                      ? 'Please enter the address for the Project'
                      : null,
                  onChanged: (val) =>
                      setState(() => _addressStreetAndNumber = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter the PostCode and City'),
                  validator: (val) => val.isEmpty
                      ? 'Please enter the address for the Project'
                      : null,
                  onChanged: (val) =>
                      setState(() => _addressPostcodeAndCity = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter the name of the Customer'),
                  validator: (val) => val.isEmpty
                      ? 'Please enter the name of the customer for the Project'
                      : null,
                  onChanged: (val) => setState(() => _customer = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter the name of a contact person'),
                  validator: (val) => val.isEmpty
                      ? 'Please enter the contact data for the Project'
                      : null,
                  onChanged: (val) => setState(() => _contact = val),
                ),
                SizedBox(height: 20),
                employeeSelection(),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    'Add new project',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate() && save) {
                      await DatabaseService(uid: uuid.v1()).updateProjectData(
                          _name,
                          _abbreviation,
                          _leader,
                          _addressStreetAndNumber,
                          _addressPostcodeAndCity,
                          _customer,
                          _contact,
                          _employees);
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ))
      ],
    );
  }

  // this widget provides a list of users to select a leader for this project
  Widget leaderSelection() {
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
                value: _leader,
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _leader = value;
                  });
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Loading();
          }
        });
  }

  // this widget provides a list of all users
  // its possible to select multiple users as employees
  Widget employeeSelection() {
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
              closeButton: (SizedBox.shrink()),
              onChanged: (value) {
                setState(() {
                  selectedItems = value;
                });
                for (int i in value) {
                  _employees.add(users[i].uid);
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
