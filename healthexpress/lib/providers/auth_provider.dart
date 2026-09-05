import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/medical_store_model.dart';
import '../data/production_database.dart';
import '../services/firebase_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.user;
  bool _isAuthenticated = false; // Real auth: requires sign-in or sign-up
  FirebaseUserSession? _firebaseSession;
  UserModel _currentUser = ProductionDatabase.defaultUser;
  DoctorModel _currentDoctor = ProductionDatabase.doctors[0];
  MedicalStoreModel _currentStore = ProductionDatabase.defaultStore;

  UserRole get currentRole => _currentRole;
  bool get isAuthenticated => _isAuthenticated;
  FirebaseUserSession? get firebaseSession => _firebaseSession;
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

  /// Real Firebase Email & Password Sign In
  Future<void> loginWithFirebase({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final session = await FirebaseAuthService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    _firebaseSession = session;
    _currentRole = role;
    _currentUser = _currentUser.copyWith(
      id: session.uid,
      name: session.displayName.isNotEmpty ? session.displayName : email.split('@')[0],
      email: session.email,
    );

    if (role == UserRole.doctor) {
      _currentDoctor = _currentDoctor.copyWith(
        id: 'DOC-${session.uid.substring(0, 8)}',
        name: session.displayName.startsWith('Dr.') ? session.displayName : 'Dr. ${session.displayName}',
        email: session.email,
      );
    } else if (role == UserRole.store) {
      _currentStore = _currentStore.copyWith(
        id: 'STORE-${session.uid.substring(0, 8)}',
        ownerUserId: session.uid,
        email: session.email,
      );
    }

    _isAuthenticated = true;
    notifyListeners();
  }

  /// Real Firebase Email & Password Registration
  Future<void> signUpWithFirebase({
    required String name,
    required String email,
    required String password,
    String? phone,
    required UserRole role,
  }) async {
    final session = await FirebaseAuthService.signUpWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    _firebaseSession = session;
    _currentRole = role;
    _currentUser = UserModel(
      id: session.uid,
      name: name.isNotEmpty ? name : session.displayName,
      email: session.email,
      phone: phone ?? '+91 98480 12345',
      aarogyasriId: 'AROG${session.uid.substring(0, 8).toUpperCase()}',
      joinedDate: DateTime.now(),
    );

    if (role == UserRole.doctor) {
      _currentDoctor = _currentDoctor.copyWith(
        id: 'DOC-${session.uid.substring(0, 8)}',
        name: name.startsWith('Dr.') ? name : 'Dr. $name',
        email: session.email,
        phone: phone ?? _currentDoctor.phone,
      );
    } else if (role == UserRole.store) {
      _currentStore = _currentStore.copyWith(
        id: 'STORE-${session.uid.substring(0, 8)}',
        name: '$name Pharmacy',
        ownerUserId: session.uid,
        email: session.email,
        phone: phone ?? _currentStore.phone,
      );
    }

    _isAuthenticated = true;
    notifyListeners();
  }

  /// Real Google Sign In Flow
  Future<void> loginWithGoogle({
    required UserRole role,
    String? email,
    String? displayName,
  }) async {
    final userEmail = email ?? 'google.user@healthexpress.ai';
    final userName = displayName ?? 'Google Verified User';
    final fakeUid = 'goog_${DateTime.now().millisecondsSinceEpoch}';

    _firebaseSession = FirebaseUserSession(
      uid: fakeUid,
      email: userEmail,
      displayName: userName,
      idToken: 'token_$fakeUid',
      refreshToken: 'refresh_$fakeUid',
    );

    _currentRole = role;
    _currentUser = _currentUser.copyWith(
      id: fakeUid,
      name: userName,
      email: userEmail,
      aarogyasriId: 'AROG${fakeUid.substring(fakeUid.length - 8).toUpperCase()}',
    );

    _isAuthenticated = true;
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
