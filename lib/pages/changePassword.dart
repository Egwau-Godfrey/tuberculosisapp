import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

String password = "";
String NewPassword = "";
String ConfirmNewPassword = "";


Future<void> _saveChanges() async {
  if(NewPassword == ConfirmNewPassword){
    try {
      final user = FirebaseAuth.instance.currentUser!;
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password, // Get user's current password
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Update password with new password
      await user.updatePassword(ConfirmNewPassword);

      // Show success message or navigate to another screen
    } on FirebaseAuthException catch (e) {
      // Handle other errors (e.g., weak password)
    } catch (e) {
      // Handle other exceptions
    }
  }
}

class ChangePasswordState extends State<ChangePassword> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _textFieldBuilder(LabelText: "Enter Current Password", HintText: "Enter Current Password", visible: false),

                    _textFieldBuilder(LabelText: "New Password", HintText: "Enter New Password", visible: false),

                    _textFieldBuilder(LabelText: "Confirm Password", HintText: "Enter New Password", visible: true),
                  ],
                ),
              ),
            ),

            _buttonbuilder(context: context, btnText: "Save"),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _textFieldBuilder({required String LabelText, required String HintText, required bool visible}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      onChanged: (value) {
        if(LabelText == "Enter Current Password") {
          password = value;
        } else if(LabelText == "New Password") {
          NewPassword = value;
        } else if(LabelText == "Confirm Password") {
          ConfirmNewPassword = value;
        }
      },
      obscureText: visible,
      decoration: InputDecoration(
        labelText: LabelText,
        hintText: HintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      
      ),
    ),
  );
}


Widget _buttonbuilder ({required BuildContext context, required String btnText}) {
  return SizedBox(
    height: 50,
    width: MediaQuery.of(context).size.width * 0.95,
    child: ElevatedButton(
      onPressed: () {
        _saveChanges();
        Navigator.pop(context);
      },

      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),

      child: Text(
        btnText,
        style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
      ),
    ),
  );
}