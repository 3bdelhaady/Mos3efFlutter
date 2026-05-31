class Service {
  final String id;
  final String name;
  final String serviceType; // clinic, hospital, lab
  final String serviceName;
  final double price;
  final String? image;
  bool isSaved;
  bool isRequested;

  Service({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.serviceName,
    required this.price,
    this.image,
    this.isSaved = false,
    this.isRequested = false,
  });

  // Create a copy with modified fields
  Service copyWith({
    String? id,
    String? name,
    String? serviceType,
    String? serviceName,
    double? price,
    String? image,
    bool? isSaved,
    bool? isRequested,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      serviceType: serviceType ?? this.serviceType,
      serviceName: serviceName ?? this.serviceName,
      price: price ?? this.price,
      image: image ?? this.image,
      isSaved: isSaved ?? this.isSaved,
      isRequested: isRequested ?? this.isRequested,
    );
  }
}
