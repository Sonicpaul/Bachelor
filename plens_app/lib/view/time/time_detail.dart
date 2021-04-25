import 'package:flutter/material.dart';
import 'package:plens_app/models/work_time.dart';

class WorkTimeDetails extends StatefulWidget {
  final WorkTime workTime;
  WorkTimeDetails({this.workTime});
  @override
  _WorkTimeDetailsState createState() => _WorkTimeDetailsState();
}

class _WorkTimeDetailsState extends State<WorkTimeDetails> {
  String error = '';
  double size = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
