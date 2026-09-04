import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/medicine_model.dart';
import '../data/production_database.dart';

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
    this.etaMinutes = '18 mins',
    required this.orderTime,
  });
}

class PharmacyProvider extends ChangeNotifier {
  final List<MedicineModel> _medicines = List.from(ProductionDatabase.medicines);
  final List<CartItemModel> _cart = [
    CartItemModel(medicine: ProductionDatabase.medicines[0], quantity: 1), // Paracetamol
    CartItemModel(medicine: ProductionDatabase.medicines[1], quantity: 1), // Cetirizine
    CartItemModel(medicine: ProductionDatabase.medicines[2], quantity: 1), // Cough Syrup
  ];

  String _selectedAddress = 'Home - 500081, Flat 402, Green Meadows, Hitech City, Hyderabad';
  String? _uploadedPrescriptionPath;
  ActiveOrder? _activeOrder;

  PharmacyProvider() {
    // Initialize default active order for demonstration
    _activeOrder = ActiveOrder(
      orderId: '#HE12345678',
      items: [
        CartItemModel(medicine: ProductionDatabase.medicines[0], quantity: 1),
        CartItemModel(medicine: ProductionDatabase.medicines[1], quantity: 1),
        CartItemModel(medicine: ProductionDatabase.medicines[2], quantity: 1),
      ],
      subtotal: 150.0,
      deliveryFee: 0.0, // Free quick delivery on > ₹99
      total: 150.0,
      deliveryAddress: _selectedAddress,
      status: DeliveryStatus.outForDelivery,
      orderTime: DateTime.now().subtract(const Duration(minutes: 12)),
    );
  }

  List<MedicineModel> get medicines => _medicines;
  List<CartItemModel> get cart => _cart;
  String get selectedAddress => _selectedAddress;
  String? get uploadedPrescriptionPath => _uploadedPrescriptionPath;
  ActiveOrder? get activeOrder => _activeOrder;

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
    final item = _cart.firstWhere((c) => c.medicine.id == medicineId, orElse: () => CartItemModel(medicine: _medicines[0], quantity: 0));
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
    final order = ActiveOrder(
      orderId: '#HE${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      items: List.from(_cart),
      subtotal: cartSubtotal,
      deliveryFee: deliveryFee,
      total: cartTotal,
      deliveryAddress: _selectedAddress,
      status: DeliveryStatus.orderConfirmed,
      orderTime: DateTime.now(),
    );
    _activeOrder = order;
    _cart.clear();
    _uploadedPrescriptionPath = null;
    notifyListeners();
    return order;
  }

  void advanceOrderStatus() {
    if (_activeOrder == null) return;
    if (_activeOrder!.status == DeliveryStatus.orderConfirmed) {
      _activeOrder!.status = DeliveryStatus.packed;
    } else if (_activeOrder!.status == DeliveryStatus.packed) {
      _activeOrder!.status = DeliveryStatus.outForDelivery;
    } else if (_activeOrder!.status == DeliveryStatus.outForDelivery) {
      _activeOrder!.status = DeliveryStatus.delivered;
    }
    notifyListeners();
  }
}
