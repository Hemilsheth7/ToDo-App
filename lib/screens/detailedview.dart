import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailedView extends StatelessWidget {
  final String title,description,date;
  const DetailedView({Key? key, required this.title, required this.description, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Description"),
      ),
      body: Container(
        child:  Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15, top: 10),
              padding: EdgeInsets.all(5),
              child: Text(title,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15, top: 5),
              padding: EdgeInsets.all(5),
              child: Text("Created on :"+date,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: Colors.black38,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15, top: 5),
              padding: EdgeInsets.all(5),
              child: Text(description,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
