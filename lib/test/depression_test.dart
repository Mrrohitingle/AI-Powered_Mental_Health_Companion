import 'package:flutter/material.dart';
import 'package:yaddy/navigator_drawer.dart';

class DepressionTestPage extends StatefulWidget {
  const DepressionTestPage({super.key});

  @override
  _DepressionTestPageState createState() => _DepressionTestPageState();
}

class _DepressionTestPageState extends State<DepressionTestPage> {
  List<int> answers = List.filled(9, 0); // Store answers for 9 questions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depression Test (PHQ-9)'),
        backgroundColor: Colors.teal,
      ),
      drawer: const AppNavigator(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Over the last 2 weeks, how often have you been bothered by the following problems?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _questions.length; i++) _buildQuestion(i),
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
          '${index + 1}. ${_questions[index]}',
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

    if (totalScore <= 4) {
      _showResultDialog(
        'Minimal Depression',
        'Great job! Keep going, stay positive and maintain a balanced lifestyle!',
        'assets/motivation.jpg', // Add relevant image asset here
      );
    } else if (totalScore <= 9) {
      _showResultDialog(
        'Mild Depression',
        'We recommend exploring breathing and yoga tutorials in our app to help manage your anxiety.',
        'assets/yoga.jpg', // Add relevant image asset here
      );
    } else if (totalScore <= 14) {
      _showResultDialog(
        'Moderate Depression',
        'Consider joining our community groups, explore books and videos from our resources, and try yoga tutorials.',
        'assets/community.jpg', // Add relevant image asset here
      );
    }else if (totalScore <= 19) {
      _showResultDialog(
        'Moderately severe Depression',
        'Consult a psychologist,Consider joining community groups, talk to your near ones and try yoga. ',
        'assets/psychologist.png', // Add relevant image asset here
      );
    }else {
      _showResultDialog(
        'Severe Depression',
        'It\'s best to consult a psychologist . Use our app to find one nearby.Contact hotline if you feel too down or want to talk to someone ',
        'assets/psychologist.png', // Add relevant image asset here
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
            height: MediaQuery.of(context).size.height * 0.75, // 75% of screen
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
                Image.asset(imagePath, height: 150), // Display the relevant image
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
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

const _questions = [
  'Little interest or pleasure in doing things',
  'Feeling down, depressed, or hopeless',
  'Trouble falling or staying asleep, or sleeping too much',
  'Feeling tired or having little energy',
  'Poor appetite or overeating',
  'Feeling bad about yourself — or that you are a failure or have let yourself or your family down',
  'Trouble concentrating on things, such as reading the newspaper or watching television',
  'Moving or speaking so slowly that other people could have noticed? Or the opposite — being so fidgety or restless that you have been moving a lot more than usual',
  'Thoughts that you would be better off dead, or thoughts of hurting yourself in some way',
];