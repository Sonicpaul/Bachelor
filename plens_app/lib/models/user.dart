class User{
  final String uid;
  final String name;
  final String email;
  final String phone;
  final double workTimeMonthly;

  User({this.uid, this.name, this.email, this.phone, this.workTimeMonthly});
}

class UserData{
  final String uid;
  final String name;
  final String email;
  final String phone;
  final double workTimeMonthly;
  final List<String> projectList;

  UserData({this.uid, this.name, this.email, this.phone, this.workTimeMonthly, this.projectList});

}