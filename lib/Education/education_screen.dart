import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationScreen extends StatelessWidget {
  // List of clickable items with titles and URLs
  final List<Map<String, String>> educationItems = [
    {'title': 'Flutter Documentation', 'url': 'https://flutter.dev/docs'},
    {'title': 'Dart Programming Language', 'url': 'https://dart.dev'},
    {'title': 'Stack Overflow', 'url': 'https://stackoverflow.com'},
    {'title': 'Medium Blogs', 'url': 'https://medium.com'},
    {'title': 'GitHub', 'url': 'https://github.com'},
  ];

  // Function to handle URL opening
  void _openUrl(String url) async {
    print('Attempting to open URL: $url');
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      print('URL opened successfully');
    } else {
      print('Could not open URL: $url');
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('Could not open URL')));
    }
  }

  // Global key for showing error feedback
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Education Resources'),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
          itemCount: educationItems.length,
          itemBuilder: (context, index) {
            final item = educationItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: const Icon(Icons.link, color: Colors.green),
                title: Text(
                  item['title']!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
                onTap: () {
                  _openUrl(item['url']!);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
