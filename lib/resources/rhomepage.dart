import 'package:flutter/material.dart';
import 'anxiety_resource.dart';
import'depression_resource.dart';
import 'package:yaddy/navigator_drawer.dart'; // Make sure this includes the necessary resource pages.

class ResourceHome extends StatelessWidget {
  final List<String> topics = [
    'Anxiety', 'Depression', 'PTSD', 'OCD', 'Stress', 'Bipolar', 'Miscellaneous'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Topics'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const AppNavigator(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.5,
          ),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: Colors.blue.shade50,
              child: InkWell(
                onTap: () {
                  // Navigate to the resource page based on the topic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResourcePage(topic: topics[index]),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12.0),
                child: Center(
                  child: Text(
                    topics[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ResourcePage extends StatelessWidget {
  final String topic;
  ResourcePage({required this.topic});

  // Example resources for each topic
  final Map<String, List<String>> resources = {
    'Anxiety': [
      'Literature',  // When clicked, should go to 'AnxLiteraturePage'
      'Exercises',   // When clicked, should go to 'AnxExercisePage'
      'Videos',
      'Games'
    ],
    'Depression': [
      'Literature',  // When clicked, should go to 'DepressionLiteraturePage'
      'Exercises',   // When clicked, should go to 'DepressionExercisePage'
      'Videos',      // When clicked, should go to 'DepressionVideoPage'
    ],
    // Add resources for other topics similarly.
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$topic Resources')),
      drawer: const AppNavigator(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: resources[topic]?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(12.0),
                title: Text(resources[topic]![index]),
                onTap: () {
                  // Navigate to specific pages based on resource name
                  if (resources[topic]![index] == 'Literature') {
                    if (topic == 'Anxiety') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnxLiteraturePage(),
                        ),
                      );
                    } else if (topic == 'Depression') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepLiteraturePage(),
                        ),
                      );
                    }
                  } else if (resources[topic]![index] == 'Exercises') {
                    if (topic == 'Anxiety') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnxExercisePage(),
                        ),
                      );
                    } else if (topic == 'Depression') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepExercisePage(),
                        ),
                      );
                    }
                  } else if (resources[topic]![index] == 'Videos') {
                    if (topic == 'Anxiety') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnxVideoPage(),
                        ),
                      );
                    } else if (topic == 'Depression') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepVideoPage(),
                        ),
                      );
                    }
                  }
                  else if (resources[topic]![index] == 'Games') {
    if (topic == 'Anxiety') {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => AnxGamesPage(),
    ),
    );
    }
    }
                  },
              ),
            );
          },
        ),
      ),
    );
  }
}
