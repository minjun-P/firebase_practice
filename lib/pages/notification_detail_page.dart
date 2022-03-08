import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NotificationDetailPage extends StatelessWidget {
  final String title;
  const NotificationDetailPage({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'hi'
        ),
      ),
    );
  }
}
