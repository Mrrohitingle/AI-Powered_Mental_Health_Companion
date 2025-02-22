import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yaddy/navigator_drawer.dart';

class PostDetailsPage extends StatefulWidget {
  final String topicId;
  final String categoryName;

  PostDetailsPage({required this.topicId, required this.categoryName});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  TextEditingController commentController = TextEditingController();
  TextEditingController editCommentController = TextEditingController();
  TextEditingController editPostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var post = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Post
                        Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<DocumentSnapshot>(
                                  future: post['user'].get(),
                                  builder: (context, authorSnapshot) {
                                    if (!authorSnapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }

                                    var authorData =
                                    authorSnapshot.data!.data() as Map<String, dynamic>;
                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          child: Text(
                                            authorData['name'][0].toUpperCase(),
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          authorData['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Spacer(),
                                        if (FirebaseAuth.instance.currentUser!.uid ==
                                            post['user'].id)
                                          PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'Edit') {
                                                _editPostDialog(post);
                                              } else if (value == 'Delete') {
                                                _deletePost();
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 'Edit',
                                                child: Text('Edit'),
                                              ),
                                              PopupMenuItem(
                                                value: 'Delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 10),
                                Text(
                                  post['heading'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  post['description'],
                                  style: TextStyle(color: Colors.black54, fontSize: 14),
                                ),
                                if (post['edited'] == true)
                                  Text(
                                    '(Edited)',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: post['likedBy']
                                            .contains(FirebaseAuth.instance.currentUser!.uid)
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      onPressed: () =>
                                          _likePost(post['likes'], post['likedBy']),
                                    ),
                                    Text(
                                      '${post['likes']}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Comments',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 10),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('topics')
                              .doc(widget.topicId)
                              .collection('posts')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, commentSnapshot) {
                            if (!commentSnapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            List<DocumentSnapshot> comments =
                                commentSnapshot.data!.docs;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                var commentData =
                                comments[index].data() as Map<String, dynamic>;

                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(commentData['author'])
                                      .get(),
                                  builder: (context, commentUserSnapshot) {
                                    if (!commentUserSnapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }

                                    var commentUserData =
                                    commentUserSnapshot.data!.data()
                                    as Map<String, dynamic>;

                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  child: Text(
                                                    commentUserData['name'][0]
                                                        .toUpperCase(),
                                                    style:
                                                    TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  commentUserData['name'],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Spacer(),
                                                if (FirebaseAuth.instance
                                                    .currentUser!.uid ==
                                                    commentData['author'])
                                                  PopupMenuButton<String>(
                                                    onSelected: (value) {
                                                      if (value == 'Edit') {
                                                        _editCommentDialog(
                                                            commentData,
                                                            comments[index].id);
                                                      } else if (value ==
                                                          'Delete') {
                                                        _deleteComment(
                                                            comments[index].id);
                                                      }
                                                    },
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        value: 'Edit',
                                                        child: Text('Edit'),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 'Delete',
                                                        child: Text('Delete'),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(commentData['text']),
                                            if (commentData['edited'] == true)
                                              Text(
                                                '(Edited)',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.thumb_up,
                                                    color: commentData['likedBy']
                                                        .contains(FirebaseAuth
                                                        .instance
                                                        .currentUser!.uid)
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                    size: 20,
                                                  ),
                                                  onPressed: () => _likeComment(
                                                      commentData['likes'],
                                                      comments[index].id),
                                                ),
                                                Text(
                                                  '${commentData['likes']}',
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          labelText: 'Write a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: _addComment,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Add Comment Logic
  void _addComment() async {
    String commentText = commentController.text.trim();
    if (commentText.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('topics')
          .doc(widget.topicId)
          .collection('posts')
          .add({
        'author': FirebaseAuth.instance.currentUser!.uid,
        'text': commentText,
        'timestamp': Timestamp.now(),
        'likes': 0,
        'likedBy': [],
        'edited': false,
      });
      commentController.clear();
    }
  }

  // Delete Post Logic
  void _deletePost() async {
    await FirebaseFirestore.instance.collection('topics').doc(widget.topicId).delete();
    Navigator.pop(context);
  }

  // Delete Comment Logic
  void _deleteComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .collection('posts')
        .doc(commentId)
        .delete();
  }

  // Edit Post Dialog
  void _editPostDialog(Map<String, dynamic> post) {
    editPostController.text = post['description'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Post'),
        content: TextField(
          controller: editPostController,
          maxLines: 3,
          decoration: InputDecoration(labelText: 'Post Description'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              String updatedText = editPostController.text.trim();
              if (updatedText.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('topics')
                    .doc(widget.topicId)
                    .update({
                  'description': updatedText,
                  'edited': true,
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  // Edit Comment Dialog
  void _editCommentDialog(Map<String, dynamic> commentData, String commentId) {
    editCommentController.text = commentData['text'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Comment'),
        content: TextField(
          controller: editCommentController,
          maxLines: 2,
          decoration: InputDecoration(labelText: 'Comment Text'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              String updatedText = editCommentController.text.trim();
              if (updatedText.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('topics')
                    .doc(widget.topicId)
                    .collection('posts')
                    .doc(commentId)
                    .update({
                  'text': updatedText,
                  'edited': true,
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  // Like/Unlike Post Logic
  void _likePost(int likes, List likedBy) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (likedBy.contains(userId)) {
      // Unlike the post
      await FirebaseFirestore.instance.collection('topics').doc(widget.topicId).update({
        'likes': likes - 1,
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      // Like the post
      await FirebaseFirestore.instance.collection('topics').doc(widget.topicId).update({
        'likes': likes + 1,
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  // Like/Unlike Comment Logic
  void _likeComment(int likes, String commentId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot commentSnapshot = await FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .collection('posts')
        .doc(commentId)
        .get();

    List likedBy = commentSnapshot['likedBy'];

    if (likedBy.contains(userId)) {
      // Unlike the comment
      await FirebaseFirestore.instance
          .collection('topics')
          .doc(widget.topicId)
          .collection('posts')
          .doc(commentId)
          .update({
        'likes': likes - 1,
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      // Like the comment
      await FirebaseFirestore.instance
          .collection('topics')
          .doc(widget.topicId)
          .collection('posts')
          .doc(commentId)
          .update({
        'likes': likes + 1,
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }
}
