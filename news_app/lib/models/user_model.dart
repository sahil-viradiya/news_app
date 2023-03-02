// ignore_for_file: empty_constructor_bodies

class User {
  late int id;
  late String? name,image,phone;

  User.fromJson(dynamic json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
    phone = json['phone'];
  }
  
}