import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationScreen extends StatelessWidget {
  // List of clickable items with titles and URLs
  final List<Map<String, String>> educationItems = [
    {'title': 'Dyscalculia Information Centre', 'url': 'https://www.dyscalculia.me.uk'},
    {'title': 'Dyscalculia Blog', 'url': 'https://dyscalculia-blog.com'},
    {'title': 'About Dyscalculia', 'url': 'https://www.bdadyslexia.org.uk/dyscalculia'},
    {'title': 'Explore Dyscalculia', 'url': 'https://my.clevelandclinic.org/health/diseases/23949-dyscalculia'},
    {'title': 'What is dyscalculia?', 'url': 'https://www.understood.org/en/articles/what-is-dyscalculia'},
  ];

  // Function to handle URL opening
  void _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not open URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Resources', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black, // Set the AppBar to black
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFDE59), Color(0xFFF7B4C6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF7F7F7), // Set the background of the screen to off-white
      body: ListView.builder(
        itemCount: educationItems.length,
        itemBuilder: (context, index) {
          final item = educationItems[index];
          final colors = [
            const Color(0xFFFFDE59),
            const Color(0xFFF7B4C6),
            const Color(0xFF373E37)
          ];
          final color = colors[index % colors.length];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.link, color: Colors.white),
                title: Text(
                  item['title']!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                onTap: () {
                  _openUrl(item['url']!);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
