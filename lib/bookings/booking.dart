import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yaddy/navigator_drawer.dart';
import 'package:yaddy/index.dart';

class BookAppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Appointments"),
          backgroundColor: Colors.blueAccent,
          bottom: TabBar(
            tabs: [
              Tab(text: "Book Appointment"),
              Tab(text: "Scheduled Appointments"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Book Appointment Section
            BookAppointmentSection(),

            // Scheduled Appointments Section
            ScheduledAppointmentsSection(),
          ],
        ),
      ),
    );
  }
}

class BookAppointmentSection extends StatelessWidget {
  final Map<String, dynamic> doctorInfo = {
    'name': 'Dr. Uday Bendale',
    'title': 'Anand Psychiatry Clinic',
    'address': 'Beside Renuka Medical, Opp J.D.C.C Bank Head office, Ring Rd, Jalgaon, Maharashtra 425001, India',
    'image': 'assets/doctor.jpg', // Image path in assets folder
    'city': 'Jalgaon',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor's Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                doctorInfo['image'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorInfo['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    doctorInfo['title'],
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    doctorInfo['address'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'City: ${doctorInfo['city']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvailableSlotsPage(),
                          ),
                        );
                      },
                      child: Text("Book Appointment"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
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

class AvailableSlotsPage extends StatelessWidget {
  final String doctorUid = "dxkJ8bwKBWYWFc1LuFKyLM2pRlr1"; // Doctor UID in Firestore.

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Slots"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(doctorUid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<dynamic> slots = snapshot.data!['availableSlots'] ?? [];
          if (slots.isEmpty) {
            return Center(child: Text("No slots available."));
          }

          return ListView.builder(
            itemCount: slots.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(slots[index]),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      // Fetch patient details
                      var patientDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
                      var patientName = patientDoc['name'] ?? 'Unknown'; // Default to 'Unknown' if name is not set

                      // Add appointment request
                      await FirebaseFirestore.instance.collection('appointments').add({
                        'doctorUid': doctorUid,
                        'patientUid': user.uid,
                        'patientName': patientName, // Use the fetched patient name
                        'requestedSlot': slots[index],
                        'status': 'pending',
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Appointment request sent."),
                        backgroundColor: Colors.green,
                      ));
                    },
                    child: Text("Request"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class ScheduledAppointmentsSection extends StatelessWidget {
  final String doctorUid = "dxkJ8bwKBWYWFc1LuFKyLM2pRlr1"; // Doctor UID in Firestore.

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('patientUid', isEqualTo: user!.uid)
          .where('status', isEqualTo: 'confirmed')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var appointments = snapshot.data!.docs;
        if (appointments.isEmpty) {
          return Center(child: Text("No scheduled appointments."));
        }

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            var appointment = appointments[index].data() as Map<String, dynamic>;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text("Slot: ${appointment['scheduledSlot']}"),
                subtitle: Text("Doctor: Dr. Uday Bendale"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(appointments[index].id)
                            .update({'status': 'cancelled by patient'});

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Appointment cancelled."),
                          backgroundColor: Colors.red,
                        ));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.video_call, color: Colors.blue),
                      onPressed: () {
                        // Navigate to the video call page or open a video call link.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IndexPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

