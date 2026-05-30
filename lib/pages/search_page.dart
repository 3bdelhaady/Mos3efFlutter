import 'package:flutter/material.dart';
import 'my_saved.dart';
import 'profile_ui.dart';
import 'Home_page.dart';
import 'service_details.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _services = [
    {
      "id": 1,
      "name": "General Check-up",
      "hospital": "City Hospital",
      "price": "500 EGP",
      "image":
          "https://www.aha.org/sites/default/files/2023-04/Hospital2_icon.png",
    },
    {
      "id": 2,
      "name": "Dental Cleaning",
      "hospital": "Smile Dental Clinic",
      "price": "300 EGP",
      "image":
          "https://www.aha.org/sites/default/files/2023-04/Hospital2_icon.png",
    },
    {
      "id": 3,
      "name": "X-Ray",
      "hospital": "General Hospital",
      "price": "700 EGP",
      "image":
          "https://www.aha.org/sites/default/files/2023-04/Hospital2_icon.png",
    },
  ];
  String? _selectedCategory;

  Widget buildCategoryButton(String label, String categoryValue) {
    final isSelected = _selectedCategory == categoryValue;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Colors.blue
            : const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _selectedCategory = categoryValue;
        });
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset("Image/Logo.png", height: 45),
      ),
      body: Container(
        color: const Color.fromARGB(248, 255, 255, 255),

        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'ابحث عن الخدمة',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Mock search
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildCategoryButton('الكل', 'all'),
                  const SizedBox(width: 8),
                  buildCategoryButton('مستشفى', 'hospital'),
                  const SizedBox(width: 8),
                  buildCategoryButton('عيادة', 'clinic'),
                  const SizedBox(width: 8),
                  buildCategoryButton('مختبر', 'lab'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(
                        service['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(service['name']),
                      subtitle: Text(service['hospital']),
                      trailing: Text(service['price']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ServiceDetailsPage(service: service),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "My Saved",
          ),
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
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MySavedServicesPage()),
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
