import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final ValueNotifier<bool> isDarkModeNotifier;

  const Settings({required this.isDarkModeNotifier, super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Settings> {

  Future<void> clearData() async {
    final SharedPreferences userUID = await SharedPreferences.getInstance();
    userUID.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left:12),
              child: Text(
                "Settings",
                style: TextStyle(
                  //color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.only(left:12),
              child: Text(
                "General",
                style: TextStyle(
                  //color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dark_mode),
                      title: const Text("Dark Mode"),
                      trailing: Switch(
                        value: widget.isDarkModeNotifier.value,
                        onChanged: (bool value) {
                          setState(() {
                            widget.isDarkModeNotifier.value = value;
                            
                          });
                        }
                      ),
                    ),

                    _buildDivider(),
              
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text("Notifications"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),

                    _buildDivider(),
              
                    ListTile(
                      leading: const Icon(Icons.question_mark),
                      title: const Text("Help and FAQ"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, "HelpAndFAQ");
                      },
                    )
                  ],
                ),
              ),
            ),


            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.only(left:12),
              child: Text(
                "Policy and account terms",
                style: TextStyle(
                  //color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 4),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text("Privacy policy"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, "Privacy");
                      },
                    ),

                    _buildDivider(),
              
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text("Terms and conditions"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, "TermsAndCondition");
                      },
                    )
                  ],
                ),
              ),
            ),


            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.thumb_up_alt_outlined),
                      title: const Text("Leave feedback"),
                      subtitle: const Text("Let us know what you think of the app"),
                      onTap: () {},
                    ),

                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  clearData();
                  Navigator.pushNamed(context, '/');
                }, 
              
                style: ElevatedButton.styleFrom(
              
                  minimumSize: const Size(450, 50),
              
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
              
                  backgroundColor:Colors.blue,
                  
                ),
              
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  
                ),
              ),
            ),
          ],
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