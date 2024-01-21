import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isBride;

  CustomBottomNavigationBar(
      {required this.selectedIndex, required this.onItemTapped, required this.isBride});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // backgroundColor: Color(0xFFFF7E2),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      selectedItemColor: const Color(0xFF4F2E22),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      unselectedItemColor: const Color(0xFFC58D80),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.waving_hand_rounded),
          label: 'Blessings',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: 'Album',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          label: 'Ask me',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: widget.isBride ? 'Guest List' : 'Invitation',
        ),
      ],
    );
  }
}
