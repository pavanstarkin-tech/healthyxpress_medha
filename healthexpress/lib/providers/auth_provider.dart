import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../data/production_database.dart';

class AuthProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.user;
  bool _isAuthenticated = true; // start authenticated for rich interactive demo, or can be reset
  UserModel _currentUser = ProductionDatabase.defaultUser;
  DoctorModel _currentDoctor = ProductionDatabase.doctors[0]; // Default doctor: Dr. Sandeep Attawar

  UserRole get currentRole => _currentRole;
  bool get isAuthenticated => _isAuthenticated;
  UserModel get currentUser => _currentUser;
  DoctorModel get currentDoctor => _currentDoctor;

  bool get isDoctorMode => _currentRole == UserRole.doctor;
  bool get isUserMode => _currentRole == UserRole.user;

  void setRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void switchRole() {
    if (_currentRole == UserRole.user) {
      _currentRole = UserRole.doctor;
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
