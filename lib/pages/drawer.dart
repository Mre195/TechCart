import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/products.dart';
import 'package:project/pages/settings.dart';

import 'data.dart';
import 'login.dart';
import 'home.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final headerBg = isDark ? const Color(0xFF1E1E1E) : Colors.green;
    final textColor = isDark ? Colors.white : Colors.black;
    final iconColor = isDark ? Colors.greenAccent : Colors.green;

    return Drawer(
      backgroundColor: bgColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: headerBg),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  "assets/lolg.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            accountName: Text(
              user?.displayName ?? "Guest",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user?.email ?? "guest"),
          ),

          _drawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            iconColor: iconColor,
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>HomePage()),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.shopping_bag,
            title: 'Products',
            iconColor: iconColor,
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductsPage(initialCategory: 'GPU'),
                ),
              );
            },
          ),

          FutureBuilder<String>(
            future: getUserRole(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              if (snapshot.hasData && snapshot.data == 'admin') {
                return _drawerItem(
                  context,
                  icon: Icons.add,
                  title: 'Add Product',
                  iconColor: iconColor,
                  textColor: textColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddProductPage(),
                      ),
                    );
                  },
                );
              }

              return SizedBox();
            },
          ),

          _drawerItem(
            context,
            icon: Icons.settings,
            title: "Settings",
            iconColor: iconColor,
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Settingsp()),
              );
            },
          ),

          if (user != null)
            _drawerItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              iconColor: Colors.redAccent,
              textColor: textColor,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>login()),
                );
              },
            )
          else
            _drawerItem(
              context,
              icon: Icons.login,
              title: 'Back to Login',
              iconColor: iconColor,
              textColor: textColor,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => login()),
                );
              },
            ),

        ],

      ),
    );
  }

  Future<String> getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'guest';

    final doc = await FirebaseFirestore.instance
        .collection('data')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data()!.containsKey('role')) {
      return doc['role'];
    }
    return 'user';
  }
}

Widget _drawerItem(
    BuildContext context, {
      required IconData icon,
      required String title,
      required Color iconColor,
      required Color textColor,
      required VoidCallback onTap,
    }) {
  return ListTile(
    leading: Icon(icon, color: iconColor),
    title: Text(
      title,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    onTap: onTap,
    horizontalTitleGap: 8,
  );
}

