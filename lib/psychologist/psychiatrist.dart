import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaddy/navigator_drawer.dart';

class PsychiatristSearchPage extends StatefulWidget {
  @override
  _PsychiatristSearchPageState createState() => _PsychiatristSearchPageState();
}

class _PsychiatristSearchPageState extends State<PsychiatristSearchPage> {
  final TextEditingController _cityController = TextEditingController();
  List<Map<String, dynamic>> _psychiatrists = [];
  List<Map<String, dynamic>> _filteredResults = [];
  List<Map<String, dynamic>> _ourTeam = [];
  bool isLoading = false;

  // Function to load CSV data
  Future<void> loadCsvData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final csvString = await rootBundle.loadString('assets/data/psychiatrists.csv');
      List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);

      // Convert CSV rows to a list of maps for easier handling
      final headers = csvData.first.map((e) => e.toString()).toList();
      _psychiatrists = csvData
          .skip(1) // Skip headers
          .map((row) => Map<String, dynamic>.fromIterables(headers, row))
          .toList();

      // Include "Anand Psychiatry Clinic" data in the "Our Team" section regardless of city
      _ourTeam = [
        {
          'title': 'Anand Psychiatry Clinic',
          'address': 'Beside Renuka Medical, Opp J.D.C.C Bank Head office, Ring Rd, Jalgaon, Maharashtra 425001, India',
          'phone': '+91 98227 97912',
          'imageUrl': 'https://lh5.googleusercontent.com/p/AF1QipO4QKeNJn6oSBKCFICXKSpI2ZDfbIrwoFTWutYv=w426-h240-k-no',
          'website': 'https://www.google.com/maps/search/?api=1&query=Anand%20Psychiatry%20clinic&query_place_id=ChIJneXhz_MP2TsRI9het3-sUMM',
          'city': 'Jalgaon', // You can set the city as Jalgaon here for display purposes
          'totalScore': '4.5', // Optional, add if required
        },
      ];
    } catch (e) {
      print("Error loading CSV: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to filter results based on city
  void filterResults(String city) {
    setState(() {
      if (city.isEmpty) {
        _filteredResults = [];
      } else {
        _filteredResults = _psychiatrists
            .where((entry) =>
        entry['city']?.toString().toLowerCase() == city.toLowerCase() &&
            entry['title'] != 'Anand Psychiatry Clinic') // Exclude "Our Team"
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadCsvData(); // Load CSV data when the screen initializes
  }

  Widget _buildCard(Map<String, dynamic> psychiatrist) {
    final String? imageUrl = psychiatrist['imageUrl'];
    final bool isImageAvailable = imageUrl != null && imageUrl.isNotEmpty;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              isImageAvailable ? imageUrl : '', // Use imageUrl if valid
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/default.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  psychiatrist['title'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  psychiatrist['address'] ?? 'Address not available',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      psychiatrist['phone'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final website = psychiatrist['website'] ?? '';
                    if (website.isNotEmpty) {
                      final uri = Uri.parse(website);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not open website'),
                          ),
                        );
                      }
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.link, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        psychiatrist['website'] ?? 'Website not available',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Rating: ${psychiatrist['totalScore'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psychiatrist Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => filterResults(_cityController.text),
                ),
              ),
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView(
                children: [
                  // Display "Our Team" section
                  if (_ourTeam.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Our Team',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ..._ourTeam.map((psychiatrist) => _buildCard(psychiatrist)).toList(),
                  ],
                  // Display "Psychiatrists Nearby" section
                  if (_filteredResults.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Psychiatrists Nearby',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ..._filteredResults.map((psychiatrist) => _buildCard(psychiatrist)).toList(),
                  ],
                  // If no results
                  if (_filteredResults.isEmpty && _ourTeam.isEmpty)
                    const Center(
                      child: Text('No psychiatrists found'),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
