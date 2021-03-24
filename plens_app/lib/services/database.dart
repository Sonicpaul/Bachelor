import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plens_app/models/project.dart';
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

  Future updateProjectData(String name, String abbreviation, String leader, String address, String customer, String contact, List employees ) async{
    return await projectCollection.doc(uid).set({
      'name' : name,
      'abbreviation' : abbreviation,
      'leader' : leader,
      'address' : address,
      'customer' : customer,
      'contact' : contact,
      'employees' : employees
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

  // project List from Snapshot
  List<Project> _projectListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Project(
        uid: doc.id ?? '',
        name: doc.data()['name'] ?? '',
        abbreviation: doc.data()['abbreviation'] ?? '',
        leader: doc.data()['leader'] ?? '',
        address: doc.data()['address'] ?? '',
        customer: doc.data()['customer'] ?? '',
        contact: doc.data()['contact'] ?? '',
        employees: doc.data()['employees'] ?? '',
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
        projectList: snapshot.data()['projectList'] ?? [],
    );
  }

  //ProjectData from Snapshot
  Project _projectDataFromSnapshot(DocumentSnapshot snapshot){
    return Project(
      uid: snapshot.id ?? '',
      name: snapshot.data()['name'] ?? '',
      abbreviation: snapshot.data()['abbreviation'] ?? '',
      leader: snapshot.data()['leader'] ?? '',
      address: snapshot.data()['address'] ?? '',
      customer: snapshot.data()['customer'] ?? '',
      contact: snapshot.data()['contact'] ?? '',
      employees: snapshot.data()['employees'] ?? '',
    );
  }

  // create user Stream
  Stream<List<User>> get users{
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  // create project Stream
  Stream<List<Project>> get projects{
    return projectCollection.snapshots().map(_projectListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get project doc stream
  Stream<Project> get projectData{
    return projectCollection.doc(uid).snapshots().map(_projectDataFromSnapshot);
  }
}