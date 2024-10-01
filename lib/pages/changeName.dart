import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({super.key});

  @override
  ChangeNameState createState() => ChangeNameState();
}

String fname = '';
String lname = '';

String Changedfname = '';
String Changedlname = '';

FirebaseDatabase database = FirebaseDatabase.instance;

Future<void> SaveChanges(String ChangedFirstName, String ChangedLastName) async {
  final SharedPreferences userUID = await SharedPreferences.getInstance();
  final String? uid = userUID.getString('UID');

  final userRef = database.ref().child('users/${uid}');

  Map<String, String> userData;

  if(ChangedFirstName == "") {
    userData = {
      'lastName': ChangedLastName,
    };
  } else if (ChangedLastName == "") {
    userData = {
      'firstName': ChangedFirstName,
    };

  } else {
    userData = {
      'firstName': ChangedFirstName,
      'lastName': ChangedLastName,
    };
  }


  
    
  // 4. Write user data to the database (overwrites existing data)
  await userRef.update(userData);  
}

class ChangeNameState extends State<ChangeName> {

  

  Future<void> Names() async {
    final SharedPreferences userUID = await SharedPreferences.getInstance();

    fname = userUID.getString('fname')!;
    lname = userUID.getString('lname')!;
  }

  @override
  void initState() {
    super.initState();
    Names();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Name"),
      ),

      body: SafeArea(
      child: Column( // Use a Column for the entire body
        children: <Widget>[
          Expanded( // This pushes the button to the bottom
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _textFieldBuilder(LabelText: "First Name", HintText: "Enter First Name", initialText: fname),
                  _textFieldBuilder(LabelText: "Last Name", HintText: "Enter Last Name", initialText: lname),
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

Widget _textFieldBuilder({required String LabelText, required String HintText, required String initialText}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      onChanged: (value) {
        if (LabelText == "First Name") {
          Changedfname = value;
        } else if (LabelText == "Last Name") {
          Changedlname = value;
        }
      },
      initialValue: initialText,
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
        SaveChanges(Changedfname, Changedlname);
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