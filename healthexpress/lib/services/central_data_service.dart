import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/appointment_model.dart';
import '../models/medicine_model.dart';
import '../data/production_database.dart';

class CentralOrderModel {
  final String orderId;
  final String patientName;
  final String patientPhone;
  final String address;
  final List<String> itemNames;
  final List<CartItemModel> rawItems;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final DateTime orderTime;
  DeliveryStatus deliveryStatus;
  String driverName;
  String driverPhone;
  String etaMinutes;

  CentralOrderModel({
    required this.orderId,
    required this.patientName,
    required this.patientPhone,
    required this.address,
    required this.itemNames,
    required this.rawItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.orderTime,
    this.deliveryStatus = DeliveryStatus.orderConfirmed,
    this.driverName = 'Ravi Kumar',
    this.driverPhone = '+91 9848123456',
    this.etaMinutes = '15 mins',
  });

  String get storeStatusString {
    switch (deliveryStatus) {
      case DeliveryStatus.orderConfirmed:
        return 'incoming';
      case DeliveryStatus.packed:
        return 'packing';
      case DeliveryStatus.outForDelivery:
        return 'dispatched';
      case DeliveryStatus.delivered:
        return 'delivered';
    }
  }

  void updateFromStoreStatus(String storeStatus) {
    switch (storeStatus.toLowerCase()) {
      case 'incoming':
        deliveryStatus = DeliveryStatus.orderConfirmed;
        break;
      case 'packing':
        deliveryStatus = DeliveryStatus.packed;
        break;
      case 'dispatched':
        deliveryStatus = DeliveryStatus.outForDelivery;
        break;
      case 'delivered':
        deliveryStatus = DeliveryStatus.delivered;
        break;
    }
  }
}

class CentralDataService extends ChangeNotifier {
  static final CentralDataService instance = CentralDataService._internal();

  CentralDataService._internal() {
    _initializeData();
  }

  final List<AppointmentModel> _appointments = [];
  final List<CentralOrderModel> _orders = [];
  CentralOrderModel? _activePatientOrder;

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
  List<CentralOrderModel> get orders => List.unmodifiable(_orders);
  CentralOrderModel? get activePatientOrder => _activePatientOrder;

  void _initializeData() {
    // 1. Initialize Appointments from Production Database
    _appointments.addAll(ProductionDatabase.initialAppointments);

    // 2. Initialize Seed Orders with Real Hyderabad delivery context
    final defaultParacetamol = ProductionDatabase.medicines[0];
    final defaultCetirizine = ProductionDatabase.medicines[1];
    final defaultCoughSyrup = ProductionDatabase.medicines[2];

    final initialOrder = CentralOrderModel(
      orderId: '#HE4064568',
      patientName: 'Rahul Kumar',
      patientPhone: '+91 98765 43210',
      address: 'Flat 402, Cyber Towers View, Hitech City, Hyderabad',
      itemNames: ['Dolo 650mg (2 strips)', 'Pan-D (1 strip)', 'Cough Syrup (1 bottle)'],
      rawItems: [
        CartItemModel(medicine: defaultParacetamol, quantity: 2),
        CartItemModel(medicine: defaultCetirizine, quantity: 1),
        CartItemModel(medicine: defaultCoughSyrup, quantity: 1),
      ],
      subtotal: 215.0,
      deliveryFee: 0.0,
      totalAmount: 215.0,
      orderTime: DateTime.now().subtract(const Duration(minutes: 12)),
      deliveryStatus: DeliveryStatus.outForDelivery,
      driverName: 'Ravi Kumar',
      driverPhone: '+91 9848123456',
      etaMinutes: '14 mins',
    );

    _orders.add(initialOrder);
    _activePatientOrder = initialOrder;

    _orders.add(CentralOrderModel(
      orderId: '#HE882190',
      patientName: 'Sneha Reddy',
      patientPhone: '+91 98490 88211',
      address: 'Plot 18, Road No 36, Jubilee Hills, Hyderabad',
      itemNames: ['Azithral 500mg (1 strip)', 'Allegra 120mg (1 strip)'],
      rawItems: [
        CartItemModel(medicine: defaultCetirizine, quantity: 1),
      ],
      subtotal: 314.0,
      deliveryFee: 0.0,
      totalAmount: 314.0,
      orderTime: DateTime.now().subtract(const Duration(minutes: 24)),
      deliveryStatus: DeliveryStatus.packed,
      driverName: 'Arun Varma',
      driverPhone: '+91 98480 11223',
      etaMinutes: '18 mins',
    ));

    _orders.add(CentralOrderModel(
      orderId: '#HE881523',
      patientName: 'Venkata Rao',
      patientPhone: '+91 99887 66554',
      address: 'Block B, Madhapur Main Road, Hyderabad',
      itemNames: ['Accu-Chek Active Strips (1 pack)'],
      rawItems: [
        CartItemModel(medicine: defaultParacetamol, quantity: 1),
      ],
      subtotal: 890.0,
      deliveryFee: 0.0,
      totalAmount: 890.0,
      orderTime: DateTime.now().subtract(const Duration(hours: 2)),
      deliveryStatus: DeliveryStatus.delivered,
      driverName: 'Suresh Babu',
      driverPhone: '+91 98480 99887',
      etaMinutes: 'Delivered',
    ));
  }

