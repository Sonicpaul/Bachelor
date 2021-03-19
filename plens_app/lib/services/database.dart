import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});


  // Collection reference
  final CollectionReference projectCollection = FirebaseFirestore.instance.collection('projects');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String email, String phoneNumber, double workTimeMonthly) async {
    return await userCollection.doc(uid).set({
      'name' : name,
      'email' : email,
      'phone' : phoneNumber,
      'workTimeMonthly' : workTimeMonthly
    });
  }

}