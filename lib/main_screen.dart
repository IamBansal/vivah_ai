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
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainViewModel model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
      model.init();
    });
  }

  void _onItemTapped(int index) {
    model.setTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, model, child) {
      final List<Widget> screens = [
        const HomeScreen(),
        const ShowBlessings(),
        const VivahPhotosScreen(),
        const InfoScreen(),
        model.isCouple
            ? const GuestListScreen()
            : const PersonalInvitation(),
      ];
      return Scaffold(
        body: screens[model.selectedIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: model.selectedIndex,
          onItemTapped: _onItemTapped,
          isBride: model.isCouple,
        ),
      );
    });
  }
}
