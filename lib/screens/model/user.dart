class User {
  // ignore: non_constant_identifier_names
  int user_id;
  // ignore: non_constant_identifier_names
  String user_name;
  // ignore: non_constant_identifier_names
  String user_no;
  // ignore: non_constant_identifier_names
  String user_type;
  // ignore: non_constant_identifier_names
  String user_start_time;
  // ignore: non_constant_identifier_names
  String user_end_time;
  // ignore: non_constant_identifier_names
  String user_date;

  User(
    this.user_id,
    this.user_name,
    this.user_no,
    this.user_type,
    this.user_start_time,
    this.user_end_time,
    this.user_date,
  );

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'user_name': user_name,
        'user_no': user_no.toString(),
        'user_type': user_type,
        'user_start_time': user_start_time,
        'user_end_time': user_end_time,
        'user_date': user_date,
      };
}
