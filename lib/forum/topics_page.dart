import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'post_details_page.dart';
import 'package:yaddy/navigator_drawer.dart';

class TopicsPage extends StatelessWidget {
  final String categoryName;

  TopicsPage({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Related Queries'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .where('category', isEqualTo: categoryName)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(data['heading']),
                  subtitle: Text('Likes: ${data['likes']} - Posted on: ${data['timestamp'].toDate()}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailsPage(
                          topicId: docs[index].id,
                          categoryName: categoryName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTopic(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTopic(BuildContext context) {
    TextEditingController headingController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Topic'),
        content: Column(
          children: [
            TextField(
              controller: headingController,
              decoration: InputDecoration(labelText: 'Topic Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String heading = headingController.text;
              String description = descriptionController.text;
              String userId = FirebaseAuth.instance.currentUser!.uid;

              if (heading.isNotEmpty && description.isNotEmpty) {
                await FirebaseFirestore.instance.collection('topics').add({
                  'heading': heading,
                  'description': description,
                  'category': categoryName,
                  'timestamp': Timestamp.now(),
                  'user': FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId), // This stores the user's DocumentReference
                  'likes': 0,
                  'likedBy': [],
                });
                Navigator.pop(context);
              }
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }


}


