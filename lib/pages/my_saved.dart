import 'package:flutter/material.dart';
import 'profile_ui.dart';
import './Home_page.dart';

class MySavedServicesPage extends StatefulWidget {
  const MySavedServicesPage({super.key});

  @override
  State<MySavedServicesPage> createState() => _MySavedServicesPageState();
}

class _MySavedServicesPageState extends State<MySavedServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset("Image/Logo.png", height: 45),
      ),
      body: Container(
        color: Colors.grey[100],
        child: const Center(child: Text("No saved services 👀")),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePagem()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PatientProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
