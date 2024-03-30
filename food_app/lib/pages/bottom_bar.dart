import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onProfilePressed;

  const BottomBar({
    Key? key,
    required this.onHomePressed,
    required this.onSearchPressed,
    required this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 73, 145, 76),
            Color.fromARGB(255, 42, 88, 45),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 30,
              ),
              onPressed: onHomePressed,
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              onPressed: onSearchPressed,
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 30,
              ),
              onPressed: onProfilePressed,
            ),
          ],
        ),
      ),
    );
  }
}
