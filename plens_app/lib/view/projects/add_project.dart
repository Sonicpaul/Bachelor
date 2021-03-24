import 'package:flutter/material.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:plens_app/models/project.dart';
import 'package:uuid/uuid.dart';


class AddAProject extends StatefulWidget {
  @override
  _AddAProjectState createState() => _AddAProjectState();
}

class _AddAProjectState extends State<AddAProject> {
  final _formKey = GlobalKey<FormState>();

  var uuid = Uuid();

  // form values
   String _name;
   String _abbreviation;
   String _leader;
   String _address;
   String _customer;
   String _contact;
   List _employees;

   String error ='';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text('Add a new project',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: textInputDecoration,
              validator: (val) => val.isEmpty ? 'Please enter a name' : null,
              onChanged: (val) => setState(() => _name = val),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () async {
                if(_formKey.currentState.validate()){
                  dynamic result = await DatabaseService(uid: uuid.v1()).updateProjectData('name', 'abbreviation', 'leader', 'address', 'customer', 'contact', []);

                  if(result == null){
                    setState(() => error = 'Check the Email address please or try to log out and sign in again.');

                  }else{
                    Navigator.pop(context);
                  }
                }
              },
            )
          ],
        )
    );
  }
}
