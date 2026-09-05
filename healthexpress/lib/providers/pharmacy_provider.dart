import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/medicine_model.dart';
import '../models/medical_store_model.dart';
import '../data/production_database.dart';
import '../services/api_service.dart';
import '../services/central_data_service.dart';

class ActiveOrder {
  final String orderId;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryAddress;
  DeliveryStatus status;
  final String driverName;
  final String driverPhone;
  final String etaMinutes;
  final DateTime orderTime;

  ActiveOrder({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryAddress,
    this.status = DeliveryStatus.outForDelivery,
    this.driverName = 'Ravi Kumar',
    this.driverPhone = '+91 9848123456',
    this.etaMinutes = '14 mins',
    required this.orderTime,
  });
}

class PharmacyProvider extends ChangeNotifier {
  final CentralDataService _central = CentralDataService.instance;
  final List<MedicineModel> _medicines = List.from(ProductionDatabase.medicines);
  final List<MedicalStoreModel> _medicalStores = List.from(ProductionDatabase.medicalStores);
  MedicalStoreModel? _selectedStore;
  bool _isLoading = false;

  final List<CartItemModel> _cart = [
    CartItemModel(medicine: ProductionDatabase.medicines[0], quantity: 1), // Paracetamol
    CartItemModel(medicine: ProductionDatabase.medicines[1], quantity: 1), // Cetirizine
    CartItemModel(medicine: ProductionDatabase.medicines[2], quantity: 1), // Cough Syrup
  ];

  String _selectedAddress = 'Flat 402, Cyber Towers View, Hitech City, Hyderabad';
  String? _uploadedPrescriptionPath;

  PharmacyProvider() {
    _central.addListener(_onCentralChanged);
    loadFromLiveBackend();
  }

  void _onCentralChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _central.removeListener(_onCentralChanged);
    super.dispose();
  }

  bool get isLoading => _isLoading;

  Future<void> loadFromLiveBackend() async {
    _isLoading = true;
    notifyListeners();
    try {
      final remoteMeds = await ApiService.fetchMedicines();
      if (remoteMeds.isNotEmpty) {
        _medicines.clear();
        _medicines.addAll(remoteMeds);
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  List<MedicineModel> get medicines => _medicines;
  List<MedicalStoreModel> get medicalStores => _medicalStores;
  MedicalStoreModel? get selectedStore => _selectedStore;
  List<CartItemModel> get cart => _cart;
  String get selectedAddress => _selectedAddress;
  String? get uploadedPrescriptionPath => _uploadedPrescriptionPath;

  ActiveOrder? get activeOrder {
    final centralActive = _central.activePatientOrder;
    if (centralActive == null) return null;
    return ActiveOrder(
      orderId: centralActive.orderId,
      items: centralActive.rawItems,
      subtotal: centralActive.subtotal,
      deliveryFee: centralActive.deliveryFee,
      total: centralActive.totalAmount,
      deliveryAddress: centralActive.address,
      status: centralActive.deliveryStatus,
      driverName: centralActive.driverName,
      driverPhone: centralActive.driverPhone,
      etaMinutes: centralActive.etaMinutes,
      orderTime: centralActive.orderTime,
    );
  }

  void selectStore(MedicalStoreModel? store) {
    if (_selectedStore?.id == store?.id) {
      _selectedStore = null;
    } else {
      _selectedStore = store;
    }
    notifyListeners();
  }

  List<MedicineModel> getMedicinesForStore() {
    if (_selectedStore == null) {
      return _medicines;
    }
    return _medicines.where((m) => _selectedStore!.availableMedicineIds.contains(m.id)).toList();
  }

  int get totalCartCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartSubtotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => (cartSubtotal > 199.0 || cartSubtotal == 0) ? 0.0 : 25.0;
  double get cartTotal => cartSubtotal + deliveryFee;

  void addToCart(MedicineModel medicine) {
    final index = _cart.indexWhere((c) => c.medicine.id == medicine.id);
    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItemModel(medicine: medicine, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String medicineId) {
    final index = _cart.indexWhere((c) => c.medicine.id == medicineId);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  int getItemQuantity(String medicineId) {
    final item = _cart.firstWhere(
      (c) => c.medicine.id == medicineId,
      orElse: () => CartItemModel(medicine: _medicines[0], quantity: 0),
    );
    return item.quantity;
  }

  void uploadPrescription(String path) {
    _uploadedPrescriptionPath = path;
    notifyListeners();
  }

  void setAddress(String address) {
    _selectedAddress = address;
    notifyListeners();
  }

  ActiveOrder placeOrder() {
    _central.placeNewOrder(
      items: _cart,
      subtotal: cartSubtotal,
      deliveryFee: deliveryFee,
      total: cartTotal,
      deliveryAddress: _selectedAddress,
    );
    _cart.clear();
    _uploadedPrescriptionPath = null;
    return activeOrder!;
  }

  void advanceOrderStatus() {
    _central.advanceActiveOrderStatus();
  }
}
