import 'package:flutter/material.dart';
import 'package:yaddy/navigator_drawer.dart';

class OCDTestPage extends StatefulWidget {
  const OCDTestPage({super.key});

  @override
  _OCDTestPageState createState() => _OCDTestPageState();
}

class _OCDTestPageState extends State<OCDTestPage> {
  List<int> answers = List.filled(10, 0); // 10 questions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCD Test'),
        backgroundColor: Colors.teal,
      ),
      drawer: const AppNavigator(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'In the past week, have you experienced any of the following obsessions or compulsions?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _ocdQuestions.length; i++) _buildQuestion(i),
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
          '${index + 1}. ${_ocdQuestions[index]}',
          style: const TextStyle(fontSize: 16),
        ),
        Column(
          children: [
            _buildOption(index, 0, 'Not at all'),
            _buildOption(index, 1, 'A little bit'),
            _buildOption(index, 2, 'Moderately'),
            _buildOption(index, 3, 'A lot'),
            _buildOption(index, 4, 'Extremely'),
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

    if (totalScore <= 10) {
      _showResultDialog(
        'Minimal OCD Symptoms',
        'Your score indicates minimal symptoms. Keep monitoring your mental health.',
        'assets/motivation.jpg', // Replace with an appropriate image
      );
    } else if (totalScore <= 20) {
      _showResultDialog(
        'Moderate OCD Symptoms',
        'Consider exploring strategies such as mindfulness, breathing exercises, or seeking support.',
        'assets/yoga.jpg', // Replace with an appropriate image
      );
    } else {
      _showResultDialog(
        'High OCD Symptoms',
        'Your score suggests significant symptoms. It is advisable to consult with a mental health professional for an evaluation.',
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

const _ocdQuestions = [
  'Do you have frequent, intrusive thoughts or urges to perform certain actions?',
  'Do you find yourself repeatedly washing your hands, or avoiding contamination?',
  'Do you experience excessive checking behaviors (e.g., repeatedly checking locks, stoves, etc.)?',
  'Do you feel that certain actions or behaviors must be done in a specific way or order?',
  'Do you have a persistent fear of harming others, even though you would never do so?',
  'Do you feel the need to mentally repeat or recheck things to prevent something bad from happening?',
  'Do you find yourself performing rituals that you feel are unnecessary but cannot stop doing?',
  'Do you experience distress or anxiety when you are unable to perform certain rituals?',
  'Do you worry about the potential harm or danger of not performing rituals or compulsions?',
  'Do these symptoms interfere with your daily life, work, or relationships?'
];
