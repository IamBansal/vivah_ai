import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivah_ai/screens/blessings_screens/show_blessings.dart';
import 'package:vivah_ai/screens/guest_screens/guest_list_screen.dart';
import 'package:vivah_ai/screens/home_screens/home_screen.dart';
import 'package:vivah_ai/screens/info_screen.dart';
import 'package:vivah_ai/screens/personal%20_invitation.dart';
import 'package:vivah_ai/screens/vivah_photos.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
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

  late MainViewModel model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
      model.init();
    });

    setState(() {
      _selectedIndex = widget.index;
    });
  }

  final firestore = FirebaseFirestore.instance;
  String userId = '';
  String bride = 'Bride';
  String groom = 'Groom';

  bool isBride = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, model, child) {
      final List<Widget> screens = [
        const HomeScreen(),
        const ShowBlessings(),
        const VivahPhotosScreen(),
        const InfoScreen(),
        widget.isBrideGroom
            ? const GuestListScreen()
            : const PersonalInvitation(),
      ];
      return Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          isBride: widget.isBrideGroom,
        ),
      );
    });
  }
}
