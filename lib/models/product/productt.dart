class Productt {
  Map<String, dynamic> fields;
  String type;
  Productt({required this.type, this.fields = const {}});

  void validate() {
    if (!fields.containsKey("id") &&
        (fields["id"] == null || fields["id"] == "")) {

        }
  }

  
}
