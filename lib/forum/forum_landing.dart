import 'package:flutter/material.dart';
import 'topics_page.dart';
import 'package:yaddy/navigator_drawer.dart';

class ForumLandingPage extends StatelessWidget {
  final List<String> categories = [
    'Anxiety',
    'Depression',
    'PTSD',
    'OCD',
    'Stress',
    'Bipolar',
    'Miscellaneous'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Forum'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                categories[index],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TopicsPage(categoryName: categories[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
