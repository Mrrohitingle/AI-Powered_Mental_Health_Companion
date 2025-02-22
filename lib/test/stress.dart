import 'package:flutter/material.dart';
import 'package:yaddy/navigator_drawer.dart';

class StressTestPage extends StatefulWidget {
  const StressTestPage({super.key});

  @override
  _StressTestPageState createState() => _StressTestPageState();
}

class _StressTestPageState extends State<StressTestPage> {
  List<int> answers = List.filled(8, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Test'),
        backgroundColor: Colors.teal,
      ),
      drawer: const AppNavigator(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Over the last month, how often have you been bothered by the following problems?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _stressQuestions.length; i++) _buildQuestion(i),
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
          '${index + 1}. ${_stressQuestions[index]}',
          style: const TextStyle(fontSize: 16),
        ),
        Column(
          children: [
            _buildOption(index, 0, 'Never'),
            _buildOption(index, 1, 'Almost Never'),
            _buildOption(index, 2, 'Sometimes'),
            _buildOption(index, 3, 'Fairly Often'),
            _buildOption(index, 4, 'Very Often'),
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
      _showResultDialog('Low Stress', 'Keep it up! Maintain a balanced lifestyle.', 'assets/motivation.jpg');
    } else if (totalScore <= 20) {
      _showResultDialog('Moderate Stress', 'Consider relaxation techniques like deep breathing or meditation.', 'assets/yoga.jpg');
    } else {
      _showResultDialog('High Stress', 'Consult a mental health professional for support.', 'assets/psychologist.png');
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

const _stressQuestions = [
  'Felt that you were unable to control important things in your life?',
  'Felt nervous and stressed?',
  'Felt that things were going your way?',
  'Found it difficult to cope with things?',
  'Felt confident about handling your problems?',
  'Felt that things were going as planned?',
  'Felt angry or irritated easily?',
  'Felt that you were on top of things?',
];
