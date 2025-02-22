import 'package:flutter/material.dart';
import 'anxiety_test.dart';
import 'depression_test.dart';
import 'stress.dart';
import 'ptsd.dart';
import 'Bipolar.dart';
import 'ocd.dart';
import 'package:yaddy/navigator_drawer.dart';



class TestSelectionPage extends StatelessWidget {
  const TestSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tests'),
        backgroundColor: Colors.teal,
      ),
      drawer: const AppNavigator(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select a test to assess your mental health:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 bubbles per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildTestBubble(context, 'Anxiety Test', Icons.sentiment_dissatisfied, const AnxietyTestPage()),
                  _buildTestBubble(context, 'Depression Test', Icons.sentiment_very_dissatisfied, const DepressionTestPage()),
                  _buildTestBubble(context, 'Stress Test', Icons.sentiment_neutral, const StressTestPage()),
                  _buildTestBubble(context, 'PTSD Test', Icons.sentiment_neutral, const PTSDTestPage()),
                  _buildTestBubble(context, 'Bipolar Disorder Test', Icons.sentiment_satisfied, const BipolarTestPage()),
                  _buildTestBubble(context, 'OCD Test', Icons.sentiment_very_satisfied, const OCDTestPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create each test bubble
  Widget _buildTestBubble(BuildContext context, String testName, IconData icon, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal.shade300,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              testName,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Landing Pages for Other Tests






