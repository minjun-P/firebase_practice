import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/pages/list_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ListPage extends GetView<ListPageController> {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ListPageController());
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    GlobalKey<FormState> formKey = GlobalKey();
    
    Future<void> getFruit() async {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('listFruit');
      final results = await callable();
      List fruit = results.data;
      print(fruit);
    }

     Future<void> writeMessage(String message) async {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('writeMessage');
      final resp = await callable.call(<String, dynamic>{
        'text':'A message sent from a client device',
      });
      print('result: ${resp.data}');
     }

     Future<void> sendMessage() async {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendMessage');
      final resp = await callable();
      print('result : $resp');
     }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('디비에서 항목을 끌어와 보자'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: users.snapshots()..listen((event) {print(event);}),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting){
                  return Text('Loading');
                }
                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document){
                      Map<String, dynamic> data = document.data()! as Map<String,dynamic>;
                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text(data['hobby']),
                        leading: Text(data['age']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: (){
                                  document.reference.delete();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.update),
                                onPressed: (){
                                  controller.updateUserAge(document.id, '100');
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text('목록 추가하기'),
                      content: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: '이름'
                              ),
                              onSaved: (text){
                                controller.name(text);
                              },
                              initialValue: '',
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: '나이'
                              ),
                              onSaved: (text){
                                controller.age(text);
                              },
                              keyboardType: TextInputType.number,
                              initialValue: '',
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: '취미'
                              ),
                              onSaved: (text){
                                controller.hobby(text);
                              },
                              initialValue: '',
                            ),
                            ElevatedButton(
                              child: Text('제출하기'),
                              onPressed: (){
                                formKey.currentState!.save();
                                formKey.currentState!.reset();
                                controller.addUser();
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  }
                );

              },
              child: Text('목록 추가하기'),
            ),
            ElevatedButton(
              onPressed: (){
                getFruit();
                writeMessage('짱구');
              },
              child: Text('과일'),
            ),
            ElevatedButton(
              onPressed: (){
                sendMessage();
              },
              child: Text('메시지보내기'),
            )

          ],
        ),
      )
    );
  }
}
