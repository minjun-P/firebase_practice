import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ListPageController {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Map<String, String> tokenMap = {
    'emulator':'djI2V3v_QV-_OGutuJZEha:APA91bH3uI4b_2bcFQlo67UECexqcKIS8dXLd-yB-A4nH-c1xZc0GV1s9LNzUwyZdPN74Fejd1U0WvjvZOctF8TGjeYFI5atCf3Wb5S6FOljZWFvjtg3B-umzS6GoCqnHRydkRusFpEp',
    'phone':'eTVbNOc0SySZDM8MVrijp9:APA91bEuYRuOOvtmCyp0GwmlACmEp3GD6NpF7b6ImBrie7KqeOVEuQ8tureXXkisWJsEfxXXO6B0h9jRtgMushjkXsMLFm6Fq7mV8daicCAc_GTqNSGieLP3e95QjnCE39IMiMJQ7uRa'
  };

  var name = ''.obs;
  var age = ''.obs;
  var hobby = ''.obs;
  FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');

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
  Future<void> sendFcm({required String token}) async {
    HttpsCallable callable = functions.httpsCallable('sendFcm');
    final resp = await callable.call(<String,dynamic> {
      'token':token,
      'title':name.value,
      'body':hobby.value
    });
    print(resp);
  }
  Future<void> change(String docId) async{
    HttpsCallable callable = functions.httpsCallable('updateUsers');
    final resp = await callable.call(<String, String> {
      'doc':docId
    });
    print(resp);
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