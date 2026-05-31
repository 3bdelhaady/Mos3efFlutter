import 'package:flutter/foundation.dart';
import '/models/service.dart';

class ServicesProvider extends ChangeNotifier {
  final List<Service> _allServices = [
    // Clinics
    Service(
      id: '1',
      name: 'عيادة د. أحمد السلام',
      serviceType: 'clinic',
      serviceName: 'الكشف العام',
      price: 150.0,
    ),
    Service(
      id: '2',
      name: 'عيادة د. فاطمة محمود',
      serviceType: 'clinic',
      serviceName: 'طب الأسنان',
      price: 200.0,
    ),
    Service(
      id: '3',
      name: 'عيادة د. محمد علي',
      serviceType: 'clinic',
      serviceName: 'الجلدية',
      price: 175.0,
    ),
    Service(
      id: '4',
      name: 'عيادة د. ليلى حسن',
      serviceType: 'clinic',
      serviceName: 'أمراض الجهاز الهضمي',
      price: 250.0,
    ),
    Service(
      id: '5',
      name: 'عيادة د. سارة إبراهيم',
      serviceType: 'clinic',
      serviceName: 'النساء والتوليد',
      price: 300.0,
    ),

    // Hospitals
    Service(
      id: '6',
      name: 'مستشفى النيل الدولية',
      serviceType: 'hospital',
      serviceName: 'الإقامة مع العلاج',
      price: 2500.0,
    ),
    Service(
      id: '7',
      name: 'مستشفى الأمل',
      serviceType: 'hospital',
      serviceName: 'العمليات الجراحية',
      price: 3000.0,
    ),
    Service(
      id: '8',
      name: 'مستشفى الحياة',
      serviceType: 'hospital',
      serviceName: 'الطوارئ والإسعافات',
      price: 1500.0,
    ),
    Service(
      id: '9',
      name: 'مستشفى التعافي',
      serviceType: 'hospital',
      serviceName: 'الرعاية المركزة',
      price: 4000.0,
    ),
    Service(
      id: '10',
      name: 'مستشفى القاهرة التخصصي',
      serviceType: 'hospital',
      serviceName: 'أمراض القلب',
      price: 3500.0,
    ),

    // Labs
    Service(
      id: '11',
      name: 'معمل د. محمود للتحاليل',
      serviceType: 'lab',
      serviceName: 'تحليل دم كامل',
      price: 100.0,
    ),
    Service(
      id: '12',
      name: 'معمل الشرق الأوسط',
      serviceType: 'lab',
      serviceName: 'تحليل البول والبراز',
      price: 75.0,
    ),
    Service(
      id: '13',
      name: 'معمل النخبة الطبية',
      serviceType: 'lab',
      serviceName: 'الفحوصات الميكروبية',
      price: 150.0,
    ),
    Service(
      id: '14',
      name: 'معمل الأطباء المتحدة',
      serviceType: 'lab',
      serviceName: 'الاختبارات الجزيئية',
      price: 250.0,
    ),
    Service(
      id: '15',
      name: 'معمل الدقة الطبية',
      serviceType: 'lab',
      serviceName: 'فحص السكر والدهنيات',
      price: 120.0,
    ),
  ];

  final List<Service> _savedServices = [];
  String _selectedFilter = 'all';

  // Getters
  List<Service> get allServices => _allServices;
  List<Service> get filteredServices {
    if (_selectedFilter == 'all') {
      return _allServices;
    }
    return _allServices.where((s) => s.serviceType == _selectedFilter).toList();
  }

  List<Service> get savedServices => _savedServices;
  String get selectedFilter => _selectedFilter;

  // Filter services
  void filterServices(String type) {
    _selectedFilter = type;
    notifyListeners();
  }

  // Toggle save service
  void toggleSaveService(Service service) {
    final index = _allServices.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      final updatedService = _allServices[index].copyWith(
        isSaved: !_allServices[index].isSaved,
      );
      _allServices[index] = updatedService;

      if (updatedService.isSaved) {
        _savedServices.add(updatedService);
      } else {
        _savedServices.removeWhere((s) => s.id == service.id);
      }
    }
    notifyListeners();
  }

  // Remove saved service
  void removeSavedService(String id) {
    final index = _allServices.indexWhere((s) => s.id == id);
    if (index != -1) {
      _allServices[index] = _allServices[index].copyWith(isSaved: false);
    }
    _savedServices.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // Request service
  void requestService(Service service) {
    final index = _allServices.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      _allServices[index] = _allServices[index].copyWith(
        isRequested: !_allServices[index].isRequested,
      );
    }
    notifyListeners();
  }
}
