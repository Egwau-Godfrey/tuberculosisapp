import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  Stream<List<Map<String, dynamic>>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _initializeHistory();
  }

  void _initializeHistory() {
    _historyFuture = getHistory();
  }

  Stream<List<Map<String, dynamic>>> getHistory() async* {
    final SharedPreferences userUID = await SharedPreferences.getInstance();
    final String? uid = userUID.getString('UID');

    if (uid == null) {
      yield [];
      return;
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref('users/$uid/saved_history');
    
    yield* ref.onValue.map((event) {
      if (event.snapshot.value != null) {
        dynamic data = event.snapshot.value;
        if (data is Map) {
          Map<String, dynamic> savedHistoryMap = Map<String, dynamic>.from(data);
          List<Map<String, dynamic>> historyList = savedHistoryMap.entries
              .map((e) => Map<String, dynamic>.from(e.value as Map))
              .toList();

          historyList.sort((a, b) {
            DateTime timeA = DateTime.parse(a['time']);
            DateTime timeB = DateTime.parse(b['time']);
            return timeB.compareTo(timeA);
          });

          return historyList;
        }
      }
      return <Map<String, dynamic>>[];
    });
  }

  @override
  Widget build(BuildContext context) {
    _initializeHistory();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  "History",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getHistory(),
                  builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No saved history found.'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final historyItem = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text('Diagnosis: ${historyItem['diagnosis'] ?? 'N/A'}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Confidence: ${historyItem['confidence'] ?? 'N/A'}'),
                                  Text('Time: ${historyItem['time'] ?? 'N/A'}'),
                                ],
                              ),
                            )
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
