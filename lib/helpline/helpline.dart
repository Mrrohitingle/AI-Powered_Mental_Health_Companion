import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaddy/navigator_drawer.dart';

class HelplinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helpline & Support'),
        backgroundColor: Colors.teal[700],
      ),
      drawer: const AppNavigator(),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Help Now',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Reach out to trusted mental health organizations for support.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          // List of Helplines
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                HelplineCard(
                  orgName: 'Kiran Mental Health Helpline',
                  description: '24/7 helpline for mental health support in India.',
                  contactNumber: '1800-599-0019',
                  website: 'https://kiranhelpline.in',
                ),
                HelplineCard(
                  orgName: 'Vandrevala Foundation',
                  description: 'Free mental health support and counseling.',
                  contactNumber: '1860-266-2345',
                  website: 'https://vandrevalafoundation.com',
                ),
                HelplineCard(
                  orgName: 'Snehi',
                  description: 'Helpline for emotional support and mental health.',
                  contactNumber: '91-22-2772-6771',
                  website: 'https://snehi.org',
                ),
                HelplineCard(
                  orgName: 'NIMHANS',
                  description: 'Psychological support and interventions.',
                  contactNumber: '080-4611-0007',
                  website: 'https://nimhans.ac.in',
                ),
                HelplineCard(
                  orgName: 'iCall by TATA Institute',
                  description: 'Psychological chat and call support for Youth',
                  contactNumber: '9152987821',
                  website: 'https://icallhelpline.org/',
                ),
                HelplineCard(
                  orgName: 'Champs Helpline by iCall',
                  description: 'Counselling service for Children and Adolsccent',
                  contactNumber: '1800 22 2211',
                  website: 'https://icallhelpline.org/',
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HelplineCard extends StatelessWidget {
  final String orgName;
  final String description;
  final String contactNumber;
  final String website;

  HelplineCard({
    required this.orgName,
    required this.description,
    required this.contactNumber,
    required this.website,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orgName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  contactNumber,
                  style: TextStyle(fontSize: 16, color: Colors.teal[100]),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _launchCaller(contactNumber),
                  child: Text('Call Now'),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Website Link
            GestureDetector(
              onTap: () => _launchURL(website),
              child: Text(
                website,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to initiate a call
  void _launchCaller(String number) async {
    final url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to open website in browser
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
