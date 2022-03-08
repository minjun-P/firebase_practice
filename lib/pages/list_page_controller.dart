import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListPageController {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  var name = ''.obs;
  var age = ''.obs;
  var hobby = ''.obs;

  Future<void> addUser() {
    User user = User(name.value,age.value,hobby.value);
    return users.add(user.toJson())
    .then((value)=>print('User Added'))
    .catchError((error)=>print('Failed to add user: $error'));
  }

  Future<void> updateUserAge(String id,String age) {
    return users.doc(id).update({'age':age})
        .then((value)=>print('User updated'))
        .catchError((error)=>print('Failed to update user: $error'));
  }

}
class User {
  String name;
  String age;
  String hobby;
  User(this.name,this.age,this.hobby);

  Map<String,dynamic> toJson() {
    return {
      'name':name,
      'age':age,
      'hobby':hobby
    };
  }
}