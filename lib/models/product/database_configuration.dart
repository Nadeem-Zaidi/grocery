class DatabaseConfiguration {
  String fieldname;
  String datatype;
  bool required;

  DatabaseConfiguration(
      {required this.fieldname,
      required this.datatype,
      required this.required});
}
