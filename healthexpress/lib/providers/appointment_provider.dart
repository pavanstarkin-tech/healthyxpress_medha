import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../services/central_data_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final CentralDataService _central = CentralDataService.instance;

  AppointmentProvider() {
    _central.addListener(_onCentralChanged);
  }

  void _onCentralChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _central.removeListener(_onCentralChanged);
    super.dispose();
  }

  List<AppointmentModel> get appointments => _central.appointments;

  List<AppointmentModel> get upcomingAppointments => _central.appointments
      .where((a) => a.status == AppointmentStatus.confirmed || a.status == AppointmentStatus.pending)
      .toList();

  List<AppointmentModel> get completedAppointments => _central.appointments
      .where((a) => a.status == AppointmentStatus.completed)
      .toList();

  List<AppointmentModel> get cancelledAppointments => _central.appointments
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

    _central.addAppointment(newBooking);
    return newBooking;
  }

  bool rescheduleAppointment({
    required String appointmentId,
    required DateTime newDate,
    required String newTimeSlot,
  }) {
    final index = _central.appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) return false;

    _central.updateAppointmentStatus(appointmentId, AppointmentStatus.confirmed);
    return true;
  }

  bool cancelAppointment(String appointmentId) {
    _central.updateAppointmentStatus(appointmentId, AppointmentStatus.cancelled);
    return true;
  }

  void addDoctorPrescription({
    required String appointmentId,
    required String doctorNotes,
    required List<PrescriptionItem> prescription,
    required List<String> recommendedTests,
  }) {
    _central.recordDoctorPrescription(
      appointmentId: appointmentId,
      doctorNotes: doctorNotes,
      prescription: prescription,
      recommendedTests: recommendedTests,
    );
  }
}
