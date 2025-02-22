import 'package:flutter/material.dart';
import 'package:yaddy/navigator_drawer.dart';

class PTSDTestPage extends StatefulWidget {
  const PTSDTestPage({super.key});

  @override
  _PTSDTestPageState createState() => _PTSDTestPageState();
}

class _PTSDTestPageState extends State<PTSDTestPage> {
  List<int> answers = List.filled(5, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PTSD Test'),
        backgroundColor: Colors.teal,
      ),
      drawer: const AppNavigator(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'In the past month, have you been bothered by any of the following problems?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _ptsdQuestions.length; i++) _buildQuestion(i),
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
          '${index + 1}. ${_ptsdQuestions[index]}',
          style: const TextStyle(fontSize: 16),
        ),
        Column(
          children: [
            _buildOption(index, 0, 'Not at all'),
            _buildOption(index, 1, 'Several days'),
            _buildOption(index, 2, 'More than half the days'),
            _buildOption(index, 3, 'Nearly every day'),
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

    if (totalScore <= 3) {
      _showResultDialog(
        'Low PTSD Symptoms',
        'Your score indicates low symptoms of PTSD. Keep managing your mental health and monitor any changes.',
        'assets/motivation.jpg', // Replace with an appropriate image
      );
    } else if (totalScore <= 9) {
      _showResultDialog(
        'Moderate PTSD Symptoms',
        'Consider relaxation techniques and self-care strategies to manage these symptoms. Reach out for help if they persist.',
        'assets/yoga.jpg', // Replace with an appropriate image
      );
    } else {
      _showResultDialog(
        'High PTSD Symptoms',
        'It is recommended that you consult a mental health professional for support and guidance on managing PTSD symptoms.',
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

const _ptsdQuestions = [
  'Have you had nightmares or thought about the event when you did not want to?',
  'Tried hard not to think about it or went out of your way to avoid situations that reminded you of it?',
  'Been constantly on guard, watchful, or easily startled?',
  'Felt numb or detached from people, activities, or your surroundings?',
  'Felt guilty or unable to stop blaming yourself or others for the event or any problems the event may have caused?',
];