  // ==========================================
  // APPOINTMENT OPERATIONS (Sync Patient & Doctor)
  // ==========================================

  void addAppointment(AppointmentModel appt) {
    _appointments.insert(0, appt);
    notifyListeners();
  }

  void updateAppointmentStatus(String id, AppointmentStatus status) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: status);
      notifyListeners();
    }
  }

  void recordDoctorPrescription({
    required String appointmentId,
    required String doctorNotes,
    required List<PrescriptionItem> prescription,
    required List<String> recommendedTests,
  }) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.completed,
        doctorNotes: doctorNotes,
        prescription: prescription,
        recommendedTests: recommendedTests,
      );
      notifyListeners();
    }
  }

  List<AppointmentModel> getDoctorAppointments(String doctorId) {
    return _appointments.where((a) => a.doctorId == doctorId || doctorId == 'DOC-01').toList();
  }

  // ==========================================
  // PHARMACY & STORE ORDERS (Sync Patient & Store)
  // ==========================================

  CentralOrderModel placeNewOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String deliveryAddress,
    String patientName = 'Rahul Kumar',
    String patientPhone = '+91 98765 43210',
  }) {
    final orderId = '#HE${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    final newOrder = CentralOrderModel(
      orderId: orderId,
      patientName: patientName,
      patientPhone: patientPhone,
      address: deliveryAddress,
      itemNames: items.map((i) => '${i.medicine.name} (x${i.quantity})').toList(),
      rawItems: List.from(items),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      totalAmount: total,
      orderTime: DateTime.now(),
      deliveryStatus: DeliveryStatus.orderConfirmed,
      driverName: 'Ravi Kumar',
      driverPhone: '+91 9848123456',
      etaMinutes: '15 mins',
    );

    _orders.insert(0, newOrder);
    _activePatientOrder = newOrder;
    notifyListeners();
    return newOrder;
  }

  void updateOrderStatus(String orderId, DeliveryStatus newStatus) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      _orders[index].deliveryStatus = newStatus;
      if (_activePatientOrder?.orderId == orderId) {
        _activePatientOrder!.deliveryStatus = newStatus;
      }
      notifyListeners();
    }
  }

  void updateStoreOrderStatus(String orderId, String storeStatus) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      _orders[index].updateFromStoreStatus(storeStatus);
      if (_activePatientOrder?.orderId == orderId) {
        _activePatientOrder!.updateFromStoreStatus(storeStatus);
      }
      notifyListeners();
    }
  }

  void advanceActiveOrderStatus() {
    if (_activePatientOrder == null) return;
    final current = _activePatientOrder!.deliveryStatus;
    if (current == DeliveryStatus.orderConfirmed) {
      updateOrderStatus(_activePatientOrder!.orderId, DeliveryStatus.packed);
    } else if (current == DeliveryStatus.packed) {
      updateOrderStatus(_activePatientOrder!.orderId, DeliveryStatus.outForDelivery);
    } else if (current == DeliveryStatus.outForDelivery) {
      updateOrderStatus(_activePatientOrder!.orderId, DeliveryStatus.delivered);
    }
  }
}
