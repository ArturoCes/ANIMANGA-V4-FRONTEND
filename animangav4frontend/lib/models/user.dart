class User {
  String? id;
  String? username;
  String? image;
  String? fullName;
  String? createdAt;

  User({this.id, this.username, this.image, this.fullName, this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    image = json['image'];
    fullName = json['fullName'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['image'] = this.image;
    data['fullName'] = this.fullName;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
