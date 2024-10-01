import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

String fname = '';
String lname = '';
String email = '';
String username = '';
String password = '';
String? selectedCountry;


class SignUpState extends State<SignUp> {

  final List<Map<String, dynamic>> _allCountries = [
    {'name': 'Algeria', 'code': 'DZ'},
    {'name': 'Angola', 'code': 'AO'},
    {'name': 'Benin', 'code': 'BJ'},
    {'name': 'Botswana', 'code': 'BW'},
    {'name': 'Burkina Faso', 'code': 'BF'},
    {'name': 'Burundi', 'code': 'BI'},
    {'name': 'Cameroon', 'code': 'CM'},
    {'name': 'Cape Verde', 'code': 'CV'},
    {'name': 'Central African Republic', 'code': 'CF'},
    {'name': 'Chad', 'code': 'TD'},
    {'name': 'Comoros', 'code': 'KM'},
    {'name': 'Congo, Democratic Republic of the', 'code': 'CD'},
    {'name': 'Congo, Republic of the', 'code': 'CG'},
    {'name': 'Côte d\'Ivoire', 'code': 'CI'},
    {'name': 'Djibouti', 'code': 'DJ'},
    {'name': 'Egypt', 'code': 'EG'},
    {'name': 'Equatorial Guinea', 'code': 'GQ'},
    {'name': 'Eritrea', 'code': 'ER'},
    {'name': 'Eswatini', 'code': 'SZ'},
    {'name': 'Ethiopia', 'code': 'ET'},
    {'name': 'Gabon', 'code': 'GA'},
    {'name': 'Gambia', 'code': 'GM'},
    {'name': 'Ghana', 'code': 'GH'},
    {'name': 'Guinea', 'code': 'GN'},
    {'name': 'Guinea-Bissau', 'code': 'GW'},
    {'name': 'Kenya', 'code': 'KE'},
    {'name': 'Lesotho', 'code': 'LS'},
    {'name': 'Liberia', 'code': 'LR'},
    {'name': 'Libya', 'code': 'LY'},
    {'name': 'Madagascar', 'code': 'MG'},
    {'name': 'Malawi', 'code': 'MW'},
    {'name': 'Mali', 'code': 'ML'},
    {'name': 'Mauritania', 'code': 'MR'},
    {'name': 'Mauritius', 'code': 'MU'},
    {'name': 'Morocco', 'code': 'MA'},
    {'name': 'Mozambique', 'code': 'MZ'},
    {'name': 'Namibia', 'code': 'NA'},
    {'name': 'Niger', 'code': 'NE'},
    {'name': 'Nigeria', 'code': 'NG'},
    {'name': 'Rwanda', 'code': 'RW'},
    {'name': 'Sao Tome and Principe', 'code': 'ST'},
    {'name': 'Senegal', 'code': 'SN'},
    {'name': 'Seychelles', 'code': 'SC'},
    {'name': 'Sierra Leone', 'code': 'SL'},
    {'name': 'Somalia', 'code': 'SO'},
    {'name': 'South Africa', 'code': 'ZA'},
    {'name': 'South Sudan', 'code': 'SS'},
    {'name': 'Sudan', 'code': 'SD'},
    {'name': 'Tanzania', 'code': 'TZ'},
    {'name': 'Togo', 'code': 'TG'},
    {'name': 'Tunisia', 'code': 'TN'},
    {'name': 'Uganda', 'code': 'UG'},
    {'name': 'Zambia', 'code': 'ZM'},
    {'name': 'Zimbabwe', 'code': 'ZW'},
    // Add more countries here
  ];

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> sign_up(String email, String fname, String lname, String username, String password, String selectedCountry, BuildContext context) async {
    
    try {
      final LoginDetails = await auth.createUserWithEmailAndPassword(email: email, password: password);
      final userRef = database.ref().child('users/${LoginDetails.user!.uid}');

      final SharedPreferences userUID = await SharedPreferences.getInstance();

      await userUID.setString('UID', LoginDetails.user!.uid);

      // 3. Prepare user data to be stored
      final userData = {
        'email': email,
        'firstName': fname,
        'lastName': lname,
        'username': username,
        'selectedCountry': selectedCountry,
      };
        
      // 4. Write user data to the database (overwrites existing data)
      await userRef.set(userData);  

      Navigator.pushNamed(context, 'landingUi');
    } on FirebaseAuthException catch(e) {
      // Handle FirebaseAuth errors (e.g., weak password, email already in use)
      print('Firebase Auth Error: ${e.code}');

      if (e.code == 'email-already-in-use') {
        print('email-already-in-use');
      }
    } catch(e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent,
                    //Colors.red,
                    Color(0xff281537)
                  ]
                )
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                
                    color: Theme.of(context).cardColor,
                  ),
              
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                    
                        _inputbuilder(labelText: "First name", hintText: "Enter First Name", hideText: false),
                    
                        const SizedBox(height: 20),
                    
                        _inputbuilder(labelText: "Last name", hintText: "Enter Last Name", hideText: false),
                    
                        const SizedBox(height: 20),
                    
                        _inputbuilder(labelText: "Email", hintText: "Enter Email", hideText: false),
                    
                        const SizedBox(height: 20),
                    
                        _inputbuilder(labelText: "Username", hintText: "Enter Username", hideText: false),
                    
                        const SizedBox(height: 20),
                    
                        _inputbuilder(labelText: "Password", hintText: "Enter Password", hideText: true),
                    
                        const SizedBox(height: 20),
                    
                        dropdown(),
                    
                        const SizedBox(height: 20),
                    
                        _buttonbuilder(context: context, btnText: "Sign Up", sign_up: () {sign_up(email, fname, lname, username, password, selectedCountry!, context);}),
                    
                    
                        const SizedBox(height: 5),
                    
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            children: [
                              const Text(
                                "Already have an account, "
                              ),
                          
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/");
                                }, 
                                child: const Text("Log in")
                              )
                            ],
                          ),
                        )
                    
                    
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  // String? selectedCountry;

  Widget dropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded( // <-- Wrap with Expanded
            child: DropdownButtonFormField<String>(
              value: selectedCountry,
              hint: const Text("Select Country"),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountry = newValue;
                });
              },
              items: _allCountries.map((country) {
                return DropdownMenuItem<String>(
                  value: country['name'],
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust factor as needed
                    ),
                    child: Row(
                      children: [
                        Flag.fromString(
                          country['code'],
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 5),
                        Expanded( // <-- Wrap the Text widget with Expanded
                          child: Text(country['name']),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );

  }

}



Widget _buttonbuilder ({required BuildContext context, required String btnText, required VoidCallback sign_up}) {
  return SizedBox(
    height: 50,
    width: MediaQuery.of(context).size.width * 0.90,
    child: ElevatedButton(
      onPressed: sign_up,

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


Widget _inputbuilder({required String labelText, required String hintText, required bool hideText}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextFormField(
      obscureText: hideText,
      onChanged: (value) {
        if (labelText =='First name') {
          fname = value;
        }
        if (labelText =='Last name') {
          lname = value;
        }
        if (labelText =='Email') {
          email = value;
        }
        if (labelText =='Username') {
          username = value;
        }
        if (labelText =='Password') {
          password = value;
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(
          //color: Colors.black,
        ),
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 74, 74, 74),
        ),
    
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    ),
  );
}