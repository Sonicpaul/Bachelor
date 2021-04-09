class Project {
  final String uid;
  final String name;
  final String abbreviation;
  final String leader;
  final String addressStreetAndNumber;
  final String addressPostcodeAndCity;
  final String customer;
  final String contact;
  final List employees;

  Project(
      {this.uid,
      this.name,
      this.abbreviation,
      this.leader,
      this.addressStreetAndNumber,
      this.addressPostcodeAndCity,
      this.customer,
      this.contact,
      this.employees});
}
