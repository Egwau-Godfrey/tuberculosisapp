import 'package:flutter/material.dart';
import 'package:tuberculosisapp/pages/history.dart';
import 'package:tuberculosisapp/pages/homeScreen.dart';
import 'package:tuberculosisapp/pages/profiles.dart';
import 'package:tuberculosisapp/pages/settings.dart';

class LandingUI extends StatefulWidget {
  final ValueNotifier<bool> isDarkModeNotifier;

  const LandingUI({required this.isDarkModeNotifier, super.key});

  @override
  LandingUIPage createState() => LandingUIPage();
}

class LandingUIPage extends State<LandingUI> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const Homescreen(),
    const History(),
    const Profiles(),
    Settings(isDarkModeNotifier: widget.isDarkModeNotifier),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  SafeArea(
        child: _screens[_currentIndex]
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //it ensures that all icons are visible
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue,
      ),
    );
  }
}