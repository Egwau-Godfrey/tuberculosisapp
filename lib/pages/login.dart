import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height * 0.75,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Login extends StatefulWidget {
  Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
      final SharedPreferences userUID = await SharedPreferences.getInstance();
      await userUID.setString('UID', credentials.user!.uid);

      Navigator.pushNamed(context, 'landingUi');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          error = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          error = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          error = 'Invalid email.';
        } else if (e.code == 'invalid-credential') {
          error = 'Invalid email or password.';
        } else {
          error = 'An unknown error occurred.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: NewClipper(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.redAccent,
                            Color(0xff281537),
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Image.asset(
                        'lib/images/logo.png',
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                "Tuberculosis Testing",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                error,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              _inputBuilder(labelText: "Email", hintText: "Email", hideText: false, validator: validateEmail),
              const SizedBox(height: 20),
              _inputBuilder(labelText: "Password", hintText: "Enter Password", hideText: true, validator: validatePassword),
              const SizedBox(height: 40),
              _buttonBuilder(
                context: context,
                btnText: "Login",
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    signIn(email, password, context);
                  }
                },
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    const Text("Don't have an account, "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "SignUp");
                      },
                      child: const Text("create one"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputBuilder({required String labelText, required String hintText, required bool hideText, required FormFieldValidator<String> validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: hideText,
        onChanged: (value) {
          if (labelText == "Email") {
            email = value;
          } else if (labelText == "Password") {
            password = value;
          }
        },
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buttonBuilder({required BuildContext context, required String btnText, required VoidCallback onPress}) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.90,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          btnText,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}
