import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';

class ProjectDetails extends StatelessWidget {
  final Project project;
  ProjectDetails({this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name + " - " + project.abbreviation),
        actions: <Widget>[
          ElevatedButton(
              child: Text('Edit'),
              onPressed:  (){
                //TODO Contextmenü zum ändern
          })
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Text('Project leader'+ '\n'),
                    ),
                    SizedBox(width:50,),
                    Flexible(
                      flex: 2,
                      child: Text('Address' + '\n' + project.address.padRight(10)),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.blue[900],
                height: 50,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text('Customer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}
