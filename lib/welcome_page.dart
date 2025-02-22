import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Lottie animation package
import 'package:yaddy/helpline/helpline.dart';
import 'package:yaddy/psychologist/psychiatrist.dart';
import 'resources/rhomepage.dart';
import 'test/test_selection.dart';
import 'forum/forum_landing.dart';
import 'package:yaddy/bookings/booking.dart';
import 'package:yaddy/navigator_drawer.dart';
import 'package:yaddy/chatbot_inappwebview.dart'; // Ensure this file is imported

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Widget _buildBlock(BuildContext context, String title, IconData icon, Widget? nextPage) {
    return GestureDetector(
      onTap: () {
        if (nextPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 48.0),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const AppNavigator(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Background Grid
                GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16.0),
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildBlock(context, 'Take Test', Icons.edit, const TestSelectionPage()),
                    _buildBlock(context, 'Forum', Icons.forum, ForumLandingPage()),
                    _buildBlock(context, 'Helpline', Icons.call, HelplinePage()),
                    _buildBlock(context, 'Resources', Icons.library_books, ResourceHome()),
                    _buildBlock(context, 'Psychiatrist', Icons.psychology, PsychiatristSearchPage()),
                    _buildBlock(context, 'Book Appointment', Icons.calendar_today, BookAppointmentPage()),
                  ],
                ),
                // Companion Chatbot Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatbotInAppWebView(chatbotUrl: 'https://5oqpixo4x2qj.trickle.host/'),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Lottie Animation
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Lottie.asset('assets/chatbot_wave.json'), // Lottie animation file
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Hi! Want to talk?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotInAppWebView(chatbotUrl: 'https://5oqpixo4x2qj.trickle.host/'),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
