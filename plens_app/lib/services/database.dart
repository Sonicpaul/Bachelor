import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plens_app/models/project.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/models/work_time.dart';

// this class is for the Database only!
// everythin needed to do with the databse is need to be here
class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference projectCollection =
      FirebaseFirestore.instance.collection('projects');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference workTimeCollection =
      FirebaseFirestore.instance.collection('workTime');

  // Updates the data of an user
  Future updateUserData(String name, String email, String phoneNumber) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phoneNumber,
    });
  }

  // updates the data of an project
  Future updateProjectData(
      String name,
      String abbreviation,
      String leader,
      String addressStreetAndNumber,
      String addressPostcodeAndRegion,
      String customer,
      String contact,
      List employees) async {
    return await projectCollection.doc(uid).set({
      'name': name,
      'abbreviation': abbreviation,
      'leader': leader,
      'addressStreetAndNumber': addressStreetAndNumber,
      'addressPostcodeAndRegion': addressPostcodeAndRegion,
      'customer': customer,
      'contact': contact,
      'employees': employees
    });
  }

  // updates the data of the worktime
  Future updateworkTime(String date, double time, String userUid,
      String projectUid, String message) async {
    return await workTimeCollection.doc(uid).set({
      'date': date,
      'time': time,
      'userUid': userUid,
      'projectUid': projectUid,
      'message': message
    });
  }

  // user list from Snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return User(
        uid: doc.id ?? '',
        name: doc.data()['name'] ?? '',
        email: doc.data()['email'] ?? '',
        phone: doc.data()['phone'] ?? '',
        workTimeMonthly: doc.data()['workTimeMonthly'] ?? 0,
      );
    }).toList();
  }

  // project List from Snapshot
  List<Project> _projectListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Project(
        uid: doc.id ?? '',
        name: doc.data()['name'] ?? '',
        abbreviation: doc.data()['abbreviation'] ?? '',
        leader: doc.data()['leader'] ?? '',
        addressStreetAndNumber: doc.data()['addressStreetAndNumber'] ?? '',
        addressPostcodeAndCity: doc.data()['addressPostcodeAndRegion'] ?? '',
        customer: doc.data()['customer'] ?? '',
        contact: doc.data()['contact'] ?? '',
        employees: doc.data()['employees'] ?? [],
      );
    }).toList();
  }

  //workTime List from Snapshot
  List<WorkTime> _workTimeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return WorkTime(
        uid: doc.id ?? '',
        time: doc.data()['time'] ?? 0.0,
        date: doc.data()['date'] ?? '',
        userUid: doc.data()['userUid'] ?? '',
        projectUid: doc.data()['projectUid'] ?? '',
        message: doc.data()['message'] ?? '',
      );
    }).toList();
  }

  // userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
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
  Project _projectDataFromSnapshot(DocumentSnapshot snapshot) {
    return Project(
      uid: snapshot.id ?? '',
      name: snapshot.data()['name'] ?? '',
      abbreviation: snapshot.data()['abbreviation'] ?? '',
      leader: snapshot.data()['leader'] ?? '',
      addressStreetAndNumber: snapshot.data()['addressStreetAndNumber'] ?? '',
      addressPostcodeAndCity: snapshot.data()['addressPostcodeAndRegion'] ?? '',
      customer: snapshot.data()['customer'] ?? '',
      contact: snapshot.data()['contact'] ?? '',
      employees: snapshot.data()['employees'] ?? '',
    );
  }

  // Worktime data from Snapshot
  WorkTime _workTimeDataFromSnapshot(DocumentSnapshot snapshot) {
    return WorkTime(
        uid: snapshot.id ?? '',
        date: snapshot.data()['date'] ?? '',
        time: snapshot.data()['time'] ?? 0.0,
        userUid: snapshot.data()['userUid'] ?? '',
        projectUid: snapshot.data()['projectUid'] ?? '',
        message: snapshot.data()['message'] ?? '');
  }

  // create user Stream
  Stream<List<User>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  // create project Stream
  Stream<List<Project>> get projects {
    return projectCollection.snapshots().map(_projectListFromSnapshot);
  }

  //create workTime Stream
  Stream<List<WorkTime>> get workTimes {
    return workTimeCollection.snapshots().map(_workTimeListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get project doc stream
  Stream<Project> get projectData {
    return projectCollection.doc(uid).snapshots().map(_projectDataFromSnapshot);
  }

  // get workTime doc stream
  Stream<WorkTime> get workTimeData {
    return workTimeCollection
        .doc(uid)
        .snapshots()
        .map(_workTimeDataFromSnapshot);
  }

  // UserList from Database
  Future<List<User>> getUserList() async {
    QuerySnapshot qShot =
        await FirebaseFirestore.instance.collection('users').get();

    return qShot.docs
        .map((doc) => User(
              uid: doc.id ?? '',
              name: doc.data()['name'] ?? '',
              email: doc.data()['email'] ?? '',
              phone: doc.data()['phone'] ?? '',
              workTimeMonthly: doc.data()['workTimeMonthly'] ?? 0,
            ))
        .toList();
  }

  //ProjectList from Database
  Future<List<Project>> getProjectList() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('projects').get();

    return querySnapshot.docs
        .map((doc) => Project(
              uid: doc.id ?? '',
              name: doc.data()['name'] ?? '',
              abbreviation: doc.data()['abbreviation'] ?? '',
              leader: doc.data()['leader'] ?? '',
              addressStreetAndNumber:
                  doc.data()['addressStreetAndNumber'] ?? '',
              addressPostcodeAndCity:
                  doc.data()['addressPostcodeAndRegion'] ?? '',
              customer: doc.data()['customer'] ?? '',
              contact: doc.data()['contact'] ?? '',
              employees: doc.data()['employees'] ?? [],
            ))
        .toList();
  }

  // worktimelist from Dataabse
  Future<List<WorkTime>> getWorkTimeFromUser(String userUid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('workTime')
        .where('userUid', isEqualTo: userUid)
        .get();

    return querySnapshot.docs
        .map((doc) => WorkTime(
              uid: doc.id ?? '',
              time: doc.data()['time'] ?? 0.0,
              date: doc.data()['date'] ?? '',
              userUid: doc.data()['userUid'] ?? '',
              projectUid: doc.data()['projectUid'] ?? '',
              message: doc.data()['message'] ?? '',
            ))
        .toList();
  }

  // deletes an project by its uid
  void deleteProject(String uid) {
    projectCollection.doc(uid).delete();
  }
}
