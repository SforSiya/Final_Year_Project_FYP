import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentScreen extends StatelessWidget {
  final String doctorId;

  const DoctorAppointmentScreen({Key? key, required this.doctorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: Text("Appointments")),
      body: StreamBuilder(
        stream: _firestore
            .collection('appointments')
            .where('doctorId', isEqualTo: doctorId) // Fetch appointments for the specific doctor
            .where('status', isEqualTo: 'pending') // Only show pending appointments
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No pending appointments."));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                title: Text(
                    "Day: ${appointment['day']} | Time: ${appointment['time']}"),
                subtitle: Text("Parent ID: ${appointment['parentId']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        // Accept appointment
                        await _firestore
                            .collection('appointments')
                            .doc(appointment.id)
                            .update({
                          'status': 'accepted',
                          'doctorId': doctorId,
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        // Reject appointment
                        await _firestore
                            .collection('appointments')
                            .doc(appointment.id)
                            .update({'status': 'rejected'});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
