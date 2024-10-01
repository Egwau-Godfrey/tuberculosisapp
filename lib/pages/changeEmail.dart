import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  ChangeEmailState createState() => ChangeEmailState();
}

String email = '';

String ChangedEmails = '';

String _newPassword = '';

FirebaseDatabase database = FirebaseDatabase.instance;


String _currentEmail = '';


class ChangeEmailState extends State<ChangeEmail> {
  final _formKey = GlobalKey<FormState>();
  
  String _newEmail = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentEmail();
  }

  Future<String> _loadCurrentEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    return email ?? ''; // Return the email or an empty string if it's null
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser!;
        await user.verifyBeforeUpdateEmail(_newEmail); 

        print(_newEmail);

        // 4. Update the database after successful email verification
        final prefs = await SharedPreferences.getInstance();
        final uid = prefs.getString('UID');
        if (uid != null) {
          await FirebaseDatabase.instance.ref().child('users/$uid').update({
            'email': _newEmail,
          });
        }

        // Update the email in SharedPreferences
        await prefs.setString('email', _newEmail);

        // Optionally, reauthenticate to refresh credentials
        await user.reauthenticateWithCredential(EmailAuthProvider.credential(
          email: user.email!,
          password: _newPassword, // This should be obtained securely!
        )); 

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          // Handle reauthentication flow here (e.g., show a login dialog)
        } else {
          // Handle other Firebase errors
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            FutureBuilder<String>(
              future: _loadCurrentEmail(), // Load current email here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while fetching
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  _currentEmail = snapshot.data ?? ''; // Update _currentEmail with fetched value
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: _currentEmail, // Display _currentEmail
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Current Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "New Email",
                  hintText: "Enter New Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) => _newEmail = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) => _newPassword = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please password to confirm change';
                  }
                  // if (!value.contains()) {
                  //   return 'Please enter password';
                  // }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text("Save", style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}