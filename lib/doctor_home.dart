import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'index.dart';

class DoctorHomePage extends StatelessWidget {
  final String doctorUid = "dxkJ8bwKBWYWFc1LuFKyLM2pRlr1"; // Replace with actual doctor UID.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Manage Slots"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageSlotsPage(doctorUid: doctorUid),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text("Pending Requests"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PendingRequestsPage(doctorUid: doctorUid),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text("Scheduled Appointments"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduledAppointmentsPage(doctorUid: doctorUid),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ManageSlotsPage extends StatefulWidget {
  final String doctorUid;

  const ManageSlotsPage({Key? key, required this.doctorUid}) : super(key: key);

  @override
  State<ManageSlotsPage> createState() => _ManageSlotsPageState();
}

class _ManageSlotsPageState extends State<ManageSlotsPage> {
  final List<String> timeSlots = ["10:00 AM - 12:00 PM", "12:00 PM - 2:00 PM", "6:00 PM - 7:00 PM"];
  List<String> selectedSlots = [];

  @override
  void initState() {
    super.initState();
    fetchSelectedSlots();
  }

  void fetchSelectedSlots() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(widget.doctorUid).get();
    List<dynamic> slots = (doc.data() as Map<String, dynamic>)['availableSlots'] ?? [];

    setState(() {
      selectedSlots = List<String>.from(slots);
    });
  }

  List<Map<String, String>> generateNext7DaysSlots() {
    DateTime today = DateTime.now();
    List<Map<String, String>> allSlots = [];

    for (int i = 0; i < 7; i++) {
      DateTime date = today.add(Duration(days: i));
      String dateFormatted = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      String dayName = _getDayName(date.weekday);

      for (String timeSlot in timeSlots) {
        allSlots.add({
          "date": dateFormatted,
          "day": dayName,
          "time": timeSlot,
        });
      }
    }
    return allSlots;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "";
    }
  }

  void addSlot(Map<String, String> slot) async {
    String fullSlot = "${slot['date']} (${slot['day']}) - ${slot['time']}";
    if (!selectedSlots.contains(fullSlot)) {
      await FirebaseFirestore.instance.collection('users').doc(widget.doctorUid).update({
        'availableSlots': FieldValue.arrayUnion([fullSlot]),
      });
      setState(() {
        selectedSlots.add(fullSlot);
      });
    }
  }

  void removeSlot(Map<String, String> slot) async {
    String fullSlot = "${slot['date']} (${slot['day']}) - ${slot['time']}";
    if (selectedSlots.contains(fullSlot)) {
      await FirebaseFirestore.instance.collection('users').doc(widget.doctorUid).update({
        'availableSlots': FieldValue.arrayRemove([fullSlot]),
      });
      setState(() {
        selectedSlots.remove(fullSlot);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> slots = generateNext7DaysSlots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Slots"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: slots.length,
        itemBuilder: (context, index) {
          Map<String, String> slot = slots[index];
          String fullSlot = "${slot['date']} (${slot['day']}) - ${slot['time']}";
          bool isSelected = selectedSlots.contains(fullSlot);

          return ListTile(
            title: Text("${slot['date']} (${slot['day']})"),
            subtitle: Text(slot['time']!),
            trailing: isSelected
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green), // Green tick for selected slots
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeSlot(slot), // Remove slot
                ),
              ],
            )
                : ElevatedButton(
              onPressed: () => addSlot(slot), // Add slot
              child: Text("Add Slot"),
            ),
          );
        },
      ),
    );
  }
}




class PendingRequestsPage extends StatelessWidget {
  final String doctorUid;

  const PendingRequestsPage({Key? key, required this.doctorUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Requests"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorUid', isEqualTo: doctorUid)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var requests = snapshot.data!.docs;
          if (requests.isEmpty) return Center(child: Text("No pending requests."));

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(request['patientName']),
                  subtitle: Text("Requested Slot: ${request['requestedSlot']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          // Confirm the appointment
                          await FirebaseFirestore.instance
                              .collection('appointments')
                              .doc(requests[index].id)
                              .update({
                            'status': 'confirmed',
                            'scheduledSlot': request['requestedSlot'], // Store requestedSlot as scheduledSlot
                          });

                          await FirebaseFirestore.instance.collection('notifications').add({
                            'userUid': request['patientUid'],
                            'message': "Your appointment has been confirmed for ${request['requestedSlot']}.",
                            'timestamp': Timestamp.now(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Appointment confirmed."),
                            backgroundColor: Colors.green,
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('appointments')
                              .doc(requests[index].id)
                              .update({'status': 'rejected'});

                          await FirebaseFirestore.instance.collection('notifications').add({
                            'userUid': request['patientUid'],
                            'message': "Your appointment request was rejected.",
                            'timestamp': Timestamp.now(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Appointment rejected."),
                            backgroundColor: Colors.red,
                          ));
                        },
                      ),
                    ],
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
class ScheduledAppointmentsPage extends StatelessWidget {
  final String doctorUid;

  const ScheduledAppointmentsPage({Key? key, required this.doctorUid}) : super(key: key);

  /// Deletes expired appointments based on `scheduledSlot` field.
  Future<void> deleteExpiredAppointments() async {
    final now = DateTime.now(); // Current date

    try {
      // Fetch appointments for the doctor that are confirmed
      final expiredAppointments = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorUid', isEqualTo: doctorUid)
          .where('status', isEqualTo: 'confirmed')
          .get();

      for (var doc in expiredAppointments.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Extract the scheduledSlot date
        String scheduledSlot = data['scheduledSlot'];
        String slotDate = scheduledSlot.split(' ')[0]; // Extract the date part only
        DateTime scheduledDate = DateTime.parse(slotDate);

        // Check if the appointment date is in the past
        if (scheduledDate.isBefore(DateTime(now.year, now.month, now.day))) {
          // Delete the expired appointment from Firestore
          await doc.reference.delete();
        }
      }
    } catch (e) {
      print("Error deleting expired appointments: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scheduled Appointments"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        future: deleteExpiredAppointments(), // Delete expired appointments before showing
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .where('doctorUid', isEqualTo: doctorUid)
                .where('status', isEqualTo: 'confirmed')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

              var appointments = snapshot.data!.docs;
              if (appointments.isEmpty) return Center(child: Text("No scheduled appointments."));

              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  var appointment = appointments[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text("Patient: ${appointment['patientName']}"),
                      subtitle: Text("Scheduled Slot: ${appointment['scheduledSlot']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.video_call, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndexPage(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () async {
                              bool confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Cancel Appointment"),
                                  content: Text(
                                    "Are you sure you want to cancel the appointment with ${appointment['patientName']}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text("No"),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text("Yes"),
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm) {
                                await FirebaseFirestore.instance
                                    .collection('appointments')
                                    .doc(appointments[index].id)
                                    .update({'status': 'cancelled by doctor'});

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Appointment cancelled successfully."),
                                  backgroundColor: Colors.red,
                                ));
                              }
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
        },
      ),
    );
  }
}
