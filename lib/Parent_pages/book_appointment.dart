import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookAppointment extends StatefulWidget {
  final String parentEmail;

  const BookAppointment({required this.parentEmail, Key? key}) : super(key: key);

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  String? selectedDoctor;
  String? selectedDay;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Select Doctor:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'Psychiatrist')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No doctors available.', style: TextStyle(color: Colors.grey));
                }

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDoctor = data['username'];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedDoctor == data['username'] ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green),
                          boxShadow: [
                            if (selectedDoctor == data['username'])
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 10,
                              ),
                          ],
                        ),
                        child: Text(
                          data['username'] ?? 'Unknown',
                          style: TextStyle(
                            color: selectedDoctor == data['username'] ? Colors.white : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Select Day:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((day) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedDay == day ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                      boxShadow: [
                        if (selectedDay == day)
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                      ],
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: selectedDay == day ? Colors.white : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (selectedDay != null) ...[
              const Text('Select Time:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: ['9:00 AM', '10:00 AM', '11:00 AM', '2:00 PM', '4:00 PM'].map((time) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedTime == time ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green),
                        boxShadow: [
                          if (selectedTime == time)
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                        ],
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: selectedTime == time ? Colors.white : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: selectedDoctor != null && selectedDay != null && selectedTime != null
                  ? () async {
                      try {
                        // Check if the appointment is already booked for the selected doctor, day, and time
                        var existingAppointment = await FirebaseFirestore.instance
                            .collection('appointments')
                            .where('doctorname', isEqualTo: selectedDoctor)
                            .where('day', isEqualTo: selectedDay)
                            .where('time', isEqualTo: selectedTime)
                            .get();

                        if (existingAppointment.docs.isNotEmpty) {
                          // If an appointment already exists for the selected time, show a message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Appointment at this time is already booked.')),
                          );
                        } else {
                          // If no appointment exists, proceed with creating a new appointment request
                          await FirebaseFirestore.instance.collection('appointments').add({
                            'doctorname': selectedDoctor,
                            'day': selectedDay,
                            'time': selectedTime,
                            'status': 'pending',
                            'parentEmail': widget.parentEmail,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Appointment request sent successfully!')),
                          );
                          setState(() {
                            selectedDoctor = null;
                            selectedDay = null;
                            selectedTime = null;
                          });
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $error')),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Submit Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
