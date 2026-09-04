class MedicalStoreModel {
  final String id;
  final String name;
  final String address;
  final String area;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final int etaMinutes;
  final bool is24x7;
  final bool isOpen;
  final String phone;
  final String licenseNumber;
  final String imageUrl;
  final List<String> availableMedicineIds;

  const MedicalStoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.area,
    this.rating = 4.7,
    this.reviewCount = 320,
    required this.distanceKm,
    required this.etaMinutes,
    this.is24x7 = true,
    this.isOpen = true,
    required this.phone,
    required this.licenseNumber,
    required this.imageUrl,
    this.availableMedicineIds = const [],
  });

  factory MedicalStoreModel.fromJson(Map<String, dynamic> json) {
    return MedicalStoreModel(
      id: json['id'] as String? ?? 'STORE-01',
      name: json['name'] as String? ?? 'Apollo Pharmacy',
      address: json['address'] as String? ?? '',
      area: json['area'] as String? ?? 'Hitech City',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.7,
      reviewCount: json['review_count'] as int? ?? 120,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 1.2,
      etaMinutes: json['eta_minutes'] as int? ?? 15,
      is24x7: json['is_24x7'] as bool? ?? true,
      isOpen: json['is_open'] as bool? ?? true,
      phone: json['phone'] as String? ?? '+91 9848012345',
      licenseNumber: json['license_number'] as String? ?? 'TS/MED/2024/9912',
      imageUrl: json['image_url'] as String? ?? 'https://images.unsplash.com/photo-1576602976047-174e57a47881?auto=format&fit=crop&q=80&w=400',
      availableMedicineIds: (json['available_medicine_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'area': area,
      'rating': rating,
      'review_count': reviewCount,
      'distance_km': distanceKm,
      'eta_minutes': etaMinutes,
      'is_24x7': is24x7,
      'is_open': isOpen,
      'phone': phone,
      'license_number': licenseNumber,
      'image_url': imageUrl,
      'available_medicine_ids': availableMedicineIds,
    };
  }
}
