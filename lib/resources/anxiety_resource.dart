import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaddy/navigator_drawer.dart';

class AnxLiteraturePage extends StatefulWidget {
  @override
  _AnxLiteraturePageState createState() => _AnxLiteraturePageState();
}

class _AnxLiteraturePageState extends State<AnxLiteraturePage> {
  // Store file paths for downloaded PDFs
  List<String?> localFilePaths = List.filled(8, null);

  @override
  void initState() {
    super.initState();
    downloadAndSavePdfs();
  }

  Future<void> downloadAndSavePdfs() async {
    final pdfUrls = [
      'https://drive.google.com/uc?export=download&id=1A_1WBIMJ6HlPwUaUseMKkqcmU4SJvEeL', // Book 1 URL
      'https://drive.google.com/uc?export=download&id=1-xEtlfLrDPQB4VHACgxPpD6wz9NF6lS0', // Book 2 URL
      'https://drive.google.com/uc?export=download&id=188fqLSJrtwv1L0oS-LeV3qYcUUDoJ6lm', // Book 3 URL
      'https://drive.google.com/uc?export=download&id=18w3_B95JI_Eer688bnI9VMqUgXjL1z_0', // Book 4 URL
      'https://drive.google.com/uc?export=download&id=1OVrds8qn6YluTIfhn2-_fDKOdwwMth1x', // Book 5 URL
      'https://drive.google.com/uc?export=download&id=1uPa9qmZjhWHY5oEQDXRxlsg-h8l-nIh2', // Book 6 URL
      'https://drive.google.com/uc?export=download&id=1BcdXRqr1ptrx0f9CczFn627lhn_G0Nzm', // Book 7 URL
      'https://drive.google.com/uc?export=download&id=18_bWrAqhUwk-0snInqIPkcz5zl9XFBwN', // Book 8 URL
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
      {'title': 'Book 1: Anxiety and Phobia Workbook', 'subtitle': '-EDMUND J BOURNE', 'image': 'assets/book1.png'},
      {'title': 'Book 2: Feeling Good', 'subtitle': '-David D Burns', 'image': 'assets/book2.png'},
      {'title': 'Book 3: ', 'subtitle': 'Effective coping methods', 'image': 'assets/book3.png'},
      {'title': 'Book 4: Mindfulness', 'subtitle': 'Practicing mindfulness', 'image': 'assets/book4.png'},
      {'title': 'Book 5: Emotional Resilience', 'subtitle': 'Building resilience', 'image': 'assets/book5.png'},
      {'title': 'Book 6: Stress Management', 'subtitle': 'Managing stress levels', 'image': 'assets/book6.png'},
      {'title': 'Book 7: Positive Thinking', 'subtitle': 'Cultivate positive thoughts', 'image': 'assets/book7.png'},
      {'title': 'Book 8: Self-Care Basics', 'subtitle': 'Essentials of self-care', 'image': 'assets/book8.png'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Anxiety Literature')),
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



class AnxExercisePage extends StatelessWidget {
  final List<Map<String, String>> videoData = [
    {
      'url': 'https://youtu.be/odADwWzHR24?si=lSmcmn2sutBgCRUB',
      'title': 'Breathing Techniques for Anxiety'
    },
    {
      'url': 'https://youtu.be/I77hh5I69gA?si=u-y0AITeKaIgBhUi',
      'title': 'Mindful Meditation Exercise'
    },
  ];

  final List<Map<String, String>> articleData = [
    {
      'title': '8 Breathing exercises for Anxiety',
      'url': 'https://www.healthline.com/health/breathing-exercises-for-anxiety#long-exhale',
    },
    {
      'title': 'Yoga for Anxiety',
      'url': 'https://www.medicalnewstoday.com/articles/anxiety-for-yoga-benefits-and-poses#poses',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Anxiety Exercises')),
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


class AnxVideoPage extends StatelessWidget {
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
      'name': 'Anxiety Fitness',
      'image': 'assets/self_care_haven.jpg', // Replace with your asset path
      'description': 'Anxiety and self-care strategies.',
      'url': 'https://www.youtube.com/@anxiety_fitness',
    },
    {
      'name': 'The Anxiety Guy',
      'image': 'assets/anxiety_guy.jpg', // Replace with your asset path
      'description': 'Personal experiences and coping tips.',
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
        title: const Text('Anxiety Videos'),
        backgroundColor: Colors.blueAccent,
      ),
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




class AnxGamesPage extends StatelessWidget {
  final List<Map<String, String>> games = [
    {
      'name': 'Calm Breathing Bubble',
      'description': 'A simple breathing exercise to help you calm down.',
      'link': 'https://calm-with-breathing.vercel.app/'
    },
    {
      'name': 'Relaxing Sounds',
      'description': 'Play ambient sounds to relax your mind.',
      'link': 'https://asoftmurmur.com/'
    },
    {
      'name': 'Color Therapy Game',
      'description': 'Choose colors to relax and express your emotions.',
      'link': 'https://www.coolmathgames.com/0-coloring-puzzle'
    },
    {
      'name': 'Soothing Jigsaw Puzzles',
      'description': 'Solve relaxing puzzles for mindfulness.',
      'link': 'https://im-a-puzzle.com/'
    },
    {
      'name': 'Memory Card Game',
      'description': 'Match cards and boost your cognitive skills.',
      'link': 'https://www.brainhq.com/brain-resources/memory-games/'
    },
  ];

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anxiety Games'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game['name']!,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      game['description']!,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () => _launchURL(game['link']!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Play Now'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
