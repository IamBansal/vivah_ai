import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivah_ai/screens/blessings_screens/show_blessings.dart';
import 'package:vivah_ai/screens/guest_screens/guest_list_screen.dart';
import 'package:vivah_ai/screens/home_screens/home_screen.dart';
import 'package:vivah_ai/screens/info_screen.dart';
import 'package:vivah_ai/screens/personal%20_invitation.dart';
import 'package:vivah_ai/screens/vivah_photos.dart';
import 'package:vivah_ai/widgets/bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {

  final bool isBrideGroom;
  final int index;
  const MainScreen({super.key, required this.isBrideGroom, required this.index});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.isBrideGroom) _screens.last = const GuestListScreen();
      _selectedIndex = widget.index;
    });
  }


  final firestore = FirebaseFirestore.instance;
  String userId = '';
  String bride = 'Bride';
  String groom = 'Groom';

  bool isBride = false;

   final List<Widget> _screens = [
    // HomeScreen(onButtonPressed: _onItemTapped),
    const HomeScreen(),
    const ShowBlessings(),
    const VivahPhotosScreen(),
    const InfoScreen(),
    const PersonalInvitation(),
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
        isBride: widget.isBrideGroom,
      ),
    );
  }
}