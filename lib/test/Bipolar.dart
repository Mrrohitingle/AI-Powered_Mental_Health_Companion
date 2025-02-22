import 'package:flutter/material.dart';
import 'package:yaddy/navigator_drawer.dart';

class BipolarTestPage extends StatefulWidget {
  const BipolarTestPage({super.key});

  @override
  _BipolarTestPageState createState() => _BipolarTestPageState();
}

class _BipolarTestPageState extends State<BipolarTestPage> {
  List<int> answers = List.filled(7, 0); // 7 questions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bipolar Test'),
        backgroundColor: Colors.teal,
      ),
      drawer: const AppNavigator(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'In the past week, have you experienced the following?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _bipolarQuestions.length; i++) _buildQuestion(i),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateResult,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${index + 1}. ${_bipolarQuestions[index]}',
          style: const TextStyle(fontSize: 16),
        ),
        Column(
          children: [
            _buildOption(index, 0, 'Not at all'),
            _buildOption(index, 1, 'Occasionally'),
            _buildOption(index, 2, 'Frequently'),
            _buildOption(index, 3, 'Almost always'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOption(int questionIndex, int value, String text) {
    return RadioListTile(
      value: value,
      groupValue: answers[questionIndex],
      onChanged: (newValue) {
        setState(() {
          answers[questionIndex] = newValue as int;
        });
      },
      title: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  void _calculateResult() {
    int totalScore = answers.reduce((a, b) => a + b);

    if (totalScore <= 5) {
      _showResultDialog(
        'Minimal Symptoms of Bipolar',
        'Your responses indicate minimal symptoms. Continue maintaining a balanced and healthy lifestyle.',
        'assets/motivation.jpg', // Replace with an appropriate image
      );
    } else if (totalScore <= 12) {
      _showResultDialog(
        'Moderate Symptoms of Bipolar',
        'Consider practicing mood-stabilizing techniques, such as regular exercise, mindfulness, or discussing your experiences with someone you trust.',
        'assets/yoga.jpg', // Replace with an appropriate image
      );
    } else {
      _showResultDialog(
        'High Symptoms of Bipolar',
        'Your score suggests significant symptoms. It’s best to consult a mental health professional for a thorough evaluation and guidance.',
        'assets/psychologist.png', // Replace with an appropriate image
      );
    }
  }

  void _showResultDialog(String result, String message, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  result,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.asset(imagePath, height: 150),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

const _bipolarQuestions = [
  'Had periods where you felt overly happy or “high” compared to usual?',
  'Experienced mood swings from very happy to very sad or irritable?',
  'Had an unusual increase in energy and activity levels?',
  'Found yourself talking more than usual or very fast?',
  'Engaged in risky behavior (e.g., spending sprees, impulsive decisions)?',
  'Had trouble sleeping or slept less than usual without feeling tired?',
  'Experienced racing thoughts or difficulty focusing?',
];
