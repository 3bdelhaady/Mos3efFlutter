import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_ui.dart';
import 'my_saved.dart';
import 'search_page.dart';
import '/providers/auth_provider.dart';
import '/providers/services_provider.dart';

class HomePagem extends StatefulWidget {
  const HomePagem({super.key});

  @override
  State<HomePagem> createState() => _HomePagemState();
}

class _HomePagemState extends State<HomePagem> {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                  MaterialPageRoute(
                    builder: (_) => const MySavedServicesPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientProfileScreen(),
                  ),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Search button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Filter buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Consumer<ServicesProvider>(
                    builder: (context, servicesProvider, _) {
                      return Row(
                        children: [
                          _filterButton(
                            context,
                            'الكل',
                            'all',
                            servicesProvider.selectedFilter == 'all',
                          ),
                          const SizedBox(width: 10),
                          _filterButton(
                            context,
                            'العيادات',
                            'clinic',
                            servicesProvider.selectedFilter == 'clinic',
                          ),
                          const SizedBox(width: 10),
                          _filterButton(
                            context,
                            'المستشفيات',
                            'hospital',
                            servicesProvider.selectedFilter == 'hospital',
                          ),
                          const SizedBox(width: 10),
                          _filterButton(
                            context,
                            'المعامل',
                            'lab',
                            servicesProvider.selectedFilter == 'lab',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Services list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<ServicesProvider>(
                  builder: (context, servicesProvider, _) {
                    final services = servicesProvider.filteredServices;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _serviceCard(
                            context,
                            service,
                            servicesProvider,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButton(
    BuildContext context,
    String label,
    String type,
    bool isActive,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<ServicesProvider>().filterServices(type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.white,
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _serviceCard(
    BuildContext context,
    dynamic service,
    ServicesProvider provider,
  ) {
    return Container(
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
          // Service info
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
          // Heart icon
          IconButton(
            icon: Icon(
              service.isSaved ? Icons.favorite : Icons.favorite_border,
              color: service.isSaved ? Colors.red : Colors.grey,
              size: 24,
            ),
            onPressed: () {
              provider.toggleSaveService(service);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    service.isSaved
                        ? 'تمت إضافة الخدمة للمفضلة'
                        : 'تمت إزالة الخدمة من المفضلة',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
