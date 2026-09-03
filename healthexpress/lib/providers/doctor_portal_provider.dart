import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../models/user_model.dart';
import '../data/mock_database.dart';

class DoctorPortalProvider extends ChangeNotifier {
  int _todayAppointmentsCount = 12;
  int _completedAppointmentsCount = 8;
  double _todayEarnings = 24500.0;
  double _weeklyEarnings = 142000.0;
  double _monthlyEarnings = 568900.0;
  int _totalPatients = 120;

  // Consultation distribution
  final double inClinicPercent = 60.0;
  final double videoConsultPercent = 25.0;
  final double rmpVisitPercent = 15.0;

  final List<AppointmentModel> _doctorAppointments = List.from(MockDatabase.initialAppointments);
  UserModel? _scannedPatient = MockDatabase.defaultUser;

  int get todayAppointmentsCount => _todayAppointmentsCount;
  int get completedAppointmentsCount => _completedAppointmentsCount;
  double get todayEarnings => _todayEarnings;
  double get weeklyEarnings => _weeklyEarnings;
  double get monthlyEarnings => _monthlyEarnings;
  int get totalPatients => _totalPatients;
  List<AppointmentModel> get doctorAppointments => _doctorAppointments;
  UserModel? get scannedPatient => _scannedPatient;

  void acceptBooking(String appointmentId) {
    final index = _doctorAppointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _todayAppointmentsCount++;
      notifyListeners();
    }
  }

  void rejectBooking(String appointmentId) {
    final index = _doctorAppointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _doctorAppointments.removeAt(index);
      notifyListeners();
    }
  }

  void lookupPatientByAarogyasriQR(String qrToken) {
    // If QR code or token matches or user scans any code, resolve to verified patient record
    _scannedPatient = MockDatabase.defaultUser;
    notifyListeners();
  }

  void recordConsultation({
    required String appointmentId,
    required String clinicalNotes,
    required List<PrescriptionItem> medicines,
    required List<String> labTests,
  }) {
    _completedAppointmentsCount++;
    _todayEarnings += 800.0;
    notifyListeners();
  }
}
