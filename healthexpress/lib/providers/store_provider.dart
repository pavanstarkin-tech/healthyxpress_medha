import 'package:flutter/material.dart';

class StoreProductItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final int discountPercent;
  final bool inStock;
  final int stockCount;
  final String imageUrl;

  const StoreProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.discountPercent = 10,
    this.inStock = true,
    this.stockCount = 100,
    this.imageUrl = 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&q=80&w=300',
  });

  StoreProductItem copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    int? discountPercent,
    bool? inStock,
    int? stockCount,
    String? imageUrl,
  }) {
    return StoreProductItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      discountPercent: discountPercent ?? this.discountPercent,
      inStock: inStock ?? this.inStock,
      stockCount: stockCount ?? this.stockCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class StoreOrderRequest {
  final String id;
  final String patientName;
  final String patientPhone;
  final String address;
  final List<String> items;
  final double totalAmount;
  final String time;
  final String status; // 'incoming' | 'packing' | 'dispatched' | 'delivered'
  final int etaMinutes;

  const StoreOrderRequest({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.address,
    required this.items,
    required this.totalAmount,
    required this.time,
    this.status = 'incoming',
    this.etaMinutes = 15,
  });

  StoreOrderRequest copyWith({
    String? id,
    String? patientName,
    String? patientPhone,
    String? address,
    List<String>? items,
    double? totalAmount,
    String? time,
    String? status,
    int? etaMinutes,
  }) {
    return StoreOrderRequest(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      address: address ?? this.address,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      time: time ?? this.time,
      status: status ?? this.status,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }
}

class StoreProvider extends ChangeNotifier {
  List<StoreProductItem> _products = [
    const StoreProductItem(
      id: 'PROD-01',
      name: 'Dolo 650mg Paracetamol Tablets',
      category: 'Fever & Pain Relief',
      price: 32.0,
      discountPercent: 10,
      inStock: true,
      stockCount: 150,
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&q=80&w=300',
    ),
    const StoreProductItem(
      id: 'PROD-02',
      name: 'Azithral 500mg Antibiotic Strips',
      category: 'Antibiotics',
      price: 119.0,
      discountPercent: 15,
      inStock: true,
      stockCount: 80,
      imageUrl: 'https://images.unsplash.com/photo-1576602976047-174e57a47881?auto=format&fit=crop&q=80&w=300',
    ),
    const StoreProductItem(
      id: 'PROD-03',
      name: 'Allegra 120mg Antiallergic',
      category: 'Cold & Allergy',
      price: 195.0,
      discountPercent: 12,
      inStock: true,
      stockCount: 65,
      imageUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?auto=format&fit=crop&q=80&w=300',
    ),
    const StoreProductItem(
      id: 'PROD-04',
      name: 'Pan-D Gastro-Resistant Capsules',
      category: 'Antacid / Digestion',
      price: 180.0,
      discountPercent: 8,
      inStock: true,
      stockCount: 95,
      imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&q=80&w=300',
    ),
    const StoreProductItem(
      id: 'PROD-05',
      name: 'Volini Rapid Pain Relief Gel 50g',
      category: 'Pain Relief Spray / Gel',
      price: 140.0,
      discountPercent: 15,
      inStock: false,
      stockCount: 0,
      imageUrl: 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?auto=format&fit=crop&q=80&w=300',
    ),
    const StoreProductItem(
      id: 'PROD-06',
      name: 'Accu-Chek Active Glucose Test Strips (50s)',
      category: 'Diabetes Care',
      price: 890.0,
      discountPercent: 20,
      inStock: true,
      stockCount: 40,
      imageUrl: 'https://images.unsplash.com/photo-1631556097152-c39479cbfeab?auto=format&fit=crop&q=80&w=300',
    ),
  ];

  List<StoreOrderRequest> _orders = [
    const StoreOrderRequest(
      id: 'ORD-8821',
      patientName: 'Rahul Kumar',
      patientPhone: '+91 98765 43210',
      address: 'Flat 402, Cyber Towers View, Hitech City, Hyderabad',
      items: ['Dolo 650mg (2 strips)', 'Pan-D (1 strip)'],
      totalAmount: 244.0,
      time: 'Just now',
      status: 'incoming',
      etaMinutes: 12,
    ),
    const StoreOrderRequest(
      id: 'ORD-8819',
      patientName: 'Sneha Reddy',
      patientPhone: '+91 98490 88211',
      address: 'Plot 18, Road No 36, Jubilee Hills, Hyderabad',
      items: ['Azithral 500mg (1 strip)', 'Allegra 120mg (1 strip)'],
      totalAmount: 314.0,
      time: '8 mins ago',
      status: 'packing',
      etaMinutes: 15,
    ),
    const StoreOrderRequest(
      id: 'ORD-8815',
      patientName: 'Venkata Rao',
      patientPhone: '+91 99887 66554',
      address: 'Block B, Madhapur Main Road',
      items: ['Accu-Chek Active Strips (1 pack)'],
      totalAmount: 890.0,
      time: '25 mins ago',
      status: 'delivered',
      etaMinutes: 14,
    ),
  ];

  List<StoreProductItem> get products => _products;
  List<StoreOrderRequest> get orders => _orders;

  int get totalProductsCount => _products.length;
  int get inStockCount => _products.where((p) => p.inStock).length;
  int get activeOrdersCount => _orders.where((o) => o.status != 'delivered').length;
  double get todayRevenue => _orders.fold(0.0, (sum, o) => sum + o.totalAmount);

  void toggleStock(String productId) {
    _products = _products.map((p) {
      if (p.id == productId) {
        return p.copyWith(inStock: !p.inStock);
      }
      return p;
    }).toList();
    notifyListeners();
  }

  void addProduct({
    required String name,
    required String category,
    required double price,
    required int discountPercent,
    required int stockCount,
  }) {
    final newId = 'PROD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _products = [
      StoreProductItem(
        id: newId,
        name: name,
        category: category,
        price: price,
        discountPercent: discountPercent,
        inStock: stockCount > 0,
        stockCount: stockCount,
      ),
      ..._products,
    ];
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    _orders = _orders.map((o) {
      if (o.id == orderId) {
        return o.copyWith(status: newStatus);
      }
      return o;
    }).toList();
    notifyListeners();
  }
}
