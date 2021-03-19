import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plens_app/models/user.dart';

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

  // user list from Snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return User(
        uid : doc.id ?? '',
        name: doc.data()['name'] ?? '',
        email: doc.data()['email'] ?? '',
        phone: doc.data()['phone'] ?? '',
        workTimeMonthly: doc.data()['workTimeMonthly'] ?? 0,
      );
    }).toList();
  }

  // create Stream
  Stream<List<User>> get users{
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}