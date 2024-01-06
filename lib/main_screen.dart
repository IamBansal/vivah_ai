import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivah_ai/providers/shared_pref.dart';
import 'package:vivah_ai/screens/blessing_screen.dart';
import 'package:vivah_ai/screens/guest_list_screen.dart';
import 'package:vivah_ai/screens/home_screen.dart';
import 'package:vivah_ai/screens/info_screen.dart';
import 'package:vivah_ai/screens/personal%20_invitation.dart';
import 'package:vivah_ai/screens/vivah_photos.dart';
import 'package:vivah_ai/widgets/bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {

  final bool isBrideGroom;
  const MainScreen({super.key, required this.isBrideGroom});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // _getHashTagAndId();
    setState(() {
      if (widget.isBrideGroom) _screens.last = const GuestListScreen();
    });
  }


  final firestore = FirebaseFirestore.instance;
  String userId = '';
  String bride = 'Bride';
  String groom = 'Groom';

  Future<void> _getHashTagAndId() async {
    String? hashtag = await LocalData.getName();

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('entries')
          .where('hashtag', isEqualTo: hashtag!)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> firstEntry = snapshot.docs.first;
        Map<String, dynamic>? data = firstEntry.data();
        setState(() {
          bride = data!['bride'].toString();
          groom = data['groom'].toString();
          userId = data['id'].toString();
        });
        await LocalData.saveNameAndId(bride, groom, userId);
        debugPrint('Found');
      } else {
        debugPrint('No matching documents found.');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
  }

  bool isBride = false;

   final List<Widget> _screens = [
    // HomeScreen(onButtonPressed: _onItemTapped),
    const HomeScreen(),
    const RecordBlessingScreen(),
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