import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/pages/profile.dart';

class NavBar extends StatelessWidget {
  final FirebaseAuth auth;
  final String displayName;
  final String email;

  NavBar({
    required this.auth,
    required this.displayName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                  //   Navigator.push(
                  //     //context,
                  //     // MaterialPageRoute(
                  //     //   // builder: (context) => ProfilePage(
                  //     //   //   displayName: displayName,
                  //     //   //   email: email,
                  //     //   // ),
                  //     // ),
                  //  // );
                   },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Text(
                      displayName[0],
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(displayName, style: TextStyle(fontSize: 18, color: Colors.white)),
                Text(email, style: TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 73, 145, 76),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle the "Home" option
              // You can navigate to the home page or perform any desired action
              Navigator.pop(context);
            },
          ),
          Divider(), // Add a divider for visual separation
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () async {
              // Sign out the user
              await auth.signOut();

              // Navigate to the login page
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
