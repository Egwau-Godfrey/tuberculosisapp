import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuberculosisapp/pages/login.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  ProfileState createState() => ProfileState(); 
}

String email = '';
String fullName = '';
String firstName = '';
String lastName = '';
String selectedCountry = '';

class ProfileState extends State<Profiles> {
  Future<void>? userDataFuture;

  Future<void> fetchUserData() async {
    final SharedPreferences userUID = await SharedPreferences.getInstance();
    final String? uid = userUID.getString('UID');

    if (uid != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/$uid');
      ref.onValue.listen((DatabaseEvent event) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        setState(() {
          email = data['email'];
          firstName = data['firstName'];
          lastName = data['lastName'];
          fullName = '$firstName $lastName';
          selectedCountry = data['selectedCountry'];
        });
      });

      await userUID.setString('country', selectedCountry);
      await userUID.setString('fname', firstName);
      await userUID.setString('lname', lastName);
      await userUID.setString('email', email);
    }
  }

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text(email, style: TextStyle(fontSize: 14)),
                              subtitle: Text(fullName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text("Country"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.pushNamed(context, "Country");
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              title: const Text("Change Name"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.pushNamed(context, "ChangeName");
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              title: const Text("Change Email"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.pushNamed(context, "ChangeEmail");
                              },
                            ),
                            _buildDivider(),
                            ListTile(
                              title: const Text("Change Password"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.pushNamed(context, "ChangePassword");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
