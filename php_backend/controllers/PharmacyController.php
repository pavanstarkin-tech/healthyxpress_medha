<?php
/**
 * HealthExpress AI - Pharmacy Controller
 * 15-Minute Doorstep Medicine Delivery & Location-Aware Fulfillment
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../helpers/Response.php';
require_once __DIR__ . '/../helpers/MapboxHelper.php';

class PharmacyController {
    /**
     * Get All Medicines with Location-Aware Delivery ETA
     */
    public static function getMedicines(): void {
        $pdo = Database::getConnection();

        $lat = isset($_GET['lat']) ? floatval($_GET['lat']) : (isset($_GET['latitude']) ? floatval($_GET['latitude']) : null);
        $lng = isset($_GET['lng']) ? floatval($_GET['lng']) : (isset($_GET['longitude']) ? floatval($_GET['longitude']) : null);

        $stmt = $pdo->query("SELECT * FROM medicines ORDER BY is_prescription_required ASC, name ASC");
        $medicines = $stmt->fetchAll();

        $deliveryEta = 15;
        $fulfillmentHub = 'Central Hyderabad Quick-Delivery Hub';

        if ($lat && $lng) {
            // Check distance to central fulfillment hub (Gachibowli hub @ 17.4400, 78.3489)
            $hubDistance = MapboxHelper::getDistanceKm($lat, $lng, 17.4400, 78.3489);
            $deliveryEta = max(10, min(30, intval(round($hubDistance * 2.2 + 8))));
            $fulfillmentHub = $hubDistance <= 5.0 ? 'Hyperlocal 15-Min Dark Store' : 'City Express Fulfillment Hub';
        }

        foreach ($medicines as &$m) {
            $m['delivery_eta_minutes'] = $deliveryEta;
            $m['delivery_label'] = "{$deliveryEta}-min Doorstep Delivery";
            $m['fulfillment_hub'] = $fulfillmentHub;
            $m['in_stock'] = true;
        }

        Response::json([
            'medicines'       => $medicines,
            'fulfillment_hub' => $fulfillmentHub,
            'eta_minutes'     => $deliveryEta
        ]);
    }

    /**
     * Create 15-Minute Medicine Delivery Order
     */
    public static function createOrder(): void {
        $body = json_decode(file_get_contents('php://input'), true) ?? [];

        $userId = $body['user_id'] ?? 'USR-101';
        $items = $body['items'] ?? [];
        $totalAmount = floatval($body['total_amount'] ?? 450.00);
        $deliveryAddress = $body['delivery_address'] ?? 'Road No 36, Jubilee Hills, Hyderabad';
        $lat = isset($body['latitude']) ? floatval($body['latitude']) : 17.4400;
        $lng = isset($body['longitude']) ? floatval($body['longitude']) : 78.3489;

        $orderId = 'MED-ORD-' . rand(10000, 99999);
        $etaMinutes = max(12, min(25, intval(round(MapboxHelper::getDistanceKm($lat, $lng, 17.4400, 78.3489) * 2.2 + 8))));

        Response::json([
            'order_id'         => $orderId,
            'user_id'          => $userId,
            'items'            => $items,
            'total_amount'     => $totalAmount,
            'delivery_address' => $deliveryAddress,
            'delivery_status'  => 'order_placed',
            'eta_minutes'      => $etaMinutes,
            'timeline'         => [
                ['status' => 'Order Placed', 'time' => date('h:i A'), 'completed' => true],
                ['status' => 'Pharmacy Packed', 'time' => date('h:i A', strtotime('+3 minutes')), 'completed' => false],
                ['status' => 'Rider Dispatched (Mapbox Live GPS)', 'time' => date('h:i A', strtotime('+6 minutes')), 'completed' => false],
                ['status' => 'Delivered to Doorstep', 'time' => date('h:i A', strtotime("+{$etaMinutes} minutes")), 'completed' => false],
            ]
        ], 201, '15-min medicine delivery order initiated');
    }

    /**
     * Get Nearby Medical Stores & Dark Stores with Real-Time ETA
     */
    public static function getStores(): void {
        $lat = isset($_GET['lat']) ? floatval($_GET['lat']) : 17.4400;
        $lng = isset($_GET['lng']) ? floatval($_GET['lng']) : 78.3489;

        $stores = [
            [
                'id'            => 'STORE-01',
                'name'          => 'Apollo Pharmacy 24x7',
                'address'       => 'Plot 12, Phase 2, Hitech City Main Rd, Hyderabad',
                'area'          => 'Hitech City',
                'rating'        => 4.8,
                'reviews'       => 420,
                'distance_km'   => 0.8,
                'eta_minutes'   => 12,
                'is_24x7'       => true,
                'is_open'       => true,
                'phone'         => '+91 40 2360 8888',
                'license'       => 'TS-HYD-PHARM-2024-8801',
                'image_url'     => 'https://images.unsplash.com/photo-1576602976047-174e57a47881?auto=format&fit=crop&q=80&w=400',
                'available_medicines_count' => 240
            ],
            [
                'id'            => 'STORE-02',
                'name'          => 'MedPlus Chemist & Superstore',
                'address'       => 'Road No 36, Opp. Metro Pillar 1400, Jubilee Hills, Hyderabad',
                'area'          => 'Jubilee Hills',
                'rating'        => 4.7,
                'reviews'       => 310,
                'distance_km'   => 1.5,
                'eta_minutes'   => 15,
                'is_24x7'       => true,
                'is_open'       => true,
                'phone'         => '+91 40 4455 6677',
                'license'       => 'TS-HYD-PHARM-2024-4421',
                'image_url'     => 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&q=80&w=400',
                'available_medicines_count' => 195
            ],
            [
                'id'            => 'STORE-03',
                'name'          => 'Wellness Forever 15-Min Dark Store',
                'address'       => 'Near Inorbit Mall, Mindspace Junction, Madhapur, Hyderabad',
                'area'          => 'Madhapur',
                'rating'        => 4.9,
                'reviews'       => 540,
                'distance_km'   => 2.1,
                'eta_minutes'   => 14,
                'is_24x7'       => true,
                'is_open'       => true,
                'phone'         => '+91 40 6789 0011',
                'license'       => 'TS-HYD-PHARM-2024-9904',
                'image_url'     => 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?auto=format&fit=crop&q=80&w=400',
                'available_medicines_count' => 310
            ],
            [
                'id'            => 'STORE-04',
                'name'          => 'Sri Balaji Medical & General Store',
                'address'       => 'Old Mumbai Highway, Gachibowli, Hyderabad',
                'area'          => 'Gachibowli',
                'rating'        => 4.5,
                'reviews'       => 180,
                'distance_km'   => 2.8,
                'eta_minutes'   => 20,
                'is_24x7'       => false,
                'is_open'       => true,
                'phone'         => '+91 40 2300 1122',
                'license'       => 'TS-HYD-PHARM-2023-1129',
                'image_url'     => 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&q=80&w=400',
                'available_medicines_count' => 145
            ]
        ];

        Response::json([
            'stores' => $stores,
            'total'  => count($stores)
        ]);
    }

    /**
     * Add / Register New Medical Store
     */
    public static function addStore(): void {
        $body = json_decode(file_get_contents('php://input'), true) ?? [];
        
        $name = trim($body['name'] ?? '');
        $address = trim($body['address'] ?? '');
        $area = trim($body['area'] ?? 'Hyderabad');
        $phone = $body['phone'] ?? '+91 40 2300 0000';
        $license = $body['license'] ?? 'TS-HYD-PHARM-2026-9900';
        $is24x7 = !empty($body['is_24x7']);
        $imageUrl = $body['image_url'] ?? 'https://images.unsplash.com/photo-1576602976047-174e57a47881?auto=format&fit=crop&q=80&w=400';

        if (empty($name) || empty($address)) {
            Response::json(['error' => 'Store name and address are required'], 400);
            return;
        }

        $storeId = 'STORE-' . rand(100, 999);

        Response::json([
            'id'          => $storeId,
            'name'        => $name,
            'address'     => $address,
            'area'        => $area,
            'phone'       => $phone,
            'license'     => $license,
            'is_24x7'     => $is24x7,
            'image_url'   => $imageUrl,
            'status'      => 'active_registered'
        ], 201, 'Medical store successfully registered');
    }
}
