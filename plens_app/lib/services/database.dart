import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plens_app/models/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});


  // Collection reference
  final CollectionReference projectCollection = FirebaseFirestore.instance.collection('projects');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String email, String phoneNumber) async {
    return await userCollection.doc(uid).set({
      'name' : name,
      'email' : email,
      'phone' : phoneNumber,
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

  // userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
        uid: uid,
        name: snapshot.data()['name'] ?? '',
        email: snapshot.data()['email'] ?? '',
        phone: snapshot.data()['phone'] ?? '',
        workTimeMonthly: snapshot.data()['workTimeMonthly'] ?? 0,
    );
  }

  // create user Stream
  Stream<List<User>> get users{
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

}