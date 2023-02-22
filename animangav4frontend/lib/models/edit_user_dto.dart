class EditUserDto {
  EditUserDto({
    required this.fullName,
    this.email,
  });
  late final String fullName;
  late String? email;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fullName'] = fullName;
    _data['email'] = email;
    return _data;
  }
}
