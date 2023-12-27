import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar(
      {required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFFFFFF),
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.waving_hand_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
    );
  }
}
