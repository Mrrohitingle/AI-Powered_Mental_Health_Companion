import 'package:flutter/material.dart';
import 'package:yaddy/auth/sign_up.dart';
import 'package:yaddy/helpline/helpline.dart';
import 'package:yaddy/psychologist/psychiatrist.dart';
import 'resources/rhomepage.dart';
import 'test/test_selection.dart';
import 'forum/forum_landing.dart';
import 'bookings/booking.dart';// New Sign Out Page

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'App Navigation',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome!',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.psychology),
            title: const Text('Psychiatrist Search'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  PsychiatristSearchPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Book Appointment'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookAppointmentPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Helpline'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelplinePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text('Forum'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ForumLandingPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Resources'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResourceHome()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Tests'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestSelectionPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
          ),
        ],
      ),
    );
  }
}
