class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePhoto;
  final String aarogyasriId; // e.g. AROG12345678 / RGIS ID
  final String bloodGroup;
  final String allergies;
  final String chronicConditions;
  final String pastSurgeries;
  final double heightCm;
  final double weightKg;
  final double temperatureF;
  final int heartRateBpm;
  final int oxygenSpo2;
  final DateTime joinedDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhoto,
    required this.aarogyasriId,
    this.bloodGroup = 'B+',
    this.allergies = 'No known allergies',
    this.chronicConditions = 'None',
    this.pastSurgeries = 'Appendectomy (2020)',
    this.heightCm = 172.0,
    this.weightKg = 72.0,
    this.temperatureF = 99.8,
    this.heartRateBpm = 78,
    this.oxygenSpo2 = 98,
    required this.joinedDate,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profilePhoto,
    String? aarogyasriId,
    String? bloodGroup,
    String? allergies,
    String? chronicConditions,
    String? pastSurgeries,
    double? heightCm,
    double? weightKg,
    double? temperatureF,
    int? heartRateBpm,
    int? oxygenSpo2,
    DateTime? joinedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      aarogyasriId: aarogyasriId ?? this.aarogyasriId,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      pastSurgeries: pastSurgeries ?? this.pastSurgeries,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      temperatureF: temperatureF ?? this.temperatureF,
      heartRateBpm: heartRateBpm ?? this.heartRateBpm,
      oxygenSpo2: oxygenSpo2 ?? this.oxygenSpo2,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}
