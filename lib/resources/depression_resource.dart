import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaddy/navigator_drawer.dart';

class DepLiteraturePage extends StatefulWidget {
  @override
  _DepLiteraturePageState createState() => _DepLiteraturePageState();
}

class _DepLiteraturePageState extends State<DepLiteraturePage> {
  // Store file paths for downloaded PDFs
  List<String?> localFilePaths = List.filled(8, null);

  @override
  void initState() {
    super.initState();
    downloadAndSavePdfs();
  }

  Future<void> downloadAndSavePdfs() async {
    final pdfUrls = [
      'https://drive.google.com/uc?export=download&id=12VVXB2Oy_isrSwADUFVnIXAwVYOUKCSF', // Book 1 URL
      'https://drive.google.com/uc?export=download&id=1-xEtlfLrDPQB4VHACgxPpD6wz9NF6lS0', // Book 2 URL
      'https://drive.google.com/uc?export=download&id=1eMsoZIUmI5ccIn4ObEk-UDjG4X4Zcm3_', // Book 3 URL
      'https://drive.google.com/uc?export=download&id=1GuUmulfVhifM0uv-ESkvqZNl9Uw2dpzZ', // Book 4 URL
      'https://drive.google.com/uc?export=download&id=1t7ztpcZ_eCxHrqUDp1No1BkiQIXe-JRj', // Book 5 URL
      'https://drive.google.com/uc?export=download&id=121wg_d9NNGNSSdX_5bjyXGVfH5Gxl3lj', // Book 6 URL
      'https://drive.google.com/uc?export=download&id=1BcdXRqr1ptrx0f9CczFn627lhn_G0Nzm', // Book 7 URL
    ];

    final dir = await getApplicationDocumentsDirectory();

    for (int i = 0; i < pdfUrls.length; i++) {
      final fileName = 'book${i + 1}.pdf';
      final filePath = '${dir.path}/$fileName';

      try {
        await Dio().download(pdfUrls[i], filePath);
        setState(() {
          localFilePaths[i] = filePath;
        });
      } catch (e) {
        print('Error downloading file $i: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookData = [
      {'title': 'Book 1: Ikigai', 'subtitle': '-Hector Garcia', 'image': 'assets/book11.png'},
      {'title': 'Book 2: Feeling Good', 'subtitle': '-David D Burns', 'image': 'assets/book2.png'},
      {'title': 'Book 3: Overcoming Depression ', 'subtitle': 'Effective coping methods', 'image': 'assets/book13.png'},
      {'title': 'Book 4: Depression Cure', 'subtitle': 'The six step process', 'image': 'assets/book14.png'},
      {'title': 'Book 5: Reasons to Stay Alive','subtitle' :'.'  ,'image': 'assets/book15.png'},
      {'title': 'Book 6:The Last Lecture', 'subtitle': 'Randy Pausch', 'image': 'assets/book16.png'},
      {'title': 'Book 7: Positive Thinking', 'subtitle': 'Cultivate positive thoughts', 'image': 'assets/book7.png'},

    ];

    return Scaffold(
      appBar: AppBar(title: Text('Depression Literature')),
      drawer: const AppNavigator(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: bookData.length,
          itemBuilder: (context, index) {
            return BookCard(
              title: bookData[index]['title']!,
              subtitle: bookData[index]['subtitle']!,
              image: AssetImage(bookData[index]['image']!),
              onTap: () {
                if (localFilePaths[index] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerPage(localFilePath: localFilePaths[index]!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("File is still downloading. Please wait...")),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider image;
  final VoidCallback onTap;

  BookCard({required this.title, required this.subtitle, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image(image: image, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold , fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final String localFilePath;

  PDFViewerPage({required this.localFilePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book PDF Viewer')),
      body: PDF().fromPath(localFilePath),
    );
  }
}



class DepExercisePage extends StatelessWidget {
  final List<Map<String, String>> videoData = [
    {
      'url': 'https://youtu.be/Sxddnugwu-8?si=V2DtD4B2s2UdIfyi',
      'title': 'Yoga for Depression'
    },
    {
      'url': 'https://youtu.be/Bk0lzv8hEU8?si=-m86s0OHliJrXE3V',
      'title': '5 ways to deal with depression'
    },
  ];

  final List<Map<String, String>> articleData = [
    {
      'title': '7 exercises to ease Depression',
      'url': 'https://www.everydayhealth.com/depression-pictures/great-exercises-to-fight-depression.aspx',
    },
    {
      'title': 'How exercise helps better than Drugs',
      'url': 'https://www.medicalnewstoday.com/articles/is-exercise-more-effective-than-medication-for-depression-and-anxiety',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Depression Exercises')),
      drawer: const AppNavigator(),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          SectionTitle(title: 'Video Exercises'),
          ...videoData.map((data) => VideoCard(data: data)).toList(),

          SectionTitle(title: 'Exercise Articles'),
          ...articleData.map((data) => ArticleCard(data: data)).toList(),
        ],
      ),
    );
  }
}

// Section title widget
class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }
}

// Card for displaying video with title and thumbnail
class VideoCard extends StatelessWidget {
  final Map<String, String> data;

  VideoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(data['url']!)!;
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        title: Text(data['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Tap to watch'),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(thumbnailUrl, fit: BoxFit.cover, width: 80),
        ),
        trailing: Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 32),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => YouTubePlayerPage(videoUrl: data['url']!),
            ),
          );
        },
      ),
    );
  }
}

// Card for displaying articles
class ArticleCard extends StatelessWidget {
  final Map<String, String> data;

  ArticleCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        title: Text(
          data['title']!,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () => _launchUrl(data['url']!),
      ),
    );
  }
}

// YouTube player page
class YouTubePlayerPage extends StatefulWidget {
  final String videoUrl;

  YouTubePlayerPage({required this.videoUrl});

  @override
  _YouTubePlayerPageState createState() => _YouTubePlayerPageState();
}

class _YouTubePlayerPageState extends State<YouTubePlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl)!;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise Video')),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }
}

// Helper function to launch URLs
void _launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


class DepVideoPage extends StatelessWidget {
  // List of YouTube channel data
  final List<Map<String, String>> youtubeChannels = [
    {
      'name': 'Calm Sage',
      'image': 'assets/calm_sage.jpg', // Replace with your asset path
      'description': 'Mindfulness and guided meditations.',
      'url': 'https://www.youtube.com/c/CalmSage',
    },
    {
      'name': 'Therapy in a Nutshell',
      'image': 'assets/therapy_nutshell.jpg', // Replace with your asset path
      'description': 'Simplifying mental health concepts.',
      'url': 'https://www.youtube.com/c/TherapyinaNutshell',
    },

    {
      'name': 'Psych2Go',
      'image': 'assets/Psy2go.jpg', // Replace with your asset path
      'description': 'Varios Mental Illness related info.',
      'url': 'https://www.youtube.com/c/TheAnxietyGuy',
    },
    {
      'name': 'Headspace',
      'image': 'assets/headspace.jpg', // Replace with your asset path
      'description': 'Mindfulness meditations and animations.',
      'url': 'https://www.youtube.com/c/Headspace',
    },
  ];

  // Function to open a URL
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depression Videos'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const AppNavigator(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: youtubeChannels.length,
          itemBuilder: (context, index) {
            final channel = youtubeChannels[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(channel['image']!),
                  radius: 25,
                ),
                title: Text(
                  channel['name']!,
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  channel['description']!,
                  style: const TextStyle(fontSize: 14.0),
                ),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _launchURL(channel['url']!),
              ),
            );
          },
        ),
      ),
    );
  }
}




