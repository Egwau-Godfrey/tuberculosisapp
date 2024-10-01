import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Country extends StatefulWidget {
  const Country({super.key});

  @override
  CountryState createState() => CountryState();
}

class CountryState extends State<Country> {


  Future<void> Country_Selected() async {
    final SharedPreferences userUID = await SharedPreferences.getInstance();
    final String? countryName = userUID.getString('country');

    if (countryName != null) {
      final int index = _allCountries.indexWhere((country) => country['name'] == countryName);
      if (index != -1) {
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  }



  final List<Map<String, dynamic>> _allCountries = [
    {'name': 'Algeria', 'code': FlagsCode.DZ},
    {'name': 'Angola', 'code': FlagsCode.AO},
    {'name': 'Benin', 'code': FlagsCode.BJ},
    {'name': 'Botswana', 'code': FlagsCode.BW},
    {'name': 'Burkina Faso', 'code': FlagsCode.BF},
    {'name': 'Burundi', 'code': FlagsCode.BI},
    {'name': 'Cameroon', 'code': FlagsCode.CM},
    {'name': 'Cape Verde', 'code': FlagsCode.CV},
    {'name': 'Central African Republic', 'code': FlagsCode.CF},
    {'name': 'Chad', 'code': FlagsCode.TD},
    {'name': 'Comoros', 'code': FlagsCode.KM},
    {'name': 'Congo, Democratic Republic of the', 'code': FlagsCode.CD},
    {'name': 'Congo, Republic of the', 'code': FlagsCode.CG},
    {'name': 'Côte d\'Ivoire', 'code': FlagsCode.CI},
    {'name': 'Djibouti', 'code': FlagsCode.DJ},
    {'name': 'Egypt', 'code': FlagsCode.EG},
    {'name': 'Equatorial Guinea', 'code': FlagsCode.GQ},
    {'name': 'Eritrea', 'code': FlagsCode.ER},
    {'name': 'Eswatini', 'code': FlagsCode.SZ},
    {'name': 'Ethiopia', 'code': FlagsCode.ET},
    {'name': 'Gabon', 'code': FlagsCode.GA},
    {'name': 'Gambia', 'code': FlagsCode.GM},
    {'name': 'Ghana', 'code': FlagsCode.GH},
    {'name': 'Guinea', 'code': FlagsCode.GN},
    {'name': 'Guinea-Bissau', 'code': FlagsCode.GW},
    {'name': 'Kenya', 'code': FlagsCode.KE},
    {'name': 'Lesotho', 'code': FlagsCode.LS},
    {'name': 'Liberia', 'code': FlagsCode.LR},
    {'name': 'Libya', 'code': FlagsCode.LY},
    {'name': 'Madagascar', 'code': FlagsCode.MG},
    {'name': 'Malawi', 'code': FlagsCode.MW},
    {'name': 'Mali', 'code': FlagsCode.ML},
    {'name': 'Mauritania', 'code': FlagsCode.MR},
    {'name': 'Mauritius', 'code': FlagsCode.MU},
    {'name': 'Morocco', 'code': FlagsCode.MA},
    {'name': 'Mozambique', 'code': FlagsCode.MZ},
    {'name': 'Namibia', 'code': FlagsCode.NA},
    {'name': 'Niger', 'code': FlagsCode.NE},
    {'name': 'Nigeria', 'code': FlagsCode.NG},
    {'name': 'Rwanda', 'code': FlagsCode.RW},
    {'name': 'Sao Tome and Principe', 'code': FlagsCode.ST},
    {'name': 'Senegal', 'code': FlagsCode.SN},
    {'name': 'Seychelles', 'code': FlagsCode.SC},
    {'name': 'Sierra Leone', 'code': FlagsCode.SL},
    {'name': 'Somalia', 'code': FlagsCode.SO},
    {'name': 'South Africa', 'code': FlagsCode.ZA},
    {'name': 'South Sudan', 'code': FlagsCode.SS},
    {'name': 'Sudan', 'code': FlagsCode.SD},
    {'name': 'Tanzania', 'code': FlagsCode.TZ},
    {'name': 'Togo', 'code': FlagsCode.TG},
    {'name': 'Tunisia', 'code': FlagsCode.TN},
    {'name': 'Uganda', 'code': FlagsCode.UG},
    {'name': 'Zambia', 'code': FlagsCode.ZM},
    {'name': 'Zimbabwe', 'code': FlagsCode.ZW},
    // Add more countries here
  ];

  List<Map<String, dynamic>> _filteredCountries = [];

  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _filteredCountries = _allCountries; // Initially, show all countries
    Country_Selected();
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        final name = country['name'].toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SearchBar(
                  hintText: "Search Country",
                  onChanged: (value) => _filterCountries(value),
                ),
              ),

              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredCountries.length, // Use filtered list length
                itemBuilder: (context, index) {

                  final country = _filteredCountries[index];
                  final isSelected = index == _selectedIndex;

                  return ListTile(
                    leading: Flag.fromCode(
                      country['code'],
                      height: 30,
                      width: 50,
                    ),
                    title: Text(country['name']),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
