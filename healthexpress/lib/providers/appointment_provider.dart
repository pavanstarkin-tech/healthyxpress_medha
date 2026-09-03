import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../data/mock_database.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<AppointmentModel> _appointments = List.from(MockDatabase.initialAppointments);

  List<AppointmentModel> get appointments => _appointments;

  List<AppointmentModel> get upcomingAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.confirmed || a.status == AppointmentStatus.pending)
      .toList();

  List<AppointmentModel> get completedAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.completed)
      .toList();

  List<AppointmentModel> get cancelledAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.cancelled)
      .toList();

  AppointmentModel? getNextUpcoming() {
    final upcoming = upcomingAppointments;
    if (upcoming.isEmpty) return null;
    return upcoming.first;
  }

  AppointmentModel createBooking({
    required DoctorModel doctor,
    required DateTime date,
    required String timeSlot,
    required ConsultationType type,
    required bool applyAarogyasri,
    required String userName,
    required String userPhone,
    required String aarogyasriId,
    bool isRecurring = false,
  }) {
    double fee = doctor.clinicFee;
    if (type == ConsultationType.videoConsult) fee = doctor.videoFee;
    if (type == ConsultationType.homeVisitRMP) fee = doctor.homeVisitFee;

    double discount = applyAarogyasri ? (fee * 0.5) : 0.0;
    double total = (fee - discount) + AppConstants.platformFee;

    final newBooking = AppointmentModel(
      id: 'BK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      userId: 'USR-101',
      userName: userName,
      userPhone: userPhone,
      aarogyasriId: aarogyasriId,
      doctorId: doctor.id,
      doctorName: doctor.name,
      doctorPhoto: doctor.photoUrl,
      doctorSpecialty: doctor.specialty,
      hospitalId: doctor.hospitalId,
      hospitalName: doctor.hospitalName,
      hospitalLocation: doctor.location,
      dateTime: date,
      timeSlot: timeSlot,
      type: type,
      status: AppointmentStatus.confirmed,
      paymentStatus: PaymentStatus.paid,
      consultationFee: fee,
      platformFee: AppConstants.platformFee,
      discountAmount: discount,
      totalAmount: total,
      aarogyasriApplied: applyAarogyasri,
      meetingRoomId: 'ROOM-HEAL-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      isRecurring: isRecurring,
    );

    _appointments.insert(0, newBooking);
    notifyListeners();
    return newBooking;
  }

  bool rescheduleAppointment({
    required String appointmentId,
    required DateTime newDate,
    required String newTimeSlot,
  }) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) return false;

    final existing = _appointments[index];
    final hoursDiff = existing.dateTime.difference(DateTime.now()).inHours;

    double additionalDeduction = 0.0;
    if (hoursDiff < 24) {
      // Within 24 hours: 30% fee retained/re-calculated per policy
      additionalDeduction = existing.consultationFee * 0.30;
    }

    _appointments[index] = existing.copyWith(
      dateTime: newDate,
      timeSlot: newTimeSlot,
      status: AppointmentStatus.confirmed,
      totalAmount: existing.totalAmount + additionalDeduction,
    );

    notifyListeners();
    return true;
  }

  bool cancelAppointment(String appointmentId) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) return false;

    _appointments[index] = _appointments[index].copyWith(
      status: AppointmentStatus.cancelled,
      paymentStatus: PaymentStatus.refunded,
    );
    notifyListeners();
    return true;
  }

  void addDoctorPrescription({
    required String appointmentId,
    required String doctorNotes,
    required List<PrescriptionItem> prescription,
    required List<String> recommendedTests,
  }) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) return;

    _appointments[index] = _appointments[index].copyWith(
      doctorNotes: doctorNotes,
      prescription: prescription,
      recommendedTests: recommendedTests,
      status: AppointmentStatus.completed,
    );
    notifyListeners();
  }
}
