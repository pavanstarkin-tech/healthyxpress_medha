import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/medical_store_model.dart';
import '../data/production_database.dart';

class AuthProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.user;
  bool _isAuthenticated = true; // start authenticated for rich interactive demo
  UserModel _currentUser = ProductionDatabase.defaultUser;
  DoctorModel _currentDoctor = ProductionDatabase.doctors[0]; // Default doctor: Dr. Sandeep Attawar
  MedicalStoreModel _currentStore = ProductionDatabase.defaultStore;

  UserRole get currentRole => _currentRole;
  bool get isAuthenticated => _isAuthenticated;
  UserModel get currentUser => _currentUser;
  DoctorModel get currentDoctor => _currentDoctor;
  MedicalStoreModel get currentStore => _currentStore;

  bool get isDoctorMode => _currentRole == UserRole.doctor;
  bool get isUserMode => _currentRole == UserRole.user;
  bool get isStoreMode => _currentRole == UserRole.store;

  void setRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void switchRole() {
    if (_currentRole == UserRole.user) {
      _currentRole = UserRole.doctor;
    } else if (_currentRole == UserRole.doctor) {
      _currentRole = UserRole.store;
    } else {
      _currentRole = UserRole.user;
    }
    notifyListeners();
  }

  void login({required String identifier, String? password, required UserRole role}) {
    _currentRole = role;
    _isAuthenticated = true;
    notifyListeners();
  }

  void registerUser({required String name, required String phone, String? email, String? aarogyasriId}) {
    _currentUser = _currentUser.copyWith(
      name: name,
      phone: phone,
      email: email ?? _currentUser.email,
      aarogyasriId: (aarogyasriId != null && aarogyasriId.isNotEmpty) ? aarogyasriId : 'AROG${phone.substring(phone.length - 8)}',
    );
    _isAuthenticated = true;
    _currentRole = UserRole.user;
    notifyListeners();
  }

  void registerDoctor({
    required String name,
    required String phone,
    required String specialty,
    required String qualifications,
    required String hospitalId,
    required String hospitalName,
    required double clinicFee,
  }) {
    _currentDoctor = DoctorModel(
      id: 'DOC-${DateTime.now().millisecondsSinceEpoch}',
      name: name.startsWith('Dr.') ? name : 'Dr. $name',
      email: '${name.toLowerCase().replaceAll(' ', '.')}@healthexpress.ai',
      phone: phone,
      photoUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=400',
      specialty: specialty,
      qualifications: qualifications,
      experienceYears: 5,
      rating: 5.0,
      reviewCount: 1,
      hospitalId: hospitalId,
      hospitalName: hospitalName,
      location: 'Hyderabad, Telangana',
      distanceKm: 2.0,
      clinicFee: clinicFee,
      videoFee: clinicFee,
      homeVisitFee: clinicFee + 300,
      supportedTypes: [ConsultationType.clinicVisit, ConsultationType.videoConsult],
      bio: 'Dedicated $specialty specialist committed to patient well-being at $hospitalName.',
      isVerified: true,
      isOnline: true,
    );
    _isAuthenticated = true;
    _currentRole = UserRole.doctor;
    notifyListeners();
  }

  void registerStore({
    required String name,
    required String licenseNumber,
    required String phone,
    String? email,
    required String address,
    required String area,
    required String openingTime,
    required String closingTime,
    required bool is24x7,
    String? imageUrl,
  }) {
    final newId = 'STORE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _currentStore = MedicalStoreModel(
      id: newId,
      name: name,
      licenseNumber: licenseNumber,
      phone: phone,
      email: email ?? 'contact@${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '')}.com',
      address: address,
      area: area,
      openingTime: openingTime,
      closingTime: closingTime,
      is24x7: is24x7,
      isOpen: true,
      imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1576602976047-174e57a47881?auto=format&fit=crop&q=80&w=400',
      distanceKm: 1.2,
      etaMinutes: 15,
      verificationStatus: 'pending', // Starts in pending review until approved by Super Admin
      ownerUserId: _currentUser.id,
    );
    _isAuthenticated = true;
    _currentRole = UserRole.store;
    notifyListeners();
  }

  void updateStoreTimings({
    required String openingTime,
    required String closingTime,
    required bool is24x7,
  }) {
    _currentStore = _currentStore.copyWith(
      openingTime: openingTime,
      closingTime: closingTime,
      is24x7: is24x7,
    );
    notifyListeners();
  }

  void updateStoreContact({
    required String phone,
    String? email,
    required String address,
    required String area,
  }) {
    _currentStore = _currentStore.copyWith(
      phone: phone,
      email: email,
      address: address,
      area: area,
    );
    notifyListeners();
  }

  void toggleStoreOpen() {
    _currentStore = _currentStore.copyWith(isOpen: !_currentStore.isOpen);
    notifyListeners();
  }

  void verifyStoreLocally(bool approved, [String? reason]) {
    _currentStore = _currentStore.copyWith(
      verificationStatus: approved ? 'verified' : 'rejected',
      rejectionReason: approved ? null : (reason ?? 'License verification pending'),
    );
    notifyListeners();
  }

  void updateUserProfile(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  void toggleDoctorOnlineStatus() {
    _currentDoctor = _currentDoctor.copyWith(isOnline: !_currentDoctor.isOnline);
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
