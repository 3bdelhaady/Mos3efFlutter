import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_ui.dart';
import 'my_saved.dart';
import 'search_page.dart';
import '/providers/auth_provider.dart';

class HomePagem extends StatelessWidget {
  const HomePagem({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthProvider>().logout();
                },
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Image.asset("Image/Logo.png", height: 45),

        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MySavedServicesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PatientProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blue),
            onPressed: () => _handleLogout(context),
          ),
          const SizedBox(width: 10),
        ],
      ),

      // ---------------- BODY ----------------
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("Image/vectors.png", fit: BoxFit.fitWidth),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80, top: 20),
                child: Image.asset(
                  "Image/landframe.png",
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),

              // -------- SEARCH BUTTON --------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ServicesPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.search, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        "ابحث عن خدمة",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // HOSPITAL IMAGE STICKED TO BOTTOM
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Image.asset(
                  "Image/Hos.png",
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
