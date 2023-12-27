import 'package:flutter/material.dart';
import 'package:vivah_ai/screens/blessing_screen.dart';
import 'package:vivah_ai/screens/guest_list_screen.dart';
import 'package:vivah_ai/screens/home_screen.dart';
import 'package:vivah_ai/screens/info_screen.dart';
import 'package:vivah_ai/screens/profile_screen.dart';
import 'package:vivah_ai/widgets/bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    // HomeScreen(onButtonPressed: _onItemTapped),
    const HomeScreen(),
    const BlessingsScreen(),
    const GuestListScreen(),
    const InfoScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}