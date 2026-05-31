import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_ui.dart';
import './Home_page.dart';
import '/providers/services_provider.dart';

class MySavedServicesPage extends StatefulWidget {
  const MySavedServicesPage({super.key});

  @override
  State<MySavedServicesPage> createState() => _MySavedServicesPageState();
}

class _MySavedServicesPageState extends State<MySavedServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset("Image/Logo.png", height: 45),
        ),
        body: Consumer<ServicesProvider>(
          builder: (context, servicesProvider, _) {
            final savedServices = servicesProvider.savedServices;

            if (savedServices.isEmpty) {
              return Container(
                color: Colors.grey[100],
                child: const Center(
                  child: Text(
                    "لا توجد خدمات محفوظة 👀",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }

            return Container(
              color: Colors.grey[50],
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: savedServices.length,
                itemBuilder: (context, index) {
                  final service = savedServices[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200]!,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  service.serviceName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'السعر: ${service.price.toStringAsFixed(0)} جنيه',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 24,
                            ),
                            onPressed: () {
                              servicesProvider.removeSavedService(service.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تمت إزالة الخدمة من المفضلة'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
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
      ),
    );
  }
}
