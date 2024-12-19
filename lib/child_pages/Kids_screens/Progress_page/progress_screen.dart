import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressGraphScreen extends StatelessWidget {
  final String userId;

  const ProgressGraphScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Progress Graph')),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator while fetching data
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('No data found for this user.');
            }

            // Assuming 'scores' is an array of integers in Firestore for the user
            List<dynamic> scores = snapshot.data!['scores'] ?? [];

            // Check if scores are empty and handle it
            if (scores.isEmpty) {
              return Text('No scores available.');
            }

            // Display the graph with scores data
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: scores.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble() + 1, e.value.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.purple,
                      dotData: FlDotData(show: true),
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